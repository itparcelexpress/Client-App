import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/features/wallet/cubit/wallet_cubit.dart';
import 'package:client_app/features/wallet/cubit/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_app/core/widgets/loading_widgets.dart';
import 'package:client_app/l10n/app_localizations.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.wallet)),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading || state is WalletInitial) {
            return LoadingWidgets.fullScreenLoading();
          }

          if (state is WalletError) {
            return Center(child: Text(state.message));
          }

          if (state is WalletEmpty) {
            return _EmptyWallet();
          }

          if (state is WalletLoaded) {
            return _WalletContent(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _WalletContent extends StatelessWidget {
  final WalletLoaded state;
  const _WalletContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getResponsivePaddingEdgeInsets(
      context,
      const EdgeInsets.all(16),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 350),
          child: Padding(
            padding: padding,
            child: _BalanceCard(balance: state.balance),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsivePadding(context, 16),
          ),
          child: Text(
            AppLocalizations.of(context)!.recentTransactions,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1a1a1a),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        Expanded(
          child: FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: ListView.separated(
              padding: padding.copyWith(top: 8),
              itemCount: state.transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tx = state.transactions[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0ea5e9).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      color: Color(0xFF0ea5e9),
                    ),
                  ),
                  title: Text(
                    tx.description ?? tx.type.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    tx.createdAt.toLocal().toString(),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    '${tx.amount} OMR',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (state.hasMorePages)
          Padding(
            padding: padding,
            child: ElevatedButton.icon(
              onPressed:
                  () => context.read<WalletCubit>().loadMore(perPage: 20),
              icon: const Icon(Icons.expand_more_rounded),
              label: Text(AppLocalizations.of(context)!.next),
            ),
          ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
        context,
        const EdgeInsets.all(20),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8b5cf6), Color(0xFF7c3aed)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8b5cf6).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.balance,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$balance OMR',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 350),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF0ea5e9).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: Color(0xFF0ea5e9),
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noTransactionsFound,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context)!.tryAdjustingFilters,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
