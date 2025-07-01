// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      id: (json['id'] as num).toInt(),
      ownerType: json['owner_type'] as String?,
      ownerId: (json['owner_id'] as num?)?.toInt(),
      invoiceNo: json['invoice_no'] as String,
      invoiceableType: json['invoiceable_type'] as String,
      invoiceableId: (json['invoiceable_id'] as num).toInt(),
      driverRunsheetId: (json['driver_runsheet_id'] as num?)?.toInt(),
      status: json['status'] as String,
      amount: json['amount'] as String,
      paymentVoucher: json['payment_voucher'] as String?,
      driverPaymentProof: json['driver_payment_proof'] as String?,
      paidToDriver: json['paid_to_driver'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      totalPaidAmount: (json['total_paid_amount'] as num).toDouble(),
      driverTotalCommission:
          (json['driver_total_commission'] as num).toDouble(),
      invoiceable: json['invoiceable'] == null
          ? null
          : Invoiceable.fromJson(json['invoiceable'] as Map<String, dynamic>),
      invoiceOrders: (json['invoice_orders'] as List<dynamic>)
          .map((e) => InvoiceOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      runsheet: json['runsheet'],
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'owner_type': instance.ownerType,
      'owner_id': instance.ownerId,
      'invoice_no': instance.invoiceNo,
      'invoiceable_type': instance.invoiceableType,
      'invoiceable_id': instance.invoiceableId,
      'driver_runsheet_id': instance.driverRunsheetId,
      'status': instance.status,
      'amount': instance.amount,
      'payment_voucher': instance.paymentVoucher,
      'driver_payment_proof': instance.driverPaymentProof,
      'paid_to_driver': instance.paidToDriver,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'total_paid_amount': instance.totalPaidAmount,
      'driver_total_commission': instance.driverTotalCommission,
      'invoiceable': instance.invoiceable,
      'invoice_orders': instance.invoiceOrders,
      'runsheet': instance.runsheet,
    };

Invoiceable _$InvoiceableFromJson(Map<String, dynamic> json) => Invoiceable(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$InvoiceableToJson(Invoiceable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };

InvoiceOrder _$InvoiceOrderFromJson(Map<String, dynamic> json) => InvoiceOrder(
      id: (json['id'] as num).toInt(),
      invoiceId: (json['invoice_id'] as num).toInt(),
      orderTrackingNo: json['order_tracking_no'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$InvoiceOrderToJson(InvoiceOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_id': instance.invoiceId,
      'order_tracking_no': instance.orderTrackingNo,
      'status': instance.status,
    };

InvoicesListResponse _$InvoicesListResponseFromJson(
        Map<String, dynamic> json) =>
    InvoicesListResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$InvoicesListResponseToJson(
        InvoicesListResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
      'errors': instance.errors,
    };

InvoicesResponse _$InvoicesResponseFromJson(Map<String, dynamic> json) =>
    InvoicesResponse(
      message: json['message'] as String?,
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : InvoicesData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InvoicesResponseToJson(InvoicesResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

InvoicesData _$InvoicesDataFromJson(Map<String, dynamic> json) => InvoicesData(
      currentPage: (json['current_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String,
      from: (json['from'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      lastPageUrl: json['last_page_url'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => PaginationLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String,
      perPage: (json['per_page'] as num).toInt(),
      prevPageUrl: json['prev_page_url'] as String?,
      to: (json['to'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$InvoicesDataToJson(InvoicesData instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'data': instance.data,
      'first_page_url': instance.firstPageUrl,
      'from': instance.from,
      'last_page': instance.lastPage,
      'last_page_url': instance.lastPageUrl,
      'links': instance.links,
      'next_page_url': instance.nextPageUrl,
      'path': instance.path,
      'per_page': instance.perPage,
      'prev_page_url': instance.prevPageUrl,
      'to': instance.to,
      'total': instance.total,
    };

PaginationLink _$PaginationLinkFromJson(Map<String, dynamic> json) =>
    PaginationLink(
      url: json['url'] as String?,
      label: json['label'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$PaginationLinkToJson(PaginationLink instance) =>
    <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };

InvoiceDetailResponse _$InvoiceDetailResponseFromJson(
        Map<String, dynamic> json) =>
    InvoiceDetailResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: Invoice.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>,
    );

Map<String, dynamic> _$InvoiceDetailResponseToJson(
        InvoiceDetailResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
      'errors': instance.errors,
    };

PaymentTransaction _$PaymentTransactionFromJson(Map<String, dynamic> json) =>
    PaymentTransaction(
      id: (json['id'] as num).toInt(),
      trackingNo: json['tracking_no'] as String,
      amount: json['amount'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
    );

Map<String, dynamic> _$PaymentTransactionToJson(PaymentTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tracking_no': instance.trackingNo,
      'amount': instance.amount,
      'type': instance.type,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
    };

PaymentSummary _$PaymentSummaryFromJson(Map<String, dynamic> json) =>
    PaymentSummary(
      codCollected: (json['cod_collected'] as num).toDouble(),
      settled: (json['settled'] as num).toDouble(),
      pending: (json['pending'] as num).toDouble(),
    );

Map<String, dynamic> _$PaymentSummaryToJson(PaymentSummary instance) =>
    <String, dynamic>{
      'cod_collected': instance.codCollected,
      'settled': instance.settled,
      'pending': instance.pending,
    };

PaymentTransactionsResponse _$PaymentTransactionsResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentTransactionsResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => PaymentTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PaymentTransactionsResponseToJson(
        PaymentTransactionsResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
      'errors': instance.errors,
    };

PaymentSummaryResponse _$PaymentSummaryResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentSummaryResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: PaymentSummary.fromJson(json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PaymentSummaryResponseToJson(
        PaymentSummaryResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
      'errors': instance.errors,
    };
