import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyServices extends StatelessWidget {
  const EmergencyServices({super.key});

  // 🌐 Open website
  Future<void> _openWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Emergency Contacts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.all(20),
                children: [
                  // SLTDA → website
                  EmergencyItem(
                    image: "assets/images/tourism.png",
                    title: "Sri Lanka Tourism Development Authority",
                    phone: "1912",
                    onWebsiteTap: () {
                      _openWebsite("https://www.sltda.gov.lk");
                    },
                  ),

                  // Tourism Police → call
                  EmergencyItem(
                    image: "assets/images/police.png",
                    title: "Sri Lanka Tourism Police",
                    phone: "119",
                    onWebsiteTap: () {
                      _openWebsite("https://www.police.lk");
                    },
                  ),

                  // Suwa Sariya → call
                  EmergencyItem(
                    image: "assets/images/ambulance.png",
                    title: "Suwa Sariya Ambulance Service",
                    phone: "1990",
                    onWebsiteTap: () {
                      _openWebsite("https://1990.lk");
                    },
                  ),

                  // RDMNS → website
                  EmergencyItem(
                    image: "assets/images/rdmns.png",
                    title:
                        "RDMNS.LK Nationwide Official Railway Passengers' Network",
                    phone: "",
                    onWebsiteTap: () {
                      _openWebsite("https://www.rdmns.lk");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ================= EMERGENCY ITEM =================
//

class EmergencyItem extends StatelessWidget {
  final String image;
  final String title;
  final String phone;
  final VoidCallback onWebsiteTap;

  const EmergencyItem({
    super.key,
    required this.image,
    required this.title,
    required this.phone,
    required this.onWebsiteTap,
  });

  // 📞 Make phone call
  Future<void> _makeCall(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 🌐 Tap anywhere on card → website
      onTap: onWebsiteTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, height: 70, fit: BoxFit.contain),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 6),

            // 📞 ONLY phone row triggers call
            if (phone.isNotEmpty)
              InkWell(
                onTap: () async {
                  final Uri uri = Uri(scheme: 'tel', path: phone);
                  await launchUrl(uri);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}



// class EmergencyServices extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Emergency Services'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget> [
//               Text('Emergency Services Screen'),
//               Image(image:  AssetImage('assets/images/logo.png'))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }