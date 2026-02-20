import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

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

  ///////////////////////////////////////////////////////////////
  /// SIGNUP (UNCHANGED)
  ///////////////////////////////////////////////////////////////

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

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  ///////////////////////////////////////////////////////////////
  /// UI
  ///////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider).isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary.withOpacity(.05), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header()
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: .2),

                  const Gap(32),

                  /// PREMIUM FORM CARD
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _StyledField(
                              controller: nameController,
                              label: "Full Name",
                              icon: Icons.person_outline,
                            ),

                            const Gap(18),

                            _StyledField(
                              controller: emailController,
                              label: "Email address",
                              icon: Icons.email_outlined,
                            ),

                            const Gap(18),

                            _PasswordField(controller: passwordController),

                            const Gap(18),

                            _StyledField(
                              controller: businessController,
                              label: "Business Name",
                              icon: Icons.business_outlined,
                            ),

                            const Gap(18),

                            _StyledField(
                              controller: ownerController,
                              label: "Owner Name",
                              icon: Icons.badge_outlined,
                            ),

                            const Gap(18),

                            _StyledField(
                              controller: establishmentController,
                              label: "Establishment Date (YYYY-MM-DD)",
                              icon: Icons.calendar_today_outlined,
                            ),

                            const Gap(18),

                            _StyledField(
                              controller: gstController,
                              label: "GST Number",
                              icon: Icons.receipt_long_outlined,
                            ),

                            const Gap(18),

                            _StyledField(
                              controller: panController,
                              label: "PAN Number",
                              icon: Icons.credit_card_outlined,
                            ),

                            const Gap(18),

                            _StyledField(
                              controller: addressController,
                              label: "Business Address",
                              icon: Icons.location_on_outlined,
                            ),

                            const Gap(18),

                            _StyledField(
                              controller: phoneController,
                              label: "Phone Number",
                              icon: Icons.phone_outlined,
                            ),

                            const Gap(18),

                            _StyledField(
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),

                            const Gap(24),

                            _SignupButton(loading: loading, onPressed: _signup),
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
/// HEADER WITH LOGO
///////////////////////////////////////////////////////////////

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          Container(
            height: 180,
            width: 180,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset("assets/logo.png", fit: BoxFit.contain),
          ),

          const Gap(24),

          Text(
            "Become a Partner",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const Gap(8),

          Text(
            "Create your partner account to submit candidates",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// MODERN TEXT FIELD
///////////////////////////////////////////////////////////////

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _StyledField({
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
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
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: () => setState(() => obscure = !obscure),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (v) => v == null || v.isEmpty ? "Password required" : null,
    );
  }
}

///////////////////////////////////////////////////////////////
/// BUTTON
///////////////////////////////////////////////////////////////

class _SignupButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const _SignupButton({required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Create Partner Account",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
