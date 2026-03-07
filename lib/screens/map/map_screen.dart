import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../places/place_detail_screen.dart'; // ✅ adjust path if needed
//import '../../app_config.dart';

class MapScreen extends StatefulWidget {
  final String? focusPlaceId;
  final LatLng? focusLatLng;

  const MapScreen({super.key, this.focusPlaceId, this.focusLatLng});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  LatLng? _currentLocation;

  // Markers
  Set<Marker> _markers = {};
  bool _showPlaceMarkers = true;
  String? _selectedPlaceId;

  // loading
  bool _loading = true;
  bool _loadingPlaces = false;

  // radius (meters)
  int _radius = 5000;

  // String get baseUrl {
  //   if (kIsWeb) return "${AppConfig.SERVER_URL}";
  //   return "${AppConfig.SERVER_URL}"; // later: real device -> http://YOUR_PC_IP:3000
  // }

  String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000";
    } else {
      return "http://10.0.2.2:3000";
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedPlaceId = widget
        .focusPlaceId; //  pre select locatin for the navigate from the place_detail_screen

    _initMap();
  }

  Future<void> _initMap() async {
    try {
      final pos = await _getLocation();
      if (!mounted) return;

      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
      });

      // for testing purpose tangalle lat and lang points ----------------------------------------------------------

      // setState(() {
      //   _currentLocation = const LatLng(6.0243, 80.7891);
      // });

      //------------------------------------------------------------------------------------------------------------------

      // If controller not ready yet, onMapCreated will animate
      if (_controller != null) {
        await _controller!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 14),
        );
      }

      await _loadPlaces();

      if (widget.focusLatLng != null) {
        await _controller?.animateCamera(
          CameraUpdate.newLatLngZoom(widget.focusLatLng!, 15),
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<Position> _getLocation() async {
    if (!kIsWeb) {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) throw Exception("Please enable GPS / Location services");
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

  //add a marker when select place from the place_detail_screen --------------
  // void _addFocusMarkerIfAny() {
  //   if (widget.focusLatLng == null) return;

  //   final id = widget.focusPlaceId ?? "focus_place";

  //   _markers = {
  //     ..._markers,
  //     Marker(
  //       markerId: MarkerId(id),
  //       position: widget.focusLatLng!,
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //       infoWindow: const InfoWindow(title: "Selected place"),
  //     ),
  //   };
  // }

  void _addFocusMarkerIfAny(Set<Marker> markers) {
    if (widget.focusLatLng == null) return;

    final id = widget.focusPlaceId ?? "focus_place";

    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: widget.focusLatLng!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "Selected place"),
      ),
    );
  }

  Future<void> _loadPlaces() async {
    if (_currentLocation == null) return;

    setState(() => _loadingPlaces = true);

    try {
      // ✅ keep your endpoint name here
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

      // ✅ Current location marker (blue)
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

      // ✅ Place markers (green/red)
      if (_showPlaceMarkers) {
        for (final p in data) {
          final loc = p["location"];
          if (loc == null) continue;

          final lat = (loc["lat"] as num).toDouble();
          final lng = (loc["lng"] as num).toDouble();
          final id = (p["id"] ?? "${lat}_$lng").toString();

          final isSelected = _selectedPlaceId == id;

          newMarkers.add(
            Marker(
              markerId: MarkerId(id),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                isSelected
                    ? BitmapDescriptor.hueRed
                    : BitmapDescriptor.hueGreen,
              ),
              onTap: () {
                setState(() => _selectedPlaceId = id);
                _openBottomSheet(p);
                // refresh markers to apply red icon
                _rebuildMarkersKeepingData(data);
              },
            ),
          );
        }
      }

      // FORCE add selected place marker if coming from detail screen
      _addFocusMarkerIfAny(newMarkers);

      if (!mounted) return;
      setState(() => _markers = newMarkers);
    } finally {
      if (mounted) setState(() => _loadingPlaces = false);
    }
  }

  /// Rebuild markers quickly after selecting a place without calling API again
  void _rebuildMarkersKeepingData(List data) {
    if (_currentLocation == null) return;

    final Set<Marker> newMarkers = {};

    newMarkers.add(
      Marker(
        markerId: const MarkerId("me"),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: "You are here"),
      ),
    );

    if (_showPlaceMarkers) {
      for (final p in data) {
        final loc = p["location"];
        if (loc == null) continue;

        final lat = (loc["lat"] as num).toDouble();
        final lng = (loc["lng"] as num).toDouble();
        final id = (p["id"] ?? "${lat}_$lng").toString();

        final isSelected = _selectedPlaceId == id;

        newMarkers.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isSelected ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen,
            ),
            onTap: () {
              setState(() => _selectedPlaceId = id);
              _openBottomSheet(p);
              _rebuildMarkersKeepingData(data);
            },
          ),
        );
      }
    }

    // keep focus marker even after rebuild
    _addFocusMarkerIfAny(newMarkers);

    setState(() => _markers = newMarkers);
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
            if ((place["shortDesc"] ?? "").toString().isNotEmpty)
              Text((place["shortDesc"] ?? "").toString()),
            const SizedBox(height: 8),
            Text("Distance: ${(place["distanceKm"] ?? "-").toString()} km"),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (lat != null && lng != null)
                        ? () => _openDirections(lat, lng)
                        : null,
                    icon: const Icon(Icons.directions),
                    label: const Text("Directions"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: (place["id"] != null)
                        ? () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlaceDetailScreen(
                                  placeId: place["id"].toString(),
                                ),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.info_outline),
                    label: const Text("Details"),
                  ),
                ),
              ],
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

  String _radiusLabel() {
    if (_radius == 5000) return "5 km";
    if (_radius == 10000) return "10 km";
    if (_radius == 15000) return "15 km";
    if (_radius == 20000) return "20 km";
    return "${(_radius / 1000).round()} km";
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
          // ✅ toggle show/hide markers
          IconButton(
            tooltip: _showPlaceMarkers ? "Hide places" : "Show places",
            onPressed: () async {
              setState(() => _showPlaceMarkers = !_showPlaceMarkers);
              await _loadPlaces(); // rebuild markers
            },
            icon: Icon(
              _showPlaceMarkers ? Icons.visibility : Icons.visibility_off,
            ),
          ),

          // ✅ radius selection
          PopupMenuButton<int>(
            tooltip: "Radius (${_radiusLabel()})",
            onSelected: (v) async {
              setState(() => _radius = v);
              await _loadPlaces();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 5000, child: Text("5 km")),
              PopupMenuItem(value: 10000, child: Text("10 km")),
              PopupMenuItem(value: 15000, child: Text("15 km")),
              PopupMenuItem(value: 20000, child: Text("20 km")),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Row(
                  children: [
                    const Icon(Icons.tune, size: 18),
                    const SizedBox(width: 6),
                    Text(_radiusLabel()),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
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
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            onMapCreated: (c) async {
              _controller = c;

              // ✅ if opened from PlaceDetailScreen -> go to that place
              if (widget.focusLatLng != null) {
                await _controller!.animateCamera(
                  CameraUpdate.newLatLngZoom(widget.focusLatLng!, 15),
                );
              } else {
                // ✅ normal open -> go to current location
                await _controller!.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentLocation!, 14),
                );
              }
            },
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

          // little status chip
          Positioned(
            bottom: 12,
            left: 12,
            child: Chip(
              label: Text(
                _showPlaceMarkers
                    ? "Showing places • ${_radiusLabel()}"
                    : "Places hidden • ${_radiusLabel()}",
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadPlaces,
        icon: const Icon(Icons.refresh),
        label: const Text("Search"),
      ),
    );
  }
}
