import 'package:animate_do/animate_do.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/shipment/presentation/pages/create_order_page.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ShipmentPage extends StatefulWidget {
  const ShipmentPage({super.key});

  @override
  State<ShipmentPage> createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  final TextEditingController _stickerController = TextEditingController();
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _stickerController.addListener(() {
      context.read<ShipmentCubit>().enterStickerNumber(_stickerController.text);
    });
  }

  @override
  void dispose() {
    _stickerController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildSimpleAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildTitle(),
                    const SizedBox(height: 40),
                    _buildInputSection(),
                    const SizedBox(height: 30),
                    _buildResultSection(),
                    const SizedBox(height: 40),
                    _buildCreateButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleAppBar() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.white,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
            ),
            const Expanded(
              child: Text(
                'Create Shipment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1a1a1a),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 36), // Balance the back button
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Scan or Enter',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your sticker number to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [_buildTextField(), _buildDivider(), _buildScanSection()],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter manually',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _stickerController,
            decoration: InputDecoration(
              hintText: 'Type sticker number...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.tag, color: Colors.grey[400], size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF667eea),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[200])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'OR',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[200])),
        ],
      ),
    );
  }

  Widget _buildScanSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scan barcode',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 16),
          _buildScanButton(),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: _showScanBottomSheet,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Start Scanning',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return BlocBuilder<ShipmentCubit, ShipmentState>(
      builder: (context, state) {
        if (state is ShipmentInitial) return const SizedBox.shrink();

        return FadeInUp(
          duration: const Duration(milliseconds: 700),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getResultBackgroundColor(state),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getResultBorderColor(state), width: 1),
            ),
            child: Column(
              children: [
                Icon(
                  _getResultIcon(state),
                  color: _getResultColor(state),
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  _getResultTitle(state),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _getResultColor(state),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    _getResultText(state),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1a1a1a),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreateButton() {
    return BlocBuilder<ShipmentCubit, ShipmentState>(
      builder: (context, state) {
        final hasValidInput =
            state is ShipmentNumberEntered || state is ShipmentScanSuccess;

        return FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: GestureDetector(
            onTap: hasValidInput ? _createOrder : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient:
                    hasValidInput
                        ? const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                        : null,
                color: hasValidInput ? null : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
                boxShadow:
                    hasValidInput
                        ? [
                          BoxShadow(
                            color: const Color(
                              0xFF667eea,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ]
                        : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: hasValidInput ? Colors.white : Colors.grey[500],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Create Order',
                    style: TextStyle(
                      color: hasValidInput ? Colors.white : Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper methods
  void _createOrder() {
    final stickerNumber = context.read<ShipmentCubit>().currentStickerNumber;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) {
                final cubit = getIt<ShipmentCubit>();
                if (stickerNumber != null) {
                  cubit.enterStickerNumber(stickerNumber);
                }
                return cubit;
              },
              child: CreateOrderPage(stickerNumber: stickerNumber),
            ),
      ),
    );
  }

  void _showScanBottomSheet() async {
    final permission = await Permission.camera.request();
    if (permission.isGranted) {
      setState(() {
        _scannerController = MobileScannerController();
      });
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _buildScanBottomSheet(),
        ).then((_) {
          // Dispose controller when bottom sheet is closed
          _scannerController?.dispose();
          _scannerController = null;
        });
      }
    } else if (mounted) {
      context.read<ShipmentCubit>().showScanError('Camera permission denied');
    }
  }

  Widget _buildScanBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Scan Barcode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1a1a1a),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
              ],
            ),
          ),
          // Scanner
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MobileScanner(
                    controller: _scannerController,
                    onDetect: (capture) {
                      context.read<ShipmentCubit>().onBarcodeDetected(capture);
                      Navigator.pop(context); // Close bottom sheet
                    },
                  ),
                ),
              ),
            ),
          ),
          // Instructions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Position the barcode within the frame to scan',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Color _getResultColor(ShipmentState state) {
    if (state is ShipmentScanError) return const Color(0xFFef4444);
    if (state is ShipmentScanSuccess) return const Color(0xFF10b981);
    return const Color(0xFF667eea);
  }

  Color _getResultBackgroundColor(ShipmentState state) {
    if (state is ShipmentScanError) {
      return const Color(0xFFef4444).withValues(alpha: 0.1);
    }
    if (state is ShipmentScanSuccess) {
      return const Color(0xFF10b981).withValues(alpha: 0.1);
    }
    return const Color(0xFF667eea).withValues(alpha: 0.1);
  }

  Color _getResultBorderColor(ShipmentState state) {
    if (state is ShipmentScanError) {
      return const Color(0xFFef4444).withValues(alpha: 0.3);
    }
    if (state is ShipmentScanSuccess) {
      return const Color(0xFF10b981).withValues(alpha: 0.3);
    }
    return const Color(0xFF667eea).withValues(alpha: 0.3);
  }

  IconData _getResultIcon(ShipmentState state) {
    if (state is ShipmentScanError) return Icons.error_outline_rounded;
    if (state is ShipmentScanSuccess) return Icons.check_circle_outline_rounded;
    return Icons.confirmation_number_outlined;
  }

  String _getResultTitle(ShipmentState state) {
    if (state is ShipmentScanError) return 'Scan Failed';
    if (state is ShipmentScanSuccess) return 'Successfully Scanned';
    return 'Number Entered';
  }

  String _getResultText(ShipmentState state) {
    if (state is ShipmentScanError) return state.message;
    if (state is ShipmentScanSuccess) return state.trackingNumber;
    if (state is ShipmentNumberEntered) return state.stickerNumber;
    return '';
  }
}
