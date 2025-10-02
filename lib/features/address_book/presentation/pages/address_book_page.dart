import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/services/messaging_service.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/features/address_book/cubit/address_book_cubit.dart';
import 'package:client_app/features/address_book/cubit/address_book_state.dart';
import 'package:client_app/features/address_book/data/models/address_book_models.dart';
import 'package:client_app/features/address_book/presentation/pages/add_address_page.dart';
import 'package:client_app/features/address_book/presentation/pages/address_details_page.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_app/core/widgets/loading_widgets.dart';
import 'package:client_app/l10n/app_localizations.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({super.key});

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load address book entries when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressBookCubit>().loadAddressBookEntries(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Load more when user is near the bottom
      final cubit = context.read<AddressBookCubit>();
      if (cubit.hasMorePages) {
        cubit.loadMoreEntries();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: BlocConsumer<AddressBookCubit, AddressBookState>(
        listener: (context, state) {
          if (state is AddressBookEntryCreated) {
            MessagingService.showSuccess(context, state.message);
          } else if (state is AddressBookEntryDeleted) {
            MessagingService.showWarning(context, state.message);
          } else if (state is AddressBookError ||
              state is AddressBookCreateError ||
              state is AddressBookDeleteError) {
            String message = 'An error occurred';
            if (state is AddressBookError) message = state.message;
            if (state is AddressBookCreateError) message = state.message;
            if (state is AddressBookDeleteError) message = state.message;

            MessagingService.showError(context, message);
          }
        },
        builder: (context, state) {
          if (state is AddressBookLoading) {
            return _buildLoadingState();
          } else if (state is AddressBookEmpty) {
            return _buildEmptyState();
          } else if (state is AddressBookLoaded) {
            return _buildLoadedState(state);
          } else if (state is AddressBookError) {
            return _buildErrorState(state.message);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: FadeInDown(
        duration: const Duration(milliseconds: 400),
        child: Text(
          AppLocalizations.of(context)!.addressBook,
          style: const TextStyle(
            color: Color(0xFF1a1a1a),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      centerTitle: true,
      leading: FadeInLeft(
        duration: const Duration(milliseconds: 400),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF1a1a1a),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return LoadingWidgets.fullScreenLoading();
  }

  Widget _buildEmptyState() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Padding(
          padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
            context,
            const EdgeInsets.all(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveWidth(context, 120),
                height: ResponsiveUtils.getResponsiveHeight(context, 120),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667eea).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.contacts_rounded,
                  color: Colors.white,
                  size: ResponsiveUtils.getResponsiveWidth(context, 60),
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 24),
              ),
              Text(
                AppLocalizations.of(context)!.noAddressesYet,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1a1a1a),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 12),
              ),
              Text(
                AppLocalizations.of(context)!.addYourFirstAddressHint,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 32),
              ),
              ElevatedButton.icon(
                onPressed: _navigateToAddAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667eea),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  AppLocalizations.of(context)!.addAddress,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Padding(
          padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
            context,
            const EdgeInsets.all(40),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ResponsiveUtils.getResponsiveWidth(context, 120),
                height: ResponsiveUtils.getResponsiveHeight(context, 120),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: ResponsiveUtils.getResponsiveWidth(context, 60),
                ),
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 24),
              ),
              Text(
                AppLocalizations.of(context)!.errorLoadingAddresses,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1a1a1a),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 12),
              ),
              Text(
                message,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 32),
              ),
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
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  AppLocalizations.of(context)!.tryAgain,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(AddressBookLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AddressBookCubit>().loadAddressBookEntries(refresh: true);
      },
      color: const Color(0xFF667eea),
      child: ListView.builder(
        controller: _scrollController,
        padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
          context,
          const EdgeInsets.all(20),
        ),
        itemCount: state.entries.length + (state.hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.entries.length) {
            // Loading indicator for more items
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: LoadingWidgets.listLoading()),
            );
          }

          final entry = state.entries[index];
          return FadeInUp(
            duration: Duration(milliseconds: 400 + (index * 100)),
            child: _buildAddressCard(entry, index),
          );
        },
      ),
    );
  }

  Widget _buildAddressCard(AddressBookEntry entry, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToAddressDetails(entry),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getColorForIndex(index),
                            _getColorForIndex(index).withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1a1a1a),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteDialog(entry);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.cellphone,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_city_rounded,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${entry.streetAddress}, ${entry.place?.enName ?? ''}, ${entry.state?.enName ?? ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _navigateToAddAddress,
      backgroundColor: const Color(0xFF667eea),
      foregroundColor: Colors.white,
      elevation: 6,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'Add Address',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF667eea),
      const Color(0xFF10b981),
      const Color(0xFF8b5cf6),
      const Color(0xFFf59e0b),
      const Color(0xFFef4444),
      const Color(0xFF06b6d4),
    ];
    return colors[index % colors.length];
  }

  void _navigateToAddAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create: (context) => getIt<AddressBookCubit>(),
              child: const AddAddressPage(),
            ),
      ),
    );
  }

  void _navigateToAddressDetails(AddressBookEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressDetailsPage(entry: entry)),
    );
  }

  void _showDeleteDialog(AddressBookEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocalizations.of(context)!.deleteAddress,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text(
            AppLocalizations.of(context)!.deleteAddressConfirmation(entry.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (entry.id != null) {
                  context.read<AddressBookCubit>().deleteAddressBookEntry(
                    entry.id!,
                  );
                }
              },
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(color: Color(0xFFef4444)),
              ),
            ),
          ],
        );
      },
    );
  }
}
