import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../services/places_service.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;
  const PlaceDetailScreen({required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _nextImage(int length) {
    if (_currentIndex < length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),
      body: FutureBuilder(
        future: PlacesService.getPlaceById(widget.placeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final Place place = snapshot.data!;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // ================= IMAGE SLIDER =================
              SizedBox(
                height: 280,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: place.images.length,
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          place.images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),

                    // Back Button
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),

                    // Left Arrow
                    Positioned(
                      left: 10,
                      top: 120,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: _previousImage,
                      ),
                    ),

                    // Right Arrow
                    Positioned(
                      right: 10,
                      top: 120,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => _nextImage(place.images.length),
                      ),
                    ),

                    // Indicator Dots
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          place.images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentIndex == index ? 18 : 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ================= TITLE =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  place.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // ================= LOCATION =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Color(0xff1BA672),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${place.district}, ${place.province}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ================= QUICK INFO =================
              if (place.visitingHours != null || place.bestTimeToVisit != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Quick Info",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // VISITING HOURS (FULL ROW)
                      if (place.visitingHours != null)
                        _fullWidthInfoCard(
                          icon: Icons.access_time,
                          title: "Visiting Hours",
                          line1:
                              place.visitingHours!['daily'] ?? "Not available",
                          line2: place.visitingHours!['note'] ?? "",
                          iconColor: Colors.blue,
                          iconBg: const Color(0xffE3F2FD),
                          cardColor: const Color(0xFFD8FCEA),
                        ),

                      const SizedBox(height: 14),

                      // BEST TIME (FULL ROW)
                      if (place.bestTimeToVisit != null)
                        _fullWidthInfoCard(
                          icon: Icons.wb_sunny,
                          title: "Best Time",
                          line1:
                              place.bestTimeToVisit!['seasonNote'] ??
                              "Not available",
                          line2: place.bestTimeToVisit!['timeOfDayNote'] ?? "",
                          iconColor: Colors.orange,
                          iconBg: const Color(0xffFFF3E0),
                          cardColor: const Color(0xFFD8FCEA),
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 22),

              // ================= ABOUT =================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "About this place",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  place.description,
                  style: const TextStyle(height: 1.6, fontSize: 15),
                ),
              ),

              const SizedBox(height: 22),

              // ================= ACTIVITIES =================
              if (place.activities != null && place.activities!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Activities",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...place.activities!.entries.map(
                        (e) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xff1BA672),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  // ================= FULL WIDTH CARD =================
  Widget _fullWidthInfoCard({
    required IconData icon,
    required String title,
    required String line1,
    required String line2,
    required Color iconColor,
    required Color iconBg,
    required Color cardColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 6),

                Text(
                  line1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (line2.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      line2,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
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
