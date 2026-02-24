import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import 'login_screen.dart';
import 'partner_signup_screen.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////////////////////
  /// SIGNUP LOGIC (UNCHANGED)
  /////////////////////////////////////////////////////////////////

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authProvider.notifier)
        .signup(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );

    final state = ref.read(authProvider);

    if (state.hasError) {
      _showError(state.error.toString());
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created successfully"),
        behavior: SnackBarBehavior.floating,
      ),
    );

    /// RESET STACK → LOGIN SCREEN
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  /////////////////////////////////////////////////////////////////
  /// UI
  /////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider).isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary.withOpacity(.06), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),

              child: Column(
                children: [
                  /////////////////////////////////////////////////////////////////
                  /// HEADER
                  /////////////////////////////////////////////////////////////////
                  const _Header()
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: .2),

                  const Gap(32),

                  /////////////////////////////////////////////////////////////////
                  /// PREMIUM CARD
                  /////////////////////////////////////////////////////////////////
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(28),

                      child: Form(
                        key: _formKey,

                        child: Column(
                          children: [
                            _Field(
                              controller: nameController,
                              label: "Full Name",
                              icon: Icons.person_outline,
                            ),

                            const Gap(18),

                            _Field(
                              controller: emailController,
                              label: "Email Address",
                              icon: Icons.email_outlined,
                            ),

                            const Gap(18),

                            _PasswordField(controller: passwordController),

                            const Gap(26),

                            _PrimaryButton(
                              loading: loading,
                              text: "Create Account",
                              onPressed: _signup,
                            ),

                            const Gap(16),

                            Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text("OR"),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),

                            const Gap(12),

                            _SecondaryButton(
                              text: "Partner Signup",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PartnerSignupScreen(),
                                  ),
                                );
                              },
                            ),

                            const Gap(8),

                            _SecondaryButton(
                              text: "Back to Login",
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 150.ms).slideY(begin: .15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// HEADER
///////////////////////////////////////////////////////////////

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          height: 160,
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(.08),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Image.asset("assets/logo.png"),
        ),

        const Gap(24),

        Text(
          "Create Account",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),

        const Gap(8),

        Text(
          "Join and start your journey",
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////
/// FIELD
///////////////////////////////////////////////////////////////

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),

      validator: (v) => v == null || v.isEmpty ? "$label required" : null,
    );
  }
}

///////////////////////////////////////////////////////////////
/// PASSWORD FIELD
///////////////////////////////////////////////////////////////

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscure,

      decoration: InputDecoration(
        labelText: "Password",

        prefixIcon: const Icon(Icons.lock_outline),

        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() => obscure = !obscure);
          },
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),

      validator: (v) => v == null || v.isEmpty ? "Password required" : null,
    );
  }
}

///////////////////////////////////////////////////////////////
/// BUTTONS
///////////////////////////////////////////////////////////////

class _PrimaryButton extends StatelessWidget {
  final bool loading;
  final String text;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.loading,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,

      child: ElevatedButton(
        onPressed: loading ? null : onPressed,

        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(text),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _SecondaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(text));
  }
}
