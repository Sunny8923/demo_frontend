import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/shared/current_job_provider.dart';
import 'package:frontend/core/shared/job_history_provider.dart';
import 'package:gap/gap.dart';

import '../providers/resume_upload_provider.dart';
import 'job_status_screen.dart';

class UploadResumeScreen extends ConsumerStatefulWidget {
  const UploadResumeScreen({super.key});

  @override
  ConsumerState<UploadResumeScreen> createState() => _UploadResumeScreenState();
}

class _UploadResumeScreenState extends ConsumerState<UploadResumeScreen> {
  List<html.File> selectedFiles = [];

  ////////////////////////////////////////////////////////////
  /// PICK FILES (WEB)
  ////////////////////////////////////////////////////////////

  void pickFiles() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.accept = ".pdf,.doc,.docx";

    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;

      if (files != null && files.isNotEmpty) {
        setState(() {
          selectedFiles = files;
        });
      }
    });
  }

  ////////////////////////////////////////////////////////////
  /// UPLOAD
  ////////////////////////////////////////////////////////////

  Future<void> upload() async {
    if (selectedFiles.isEmpty) return;

    final notifier = ref.read(resumeUploadProvider.notifier);

    try {
      final jobId = await notifier.upload(selectedFiles);

      ////////////////////////////////////////////////////////////
      /// SAVE JOB GLOBALLY
      ////////////////////////////////////////////////////////////
      ref.read(currentJobProvider.notifier).setJob(jobId);

      ref.read(jobHistoryProvider.notifier).addJob(jobId);

      ////////////////////////////////////////////////////////////
      /// NAVIGATE TO STATUS SCREEN
      ////////////////////////////////////////////////////////////
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => JobStatusScreen(jobId: jobId)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload failed")));
    }
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final uploadState = ref.watch(resumeUploadProvider);

    final isLoading = uploadState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Upload Resumes")),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                ////////////////////////////////////////////////////////////
                /// SCROLLABLE CONTENT
                ////////////////////////////////////////////////////////////
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ////////////////////////////////////////////////////////////
                        /// HEADER
                        ////////////////////////////////////////////////////////////
                        Text(
                          "Upload Resumes",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const Gap(8),

                        Text(
                          "Upload single or multiple resumes (PDF, DOC, DOCX)",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),

                        const Gap(24),

                        ////////////////////////////////////////////////////////////
                        /// DROP AREA
                        ////////////////////////////////////////////////////////////
                        GestureDetector(
                          onTap: isLoading ? null : pickFiles,
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
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  size: 40,
                                  color: isLoading
                                      ? Colors.grey
                                      : theme.colorScheme.primary,
                                ),
                                const Gap(12),
                                Text(
                                  "Click to upload resumes",
                                  style: theme.textTheme.titleMedium,
                                ),
                                const Gap(6),
                                Text(
                                  "or drag & drop (optional later)",
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Gap(20),

                        ////////////////////////////////////////////////////////////
                        /// FILE LIST
                        ////////////////////////////////////////////////////////////
                        if (selectedFiles.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selected Files (${selectedFiles.length})",
                                style: theme.textTheme.titleMedium,
                              ),
                              const Gap(10),

                              ...selectedFiles.map(
                                (f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text("• ${f.name}"),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                ////////////////////////////////////////////////////////////
                /// ERROR (fixed area)
                ////////////////////////////////////////////////////////////
                uploadState.whenOrNull(
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "Error: $e",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ) ??
                    const SizedBox(),

                ////////////////////////////////////////////////////////////
                /// BUTTON (always visible)
                ////////////////////////////////////////////////////////////
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (isLoading || selectedFiles.isEmpty)
                        ? null
                        : upload,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
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
