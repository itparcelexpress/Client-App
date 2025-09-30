import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/shipment/data/models/order_models.dart';
import 'package:client_app/features/shipment/presentation/pages/create_order_page.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:client_app/core/utilities/taost_service.dart';
import 'package:intl/intl.dart';
import 'package:client_app/l10n/app_localizations.dart';

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
    _statusOptions = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.created,
      AppLocalizations.of(context)!.processing,
      AppLocalizations.of(context)!.shipped,
      AppLocalizations.of(context)!.delivered,
      AppLocalizations.of(context)!.cancelled,
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadOrders() {
    String? apiStatus;
    if (_selectedStatus != null &&
        _selectedStatus != AppLocalizations.of(context)!.all) {
      // Convert localized status back to English for API
      apiStatus = _getEnglishStatus(_selectedStatus!);
    }

    context.read<ShipmentCubit>().loadClientOrders(
      status: apiStatus,
      fromDate: _fromDate,
      toDate: _toDate,
      query: _searchController.text.isEmpty ? null : _searchController.text,
    );
  }

  String _getEnglishStatus(String localizedStatus) {
    if (localizedStatus == AppLocalizations.of(context)!.created)
      return 'created';
    if (localizedStatus == AppLocalizations.of(context)!.processing)
      return 'processing';
    if (localizedStatus == AppLocalizations.of(context)!.shipped)
      return 'shipped';
    if (localizedStatus == AppLocalizations.of(context)!.delivered)
      return 'delivered';
    if (localizedStatus == AppLocalizations.of(context)!.cancelled)
      return 'cancelled';
    return localizedStatus; // fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            if (widget.showAppBar) _buildAppBar(),
            if (!widget.showAppBar) _buildInlineHeader(),
            _buildFilters(),
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
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.myOrders,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a1a),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: _loadOrders,
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
              Icons.receipt_long_rounded,
              color: Color(0xFF10b981),
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.myOrders,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1a1a1a),
                ),
              ),
            ),
            GestureDetector(
              onTap: _loadOrders,
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

  Widget _buildFilters() {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search bar
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
                      AppLocalizations.of(context)!.searchByTrackingNumber,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF666666),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _loadOrders(),
              ),
            ),
            const SizedBox(height: 16),

            // Status filter and date filters
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus ?? AppLocalizations.of(context)!.all,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.status,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items:
                        _statusOptions.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              status == AppLocalizations.of(context)!.all
                                  ? AppLocalizations.of(context)!.allStatus
                                  : status.toUpperCase(),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                      _loadOrders();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _selectDateRange,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _fromDate != null && _toDate != null
                                  ? '${_formatDateShort(_fromDate!)} - ${_formatDateShort(_toDate!)}'
                                  : AppLocalizations.of(context)!.dateRange,
                              style: TextStyle(
                                color:
                                    _fromDate != null && _toDate != null
                                        ? const Color(0xFF1a1a1a)
                                        : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
          // Orders count and pagination info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  )!.showingOrdersCount(state.orders.length, state.totalOrders),
                  style: TextStyle(
                    fontSize: 14,
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
                    fontSize: 14,
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
                padding: const EdgeInsets.all(20),
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with tracking number and status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.trackingNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => _copyToClipboard(order.orderTrackingNo),
                      child: Row(
                        children: [
                          Text(
                            order.orderTrackingNo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF667eea),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.copy, size: 16, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        order.status,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order.status),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        order.orderStatus,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      order.orderStatus,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order.orderStatus),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Recipient info
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF10b981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.recipient,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.consigneeName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1a1a1a),
                      ),
                    ),
                    if (order.consigneePhone.isNotEmpty)
                      Text(
                        order.consigneePhone,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Address
          if (order.consigneeAddress.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8b5cf6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF8b5cf6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.deliveryAddress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.consigneeAddress,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1a1a1a),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Order details
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.payment_rounded,
                  label: AppLocalizations.of(context)!.payment,
                  value: order.paymentType,
                  color: const Color(0xFFf59e0b),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.attach_money_rounded,
                  label: AppLocalizations.of(context)!.amount,
                  value: '\$${order.amount}',
                  color: const Color(0xFF10b981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.local_shipping_outlined,
                  label: AppLocalizations.of(context)!.deliveryFee,
                  value: '\$${order.deliveryFee}',
                  color: const Color(0xFF667eea),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  icon: Icons.access_time_rounded,
                  label: AppLocalizations.of(context)!.created,
                  value: _formatDate(order.createdAt),
                  color: const Color(0xFF8b5cf6),
                ),
              ),
            ],
          ),

          // Notes if available
          if (order.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.notes,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.notes,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1a1a1a),
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a1a),
                ),
              ),
            ],
          ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return const Color(0xFF667eea);
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatDateShort(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d').format(date);
    } catch (e) {
      return 'Unknown';
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ToastService.showSuccess(context, 'copyToClipboardSuccess');
  }
}
