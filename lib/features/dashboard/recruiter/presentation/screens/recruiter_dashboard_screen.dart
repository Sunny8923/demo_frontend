import 'package:flutter/material.dart';

class RecruiterDashboardScreen extends StatelessWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recruiter Dashboard")),
      body: const Center(
        child: Text("Welcome Recruiter 👋", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
