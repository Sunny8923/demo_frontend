import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_scaffold.dart';
import '../providers/admin_partner__provider.dart';

class PendingPartnerScreen extends ConsumerWidget {
  const PendingPartnerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pendingPartnerProvider);

    return AppScaffold(
      title: "Partner Approvals",

      body: state.when(
        loading: () => const _LoadingState(),

        error: (e, _) => _ErrorState(message: e.toString()),

        data: (partners) {
          if (partners.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(pendingPartnerProvider.notifier).refresh(),

            child: ListView.separated(
              itemCount: partners.length,

              separatorBuilder: (_, __) => const SizedBox(height: 12),

              itemBuilder: (context, index) {
                final partner = partners[index];

                return _PartnerCard(
                  partnerId: partner.id,
                  businessName: partner.businessName,
                  phone: partner.phone,
                  userName: partner.userName,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// PARTNER CARD
///////////////////////////////////////////////////////////////

class _PartnerCard extends ConsumerStatefulWidget {
  final String partnerId;
  final String businessName;
  final String phone;
  final String userName;

  const _PartnerCard({
    required this.partnerId,
    required this.businessName,
    required this.phone,
    required this.userName,
  });

  @override
  ConsumerState<_PartnerCard> createState() => _PartnerCardState();
}

class _PartnerCardState extends ConsumerState<_PartnerCard> {
  bool approving = false;

  Future<void> approve() async {
    setState(() => approving = true);

    await ref.read(pendingPartnerProvider.notifier).approve(widget.partnerId);

    setState(() => approving = false);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Partner approved")));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// Header row
            Row(
              children: [
                /// Avatar icon
                Container(
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Icon(
                    Icons.business_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 12),

                /// Business info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        widget.businessName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.userName,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                /// Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Text(
                    "PENDING",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Phone row
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),

                const SizedBox(width: 6),

                Text(widget.phone),
              ],
            ),

            const SizedBox(height: 16),

            /// Approve button
            Align(
              alignment: Alignment.centerRight,

              child: ElevatedButton.icon(
                onPressed: approving ? null : approve,

                icon: approving
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check),

                label: const Text("Approve"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// EMPTY STATE
///////////////////////////////////////////////////////////////

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.verified_user_outlined, size: 64, color: Colors.grey[400]),

          const SizedBox(height: 16),

          const Text(
            "No pending approvals",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            "All partner requests are reviewed",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// ERROR STATE
///////////////////////////////////////////////////////////////

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),

          const SizedBox(height: 16),

          const Text(
            "Failed to load partners",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(message),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
/// LOADING STATE
///////////////////////////////////////////////////////////////

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
