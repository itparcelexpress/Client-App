part of 'shipment_cubit.dart';

abstract class ShipmentState extends Equatable {
  const ShipmentState();

  @override
  List<Object?> get props => [];
}

class ShipmentInitial extends ShipmentState {}

class ShipmentLoading extends ShipmentState {}

class ShipmentScanSuccess extends ShipmentState {
  final String trackingNumber;

  const ShipmentScanSuccess({required this.trackingNumber});

  @override
  List<Object?> get props => [trackingNumber];
}

class ShipmentScanError extends ShipmentState {
  final String message;

  const ShipmentScanError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ShipmentNumberEntered extends ShipmentState {
  final String stickerNumber;

  const ShipmentNumberEntered({required this.stickerNumber});

  @override
  List<Object?> get props => [stickerNumber];
}

// Order Creation States
class OrderCreating extends ShipmentState {}

class OrderCreated extends ShipmentState {
  final OrderData orderData;

  const OrderCreated({required this.orderData});

  @override
  List<Object?> get props => [orderData];
}

class OrderCreationError extends ShipmentState {
  final String message;

  const OrderCreationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Order Listing States
class OrdersLoading extends ShipmentState {}

class OrdersLoaded extends ShipmentState {
  final List<OrderSummary> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrdersError extends ShipmentState {
  final String message;

  const OrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Client Orders States (new)
class ClientOrdersLoading extends ShipmentState {}

class ClientOrdersLoaded extends ShipmentState {
  final List<PickupOrderSummary> orders;
  final int currentPage;
  final int totalPages;
  final int totalOrders;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const ClientOrdersLoaded({
    required this.orders,
    required this.currentPage,
    required this.totalPages,
    required this.totalOrders,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  @override
  List<Object?> get props => [
    orders,
    currentPage,
    totalPages,
    totalOrders,
    hasNextPage,
    hasPreviousPage,
  ];
}

class ClientOrdersError extends ShipmentState {
  final String message;

  const ClientOrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}
