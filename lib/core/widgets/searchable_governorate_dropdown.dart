import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/location_models.dart';
import '../services/location_service.dart';
import '../../l10n/app_localizations.dart';

/// A searchable dropdown widget for governorate selection with localization support
class SearchableGovernorateDropdown extends StatefulWidget {
  final Governorate? value;
  final void Function(Governorate?) onChanged;
  final String label;
  final IconData icon;
  final String? Function(Governorate?)? validator;
  final bool isRequired;
  final bool enableSearch;
  final int? countryId; // Filter governorates by country
  final bool shouldShowErrors;

  const SearchableGovernorateDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.icon,
    this.validator,
    this.isRequired = true,
    this.enableSearch = true,
    this.countryId,
    this.shouldShowErrors = false,
  });

  @override
  State<SearchableGovernorateDropdown> createState() =>
      _SearchableGovernorateDropdownState();
}

class _SearchableGovernorateDropdownState
    extends State<SearchableGovernorateDropdown> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasInteracted = false;
  List<Governorate> _filteredGovernorates = [];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadGovernorates();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SearchableGovernorateDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.countryId != widget.countryId) {
      _loadGovernorates();
    }
  }

  void _loadGovernorates() {
    List<Governorate> allGovernorates = LocationService.getAllGovernorates();

    // Filter by country if specified
    if (widget.countryId != null) {
      allGovernorates =
          allGovernorates
              .where((g) => g.countryId == widget.countryId)
              .toList();
    }

    _filteredGovernorates = allGovernorates;
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;

      if (_isSearching) {
        // When searching, show ALL governorates that match the search term
        // regardless of country filter
        List<Governorate> allGovernorates =
            LocationService.getAllGovernorates();

        _filteredGovernorates =
            allGovernorates.where((governorate) {
              final isRTL =
                  Localizations.localeOf(context).languageCode == 'ar';
              final localizedName =
                  isRTL ? governorate.arName : governorate.enName;
              return localizedName.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
            }).toList();
      } else {
        _loadGovernorates();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
      _loadGovernorates();
    });
  }

  String _getLocalizedGovernorateName(Governorate governorate) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    return isRTL ? governorate.arName : governorate.enName;
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.isRequired ? '${widget.label} *' : widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 12),

        // Dropdown with search
        GestureDetector(
          onTap: () => _showGovernorateSelectionModal(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.value != null
                        ? _getLocalizedGovernorateName(widget.value!)
                        : '${AppLocalizations.of(context)!.selectGovernorate}...',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          widget.value != null
                              ? Colors.grey.shade800
                              : Colors.grey.shade500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Validation error
        if (widget.validator != null &&
            (_hasInteracted || widget.shouldShowErrors))
          Builder(
            builder: (context) {
              final error = widget.validator!(widget.value);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            error,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade700,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  void _showGovernorateSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => _GovernorateSelectionModal(
            selectedGovernorate: widget.value,
            onGovernorateSelected: (governorate) {
              setState(() {
                _hasInteracted = true;
              });
              widget.onChanged(governorate);
              Navigator.pop(context);
            },
            allGovernorates: _filteredGovernorates,
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            getLocalizedGovernorateName: _getLocalizedGovernorateName,
            isSearching: _isSearching,
            searchQuery: _searchQuery,
            onClearSearch: _clearSearch,
          ),
    );
  }
}

class _GovernorateSelectionModal extends StatefulWidget {
  final Governorate? selectedGovernorate;
  final void Function(Governorate?) onGovernorateSelected;
  final List<Governorate> allGovernorates;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;
  final String Function(Governorate) getLocalizedGovernorateName;
  final bool isSearching;
  final String searchQuery;
  final VoidCallback onClearSearch;

  const _GovernorateSelectionModal({
    required this.selectedGovernorate,
    required this.onGovernorateSelected,
    required this.allGovernorates,
    required this.searchController,
    required this.onSearchChanged,
    required this.getLocalizedGovernorateName,
    required this.isSearching,
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  State<_GovernorateSelectionModal> createState() =>
      _GovernorateSelectionModalState();
}

class _GovernorateSelectionModalState
    extends State<_GovernorateSelectionModal> {
  List<Governorate> _filteredGovernorates = [];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredGovernorates = widget.allGovernorates;
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = widget.searchController.text;
      _isSearching = _searchQuery.isNotEmpty;

      if (_isSearching) {
        // When searching, show ALL governorates that match the search term
        List<Governorate> allGovernorates =
            LocationService.getAllGovernorates();

        _filteredGovernorates =
            allGovernorates.where((governorate) {
              final isRTL =
                  Localizations.localeOf(context).languageCode == 'ar';
              final localizedName =
                  isRTL ? governorate.arName : governorate.enName;
              return localizedName.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
            }).toList();
      } else {
        _filteredGovernorates = widget.allGovernorates;
      }
    });
  }

  void _clearSearch() {
    widget.searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
      _filteredGovernorates = widget.allGovernorates;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.8,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            AppLocalizations.of(context)!.selectGovernorate,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 20),

          // Search field
          TextField(
            controller: widget.searchController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.startTypingToSearch,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
                size: 20,
              ),
              suffixIcon:
                  _isSearching
                      ? IconButton(
                        onPressed: _clearSearch,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            onChanged: (value) => _onSearchChanged(),
          ),
          const SizedBox(height: 20),

          // Governorates list
          Expanded(child: _buildGovernoratesList()),
        ],
      ),
    );
  }

  Widget _buildGovernoratesList() {
    if (_filteredGovernorates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noGovernoratesFound,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.tryDifferentSearchTerm,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredGovernorates.length,
      itemBuilder: (context, index) {
        final governorate = _filteredGovernorates[index];
        final isSelected = widget.selectedGovernorate?.id == governorate.id;

        return _buildGovernorateTile(governorate, isSelected);
      },
    );
  }

  Widget _buildGovernorateTile(Governorate governorate, bool isSelected) {
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue.shade200 : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: () => widget.onGovernorateSelected(governorate),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              governorate.enName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
            ),
          ),
        ),
        title: Text(
          widget.getLocalizedGovernorateName(governorate),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.blue.shade800 : Colors.grey.shade800,
          ),
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        subtitle: Text(
          governorate.enName,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: Colors.blue.shade600,
                  size: 20,
                )
                : null,
      ),
    );
  }
}
