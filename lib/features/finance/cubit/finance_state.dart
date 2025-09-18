part of 'finance_cubit.dart';

/// Abstract base class for finance states
abstract class FinanceState extends Equatable {
  const FinanceState();

  @override
  List<Object?> get props => [];
}

/// Initial state when finance feature is first loaded
class FinanceInitial extends FinanceState {}

/// Loading state when fetching finance data
class FinanceLoading extends FinanceState {}

/// Loading more state when loading additional pages
class FinanceLoadingMore extends FinanceState {
  final FinanceData data;

  const FinanceLoadingMore({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Loaded state when finance data is successfully fetched
class FinanceLoaded extends FinanceState {
  final FinanceData data;
  final bool isRefresh;

  const FinanceLoaded({required this.data, this.isRefresh = false});

  @override
  List<Object?> get props => [data, isRefresh];
}

/// Error state when finance data fetching fails
class FinanceError extends FinanceState {
  final String message;

  const FinanceError({required this.message});

  @override
  List<Object?> get props => [message];
}
