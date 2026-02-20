import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_scaffold.dart';
import '../../presentation/providers/appliaction_provider.dart';
import '../../../jobs/data/models/job_model.dart';

class SubmitCandidateScreen extends ConsumerStatefulWidget {
  final JobModel job;

  const SubmitCandidateScreen({super.key, required this.job});

  @override
  ConsumerState<SubmitCandidateScreen> createState() =>
      _SubmitCandidateScreenState();
}

class _SubmitCandidateScreenState extends ConsumerState<SubmitCandidateScreen> {
  //////////////////////////////////////////////////////
  /// Controllers
  //////////////////////////////////////////////////////

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final locationController = TextEditingController();
  final experienceController = TextEditingController();
  final companyController = TextEditingController();
  final designationController = TextEditingController();
  final salaryController = TextEditingController();
  final noticePeriodController = TextEditingController();
  final skillsController = TextEditingController();
  final qualificationController = TextEditingController();

  //////////////////////////////////////////////////////
  /// Helpers
  //////////////////////////////////////////////////////

  double? parseDouble(String value) {
    if (value.trim().isEmpty) return null;
    return double.tryParse(value.trim());
  }

  int? parseInt(String value) {
    if (value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }

  String? parseString(String value) {
    if (value.trim().isEmpty) return null;
    return value.trim();
  }

  //////////////////////////////////////////////////////
  /// Submit
  //////////////////////////////////////////////////////

  Future<void> submit() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name, Email, Phone required")),
      );
      return;
    }

    await ref
        .read(applyJobProvider.notifier)
        .apply(
          jobId: widget.job.id,

          /// required
          name: name,
          email: email,
          phone: phone,

          /// optional (SEND AS STRING)
          currentLocation: parseString(locationController.text),
          totalExperience: parseString(experienceController.text),
          currentCompany: parseString(companyController.text),
          currentDesignation: parseString(designationController.text),
          expectedSalary: parseString(salaryController.text),
          noticePeriodDays: parseString(noticePeriodController.text),
          skills: parseString(skillsController.text),
          highestQualification: parseString(qualificationController.text),
        );

    final state = ref.read(applyJobProvider);

    if (state.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error.toString())));
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Candidate submitted successfully")),
    );

    Navigator.pop(context);
  }

  //////////////////////////////////////////////////////
  /// UI Helpers
  //////////////////////////////////////////////////////

  Widget field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////
  /// UI
  //////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(applyJobProvider).isLoading;

    return AppScaffold(
      title: "Submit Candidate",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _JobInfoCard(job: widget.job),

            const SizedBox(height: 24),

            Text(
              "Basic Information",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            field("Full Name *", nameController),
            field(
              "Email *",
              emailController,
              keyboard: TextInputType.emailAddress,
            ),
            field("Phone *", phoneController, keyboard: TextInputType.phone),

            const SizedBox(height: 24),

            Text(
              "Professional Information",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            field("Current Location", locationController),
            field(
              "Total Experience (years)",
              experienceController,
              keyboard: TextInputType.number,
            ),
            field("Current Company", companyController),
            field("Current Designation", designationController),
            field(
              "Expected Salary",
              salaryController,
              keyboard: TextInputType.number,
            ),
            field(
              "Notice Period (days)",
              noticePeriodController,
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 24),

            Text(
              "Skills & Education",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            field("Skills", skillsController),
            field("Highest Qualification", qualificationController),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Candidate"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// Job Info Card
////////////////////////////////////////////////////////////

class _JobInfoCard extends StatelessWidget {
  final JobModel job;

  const _JobInfoCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (job.description != null)
              Text(job.description!, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text(
              job.companyName ?? "",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
