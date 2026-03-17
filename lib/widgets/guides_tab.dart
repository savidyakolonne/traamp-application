import 'package:flutter/material.dart';
import '../models/guide.dart';
import '../services/guide_service.dart';
import 'guide_card.dart';

class GuidesTab extends StatefulWidget {
  final String uid;
  final String search;
  final String? location;
  final Set<String> languages;

  const GuidesTab({
    super.key,
    required this.search,
    required this.location,
    required this.languages,
    required this.uid,
  });

  @override
  State<GuidesTab> createState() => GuidesTabState();
}

class GuidesTabState extends State<GuidesTab> {
  late Future<List<Guide>> _guidesFuture;

  @override
  void initState() {
    super.initState();
    _fetchGuides();
  }

  void _fetchGuides() {
    _guidesFuture = GuideService().fetchGuides(
      location: widget.location,
      languages: widget.languages.toList(),
    );
  }

  @override
  void didUpdateWidget(covariant GuidesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.search != widget.search ||
        oldWidget.location != widget.location ||
        oldWidget.languages != widget.languages) {
      setState(() => _fetchGuides());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Guide>>(
      future: _guidesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_search, size: 48, color: Colors.black26),
                SizedBox(height: 12),
                Text(
                  "No guides found",
                  style: TextStyle(color: Colors.black45, fontSize: 15),
                ),
              ],
            ),
          );
        }

        final searchLower = widget.search.toLowerCase();
        final filtered = snapshot.data!.where((g) {
          final fullName = "${g.firstName} ${g.lastName}".toLowerCase();
          return fullName.contains(searchLower);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text("No guides match your search"));
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final g = filtered[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GuideCard(
                uid: widget.uid,
                guideUid: g.uid ?? '',
                name: "${g.firstName} ${g.lastName}",
                location: g.location,
                rating: g.rating,
                profilePicture: g.profilePicture,
                languages: g.languages ?? [],
              ),
            );
          },
        );
      },
    );
  }
}
