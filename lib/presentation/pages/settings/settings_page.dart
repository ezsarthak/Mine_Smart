// filename: lib/presentation/pages/settings/settings_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingSection('General', [
            _buildSettingTile(
              Icons.notifications,
              'Notifications',
              'Configure alerts and warnings',
              true,
            ),
            _buildSettingTile(
              Icons.dark_mode,
              'Dark Mode',
              'Always enabled for mining theme',
              true,
            ),
          ]),
          const SizedBox(height: 24),
          _buildSettingSection('AI & Automation', [
            _buildSettingTile(
              Icons.auto_awesome,
              'Auto Optimization',
              'Enable AI-driven optimization',
              true,
            ),
            _buildSettingTile(
              Icons.psychology,
              'Predictive Alerts',
              'AI-powered early warnings',
              true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.accentColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentColor),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: AppTheme.accentColor,
      ),
    );
  }
}
