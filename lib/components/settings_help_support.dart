import 'package:flutter/material.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "HELP TOPICS",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Payments Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.payments, color: Colors.green),
                ),
                title: const Text(
                  "Payments",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Billing, refunds and subscriptions",
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "CONTACT US",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Email Support
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple.shade100,
                  child: const Icon(Icons.email, color: Colors.purple),
                ),
                title: const Text(
                  "Email Support",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Response within 24 hours",
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text("Send Email"),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Phone Support
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: const Icon(Icons.phone, color: Colors.teal),
                ),
                title: const Text(
                  "Phone Support",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Mon-Fri, 9am - 6pm EST",
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text("Call Us"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}