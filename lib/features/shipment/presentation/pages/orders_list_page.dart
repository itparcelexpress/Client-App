import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/shipment/data/models/order_models.dart';
import 'package:client_app/features/shipment/presentation/pages/create_order_page.dart';
import 'package:client_app/core/utilities/currency_utils.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:client_app/core/utilities/taost_service.dart';
import 'package:intl/intl.dart';
import 'package:client_app/l10n/app_localizations.dart';

/// Orders List Page with advanced filtering capabilities
///
/// Implements filters according to API specification (client/orders endpoint):
/// - status: Filter by order status (pending or created only)
/// - from_date: Start date filter in 'yyyy-MM-dd' format
/// - to_date: End date filter in 'yyyy-MM-dd' format
/// - query: Search by tracking number
/// - page: Pagination support (handled automatically)
///
/// All filters are applied in real-time and persist across pagination.
class OrdersListPage extends StatefulWidget {
  final bool showAppBar;

  const OrdersListPage({super.key, this.showAppBar = true});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  String? _fromDate;
  String? _toDate;

  // Filter options
  late List<String> _statusOptions;

  @override
  void initState() {
    super.initState();
    // Load client orders when page opens using new API
    _loadOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize status options after dependencies are available
    // API only supports 'pending' and 'created' status filters
    _statusOptions = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.pending,
      AppLocalizations.of(context)!.created,
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadOrders() {
    // Prepare status filter: convert localized status to API format
    // API expects: 'pending', 'created', or null for all
    String? apiStatus;
    if (_selectedStatus != null &&
        _selectedStatus != AppLocalizations.of(context)!.all) {
      // Convert localized status back to English for API
      apiStatus = _getEnglishStatus(_selectedStatus!);
    }

    // Call API with filters
    // - status: order status filter ('pending', 'created', or null for all)
    // - fromDate: start date in 'yyyy-MM-dd' format
    // - toDate: end date in 'yyyy-MM-dd' format
    // - query: search text for tracking number
    context.read<ShipmentCubit>().loadClientOrders(
      status: apiStatus,
      fromDate: _fromDate,
      toDate: _toDate,
      query: _searchController.text.isEmpty ? null : _searchController.text,
    );
  }

  String _getEnglishStatus(String localizedStatus) {
    // API only supports 'pending' and 'created' status values
    if (localizedStatus == AppLocalizations.of(context)!.pending) {
      return 'pending';
    }
    if (localizedStatus == AppLocalizations.of(context)!.created) {
      return 'created';
    }
    return localizedStatus; // fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            if (widget.showAppBar) _buildCompactAppBar(),
            if (!widget.showAppBar) _buildCompactInlineHeader(),
            _buildCompactFiltersHeader(),
            Expanded(
              child: BlocBuilder<ShipmentCubit, ShipmentState>(
                builder: (context, state) {
                  if (state is ClientOrdersLoading) {
                    return _buildLoadingState();
                  } else if (state is ClientOrdersLoaded) {
                    return _buildOrdersList(state);
                  } else if (state is ClientOrdersError) {
                    return _buildErrorState(state.message);
                  } else {
                    return _buildEmptyState();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFilterFab(),
    );
  }

  Widget _buildCompactAppBar() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back, size: 18),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.myOrders,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a1a),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: _showFiltersBottomSheet,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.filter_list,
                  size: 18,
                  color: Color(0xFF667eea),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInlineHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF10b981),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.myOrders,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1a1a1a),
                ),
              ),
            ),
            GestureDetector(
              onTap: _showFiltersBottomSheet,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.filter_list,
                  size: 18,
                  color: Color(0xFF667eea),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactFiltersHeader() {
    final hasActiveFilters =
        _searchController.text.isNotEmpty ||
        (_selectedStatus != null &&
            _selectedStatus != AppLocalizations.of(context)!.all) ||
        (_fromDate != null && _toDate != null);

    if (!hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return FadeInDown(
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.filter_alt, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (_searchController.text.isNotEmpty)
                    _buildActiveFilterChip(
                      '${AppLocalizations.of(context)!.search}: ${_searchController.text}',
                      () {
                        _searchController.clear();
                        _loadOrders();
                      },
                    ),
                  if (_selectedStatus != null &&
                      _selectedStatus != AppLocalizations.of(context)!.all)
                    _buildActiveFilterChip(
                      '${AppLocalizations.of(context)!.status}: ${_selectedStatus!.toUpperCase()}',
                      () {
                        setState(() {
                          _selectedStatus = null;
                        });
                        _loadOrders();
                      },
                    ),
                  if (_fromDate != null && _toDate != null)
                    _buildActiveFilterChip(
                      '${AppLocalizations.of(context)!.dateRange}: ${_formatDateShort(_fromDate!)} - ${_formatDateShort(_toDate!)}',
                      _clearDateRange,
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _showFiltersBottomSheet,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.edit, size: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF667eea).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF667eea).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF667eea),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: const Color(0xFF667eea)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterFab() {
    return FloatingActionButton(
      onPressed: _showFiltersBottomSheet,
      backgroundColor: const Color(0xFF667eea),
      child: const Icon(Icons.filter_list, color: Colors.white),
      mini: true,
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.filter_list,
                              color: Color(0xFF667eea),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.filterOrders,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1a1a1a),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.done,
                                style: const TextStyle(
                                  color: Color(0xFF667eea),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),

                      // Filters content
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search bar
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.searchByTrackingNumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1a1a1a),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText:
                                        AppLocalizations.of(
                                          context,
                                        )!.searchByTrackingNumber,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xFF666666),
                                    ),
                                    suffixIcon:
                                        _searchController.text.isNotEmpty
                                            ? IconButton(
                                              icon: const Icon(
                                                Icons.clear,
                                                size: 20,
                                              ),
                                              color: Colors.grey[600],
                                              onPressed: () {
                                                _searchController.clear();
                                                setState(() {});
                                              },
                                            )
                                            : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Status filter
                              Text(
                                AppLocalizations.of(context)!.status,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1a1a1a),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonFormField<String>(
                                  initialValue:
                                      _selectedStatus ??
                                      AppLocalizations.of(context)!.all,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  items:
                                      _statusOptions.map((status) {
                                        return DropdownMenuItem(
                                          value: status,
                                          child: Text(
                                            status ==
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.all
                                                ? AppLocalizations.of(
                                                  context,
                                                )!.allStatus
                                                : status.toUpperCase(),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStatus = value;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Date range filter
                              Text(
                                AppLocalizations.of(context)!.dateRange,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1a1a1a),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _selectDateRange,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Colors.grey[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _fromDate != null && _toDate != null
                                              ? '${_formatDateShort(_fromDate!)} - ${_formatDateShort(_toDate!)}'
                                              : AppLocalizations.of(
                                                context,
                                              )!.selectDateRange,
                                          style: TextStyle(
                                            color:
                                                _fromDate != null &&
                                                        _toDate != null
                                                    ? const Color(0xFF1a1a1a)
                                                    : Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (_fromDate != null && _toDate != null)
                                        GestureDetector(
                                          onTap: _clearDateRange,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.grey[600],
                                            size: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Apply button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _loadOrders();
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF667eea),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.applyFilters,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Clear all button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _selectedStatus = null;
                                      _fromDate = null;
                                      _toDate = null;
                                    });
                                    _loadOrders();
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[600],
                                    side: BorderSide(color: Colors.grey[300]!),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.clearAll,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildLoadingState() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitThreeBounce(color: Color(0xFF667eea), size: 30),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.loadingOrders,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(ClientOrdersLoaded state) {
    if (state.orders.isEmpty) {
      return _buildEmptyState();
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          // Orders count and pagination info - more compact
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  )!.showingOrdersCount(state.orders.length, state.totalOrders),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.pageCount(state.currentPage, state.totalPages),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
          ),

          // Orders list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _loadOrders(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return FadeInUp(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: _buildPickupOrderCard(order),
                  );
                },
              ),
            ),
          ),

          // Pagination controls
          if (state.totalPages > 1) _buildPaginationControls(state),
        ],
      ),
    );
  }

  Widget _buildPickupOrderCard(PickupOrderSummary order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with tracking number and status - more compact
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _copyToClipboard(order.orderTrackingNo),
                      child: Text(
                        order.orderTrackingNo,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF667eea),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.copy, size: 14, color: Colors.grey[400]),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        order.status,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order.status),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        order.orderStatus,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      order.orderStatus,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order.orderStatus),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Compact recipient and address info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF10b981),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.consigneeName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a1a1a),
                      ),
                    ),
                    if (order.consigneePhone.isNotEmpty)
                      Text(
                        order.consigneePhone,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    if (order.consigneeAddress.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.grey[500],
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              order.consigneeAddress,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Compact order details in a single row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildCompactInfoItem(
                    icon: Icons.attach_money_rounded,
                    label: AppLocalizations.of(context)!.amount,
                    value: '${CurrencyUtils.symbol(context)}${order.amount}',
                    color: const Color(0xFF10b981),
                  ),
                ),
                Container(width: 1, height: 20, color: Colors.grey[300]),
                Expanded(
                  child: _buildCompactInfoItem(
                    icon: Icons.payment_rounded,
                    label: AppLocalizations.of(context)!.payment,
                    value: order.paymentType,
                    color: const Color(0xFFf59e0b),
                  ),
                ),
                Container(width: 1, height: 20, color: Colors.grey[300]),
                Expanded(
                  child: _buildCompactInfoItem(
                    icon: Icons.access_time_rounded,
                    label: AppLocalizations.of(context)!.created,
                    value: _formatDateShort(order.createdAt),
                    color: const Color(0xFF8b5cf6),
                  ),
                ),
              ],
            ),
          ),

          // Notes if available - more compact
          if (order.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    color: Colors.blue[600],
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      order.notes,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[800],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaginationControls(ClientOrdersLoaded state) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed:
                state.hasPreviousPage
                    ? () {
                      context.read<ShipmentCubit>().loadPreviousPage(
                        status:
                            (_selectedStatus == null ||
                                    _selectedStatus ==
                                        AppLocalizations.of(context)!.all)
                                ? null
                                : _getEnglishStatus(_selectedStatus!),
                        fromDate: _fromDate,
                        toDate: _toDate,
                        query:
                            _searchController.text.isEmpty
                                ? null
                                : _searchController.text,
                      );
                    }
                    : null,
            icon: const Icon(Icons.arrow_back),
            label: Text(AppLocalizations.of(context)!.previous),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              disabledForegroundColor: Colors.grey[600],
            ),
          ),
          Text(
            AppLocalizations.of(
              context,
            )!.pageCount(state.currentPage, state.totalPages),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          ElevatedButton.icon(
            onPressed:
                state.hasNextPage
                    ? () {
                      context.read<ShipmentCubit>().loadNextPage(
                        status:
                            (_selectedStatus == null ||
                                    _selectedStatus ==
                                        AppLocalizations.of(context)!.all)
                                ? null
                                : _getEnglishStatus(_selectedStatus!),
                        fromDate: _fromDate,
                        toDate: _toDate,
                        query:
                            _searchController.text.isEmpty
                                ? null
                                : _searchController.text,
                      );
                    }
                    : null,
            icon: const Icon(Icons.arrow_forward),
            label: Text(AppLocalizations.of(context)!.next),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              disabledForegroundColor: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Padding(
          padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
            context,
            const EdgeInsets.all(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveWidth(context, 120),
                height: ResponsiveUtils.getResponsiveHeight(context, 120),
                decoration: BoxDecoration(
                  color: const Color(0xFF667eea).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: ResponsiveUtils.getResponsiveWidth(context, 60),
                  color: const Color(0xFF667eea),
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 24),
              ),
              Text(
                AppLocalizations.of(context)!.noOrdersYet,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1a1a1a),
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 12),
              ),
              Text(
                AppLocalizations.of(context)!.ordersWillAppearHere,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 32),
              ),
              ElevatedButton.icon(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BlocProvider(
                              create: (context) => getIt<ShipmentCubit>(),
                              child: const CreateOrderPage(),
                            ),
                      ),
                    ),
                icon: const Icon(Icons.add_circle_outline),
                label: Text(AppLocalizations.of(context)!.createFirstOrder),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsivePadding(
                      context,
                      24,
                    ),
                    vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                  ),
                  textStyle: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      16,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Padding(
          padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
            context,
            const EdgeInsets.all(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveWidth(context, 120),
                height: ResponsiveUtils.getResponsiveHeight(context, 120),
                decoration: BoxDecoration(
                  color: const Color(0xFFef4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: ResponsiveUtils.getResponsiveWidth(context, 60),
                  color: const Color(0xFFef4444),
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 24),
              ),
              Text(
                AppLocalizations.of(context)!.somethingWentWrong,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1a1a1a),
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 12),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 32),
              ),
              ElevatedButton.icon(
                onPressed: _loadOrders,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.tryAgain),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsivePadding(
                      context,
                      24,
                    ),
                    vertical: ResponsiveUtils.getResponsivePadding(context, 16),
                  ),
                  textStyle: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      16,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange:
          _fromDate != null && _toDate != null
              ? DateTimeRange(
                start: DateTime.parse(_fromDate!),
                end: DateTime.parse(_toDate!),
              )
              : null,
    );

    if (picked != null) {
      setState(() {
        _fromDate = DateFormat('yyyy-MM-dd').format(picked.start);
        _toDate = DateFormat('yyyy-MM-dd').format(picked.end);
      });
      _loadOrders();
    }
  }

  void _clearDateRange() {
    setState(() {
      _fromDate = null;
      _toDate = null;
    });
    _loadOrders();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFf59e0b); // Orange for pending
      case 'created':
        return const Color(0xFF667eea); // Blue for created
      case 'processing':
        return const Color(0xFFf59e0b);
      case 'shipped':
        return const Color(0xFF8b5cf6);
      case 'delivered':
        return const Color(0xFF10b981);
      case 'cancelled':
        return const Color(0xFFef4444);
      default:
        return const Color(0xFF6b7280);
    }
  }

  String _formatDateShort(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d').format(date);
    } catch (e) {
      return AppLocalizations.of(context)!.unknownError;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ToastService.showSuccess(
      context,
      AppLocalizations.of(context)!.copyToClipboardSuccess,
    );
  }
}
