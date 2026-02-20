import 'package:flutter/material.dart';

import '../../../../core/ui/app_scaffold.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return AppScaffold(
      title: "Partner Status",

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),

          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  /// Status Icon
                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      size: 42,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Title
                  Text(
                    "Approval Pending",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Text(
                      "UNDER REVIEW",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Description
                  Text(
                    "Your partner account is currently under review by our admin team.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "You will be able to submit candidates and access partner features once approved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], height: 1.5),
                  ),

                  const SizedBox(height: 24),

                  /// Info box
                  Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: primary),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            "Approval usually takes 24–48 hours.",
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
