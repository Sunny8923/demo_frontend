import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/admin/presentation/providers/amin_recruiter_provider.dart';
import 'package:gap/gap.dart';

class CreateRecruiterScreen extends ConsumerStatefulWidget {
  const CreateRecruiterScreen({super.key});

  @override
  ConsumerState<CreateRecruiterScreen> createState() =>
      _CreateRecruiterScreenState();
}

class _CreateRecruiterScreenState extends ConsumerState<CreateRecruiterScreen> {
  //////////////////////////////////////////////////////////////
  /// CONTROLLERS
  //////////////////////////////////////////////////////////////

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //////////////////////////////////////////////////////////////
  /// FORM KEY
  //////////////////////////////////////////////////////////////

  final _formKey = GlobalKey<FormState>();

  //////////////////////////////////////////////////////////////
  /// DISPOSE
  //////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////
  /// SUBMIT
  //////////////////////////////////////////////////////////////

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(adminRecruiterProvider.notifier);

    await notifier.createRecruiter(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final state = ref.read(adminRecruiterProvider);

    ////////////////////////////////////////////////////////////
    /// ERROR
    ////////////////////////////////////////////////////////////

    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
      );
      return;
    }

    ////////////////////////////////////////////////////////////
    /// SUCCESS
    ////////////////////////////////////////////////////////////

    if (state.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Recruiter created successfully"),
          backgroundColor: Colors.green,
        ),
      );

      ref.read(adminRecruiterProvider.notifier).reset();

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  //////////////////////////////////////////////////////////////
  /// UI
  //////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final state = ref.watch(adminRecruiterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Recruiter")),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Container(
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: scheme.outlineVariant.withOpacity(.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ////////////////////////////////////////////////////////////
                    /// TITLE
                    ////////////////////////////////////////////////////////////
                    Text(
                      "New Recruiter",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Gap(6),

                    Text(
                      "Admin can create recruiter accounts",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),

                    const Gap(24),

                    ////////////////////////////////////////////////////////////
                    /// NAME
                    ////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: _nameController,

                      decoration: const InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person_outline),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name required";
                        }
                        return null;
                      },
                    ),

                    const Gap(16),

                    ////////////////////////////////////////////////////////////
                    /// EMAIL
                    ////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: _emailController,

                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email required";
                        }

                        if (!value.contains("@")) {
                          return "Invalid email";
                        }

                        return null;
                      },
                    ),

                    const Gap(16),

                    ////////////////////////////////////////////////////////////
                    /// PASSWORD
                    ////////////////////////////////////////////////////////////
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,

                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_outline),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password required";
                        }

                        if (value.length < 6) {
                          return "Minimum 6 characters";
                        }

                        return null;
                      },
                    ),

                    const Gap(28),

                    ////////////////////////////////////////////////////////////
                    /// BUTTON
                    ////////////////////////////////////////////////////////////
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: state.loading ? null : _submit,

                        child: state.loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Create Recruiter"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
