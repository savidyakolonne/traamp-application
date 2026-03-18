import 'package:flutter/material.dart';

import '../screens/profile/guide_public_view_screen.dart';

class GuideCard extends StatefulWidget {
  final String uid;
  final String guideUid;
  final String name;
  final String location;
  final List<String> languages;
  final double? rating;
  final String? profilePicture;
  const GuideCard({
    super.key,
    required this.uid,
    required this.guideUid,
    required this.name,
    required this.location,
    required this.languages,
    this.rating,
    this.profilePicture,
  });

  @override
  State<GuideCard> createState() => _GuideCardState();
}

class _GuideCardState extends State<GuideCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuidePublicViewScreen(
              guideId: widget.guideUid,
              uid: widget.uid,
            ),
          ),
        );
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
              backgroundImage:
                  widget.profilePicture != null &&
                      widget.profilePicture!.isNotEmpty
                  ? NetworkImage(widget.profilePicture!)
                  : null,
              child:
                  widget.profilePicture == null ||
                      widget.profilePicture!.isEmpty
                  ? Text(
                      widget.name.isNotEmpty
                          ? widget.name.substring(0, 1)
                          : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          widget.rating.runtimeType == String
                              ? Text(widget.rating.toString())
                              : Text(widget.rating!.toStringAsFixed(1)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.languages.isNotEmpty
                        ? "$widget.location • ${widget.languages.join(", ")}"
                        : widget.location,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
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
