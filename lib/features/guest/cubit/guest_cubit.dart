import 'dart:developer' as dev;

import 'package:client_app/features/guest/cubit/guest_state.dart';
import 'package:client_app/features/guest/data/models/guest_order_models.dart';
import 'package:client_app/features/guest/data/repositories/guest_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestCubit extends Cubit<GuestState> {
  final GuestRepository _repository;

  GuestCubit(this._repository) : super(GuestInitial());

  Future<void> createGuestOrder(GuestOrderRequest request) async {
    dev.log('Starting createGuestOrder');
    emit(GuestOrderLoading());

    try {
      final response = await _repository.createGuestOrder(request);
      dev.log(
        'Repository response - success: ${response.success}, message: ${response.message}',
      );

      // If success is true, consider it a success regardless of data
      if (response.success) {
        dev.log('Emitting success state');
        if (response.data == null) {
          dev.log('Warning: response.success is true but data is null');
        }
        emit(
          GuestOrderSuccess(
            orderData: response.data!, // We know data exists if success is true
            message: response.message ?? 'Order created successfully',
          ),
        );
        dev.log('Success state emitted');
      } else {
        dev.log(
          'Emitting error state - message: ${response.message}, errors: ${response.errors}',
        );
        emit(
          GuestOrderError(
            message: response.message ?? 'Failed to create order',
            errors: response.errors ?? ['Unknown error occurred'],
          ),
        );
        dev.log('Error state emitted');
      }
    } catch (e, stackTrace) {
      dev.log('Error in createGuestOrder cubit: $e\n$stackTrace');
      emit(
        GuestOrderError(
          message: 'Failed to create order',
          errors: [e.toString()],
        ),
      );
    }
  }
}
