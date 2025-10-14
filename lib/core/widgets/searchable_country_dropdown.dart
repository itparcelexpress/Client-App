import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/location_models.dart';
import '../services/country_localization_service.dart';
import '../../l10n/app_localizations.dart';

/// A searchable dropdown widget for country selection with localization support
class SearchableCountryDropdown extends StatefulWidget {
  final Country? value;
  final void Function(Country?) onChanged;
  final String label;
  final IconData icon;
  final String? Function(Country?)? validator;
  final bool isRequired;
  final bool showPopularCountries;
  final bool enableSearch;
  final bool shouldShowErrors;

  const SearchableCountryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.icon,
    this.validator,
    this.isRequired = true,
    this.showPopularCountries = true,
    this.enableSearch = true,
    this.shouldShowErrors = false,
  });

  @override
  State<SearchableCountryDropdown> createState() =>
      _SearchableCountryDropdownState();
}

class _SearchableCountryDropdownState extends State<SearchableCountryDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = [];
  List<Country> _popularCountries = [];
  bool _isSearching = false;
  String _searchQuery = '';
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCountries() {
    final allCountries = CountryLocalizationService.getAllCountries();
    _filteredCountries = allCountries;

    if (widget.showPopularCountries) {
      _popularCountries = CountryLocalizationService.getPopularCountries();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;

      if (_isSearching) {
        _filteredCountries = CountryLocalizationService.searchCountries(
          _searchQuery,
          Localizations.localeOf(context),
        );
      } else {
        _filteredCountries = CountryLocalizationService.getAllCountries();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _isSearching = false;
      _filteredCountries = CountryLocalizationService.getAllCountries();
    });
  }

  String _getLocalizedCountryName(Country country) {
    return CountryLocalizationService.getLocalizedCountryName(
      country.id,
      Localizations.localeOf(context),
    );
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
          onTap: () => _showCountrySelectionModal(context),
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
                        ? _getLocalizedCountryName(widget.value!)
                        : '${AppLocalizations.of(context)!.selectCountry}...',
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

  void _showCountrySelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => _CountrySelectionModal(
            selectedCountry: widget.value,
            onCountrySelected: (country) {
              setState(() {
                _hasInteracted = true;
              });
              widget.onChanged(country);
              Navigator.pop(context);
            },
            popularCountries: _popularCountries,
            allCountries: _filteredCountries,
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            getLocalizedCountryName: _getLocalizedCountryName,
            isSearching: _isSearching,
            searchQuery: _searchQuery,
            onClearSearch: _clearSearch,
          ),
    );
  }
}

class _CountrySelectionModal extends StatefulWidget {
  final Country? selectedCountry;
  final void Function(Country?) onCountrySelected;
  final List<Country> popularCountries;
  final List<Country> allCountries;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;
  final String Function(Country) getLocalizedCountryName;
  final bool isSearching;
  final String searchQuery;
  final VoidCallback onClearSearch;

  const _CountrySelectionModal({
    required this.selectedCountry,
    required this.onCountrySelected,
    required this.popularCountries,
    required this.allCountries,
    required this.searchController,
    required this.onSearchChanged,
    required this.getLocalizedCountryName,
    required this.isSearching,
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  State<_CountrySelectionModal> createState() => _CountrySelectionModalState();
}

class _CountrySelectionModalState extends State<_CountrySelectionModal> {
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
            AppLocalizations.of(context)!.selectCountry,
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
                  widget.isSearching
                      ? IconButton(
                        onPressed: widget.onClearSearch,
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
            onChanged: (value) => widget.onSearchChanged(),
          ),
          const SizedBox(height: 20),

          // Countries list
          Expanded(child: _buildCountriesList()),
        ],
      ),
    );
  }

  Widget _buildCountriesList() {
    if (widget.isSearching) {
      return _buildSearchResults();
    } else {
      return _buildPopularAndAllCountries();
    }
  }

  Widget _buildSearchResults() {
    if (widget.allCountries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noCountriesFound,
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
      itemCount: widget.allCountries.length,
      itemBuilder: (context, index) {
        final country = widget.allCountries[index];
        final isSelected = widget.selectedCountry?.id == country.id;

        return _buildCountryTile(country, isSelected);
      },
    );
  }

  Widget _buildPopularAndAllCountries() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular countries section
          if (widget.popularCountries.isNotEmpty) ...[
            Text(
              AppLocalizations.of(context)!.popularCountries,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1a1a1a),
              ),
            ),
            const SizedBox(height: 12),
            ...widget.popularCountries.map((country) {
              final isSelected = widget.selectedCountry?.id == country.id;
              return _buildCountryTile(country, isSelected);
            }),
            const SizedBox(height: 24),
          ],

          // All countries section
          Text(
            AppLocalizations.of(context)!.allCountries,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.allCountries.map((country) {
            final isSelected = widget.selectedCountry?.id == country.id;
            return _buildCountryTile(country, isSelected);
          }),
        ],
      ),
    );
  }

  Widget _buildCountryTile(Country country, bool isSelected) {
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
        onTap: () => widget.onCountrySelected(country),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              country.name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
            ),
          ),
        ),
        title: Text(
          widget.getLocalizedCountryName(country),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.blue.shade800 : Colors.grey.shade800,
          ),
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
        subtitle: Text(
          country.name,
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
