import 'package:equatable/equatable.dart';

// Dashboard Response Model
class DashboardResponse extends Equatable {
  final String message;
  final bool success;
  final DashboardData data;
  final List<dynamic> errors;

  const DashboardResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: DashboardData.fromJson(json['data'] ?? {}),
      errors: json['errors'] ?? [],
    );
  }

  @override
  List<Object?> get props => [message, success, data, errors];
}

// Dashboard Data Model
class DashboardData extends Equatable {
  final int totalOrders;
  final int todayOrders;
  final int pendingPickup;
  final int pickedOrders;
  final int activeTasks;
  final int completedTasks;
  final String totalOrderValue;
  final String thisMonthValue;
  final String accountBalance;
  final String parcelValue;
  final String avgOrderValue;
  final int deliveryRate;
  final int deliveredOrders;
  final Map<String, int> orderStatuses;
  final Map<String, PaymentTypeData> paymentTypes;
  final List<ActivityData> recentActivity;
  final DashboardSummary summary;

  const DashboardData({
    required this.totalOrders,
    required this.todayOrders,
    required this.pendingPickup,
    required this.pickedOrders,
    required this.activeTasks,
    required this.completedTasks,
    required this.totalOrderValue,
    required this.thisMonthValue,
    required this.accountBalance,
    required this.parcelValue,
    required this.avgOrderValue,
    required this.deliveryRate,
    required this.deliveredOrders,
    required this.orderStatuses,
    required this.paymentTypes,
    required this.recentActivity,
    required this.summary,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    // Parse order_statuses as Map<String, int>
    Map<String, int> orderStatuses = {};
    if (json['order_statuses'] != null && json['order_statuses'] is Map) {
      final statusMap = json['order_statuses'] as Map<String, dynamic>;
      statusMap.forEach((key, value) {
        orderStatuses[key] =
            (value is int) ? value : int.tryParse(value.toString()) ?? 0;
      });
    }

    // Parse payment_types as Map<String, PaymentTypeData>
    Map<String, PaymentTypeData> paymentTypes = {};
    if (json['payment_types'] != null && json['payment_types'] is Map) {
      final paymentMap = json['payment_types'] as Map<String, dynamic>;
      paymentMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          paymentTypes[key] = PaymentTypeData.fromJson(value);
        }
      });
    }

    // Parse recent_activity as List<ActivityData>
    List<ActivityData> recentActivity = [];
    if (json['recent_activity'] != null && json['recent_activity'] is List) {
      final activityList = json['recent_activity'] as List<dynamic>;
      recentActivity =
          activityList
              .map((e) => ActivityData.fromJson(e as Map<String, dynamic>))
              .toList();
    }

    return DashboardData(
      totalOrders: json['total_orders'] ?? 0,
      todayOrders: json['today_orders'] ?? 0,
      pendingPickup: json['pending_pickup'] ?? 0,
      pickedOrders: json['picked_orders'] ?? 0,
      activeTasks: json['active_tasks'] ?? 0,
      completedTasks: json['completed_tasks'] ?? 0,
      totalOrderValue: json['total_order_value'] ?? '0.00',
      thisMonthValue: json['this_month_value'] ?? '0.00',
      accountBalance: json['account_balance'] ?? '0.00',
      parcelValue: json['parcel_value'] ?? '0.00',
      avgOrderValue: json['avg_order_value'] ?? '0.00',
      deliveryRate: json['delivery_rate'] ?? 0,
      deliveredOrders: json['delivered_orders'] ?? 0,
      orderStatuses: orderStatuses,
      paymentTypes: paymentTypes,
      recentActivity: recentActivity,
      summary: DashboardSummary.fromJson(json['summary'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [
    totalOrders,
    todayOrders,
    pendingPickup,
    pickedOrders,
    activeTasks,
    completedTasks,
    totalOrderValue,
    thisMonthValue,
    accountBalance,
    parcelValue,
    avgOrderValue,
    deliveryRate,
    deliveredOrders,
    orderStatuses,
    paymentTypes,
    recentActivity,
    summary,
  ];
}

// Payment Type Data Model (for the actual API structure)
class PaymentTypeData extends Equatable {
  final String paymentType;
  final int count;
  final String totalAmount;

  const PaymentTypeData({
    required this.paymentType,
    required this.count,
    required this.totalAmount,
  });

  factory PaymentTypeData.fromJson(Map<String, dynamic> json) {
    return PaymentTypeData(
      paymentType: json['payment_type'] ?? '',
      count: json['count'] ?? 0,
      totalAmount: json['total_amount']?.toString() ?? '0.00',
    );
  }

  @override
  List<Object?> get props => [paymentType, count, totalAmount];
}

// Activity Data Model (for the actual API structure)
class ActivityData extends Equatable {
  final String date;
  final int count;

  const ActivityData({required this.date, required this.count});

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(date: json['date'] ?? '', count: json['count'] ?? 0);
  }

  @override
  List<Object?> get props => [date, count];
}

// Dashboard Summary Model
class DashboardSummary extends Equatable {
  final int ordersThisWeek;
  final int ordersThisMonth;
  final int pendingTasks;

  const DashboardSummary({
    required this.ordersThisWeek,
    required this.ordersThisMonth,
    required this.pendingTasks,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      ordersThisWeek: json['orders_this_week'] ?? 0,
      ordersThisMonth: json['orders_this_month'] ?? 0,
      pendingTasks: json['pending_tasks'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [ordersThisWeek, ordersThisMonth, pendingTasks];
}

// Keep old models for backward compatibility but mark as deprecated
@deprecated
class OrderStatus extends Equatable {
  final String status;
  final int count;
  final String color;

  const OrderStatus({
    required this.status,
    required this.count,
    required this.color,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
      color: json['color'] ?? '#667eea',
    );
  }

  @override
  List<Object?> get props => [status, count, color];
}

@deprecated
class PaymentType extends Equatable {
  final String type;
  final int count;
  final String percentage;

  const PaymentType({
    required this.type,
    required this.count,
    required this.percentage,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
      percentage: json['percentage'] ?? '0%',
    );
  }

  @override
  List<Object?> get props => [type, count, percentage];
}

@deprecated
class RecentActivity extends Equatable {
  final String action;
  final String description;
  final String timestamp;
  final String icon;

  const RecentActivity({
    required this.action,
    required this.description,
    required this.timestamp,
    required this.icon,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      action: json['action'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] ?? '',
      icon: json['icon'] ?? 'info',
    );
  }

  @override
  List<Object?> get props => [action, description, timestamp, icon];
}
