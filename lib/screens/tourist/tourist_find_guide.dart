import 'package:flutter/material.dart';
import '../../models/guide.dart';
import '../../services/guide_service.dart';
import '../profile/guide_public_view_screen.dart';

class FindGuidesScreen extends StatefulWidget {
  const FindGuidesScreen({super.key});

  @override
  State<FindGuidesScreen> createState() => _FindGuidesScreenState();
}

class _FindGuidesScreenState extends State<FindGuidesScreen> {
  final TextEditingController _search = TextEditingController();

  String? selectedLocation;
  final Set<String> selectedLanguages = {};

  final List<String> allLanguages = [
    "Sinhala", "Tamil", "English", "Russian", "German", "French",
    "Spanish", "Italian", "Chinese (Mandarin)", "Korean", "Japanese",
    "Hindi", "Arabic", "Dutch", "Ukrainian",
  ];

  void _openFilterSheet() {
    String? tempLocation = selectedLocation;
    final tempLanguages = {...selectedLanguages};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.62,
              minChildSize: 0.45,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(22)),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text("Filter Guides",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      const Text("Location",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: tempLocation,
                        decoration: InputDecoration(
                          hintText: "Select location",
                          filled: true,
                          fillColor: const Color(0xFFF5F6F8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: "Hikkaduwa", child: Text("Hikkaduwa")),
                          DropdownMenuItem(value: "Galle", child: Text("Galle")),
                          DropdownMenuItem(value: "Ella", child: Text("Ella")),
                          DropdownMenuItem(value: "Kandy", child: Text("Kandy")),
                          DropdownMenuItem(value: "Colombo", child: Text("Colombo")),
                        ],
                        onChanged: (v) => setModalState(() => tempLocation = v),
                      ),
                      const SizedBox(height: 18),
                      const Text("Languages",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: allLanguages.map((lang) {
                          final isOn = tempLanguages.contains(lang);
                          return FilterChip(
                            label: Text(lang),
                            selected: isOn,
                            onSelected: (v) {
                              setModalState(() {
                                if (v) {
                                  tempLanguages.add(lang);
                                } else {
                                  tempLanguages.remove(lang);
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setModalState(() {
                                  tempLocation = null;
                                  tempLanguages.clear();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text("Reset"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedLocation = tempLocation;
                                  selectedLanguages
                                    ..clear()
                                    ..addAll(tempLanguages);
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: const Text("Apply"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _chip(String text, VoidCallback onRemove) {
    return Chip(
      label: Text(text),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onRemove,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (selectedLocation != null) {
      chips.add(_chip(
          selectedLocation!, () => setState(() => selectedLocation = null)));
    }
    for (final lang in selectedLanguages) {
      chips.add(_chip(
          lang, () => setState(() => selectedLanguages.remove(lang))));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header + Search + Filter chips ──────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Find a Guide",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _search,
                          decoration: InputDecoration(
                            hintText: "Search guides…",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: const Color(0xFFF5F6F8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: _openFilterSheet,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6F8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.tune),
                        ),
                      ),
                    ],
                  ),
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          const SizedBox(width: 2),
                          ...chips.map((c) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: c,
                              )),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Guides list ──────────────────────────────────
            Expanded(
              child: _GuidesTab(
                search: _search.text,
                location: selectedLocation,
                languages: selectedLanguages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ------------------ Guides list ------------------ */

class _GuidesTab extends StatefulWidget {
  final String search;
  final String? location;
  final Set<String> languages;

  const _GuidesTab({
    required this.search,
    required this.location,
    required this.languages,
  });

  @override
  State<_GuidesTab> createState() => _GuidesTabState();
}

class _GuidesTabState extends State<_GuidesTab> {
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
  void didUpdateWidget(covariant _GuidesTab oldWidget) {
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
                Text("No guides found",
                    style: TextStyle(color: Colors.black45, fontSize: 15)),
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
              child: _GuideCard(
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

/* ------------------ Guide Card ------------------ */

class _GuideCard extends StatelessWidget {
  final String guideUid;
  final String name;
  final String location;
  final List<String> languages;
  final double? rating;
  final String? profilePicture;

  const _GuideCard({
    required this.guideUid,
    required this.name,
    required this.location,
    required this.languages,
    this.rating,
    this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (guideUid.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GuidePublicViewScreen(guideId: guideUid),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.black12,
              backgroundImage: profilePicture != null &&
                      profilePicture!.isNotEmpty
                  ? NetworkImage(profilePicture!)
                  : null,
              child: profilePicture == null || profilePicture!.isEmpty
                  ? Text(
                      name.isNotEmpty ? name.substring(0, 1) : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    languages.isNotEmpty
                        ? "$location • ${languages.join(", ")}"
                        : location,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}