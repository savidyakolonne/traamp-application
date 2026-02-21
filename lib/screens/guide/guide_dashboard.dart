import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class GuideDashboard extends StatelessWidget {
  const GuideDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Guide Dashboard'),
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
      body: const Center(child: Text('Guide Dashboard (Phase 1)')),
    );
  }
}