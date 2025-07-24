import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/app_color.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/features/invoices/cubit/invoice_cubit.dart';
import 'package:client_app/features/invoices/cubit/invoice_state.dart';
import 'package:client_app/features/invoices/data/models/invoice_models.dart';
import 'package:client_app/features/invoices/presentation/pages/invoice_detail_page.dart';
import 'package:client_app/features/invoices/presentation/widgets/invoice_card_widget.dart';
import 'package:client_app/features/invoices/presentation/widgets/invoice_statistics_widget.dart';
import 'package:client_app/features/invoices/presentation/widgets/payment_summary_widget.dart';
import 'package:client_app/features/invoices/presentation/widgets/payment_transaction_card.dart';
import 'package:client_app/injections.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoicesPage extends StatefulWidget {
  final bool showAppBar;

  const InvoicesPage({super.key, this.showAppBar = true});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedStatusFilter;
  late TabController _tabController;

  final List<String> _statusFilters = ['All', 'Paid', 'Pending', 'Overdue'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInvoices();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadInvoices() {
    context.read<InvoiceCubit>().loadInvoices(refresh: true);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<InvoiceCubit>().loadMoreInvoices();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<InvoiceCubit>().clearSearch();
    } else {
      context.read<InvoiceCubit>().searchInvoices(invoiceNo: query);
    }
  }

  void _onStatusFilterChanged(String? status) {
    setState(() {
      _selectedStatusFilter = status;
    });

    if (status == null || status == 'All') {
      context.read<InvoiceCubit>().clearSearch();
    } else {
      context.read<InvoiceCubit>().filterInvoicesByStatus(status.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            if (widget.showAppBar) _buildAppBar(),
            if (!widget.showAppBar) _buildInlineHeader(),

            // Tab bar
            _buildTabBar(),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildInvoicesTab(), _buildPaymentsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.white,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
            ),
            const Expanded(
              child: Text(
                'Invoices & Payments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a1a),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                _searchController.clear();
                _selectedStatusFilter = null;
                _loadInvoices();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.refresh, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.receipt_rounded,
              color: Color(0xFFf59e0b),
              size: 28,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Invoices & Payments',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1a1a1a),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _searchController.clear();
                _selectedStatusFilter = null;
                _loadInvoices();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.refresh,
                  size: 20,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColor.accentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [Tab(text: 'Invoices'), Tab(text: 'Payments')],
      ),
    );
  }

  Widget _buildInvoicesTab() {
    return RefreshIndicator(
      onRefresh: () async {
        _searchController.clear();
        _selectedStatusFilter = null;
        _loadInvoices();
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
                    context,
                    const EdgeInsets.all(20),
                  ),
                  child: Column(
                    children: [
                      _buildSearchAndFilter(),
                      const SizedBox(height: 20),
                      _buildStatistics(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildInvoicesList(),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab() {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        // Auto-load payment data when switching to payments tab
        if (state is! PaymentLoading &&
            state is! PaymentCombinedLoaded &&
            state is! PaymentSummaryLoaded &&
            state is! PaymentTransactionsLoaded &&
            state is! PaymentError &&
            state is! PaymentEmpty) {
          context.read<InvoiceCubit>().loadPaymentData();
        }

        if (state is PaymentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PaymentError) {
          return _buildPaymentErrorWidget(state.message);
        } else if (state is PaymentEmpty) {
          return _buildPaymentEmptyWidget();
        } else if (state is PaymentCombinedLoaded) {
          return _buildPaymentLoadedWidget(state);
        } else if (state is PaymentSummaryLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: PaymentSummaryWidget(summary: state.summary),
          );
        } else if (state is PaymentTransactionsLoaded) {
          return _buildPaymentTransactionsOnly(state.transactions);
        }

        // Default loading state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPaymentLoadedWidget(PaymentCombinedLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InvoiceCubit>().refreshPaymentData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PaymentSummaryWidget(summary: state.summary),
            const SizedBox(height: 16),
            _buildPaymentTransactionsSection(state.transactions),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTransactionsOnly(List transactions) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InvoiceCubit>().refreshPaymentData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: _buildPaymentTransactionsSection(transactions),
      ),
    );
  }

  Widget _buildPaymentTransactionsSection(List transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.recentTransactions,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showPaymentFilterBottomSheet,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noTransactionsFound,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.adjustFilters,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return PaymentTransactionCard(
                transaction: transaction,
                onTap: () => _showPaymentTransactionDetails(transaction),
              );
            },
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaymentErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Payments',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<InvoiceCubit>().loadPaymentData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Payment Data',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No payment transactions found.\nCheck back later for updates.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<InvoiceCubit>().loadPaymentData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accentColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.filterPayments,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.filterByType),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children:
                    ['All', 'COD', 'Card', 'Bank'].map((type) {
                      return FilterChip(
                        label: Text(type),
                        selected: false,
                        onSelected: (selected) {
                          if (type == 'All') {
                            context.read<InvoiceCubit>().refreshPaymentData();
                          } else {
                            context
                                .read<InvoiceCubit>()
                                .filterTransactionsByType(type.toLowerCase());
                          }
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.filterByStatus),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children:
                    ['All', 'Pending', 'Completed', 'Failed'].map((status) {
                      return FilterChip(
                        label: Text(status),
                        selected: false,
                        onSelected: (selected) {
                          if (status == 'All') {
                            context.read<InvoiceCubit>().refreshPaymentData();
                          } else {
                            context
                                .read<InvoiceCubit>()
                                .filterTransactionsByStatus(
                                  status.toLowerCase(),
                                );
                          }
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentTransactionDetails(dynamic transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.transactionDetails,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                            AppLocalizations.of(context)!.trackingNo,
                            transaction.trackingNo ??
                                AppLocalizations.of(context)!.notAvailable,
                          ),
                          _buildDetailRow(
                            'Amount',
                            transaction.formattedAmount ?? 'N/A',
                          ),
                          _buildDetailRow(
                            'Type',
                            transaction.typeLabel ?? 'N/A',
                          ),
                          _buildDetailRow(
                            'Status',
                            transaction.status ?? 'N/A',
                          ),
                          _buildDetailRow(
                            'Customer',
                            transaction.customerName ?? 'N/A',
                          ),
                          _buildDetailRow(
                            'Phone',
                            transaction.customerPhone ?? 'N/A',
                          ),
                          _buildDetailRow(
                            'Date',
                            transaction.formattedDate ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchByInvoiceNumber,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF667eea),
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                          icon: const Icon(Icons.clear_rounded),
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF667eea),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _statusFilters.length,
                itemBuilder: (context, index) {
                  final status = _statusFilters[index];
                  final isSelected =
                      _selectedStatusFilter == status ||
                      (_selectedStatusFilter == null && status == 'All');

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        _onStatusFilterChanged(selected ? status : null);
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: AppColor.accentColor.withValues(
                        alpha: 0.2,
                      ),
                      checkmarkColor: AppColor.accentColor,
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? AppColor.accentColor
                                : Colors.grey[600],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      side: BorderSide(
                        color:
                            isSelected
                                ? AppColor.accentColor
                                : Colors.grey[300]!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceLoaded) {
          return const InvoiceStatisticsWidget();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInvoicesList() {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceLoading && state is! InvoiceLoaded) {
          return _buildLoadingSliver();
        }

        if (state is InvoiceError) {
          return _buildErrorSliver(state.message);
        }

        if (state is InvoiceEmpty) {
          return _buildEmptySliver();
        }

        if (state is InvoiceSearchEmpty) {
          return _buildSearchEmptySliver(state.searchQuery);
        }

        if (state is InvoiceLoaded || state is InvoiceSearchResults) {
          List<Invoice> invoices = [];
          bool hasReachedMax = true;

          if (state is InvoiceLoaded) {
            invoices = state.invoices;
            hasReachedMax = state.hasReachedMax;
          } else if (state is InvoiceSearchResults) {
            invoices = state.invoices;
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= invoices.length) {
                  return hasReachedMax ? null : _buildLoadingItem();
                }

                final invoice = invoices[index];
                return FadeInUp(
                  duration: Duration(milliseconds: 600 + (index * 100)),
                  child: Padding(
                    padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
                      context,
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: InvoiceCardWidget(
                      invoice: invoice,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BlocProvider(
                                    create: (context) => getIt<InvoiceCubit>(),
                                    child: InvoiceDetailPage(invoice: invoice),
                                  ),
                            ),
                          ),
                    ),
                  ),
                );
              },
              childCount: hasReachedMax ? invoices.length : invoices.length + 1,
            ),
          );
        }

        return _buildEmptySliver();
      },
    );
  }

  Widget _buildLoadingSliver() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.accentColor),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.loadingInvoices,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSliver(String message) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadInvoices,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySliver() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noInvoices,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noInvoicesYet,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchEmptySliver(String query) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noResults,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noInvoicesFound(query),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                context.read<InvoiceCubit>().clearSearch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.clearSearch),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColor.accentColor),
        ),
      ),
    );
  }
}
