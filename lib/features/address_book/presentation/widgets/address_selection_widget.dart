import 'package:client_app/features/address_book/cubit/address_book_cubit.dart';
import 'package:client_app/features/address_book/cubit/address_book_state.dart';
import 'package:client_app/features/address_book/data/models/address_book_models.dart';
// import 'package:client_app/features/address_book/presentation/pages/address_book_page.dart'; // Removed - Address management disabled
import 'package:client_app/injections.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_app/core/widgets/loading_widgets.dart';

class AddressSelectionWidget extends StatefulWidget {
  final AddressBookEntry? selectedAddress;
  final void Function(AddressBookEntry?) onAddressSelected;
  final String label;
  final bool isRequired;

  const AddressSelectionWidget({
    super.key,
    this.selectedAddress,
    required this.onAddressSelected,
    this.label = 'Select Address',
    this.isRequired = false,
  });

  @override
  State<AddressSelectionWidget> createState() => _AddressSelectionWidgetState();
}

class _AddressSelectionWidgetState extends State<AddressSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showAddressSelectionBottomSheet,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF667eea).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF667eea),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:
                      widget.selectedAddress != null
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.selectedAddress!.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1a1a1a),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.selectedAddress!.streetAddress}, ${widget.selectedAddress!.place?.enName ?? ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                          : Text(
                            AppLocalizations.of(context)!.tapToSelectAddress,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (widget.selectedAddress != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => widget.onAddressSelected(null),
                icon: const Icon(
                  Icons.clear_rounded,
                  size: 16,
                  color: Colors.red,
                ),
                label: Text(
                  AppLocalizations.of(context)!.clearSelection,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _showAddressSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BlocProvider(
            create: (context) => getIt<AddressBookCubit>(),
            child: AddressSelectionBottomSheet(
              onAddressSelected: (address) {
                widget.onAddressSelected(address);
                Navigator.pop(context);
              },
            ),
          ),
    );
  }
}

class AddressSelectionBottomSheet extends StatefulWidget {
  final void Function(AddressBookEntry) onAddressSelected;

  const AddressSelectionBottomSheet({
    super.key,
    required this.onAddressSelected,
  });

  @override
  State<AddressSelectionBottomSheet> createState() =>
      _AddressSelectionBottomSheetState();
}

class _AddressSelectionBottomSheetState
    extends State<AddressSelectionBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressBookCubit>().loadAddressBookEntries(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          Expanded(
            child: BlocBuilder<AddressBookCubit, AddressBookState>(
              builder: (context, state) {
                if (state is AddressBookLoading) {
                  return LoadingWidgets.fullScreenLoading();
                } else if (state is AddressBookEmpty) {
                  return _buildEmptyState();
                } else if (state is AddressBookLoaded) {
                  return _buildAddressList(state.entries);
                } else if (state is AddressBookError) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.selectAddress,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1a1a1a),
            ),
          ),
          // Add New button removed - Address management disabled
        ],
      ),
    );
  }

  Widget _buildAddressList(List<AddressBookEntry> addresses) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return _buildAddressItem(address);
      },
    );
  }

  Widget _buildAddressItem(AddressBookEntry address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onAddressSelected(address),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF667eea).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF667eea),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${address.streetAddress}, ${address.place?.enName ?? ''}, ${address.state?.enName ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.contacts_rounded,
                color: Color(0xFF667eea),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noAddressesFound,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.addressManagementDisabled,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            // Add Address button removed - Address management disabled
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorLoadingAddresses,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AddressBookCubit>().loadAddressBookEntries(
                  refresh: true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  // _navigateToFullAddressBook method removed - Address management disabled
}
