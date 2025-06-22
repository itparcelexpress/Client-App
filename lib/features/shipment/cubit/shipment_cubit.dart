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

  // Client Orders Methods (new)
  Future<void> loadClientOrders({
    String? status,
    String? fromDate,
    String? toDate,
    String? query,
    int page = 1,
  }) async {
    if (isClosed) return;

    try {
      emit(ClientOrdersLoading());
      final response = await _orderRepository.getClientOrders(
        status: status,
        fromDate: fromDate,
        toDate: toDate,
        query: query,
        page: page,
      );

      if (!isClosed) {
        final orders =
            response.data.data
                .map(
                  (pickupOrder) =>
                      PickupOrderSummary.fromPickupOrder(pickupOrder),
                )
                .toList();

        emit(
          ClientOrdersLoaded(
            orders: orders,
            currentPage: response.data.currentPage,
            totalPages: response.data.lastPage,
            totalOrders: response.data.total,
            hasNextPage: response.data.nextPageUrl != null,
            hasPreviousPage: response.data.prevPageUrl != null,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(ClientOrdersError(message: e.toString()));
      }
    }
  }

  // Load next page of client orders
  Future<void> loadNextPage({
    String? status,
    String? fromDate,
    String? toDate,
    String? query,
  }) async {
    final currentState = state;
    if (currentState is ClientOrdersLoaded && currentState.hasNextPage) {
      await loadClientOrders(
        status: status,
        fromDate: fromDate,
        toDate: toDate,
        query: query,
        page: currentState.currentPage + 1,
      );
    }
  }

  // Load previous page of client orders
  Future<void> loadPreviousPage({
    String? status,
    String? fromDate,
    String? toDate,
    String? query,
  }) async {
    final currentState = state;
    if (currentState is ClientOrdersLoaded && currentState.hasPreviousPage) {
      await loadClientOrders(
        status: status,
        fromDate: fromDate,
        toDate: toDate,
        query: query,
        page: currentState.currentPage - 1,
      );
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
