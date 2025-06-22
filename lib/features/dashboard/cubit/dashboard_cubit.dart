import 'package:client_app/features/dashboard/data/models/dashboard_models.dart';
import 'package:client_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardCubit(this._dashboardRepository) : super(DashboardInitial());

  // Load dashboard statistics
  Future<void> loadDashboardStats() async {
    if (isClosed) return;

    try {
      emit(DashboardLoading());

      final response = await _dashboardRepository.getDashboardStats();

      if (isClosed) return; // Check again after async operation

      if (response.success) {
        emit(DashboardLoaded(data: response.data));
      } else {
        emit(DashboardError(message: response.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DashboardError(message: e.toString()));
      }
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboardStats() async {
    // Don't show loading state on refresh to avoid UI flicker
    try {
      final response = await _dashboardRepository.getDashboardStats();

      if (!isClosed && response.success) {
        emit(DashboardLoaded(data: response.data));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DashboardError(message: e.toString()));
      }
    }
  }

  // Reset dashboard state
  void reset() {
    if (!isClosed) {
      emit(DashboardInitial());
    }
  }
}
