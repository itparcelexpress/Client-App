import 'package:client_app/features/guest/data/models/guest_order_models.dart';
import 'package:equatable/equatable.dart';

abstract class GuestState extends Equatable {
  const GuestState();

  @override
  List<Object?> get props => [];
}

class GuestInitial extends GuestState {}

class GuestOrderLoading extends GuestState {}

class GuestOrderSuccess extends GuestState {
  final GuestOrderData orderData;
  final String message;

  const GuestOrderSuccess({required this.orderData, required this.message});

  @override
  List<Object?> get props => [orderData, message];
}

class GuestOrderError extends GuestState {
  final String message;
  final List<String> errors;

  const GuestOrderError({required this.message, required this.errors});

  @override
  List<Object?> get props => [message, errors];
}
