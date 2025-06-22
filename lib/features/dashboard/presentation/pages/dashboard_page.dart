import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:client_app/features/dashboard/presentation/widgets/dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when page initializes
    context.read<DashboardCubit>().loadDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    final user = LocalData.user;
    final userName = user?.name ?? 'User';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<DashboardCubit>().refreshDashboardStats();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
            context,
            const EdgeInsets.all(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 40),
              ),
              _buildGreeting(userName),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 30),
              ),
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return _buildLoadingState();
                  } else if (state is DashboardError) {
                    return _buildErrorState(state.message);
                  } else if (state is DashboardLoaded) {
                    return _buildDashboardContent(state);
                  } else {
                    return _buildEmptyState();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(String userName) {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $userName! 👋',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1a1a1a),
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 8)),
          Text(
            'Here\'s your business overview',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(DashboardLoaded state) {
    final data = state.data;

    return Column(
      children: [
        // Quick Stats Grid
        _buildQuickStatsGrid(data),
        SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 24)),

        // Financial Summary
        FinancialSummaryWidget(
          totalOrderValue: data.totalOrderValue,
          thisMonthValue: data.thisMonthValue,
          accountBalance: data.accountBalance,
          parcelValue: data.parcelValue,
          avgOrderValue: data.avgOrderValue,
        ),
        SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 24)),

        // Performance Metrics
        PerformanceWidget(
          deliveryRate: data.deliveryRate,
          deliveredOrders: data.deliveredOrders,
          totalOrders: data.totalOrders,
          activeTasks: data.activeTasks,
          completedTasks: data.completedTasks,
        ),
        SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 24)),

        // Recent Activity
        RecentActivityWidget(activities: data.recentActivity),
        SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 20)),
      ],
    );
  }

  Widget _buildQuickStatsGrid(data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCardWidget(
                title: 'Total Orders',
                value: data.totalOrders.toString(),
                icon: Icons.receipt_long,
                color: const Color(0xFF667eea),
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsivePadding(context, 16)),
            Expanded(
              child: StatCardWidget(
                title: 'Today Orders',
                value: data.todayOrders.toString(),
                icon: Icons.today,
                color: const Color(0xFF10b981),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 16)),
        Row(
          children: [
            Expanded(
              child: StatCardWidget(
                title: 'Pending Pickup',
                value: data.pendingPickup.toString(),
                icon: Icons.pending_actions,
                color: const Color(0xFFf59e0b),
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsivePadding(context, 16)),
            Expanded(
              child: StatCardWidget(
                title: 'Picked Orders',
                value: data.pickedOrders.toString(),
                icon: Icons.check_circle,
                color: const Color(0xFF8b5cf6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        height: ResponsiveUtils.getResponsiveHeight(context, 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitThreeBounce(color: Color(0xFF667eea), size: 30),
              SizedBox(height: 20),
              Text(
                'Loading your dashboard...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1a1a1a),
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
      duration: const Duration(milliseconds: 600),
      child: Container(
        height: ResponsiveUtils.getResponsiveHeight(context, 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
              context,
              const EdgeInsets.all(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: ResponsiveUtils.getResponsiveWidth(context, 60),
                  color: const Color(0xFFef4444),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsivePadding(context, 16),
                ),
                Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1a1a1a),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsivePadding(context, 8),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      14,
                    ),
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsivePadding(context, 20),
                ),
                ElevatedButton(
                  onPressed:
                      () => context.read<DashboardCubit>().loadDashboardStats(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667eea),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.getResponsivePadding(
                        context,
                        24,
                      ),
                      vertical: ResponsiveUtils.getResponsivePadding(
                        context,
                        12,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 20),
              Text(
                'Welcome to Dashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to load your statistics',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<DashboardCubit>().loadDashboardStats();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Load Dashboard',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
