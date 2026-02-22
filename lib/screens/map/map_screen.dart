import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../appConfig.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  LatLng? _currentLocation;
  Set<Marker> _markers = {};

  bool _loading = true;
  bool _loadingPlaces = false;
  int _radius = 5000;

  String get baseUrl {
    if (kIsWeb) return "${AppConfig.SERVER_URL}";
    return "${AppConfig.SERVER_URL}"; // later: real device -> http://YOUR_PC_IP:3000
  }

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    try {
      final pos = await _getLocation();
      if (!mounted) return;

      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
      });

      // Smooth move to current location (works on all)
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 14),
      );

      await _loadPlaces();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Position> _getLocation() async {
    // On web this check can be unreliable, skip it.
    if (!kIsWeb) {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        throw Exception("Please enable GPS / Location services");
      }
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location denied forever. Enable it in settings.");
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _loadPlaces() async {
    if (_currentLocation == null) return;

    setState(() => _loadingPlaces = true);

    try {
      final url = Uri.parse(
        "$baseUrl/api/places/nearby"
        "?lat=${_currentLocation!.latitude}"
        "&lng=${_currentLocation!.longitude}"
        "&radius=$_radius",
      );

      final res = await http.get(url);
      if (res.statusCode != 200) {
        throw Exception("Backend error: ${res.statusCode} ${res.body}");
      }

      final List data = jsonDecode(res.body);

      final Set<Marker> newMarkers = {};

      // ✅ Current location marker (blue) — works on Web + Mobile
      newMarkers.add(
        Marker(
          markerId: const MarkerId("me"),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );

      // Place markers
      for (final p in data) {
        final loc = p["location"];
        if (loc == null) continue;

        final lat = (loc["lat"] as num).toDouble();
        final lng = (loc["lng"] as num).toDouble();
        final id = (p["id"] ?? "${lat}_$lng").toString();

        newMarkers.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            onTap: () => _openBottomSheet(p),
          ),
        );
      }

      if (!mounted) return;
      setState(() => _markers = newMarkers);
    } finally {
      if (mounted) setState(() => _loadingPlaces = false);
    }
  }

  void _openBottomSheet(dynamic place) {
    final loc = place["location"];
    final lat = loc != null ? (loc["lat"] as num).toDouble() : null;
    final lng = loc != null ? (loc["lng"] as num).toDouble() : null;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (place["name"] ?? "Unknown place").toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text((place["shortDesc"] ?? "").toString()),
            const SizedBox(height: 8),
            Text("Distance: ${(place["distanceKm"] ?? "-").toString()} km"),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: (lat != null && lng != null)
                  ? () => _openDirections(lat, lng)
                  : null,
              icon: const Icon(Icons.directions),
              label: const Text("Directions"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDirections(double lat, double lng) async {
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) _showError("Could not open directions");
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentLocation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Discover Hidden Places")),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() => _loading = true);
              _initMap();
            },
            child: const Text("Retry location"),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover Hidden Places"),
        actions: [
          PopupMenuButton<int>(
            onSelected: (v) async {
              _radius = v;
              await _loadPlaces();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 5000, child: Text("5 km")),
              PopupMenuItem(value: 10000, child: Text("10 km")),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation!,
              zoom: 14,
            ),
            myLocationEnabled: true, // ✅ native blue dot on Android/iOS
            myLocationButtonEnabled: true, // ✅ recenter button
            markers: _markers,
            onMapCreated: (c) => _controller = c,
          ),
          if (_loadingPlaces)
            const Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Loading nearby places..."),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadPlaces,
        icon: const Icon(Icons.refresh),
        label: const Text("Refresh"),
      ),
    );
  }
}
