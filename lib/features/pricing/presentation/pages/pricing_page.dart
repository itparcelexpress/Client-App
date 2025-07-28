import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/features/pricing/cubit/pricing_cubit.dart';
import 'package:client_app/features/pricing/cubit/pricing_state.dart';
import 'package:client_app/features/pricing/data/models/pricing_models.dart';
import 'package:client_app/features/pricing/presentation/widgets/pricing_card_widget.dart';
import 'package:client_app/injections.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PricingCubit>()..loadClientPricing(),
      child: const PricingView(),
    );
  }
}

class PricingView extends StatefulWidget {
  const PricingView({super.key});

  @override
  State<PricingView> createState() => _PricingViewState();
}

class _PricingViewState extends State<PricingView> {
  final TextEditingController _searchController = TextEditingController();
  List<PricingData> _filteredPricingData = [];
  List<PricingData> _allPricingData = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPricingData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPricingData = _allPricingData;
      } else {
        _filteredPricingData =
            _allPricingData
                .where(
                  (pricing) =>
                      pricing.stateName?.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ??
                      false,
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: BlocConsumer<PricingCubit, PricingState>(
        listener: (context, state) {
          if (state is PricingLoaded) {
            setState(() {
              _allPricingData = state.pricingData;
              _filteredPricingData = state.pricingData;
            });
          }
        },
        builder: (context, state) {
          if (state is PricingLoading) {
            return _buildLoadingState();
          } else if (state is PricingError) {
            return _buildErrorState(state.message);
          } else if (state is PricingLoaded) {
            return _buildLoadedState();
          } else if (state is PricingEmpty) {
            return _buildEmptyState(state.message);
          } else {
            return _buildEmptyState('Loading pricing data...');
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1a1a1a),
      centerTitle: true,
      title: Text(
        AppLocalizations.of(context)!.pricingList,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1a1a1a),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.read<PricingCubit>().refreshPricing(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF667eea),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitThreeBounce(color: Color(0xFF667eea), size: 30),
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.loadingPricingData,
            style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.errorLoadingPricing,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.read<PricingCubit>().refreshPricing(),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(AppLocalizations.of(context)!.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.price_check_outlined,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.noPricingData,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState() {
    return Column(
      children: [
        _buildSearchBar(),
        _buildPricingSummary(),
        Expanded(child: _buildPricingList()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return FadeInDown(
      duration: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterPricingData,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchByStateName,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSummary() {
    if (_filteredPricingData.isEmpty) return const SizedBox.shrink();

    final totalStates = _filteredPricingData.length;
    final avgDeliveryFee =
        _filteredPricingData
            .map((p) => p.deliveryFeeValue)
            .reduce((a, b) => a + b) /
        totalStates;
    final avgReturnFee =
        _filteredPricingData
            .map((p) => p.returnFeeValue)
            .reduce((a, b) => a + b) /
        totalStates;

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667eea).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildSummaryItem(
                AppLocalizations.of(context)!.totalStates,
                '$totalStates',
                Icons.location_on_rounded,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            Expanded(
              child: _buildSummaryItem(
                AppLocalizations.of(context)!.avgDelivery,
                '${avgDeliveryFee.toStringAsFixed(2)} OMR',
                Icons.local_shipping_rounded,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            Expanded(
              child: _buildSummaryItem(
                AppLocalizations.of(context)!.avgReturn,
                '${avgReturnFee.toStringAsFixed(2)} OMR',
                Icons.keyboard_return_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingList() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _filteredPricingData.length,
        itemBuilder: (context, index) {
          return FadeInUp(
            duration: Duration(milliseconds: 400 + (index * 100)),
            child: PricingCardWidget(pricingData: _filteredPricingData[index]),
          );
        },
      ),
    );
  }
}
