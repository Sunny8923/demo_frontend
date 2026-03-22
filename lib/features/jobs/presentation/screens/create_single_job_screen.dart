import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/app_scaffold.dart';

import '../providers/create_job_provider.dart';

class CreateSingleJobScreen extends ConsumerStatefulWidget {
  const CreateSingleJobScreen({super.key});

  @override
  ConsumerState<CreateSingleJobScreen> createState() =>
      _CreateSingleJobScreenState();
}

class _CreateSingleJobScreenState extends ConsumerState<CreateSingleJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final locationController = TextEditingController();
  final departmentController = TextEditingController();

  final minExpController = TextEditingController();
  final maxExpController = TextEditingController();

  final salaryMinController = TextEditingController();
  final salaryMaxController = TextEditingController();

  final openingsController = TextEditingController();

  final skillsController = TextEditingController();
  final educationController = TextEditingController();

  String status = "open";

  /////////////////////////////////////////////////////////////
  /// CREATE JOB
  /////////////////////////////////////////////////////////////

  Future<void> createJob() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(createJobProvider.notifier);

    await notifier.createJob(
      title: titleController.text.trim(),
      companyName: companyController.text.trim(),
      location: locationController.text.trim(),
      department: departmentController.text.trim(),
      minExperience: int.tryParse(minExpController.text),
      maxExperience: int.tryParse(maxExpController.text),
      salaryMin: int.tryParse(salaryMinController.text),
      salaryMax: int.tryParse(salaryMaxController.text),
      openings: int.tryParse(openingsController.text),
      skills: skillsController.text.trim(),
      education: educationController.text.trim(),
      status: status,
    );

    final state = ref.read(createJobProvider);

    if (state.hasError) {
      _showError(state.error.toString());
      return;
    }

    _showSuccess("Job created successfully");

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /////////////////////////////////////////////////////////////
  /// UI
  /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(createJobProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Job")),

      body: Form(
        key: _formKey,

        child: ListView(
          children: [
            _SectionCard(
              title: "Basic Information",
              children: [
                _Field("Job Title", titleController, required: true),
                _Field("Company Name", companyController, required: true),
                _Field("Location", locationController, required: true),
                _Field("Department", departmentController),
              ],
            ).animate().fadeIn().slideY(begin: .05),

            _SectionCard(
              title: "Experience",
              children: [
                _Field(
                  "Min Experience (years)",
                  minExpController,
                  keyboardType: TextInputType.number,
                ),
                _Field(
                  "Max Experience (years)",
                  maxExpController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),

            _SectionCard(
              title: "Compensation",
              children: [
                _Field(
                  "Salary Min",
                  salaryMinController,
                  keyboardType: TextInputType.number,
                ),
                _Field(
                  "Salary Max",
                  salaryMaxController,
                  keyboardType: TextInputType.number,
                ),
                _Field(
                  "Openings",
                  openingsController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ).animate().fadeIn(delay: 150.ms),

            _SectionCard(
              title: "Additional Info",
              children: [
                _Field("Skills", skillsController),
                _Field("Education", educationController),
              ],
            ).animate().fadeIn(delay: 200.ms),

            _StatusSelector(
              value: status,
              onChanged: (v) => setState(() => status = v),
            ).animate().fadeIn(delay: 250.ms),

            const Gap(12),

            _CreateButton(
              loading: loading,
              onPressed: createJob,
            ).animate().fadeIn(delay: 300.ms),

            const Gap(24),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// SECTION CARD
///////////////////////////////////////////////////////////////

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.withOpacity(.15)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const Gap(16),

            ...children,
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// FIELD
///////////////////////////////////////////////////////////////

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool required;
  final TextInputType? keyboardType;

  const _Field(
    this.label,
    this.controller, {
    this.required = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,

        validator: required
            ? (v) => v == null || v.isEmpty ? "$label required" : null
            : null,

        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// STATUS SELECTOR
///////////////////////////////////////////////////////////////

class _StatusSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _StatusSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: DropdownButtonFormField<String>(
          value: value,

          items: const [
            DropdownMenuItem(value: "open", child: Text("Open")),
            DropdownMenuItem(value: "closed", child: Text("Closed")),
          ],

          onChanged: (v) => onChanged(v!),

          decoration: const InputDecoration(labelText: "Status"),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// BUTTON
///////////////////////////////////////////////////////////////

class _CreateButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const _CreateButton({required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,

      child: ElevatedButton(
        onPressed: loading ? null : onPressed,

        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Create Job",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
