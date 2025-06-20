import 'package:client_app/features/shipment/data/models/order_models.dart';
import 'package:client_app/features/shipment/data/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

part 'shipment_state.dart';

class ShipmentCubit extends Cubit<ShipmentState> {
  final OrderRepository _orderRepository;
  String? _currentStickerNumber;

  ShipmentCubit(this._orderRepository) : super(ShipmentInitial());

  void enterStickerNumber(String stickerNumber) {
    if (isClosed) return;

    _currentStickerNumber = stickerNumber.trim();
    if (_currentStickerNumber!.isNotEmpty) {
      emit(ShipmentNumberEntered(stickerNumber: _currentStickerNumber!));
    } else {
      emit(ShipmentInitial());
    }
  }

  void onBarcodeDetected(BarcodeCapture capture) {
    if (isClosed) return;

    final barcode = capture.barcodes.first.rawValue;
    if (barcode != null && barcode.isNotEmpty) {
      _currentStickerNumber = barcode;
      emit(ShipmentScanSuccess(trackingNumber: barcode));
    } else {
      emit(const ShipmentScanError(message: 'Unable to read barcode'));
    }
  }

  void showScanError(String message) {
    if (isClosed) return;
    emit(ShipmentScanError(message: message));
  }

  // Order Creation Methods
  Future<void> createOrder(CreateOrderRequest request) async {
    if (isClosed) return;

    try {
      emit(OrderCreating());

      // Use the request as-is since it now has all the correct fields
      final response = await _orderRepository.createOrder(request);

      if (isClosed) return; // Check again after async operation

      if (response.success) {
        emit(OrderCreated(orderData: response.data));
        // Reset sticker number after successful creation
        _currentStickerNumber = null;
      } else {
        emit(OrderCreationError(message: response.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(OrderCreationError(message: e.toString()));
      }
    }
  }

  // Order Listing Methods
  Future<void> loadOrders() async {
    if (isClosed) return;

    try {
      emit(OrdersLoading());
      final orders = await _orderRepository.getUserOrders();

      if (!isClosed) {
        emit(OrdersLoaded(orders: orders));
      }
    } catch (e) {
      if (!isClosed) {
        emit(OrdersError(message: e.toString()));
      }
    }
  }

  // Reset to initial state
  void reset() {
    if (isClosed) return;

    _currentStickerNumber = null;
    emit(ShipmentInitial());
  }

  // Get current sticker number
  String? get currentStickerNumber => _currentStickerNumber;
}
