// import 'package:flutter/material.dart';

// class TechnicalIssues extends StatelessWidget {
//   const TechnicalIssues({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F5F7),

//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF4F5F7),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Technical Issues",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [

//             /// CONTACT SUPPORT CARD
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 8,
//                   )
//                 ],
//               ),

//               child: Row(
//                 children: [

//                   /// TEXT PART
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [

//                         const Text(
//                           "CONTACT US",
//                           style: TextStyle(
//                             color: Colors.orange,
//                             letterSpacing: 1,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 8),

//                         const Text(
//                           "Technical Support",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),

//                         const SizedBox(height: 4),

//                         const Text(
//                           "+1 (800) TRAMMP-HELP",
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 16,
//                           ),
//                         ),

//                         const SizedBox(height: 12),

//                         ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.orange,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: () {},
//                           icon: const Icon(Icons.phone),
//                           label: const Text("Call Now"),
//                         )
//                       ],
//                     ),
//                   ),

//                   /// ICON BOX
//                   Container(
//                     height: 70,
//                     width: 70,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.support_agent,
//                       color: Colors.orange,
//                       size: 40,
//                     ),
//                   )
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             /// DESCRIBE ISSUE TITLE
//             const Text(
//               "Describe your issue",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 12),

//             /// TEXT FIELD BOX
//             Container(
//               height: 150,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: const TextField(
//                 maxLines: null,
//                 decoration: InputDecoration(
//                   hintText:
//                       "Please provide details about the technical problem you are experiencing with the TRAMMP app...",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),

//             const Text(
//               "Maximum 500 characters. Our team typically responds within 24 hours.",
//               style: TextStyle(color: Colors.grey),
//             ),

//             const SizedBox(height: 25),

//             /// ATTACH SCREENSHOT BOX
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey.shade300,
//                   style: BorderStyle.solid,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 children: const [
//                   Icon(Icons.camera_alt_outlined, color: Colors.grey),
//                   SizedBox(width: 10),
//                   Text(
//                     "Attach a screenshot (optional)",
//                     style: TextStyle(color: Colors.grey),
//                   )
//                 ],
//               ),
//             ),

//             const SizedBox(height: 40),

//             /// SUBMIT BUTTON
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding: const EdgeInsets.symmetric(vertical: 18),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               onPressed: () {},
//               child: const Text(
//                 "Submit Report ▶",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TechnicalIssues extends StatefulWidget {
  const TechnicalIssues({super.key});

  @override
  State<TechnicalIssues> createState() => _TechnicalIssuesState();
}

class _TechnicalIssuesState extends State<TechnicalIssues> {
  final TextEditingController issueController = TextEditingController();

  Future<void> submitIssue() async {
    if (issueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please describe the issue")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('issues').add({
        "issue": issueController.text,
        "createdAt": Timestamp.now(),
        "status": "pending",
      });

      issueController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Issue submitted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Technical Issues",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Contact Support Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "CONTACT US",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Technical Support",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "+94 77 123 4567",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone),
                    label: const Text("Call Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Describe your issue",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Issue TextField
            Container(
              height: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: issueController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      "Please provide details about the technical problem you are experiencing...",
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Maximum 500 characters. Our team responds within 24 hours.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            // Submit Button
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: submitIssue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Submit Report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
