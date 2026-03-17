import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyServices extends StatelessWidget {
  const EmergencyServices({super.key});

  Future<void> open(String u) async =>
      launchUrl(Uri.parse(u), mode: LaunchMode.externalApplication);

  final data = const [
    [
      "assets/images/tourism.png",
      "Sri Lanka Tourism Development Authority",
      "Official Tourism Support",
      "1912",
      Colors.green,
      "https://www.sltda.gov.lk",
    ],
    [
      "assets/images/police.png",
      "Sri Lanka Tourism Police",
      "Security & Assistance",
      "119",
      Colors.blue,
      "https://www.police.lk",
    ],
    [
      "assets/images/ambulance.png",
      "Suwa Sariya Ambulance Service",
      "Medical Emergencies",
      "1990",
      Colors.red,
      "https://1990.lk",
    ],
    [
      "assets/images/rdmns.png",
      "RDMNS.LK Network",
      "Railway Passenger Network",
      "",
      Colors.teal,
      "https://www.rdmns.lk",
    ],
  ];

  @override
  Widget build(BuildContext c) => Scaffold(
    backgroundColor: Color.fromARGB(255, 247, 248, 246),
    appBar: AppBar(
      title: const Text("Emergency Contacts"),
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 247, 248, 246),
    ),
    body: Container(
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...data.map(
              (e) => EmergencyItem(
                image: e[0] as String,
                title: e[1] as String,
                subtitle: e[2] as String,
                phone: e[3] as String,
                color: e[4] as Color,
                onWebsiteTap: () => open(e[5] as String),
              ),
            ),
            const TravelSafeTip(),
          ],
        ),
      ),
    ),
  );
}

class EmergencyItem extends StatelessWidget {
  final String image, title, subtitle, phone;
  final Color color;
  final VoidCallback onWebsiteTap;
  const EmergencyItem({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.phone,
    required this.color,
    required this.onWebsiteTap,
  });

  Future<void> call(String n) async => launchUrl(Uri(scheme: 'tel', path: n));

  @override
  Widget build(BuildContext c) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onWebsiteTap,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(image, height: 45),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: phone.isEmpty ? onWebsiteTap : () => call(phone),
            child: CircleAvatar(
              backgroundColor: color,
              child: Icon(
                phone.isEmpty ? Icons.link : Icons.phone,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class TravelSafeTip extends StatelessWidget {
  const TravelSafeTip({super.key});
  @override
  Widget build(BuildContext c) => Card(
    color: const Color(0xFFE8F5E9),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.shield, color: Colors.green),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Travel Safe Tip\nKeep passport & important documents digitally. "
              "If lost, contact Tourism Police immediately.",
            ),
          ),
        ],
      ),
    ),
  );
}
