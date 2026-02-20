import 'package:flutter/material.dart';
import '../../models/activity_model.dart';
import '../../services/activities_service.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String activityId;
  const ActivityDetailScreen({required this.activityId});

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
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
        future: ActivitiesService.getActivityById(widget.activityId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final Activity activity = snapshot.data!;

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
                      itemCount: activity.images.length,
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          activity.images[index],
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
                        onPressed: () => _nextImage(activity.images.length),
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
                          activity.images.length,
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
                  activity.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

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
                      "${activity.district}, ${activity.province}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ================= SHORT DESCRIPTION =================
              if (activity.shortDesc != null && activity.shortDesc!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8FCEA), // light green card
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      activity.shortDesc!,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),

              const SizedBox(height: 22),

              // ================= QUICK INFO =================
              if (activity.bestTime != null)
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
                      _fullWidthInfoCard(
                        icon: Icons.wb_sunny,
                        title: "Best Time",
                        line1:
                            activity.bestTime!['seasonNote'] ?? "Not available",
                        line2: activity.bestTime!['timeOfDayNote'] ?? "",
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
                  "About this activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  activity.description,
                  style: const TextStyle(height: 1.6, fontSize: 15),
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
