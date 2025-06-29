import 'package:client_app/features/pricing/data/models/pricing_models.dart';
import 'package:equatable/equatable.dart';

abstract class PricingState extends Equatable {
  const PricingState();

  @override
  List<Object> get props => [];
}

class PricingInitial extends PricingState {}

class PricingLoading extends PricingState {}

class PricingLoaded extends PricingState {
  final List<PricingData> pricingData;
  final String message;

  const PricingLoaded({required this.pricingData, required this.message});

  @override
  List<Object> get props => [pricingData, message];
}

class PricingError extends PricingState {
  final String message;

  const PricingError({required this.message});

  @override
  List<Object> get props => [message];
}

class PricingEmpty extends PricingState {
  final String message;

  const PricingEmpty({this.message = 'No pricing data available'});

  @override
  List<Object> get props => [message];
}
