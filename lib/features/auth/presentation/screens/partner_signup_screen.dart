import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import 'login_screen.dart';
import 'signup_screen.dart';
import '../providers/auth_provider.dart';

class PartnerSignupScreen extends ConsumerStatefulWidget {
  const PartnerSignupScreen({super.key});

  @override
  ConsumerState<PartnerSignupScreen> createState() =>
      _PartnerSignupScreenState();
}

class _PartnerSignupScreenState extends ConsumerState<PartnerSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  /// BASIC
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// BUSINESS
  final businessController = TextEditingController();
  final ownerController = TextEditingController();
  final establishmentController = TextEditingController();
  final gstController = TextEditingController();
  final panController = TextEditingController();
  final addressController = TextEditingController();

  /// CONTACT
  final phoneController = TextEditingController();
  final officialEmailController = TextEditingController();

  bool msmeRegistered = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    businessController.dispose();
    ownerController.dispose();
    establishmentController.dispose();
    gstController.dispose();
    panController.dispose();
    addressController.dispose();
    phoneController.dispose();
    officialEmailController.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////////////////////
  /// SIGNUP LOGIC (UNCHANGED)
  /////////////////////////////////////////////////////////////////

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authProvider.notifier)
        .partnerSignup(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          organisationName: businessController.text.trim(),
          ownerName: ownerController.text.trim(),
          establishmentDate: establishmentController.text.trim(),
          gstNumber: gstController.text.trim(),
          panNumber: panController.text.trim(),
          address: addressController.text.trim(),
          contactNumber: phoneController.text.trim(),
          officialEmail: officialEmailController.text.trim(),
          msmeRegistered: msmeRegistered,
        );

    final state = ref.read(authProvider);

    if (state.hasError) {
      _showError(state.error.toString());
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Partner signup successful. Waiting for admin approval."),
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
              constraints: const BoxConstraints(maxWidth: 520),

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
                  /// FORM CARD
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
                            _sectionTitle("Basic Info"),

                            _Field(
                              controller: nameController,
                              label: "Full Name",
                              icon: Icons.person_outline,
                            ),

                            const Gap(16),

                            _Field(
                              controller: emailController,
                              label: "Email",
                              icon: Icons.email_outlined,
                            ),

                            const Gap(16),

                            _PasswordField(controller: passwordController),

                            const Gap(24),

                            _sectionTitle("Business Info"),

                            _Field(
                              controller: businessController,
                              label: "Business Name",
                              icon: Icons.business_outlined,
                            ),

                            const Gap(16),

                            _Field(
                              controller: ownerController,
                              label: "Owner Name",
                              icon: Icons.badge_outlined,
                            ),

                            const Gap(16),

                            _Field(
                              controller: establishmentController,
                              label: "Establishment Date",
                              icon: Icons.calendar_today_outlined,
                            ),

                            const Gap(16),

                            _Field(
                              controller: gstController,
                              label: "GST Number",
                              icon: Icons.receipt_long_outlined,
                            ),

                            const Gap(16),

                            _Field(
                              controller: panController,
                              label: "PAN Number",
                              icon: Icons.credit_card_outlined,
                            ),

                            const Gap(16),

                            _Field(
                              controller: addressController,
                              label: "Business Address",
                              icon: Icons.location_on_outlined,
                            ),

                            const Gap(24),

                            _sectionTitle("Contact"),

                            _Field(
                              controller: phoneController,
                              label: "Phone Number",
                              icon: Icons.phone_outlined,
                            ),

                            const Gap(16),

                            _Field(
                              controller: officialEmailController,
                              label: "Official Email",
                              icon: Icons.alternate_email_outlined,
                            ),

                            const Gap(12),

                            CheckboxListTile(
                              value: msmeRegistered,
                              onChanged: (v) =>
                                  setState(() => msmeRegistered = v ?? false),
                              title: const Text("MSME Registered"),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),

                            const Gap(24),

                            _PrimaryButton(
                              loading: loading,
                              text: "Create Partner Account",
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
                              text: "Normal Signup",
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                            ),

                            _SecondaryButton(
                              text: "Back to Login",
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
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

  /////////////////////////////////////////////////////////////////
  /// HELPERS
  /////////////////////////////////////////////////////////////////

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
          height: 150,
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(.08),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Image.asset("assets/logo.png"),
        ),

        const Gap(24),

        Text(
          "Partner Signup",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),

        const Gap(8),

        Text(
          "Create your partner account",
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
