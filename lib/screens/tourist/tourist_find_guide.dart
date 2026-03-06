import 'package:flutter/material.dart';
import '../../models/guide.dart';
import '../../services/guide_service.dart';

class FindGuidesScreen extends StatefulWidget {
  const FindGuidesScreen({super.key});

  @override
  State<FindGuidesScreen> createState() => _FindGuidesScreenState();
}

class _FindGuidesScreenState extends State<FindGuidesScreen> {
  final TextEditingController _search = TextEditingController();

  String? selectedLocation;
  final Set<String> selectedLanguages = {};

  // demo languages (replace with your real list)
  final List<String> allLanguages = [
    "Sinhala",
    "Tamil",
    "English",
    "Russian",
    "German",
    "French",
    "Spanish",
    "Italian",
    "Chinese (Mandarin)",
    "Korean",
    "Japanese",
    "Hindi",
    "Arabic",
    "Dutch",
    "Ukrainian",
  ];

  void _openFilterSheet() {
    // local temp state inside the sheet (so Apply/Cancel works clean)
    String? tempLocation = selectedLocation;
    final tempLanguages = {...selectedLanguages};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.62,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                  const Text(
                    "Filter Guides",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  const Text(
                    "Location",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
                      DropdownMenuItem(
                        value: "Hikkaduwa",
                        child: Text("Hikkaduwa"),
                      ),
                      DropdownMenuItem(value: "Galle", child: Text("Galle")),
                      DropdownMenuItem(value: "Ella", child: Text("Ella")),
                      DropdownMenuItem(value: "Kandy", child: Text("Kandy")),
                      DropdownMenuItem(
                        value: "Colombo",
                        child: Text("Colombo"),
                      ),
                    ],
                    onChanged: (v) => tempLocation = v,
                  ),

                  const SizedBox(height: 18),

                  // Languages
                  const Text(
                    "Languages",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
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
                          if (v) {
                            tempLanguages.add(lang);
                          } else {
                            tempLanguages.remove(lang);
                          }
                          setState(() {}); // just to refresh chip visuals
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
                            tempLocation = null;
                            tempLanguages.clear();
                            (context as Element).markNeedsBuild();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
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
      chips.add(
        _chip(selectedLocation!, () => setState(() => selectedLocation = null)),
      );
    }
    for (final lang in selectedLanguages) {
      chips.add(
        _chip(lang, () => setState(() => selectedLanguages.remove(lang))),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  titleSpacing: 16,
                  title: const Text(
                    "Find a Guide",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(132),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Column(
                        children: [
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
                                  ...chips.map(
                                    (c) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: c,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 8),
                          const TabBar(
                            isScrollable: true,
                            tabs: [
                              Tab(text: "All"),
                              Tab(text: "Guides"),
                              Tab(text: "Posts"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _AllTab(
                  search: _search.text,
                  location: selectedLocation,
                  languages: selectedLanguages,
                ),
                _GuidesTab(
                  search: _search.text,
                  location: selectedLocation,
                  languages: selectedLanguages,
                ),
                _PostsTab(
                  search: _search.text,
                  location: selectedLocation,
                  languages: selectedLanguages,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ------------------ Dynamic Guides Tab ------------------ */

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
      _fetchGuides();
      setState(() {});
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
          return const Center(child: Text("No guides found"));
        }

        final searchLower = widget.search.toLowerCase();
        final filteredGuides = snapshot.data!
            .where(
              (g) =>
                  g.firstName.toLowerCase().contains(searchLower) ||
                  g.lastName.toLowerCase().contains(searchLower),
            )
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          itemCount: filteredGuides.length,
          itemBuilder: (context, index) {
            final g = filteredGuides[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _GuideCard(
                name: "${g.firstName} ${g.lastName}",
                location: g.location,
                languages: [], // optionally map g.languages here
              ),
            );
          },
        );
      },
    );
  }
}

/* ------------------ Demo AllTab + PostsTab ------------------ */

class _AllTab extends StatelessWidget {
  final String search;
  final String? location;
  final Set<String> languages;

  const _AllTab({
    required this.search,
    required this.location,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: const [
        _GuideCard(
          name: "Demo Guide",
          location: "Hikkaduwa",
          languages: ["English"],
        ),
        SizedBox(height: 12),
        _PostCard(title: "Hidden Gems of the South", guideName: "Demo Guide"),
      ],
    );
  }
}

class _PostsTab extends StatelessWidget {
  final String search;
  final String? location;
  final Set<String> languages;

  const _PostsTab({
    required this.search,
    required this.location,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: const [
        _PostCard(title: "Best 1-day plan in Galle", guideName: "Demo Guide"),
      ],
    );
  }
}

/* ------------------ Cards ------------------ */

class _GuideCard extends StatelessWidget {
  final String name;
  final String location;
  final List<String> languages;

  const _GuideCard({
    required this.name,
    required this.location,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(
              name.substring(0, 1),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$location • ${languages.join(", ")}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            child: const Text("Message"),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final String title;
  final String guideName;

  const _PostCard({required this.title, required this.guideName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: const Center(child: Icon(Icons.image_outlined, size: 34)),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "By $guideName",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Open"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}