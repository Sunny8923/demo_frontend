import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/presentation/screens/csv_result_screen.dart';
import 'package:gap/gap.dart';

import '../providers/csv_upload_provider.dart';

class UploadCandidateCsvScreen extends ConsumerStatefulWidget {
  const UploadCandidateCsvScreen({super.key});

  @override
  ConsumerState<UploadCandidateCsvScreen> createState() =>
      _UploadCandidateCsvScreenState();
}

class _UploadCandidateCsvScreenState
    extends ConsumerState<UploadCandidateCsvScreen> {
  html.File? selectedFile;

  ////////////////////////////////////////////////////////////
  /// PICK FILE
  ////////////////////////////////////////////////////////////
  void pickFile() {
    final input = html.FileUploadInputElement();
    input.accept = ".csv";

    input.click();

    input.onChange.listen((event) {
      final file = input.files?.first;

      if (file == null) return;

      ////////////////////////////////////////////////////////////
      /// VALIDATION
      ////////////////////////////////////////////////////////////

      // Type
      if (!file.name.toLowerCase().endsWith(".csv")) {
        showError("Only CSV files are allowed");
        return;
      }

      // Size (5MB)
      if (file.size > 5 * 1024 * 1024) {
        showError("File size must be less than 5MB");
        return;
      }

      setState(() {
        selectedFile = file;
      });
    });
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  ////////////////////////////////////////////////////////////
  /// UPLOAD
  ////////////////////////////////////////////////////////////
  Future<void> upload() async {
    if (selectedFile == null) return;

    final notifier = ref.read(csvUploadProvider.notifier);

    try {
      final result = await notifier.upload(selectedFile);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CsvResultScreen(result: result)),
      );
    } catch (e) {
      showError("Upload failed");
    }
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final state = ref.watch(csvUploadProvider);
    final isLoading = state.isLoading;
    final result = state.value;

    return Scaffold(
      appBar: AppBar(title: const Text("Upload CSV")),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload CSV",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          "Upload candidate data using CSV",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        const Gap(24),

                        ////////////////////////////////////////////////////////////
                        /// PICK AREA
                        ////////////////////////////////////////////////////////////
                        GestureDetector(
                          onTap: isLoading ? null : pickFile,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withOpacity(.3),
                              ),
                            ),
                            child: Column(
                              children: const [
                                Icon(Icons.upload_file, size: 40),
                                Gap(12),
                                Text("Click to upload CSV"),
                              ],
                            ),
                          ),
                        ),

                        const Gap(20),

                        ////////////////////////////////////////////////////////////
                        /// FILE NAME
                        ////////////////////////////////////////////////////////////
                        if (selectedFile != null)
                          Text("Selected: ${selectedFile!.name}"),

                        const Gap(24),

                        ////////////////////////////////////////////////////////////
                        /// RESULT UI
                        ////////////////////////////////////////////////////////////
                        if (result != null) _ResultCard(result: result),
                      ],
                    ),
                  ),
                ),

                ////////////////////////////////////////////////////////////
                /// BUTTON
                ////////////////////////////////////////////////////////////
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (isLoading || selectedFile == null)
                        ? null
                        : upload,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Upload & Process"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// RESULT CARD
////////////////////////////////////////////////////////////

class _ResultCard extends StatelessWidget {
  final Map<String, dynamic> result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Results", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),

        Text("Total: ${result['total']}"),
        Text("Created: ${result['created']}"),
        Text("Duplicate: ${result['duplicate']}"),
        Text("Skipped: ${result['skipped']}"),
        Text("Error: ${result['error']}"),
      ],
    );
  }
}
