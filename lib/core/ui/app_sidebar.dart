import 'package:flutter/material.dart';
import '../ui/app_drawer.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 260,
      height: double.infinity, // 🔥 THIS IS REQUIRED
      child: AppDrawer(),
    );
  }
}
