import 'package:json_annotation/json_annotation.dart';

part 'invoice_models.g.dart';

@JsonSerializable()
class Invoice {
  final int id;
  @JsonKey(name: 'owner_type')
  final String? ownerType;
  @JsonKey(name: 'owner_id')
  final int? ownerId;
  @JsonKey(name: 'invoice_no')
  final String invoiceNo;
  @JsonKey(name: 'invoiceable_type')
  final String invoiceableType;
  @JsonKey(name: 'invoiceable_id')
  final int invoiceableId;
  @JsonKey(name: 'driver_runsheet_id')
  final int? driverRunsheetId;
  final String status;
  final String amount;
  @JsonKey(name: 'payment_voucher')
  final String? paymentVoucher;
  @JsonKey(name: 'driver_payment_proof')
  final String? driverPaymentProof;
  @JsonKey(name: 'paid_to_driver')
  final String? paidToDriver;
  final String? notes;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'total_paid_amount')
  final double totalPaidAmount;
  @JsonKey(name: 'driver_total_commission')
  final double driverTotalCommission;
  final Invoiceable? invoiceable;
  @JsonKey(name: 'invoice_orders')
  final List<InvoiceOrder> invoiceOrders;
  final dynamic runsheet;

  Invoice({
    required this.id,
    this.ownerType,
    this.ownerId,
    required this.invoiceNo,
    required this.invoiceableType,
    required this.invoiceableId,
    this.driverRunsheetId,
    required this.status,
    required this.amount,
    this.paymentVoucher,
    this.driverPaymentProof,
    this.paidToDriver,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPaidAmount,
    required this.driverTotalCommission,
    this.invoiceable,
    required this.invoiceOrders,
    this.runsheet,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'paid':
        return '#4CAF50'; // Green
      case 'pending':
        return '#FF9800'; // Orange
      case 'overdue':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  String get formattedAmount {
    return '${double.parse(amount).toStringAsFixed(2)} OMR';
  }
}

@JsonSerializable()
class Invoiceable {
  final int id;
  final String name;
  final String email;

  Invoiceable({required this.id, required this.name, required this.email});

  factory Invoiceable.fromJson(Map<String, dynamic> json) =>
      _$InvoiceableFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceableToJson(this);
}

@JsonSerializable()
class InvoiceOrder {
  final int id;
  @JsonKey(name: 'invoice_id')
  final int invoiceId;
  @JsonKey(name: 'order_tracking_no')
  final String orderTrackingNo;
  final String status;

  InvoiceOrder({
    required this.id,
    required this.invoiceId,
    required this.orderTrackingNo,
    required this.status,
  });

  factory InvoiceOrder.fromJson(Map<String, dynamic> json) =>
      _$InvoiceOrderFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceOrderToJson(this);

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'delivered':
        return '#4CAF50'; // Green
      case 'pending':
        return '#FF9800'; // Orange
      case 'cancelled':
        return '#F44336'; // Red
      case 'returned':
        return '#9C27B0'; // Purple
      default:
        return '#9E9E9E'; // Grey
    }
  }
}

@JsonSerializable()
class InvoicesListResponse {
  final String message;
  final bool success;
  final List<Invoice> data;
  final List<String> errors;

  InvoicesListResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory InvoicesListResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoicesListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesListResponseToJson(this);
}

@JsonSerializable()
class InvoicesResponse {
  final String? message;
  final bool? success;
  final InvoicesData? data;

  InvoicesResponse({this.message, this.success, this.data});

  factory InvoicesResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesResponseToJson(this);
}

@JsonSerializable()
class InvoicesData {
  @JsonKey(name: 'current_page')
  final int currentPage;
  final List<Invoice> data;
  @JsonKey(name: 'first_page_url')
  final String firstPageUrl;
  final int from;
  @JsonKey(name: 'last_page')
  final int lastPage;
  @JsonKey(name: 'last_page_url')
  final String lastPageUrl;
  final List<PaginationLink> links;
  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;
  final String path;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'prev_page_url')
  final String? prevPageUrl;
  final int to;
  final int total;

  InvoicesData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory InvoicesData.fromJson(Map<String, dynamic> json) =>
      _$InvoicesDataFromJson(json);

  Map<String, dynamic> toJson() => _$InvoicesDataToJson(this);
}

@JsonSerializable()
class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  PaginationLink({this.url, required this.label, required this.active});

  factory PaginationLink.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinkFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationLinkToJson(this);
}

@JsonSerializable()
class InvoiceDetailResponse {
  final String message;
  final bool success;
  final Invoice data;
  final List<dynamic> errors;

  InvoiceDetailResponse({
    required this.message,
    required this.success,
    required this.data,
    required this.errors,
  });

  factory InvoiceDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceDetailResponseToJson(this);
}
