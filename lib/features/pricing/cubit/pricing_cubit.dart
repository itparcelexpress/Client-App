import 'package:client_app/features/pricing/cubit/pricing_state.dart';
import 'package:client_app/features/pricing/data/repositories/pricing_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PricingCubit extends Cubit<PricingState> {
  final PricingRepository _pricingRepository;

  PricingCubit(this._pricingRepository) : super(PricingInitial());

  /// Load pricing data for current client
  Future<void> loadClientPricing() async {
    try {
      emit(PricingLoading());

      final response = await _pricingRepository.getCurrentClientPricing();

      if (response.success) {
        if (response.data.isNotEmpty) {
          emit(
            PricingLoaded(
              pricingData: response.data,
              message: response.message,
            ),
          );
        } else {
          emit(
            const PricingEmpty(
              message: 'No pricing data available for your location',
            ),
          );
        }
      } else {
        emit(
          PricingError(
            message:
                response.message.isNotEmpty
                    ? response.message
                    : 'Failed to load pricing data',
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 PricingCubit Error: $e');
      }
      emit(PricingError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Load pricing data for specific client
  Future<void> loadPricingForClient(int clientId) async {
    try {
      emit(PricingLoading());

      final response = await _pricingRepository.getClientPricing(clientId);

      if (response.success) {
        if (response.data.isNotEmpty) {
          emit(
            PricingLoaded(
              pricingData: response.data,
              message: response.message,
            ),
          );
        } else {
          emit(
            const PricingEmpty(
              message: 'No pricing data available for this client',
            ),
          );
        }
      } else {
        emit(
          PricingError(
            message:
                response.message.isNotEmpty
                    ? response.message
                    : 'Failed to load pricing data',
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 PricingCubit Error: $e');
      }
      emit(PricingError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Load pricing data using client ID (for create order page)
  Future<void> loadClientPricingByClientId() async {
    try {
      emit(PricingLoading());

      final response =
          await _pricingRepository.getCurrentClientPricingByClientId();

      if (response.success) {
        if (response.data.isNotEmpty) {
          emit(
            PricingLoaded(
              pricingData: response.data,
              message: response.message,
            ),
          );
        } else {
          emit(
            const PricingEmpty(
              message: 'No pricing data available for your location',
            ),
          );
        }
      } else {
        emit(
          PricingError(
            message:
                response.message.isNotEmpty
                    ? response.message
                    : 'Failed to load pricing data',
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 PricingCubit Error: $e');
      }
      emit(PricingError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Refresh pricing data
  Future<void> refreshPricing() async {
    await loadClientPricing();
  }

  /// Reset to initial state
  void reset() {
    emit(PricingInitial());
  }
}
