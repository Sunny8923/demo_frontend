import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/application/presentation/widgets/pipeline_stage_column.dart';
import '../../../../core/ui/app_scaffold.dart';

import '../providers/admin_application_provider.dart';

class AtsPipelineScreen extends ConsumerWidget {
  const AtsPipelineScreen({super.key});

  static const stages = [
    "APPLIED",
    "SCREENING",
    "CONTACTED",
    "INTERVIEW_SCHEDULED",
    "INTERVIEW_COMPLETED",
    "OFFER_SENT",
    "HIRED",
    "REJECTED",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminApplicationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("ATS pipeline")),

      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (_, __) => const Center(child: Text("Failed to load pipeline")),

        data: (applications) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            padding: const EdgeInsets.all(16),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: stages.map((stage) {
                final stageApps = applications
                    .where((app) => app.pipelineStage == stage)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.only(right: 16),

                  child: PipelineStageColumn(
                    stage: stage,
                    applications: stageApps,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
