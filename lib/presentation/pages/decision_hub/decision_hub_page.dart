// filename: lib/presentation/pages/decision_hub/decision_hub_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';

class DecisionHubPage extends StatelessWidget {
  const DecisionHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.cardColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Decision Hub',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text(
          'AI Decision Support Hub\nComing Soon',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 18),
        ),
      ),
    );
  }
}
