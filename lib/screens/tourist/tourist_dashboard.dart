import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class TouristDashboard extends StatelessWidget {
  const TouristDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.popUntil(context, (r) => r.isFirst);
            },
          ),
        ],
      ),
      body: const Center(child: Text('Tourist dashboard (phase 1)')),
    );
  }
}
