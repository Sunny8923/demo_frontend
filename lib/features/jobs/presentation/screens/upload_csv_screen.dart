import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/app_scaffold.dart';

import '../providers/upload_csv_provider.dart';

class UploadCsvScreen extends ConsumerStatefulWidget {
  const UploadCsvScreen({super.key});

  @override
  ConsumerState<UploadCsvScreen> createState() => _UploadCsvScreenState();
}

class _UploadCsvScreenState extends ConsumerState<UploadCsvScreen> {
  File? selectedFile;

  /////////////////////////////////////////////////////////////
  /// PICK FILE
  /////////////////////////////////////////////////////////////

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["csv"],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  /////////////////////////////////////////////////////////////
  /// UPLOAD
  /////////////////////////////////////////////////////////////

  Future<void> upload() async {
    if (selectedFile == null) {
      _showMessage("Please select a CSV file");
      return;
    }

    await ref.read(uploadCsvProvider.notifier).upload(selectedFile!);

    final state = ref.read(uploadCsvProvider);

    if (state.hasError) {
      _showMessage(state.error.toString());
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /////////////////////////////////////////////////////////////
  /// ERROR DIALOG
  /////////////////////////////////////////////////////////////

  void showErrors(List errors) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Upload Errors"),

        content: SizedBox(
          width: 400,

          child: ListView.builder(
            shrinkWrap: true,

            itemCount: errors.length,

            itemBuilder: (_, index) {
              final e = errors[index];

              return ListTile(
                title: Text("Row ${e['row']}"),
                subtitle: Text(e['error'] ?? "Unknown error"),
              );
            },
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  /// UI
  /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadCsvProvider);

    final loading = state.isLoading;
    final result = state.value;

    return AppScaffold(
      title: "Upload Jobs CSV",

      body: ListView(
        children: [
          /// File picker
          _FilePickerCard(
            file: selectedFile,
            onPick: pickFile,
          ).animate().fadeIn().slideY(begin: .05),

          const Gap(16),

          /// Upload button
          _UploadButton(
            loading: loading,
            onPressed: upload,
          ).animate().fadeIn(delay: 100.ms),

          const Gap(24),

          /// Result summary
          if (result != null)
            _UploadSummary(
              result: result,
              onViewErrors: () => showErrors(result.errors),
            ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// FILE PICKER CARD
///////////////////////////////////////////////////////////////

class _FilePickerCard extends StatelessWidget {
  final File? file;
  final VoidCallback onPick;

  const _FilePickerCard({required this.file, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.withOpacity(.15)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            Icon(
              Icons.upload_file_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),

            const Gap(12),

            Text(
              file?.path.split('/').last ?? "No file selected",

              style: TextStyle(
                color: file == null
                    ? Colors.grey[600]
                    : theme.colorScheme.primary,
              ),
            ),

            const Gap(16),

            ElevatedButton(
              onPressed: onPick,
              child: const Text("Select CSV File"),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// UPLOAD BUTTON
///////////////////////////////////////////////////////////////

class _UploadButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const _UploadButton({required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,

      child: ElevatedButton(
        onPressed: loading ? null : onPressed,

        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Upload CSV",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// SUMMARY
///////////////////////////////////////////////////////////////

class _UploadSummary extends StatelessWidget {
  final dynamic result;
  final VoidCallback onViewErrors;

  const _UploadSummary({required this.result, required this.onViewErrors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        const Gap(16),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,

          children: [
            _StatCard("Total Rows", result.totalRows, Colors.blue),

            _StatCard("Created", result.created, Colors.green),

            _StatCard("Duplicates", result.duplicates, Colors.orange),

            _StatCard("Failed", result.failed, Colors.red),

            _StatCard("Skipped", result.skipped, Colors.grey),

            _StatCard("Valid Rows", result.validRows, Colors.teal),
          ],
        ),

        const Gap(16),

        if (result.errors.isNotEmpty)
          ElevatedButton(
            onPressed: onViewErrors,
            child: Text("View Errors (${result.errors.length})"),
          ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////
/// STAT CARD
///////////////////////////////////////////////////////////////

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(.15)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              value.toString(),

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),

            const Gap(4),

            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
