import 'package:flutter/material.dart';
import 'package:client_app/l10n/app_localizations.dart';

import '../../data/models/hub_model.dart' as hub_models;
import '../../data/models/station_model.dart';
import 'enhanced_location_card.dart';

class LocationsCarousel extends StatefulWidget {
  final List<Station> stations;
  final List<hub_models.HubDetail> hubs;
  final int currentIndex;
  final Function(int index, dynamic item) onItemSelected;
  final Function()? onRefresh;

  const LocationsCarousel({
    super.key,
    required this.stations,
    required this.hubs,
    required this.currentIndex,
    required this.onItemSelected,
    this.onRefresh,
  });

  @override
  State<LocationsCarousel> createState() => _LocationsCarouselState();
}

class _LocationsCarouselState extends State<LocationsCarousel> {
  late PageController _pageController;
  late List<dynamic> _allItems;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.currentIndex,
      viewportFraction: 0.85,
    );
    _allItems = [...widget.stations, ...widget.hubs];
  }

  @override
  void didUpdateWidget(LocationsCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _allItems = [...widget.stations, ...widget.hubs];

    // Animate to current index if it changed
    if (widget.currentIndex != oldWidget.currentIndex) {
      _pageController.animateToPage(
        widget.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
      '🗺️ LocationsCarousel: Building with ${_allItems.length} items (${widget.stations.length} stations, ${widget.hubs.length} hubs)',
    );

    if (_allItems.isEmpty) {
      print('🗺️ LocationsCarousel: Showing empty state');
      return _buildEmptyState();
    }

    print(
      '🗺️ LocationsCarousel: Showing carousel with ${_allItems.length} items',
    );
    return Container(
      height: 180,
      margin: const EdgeInsets.all(16),
      child: _buildCarousel(),
    );
  }

  Widget _buildCarousel() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _allItems.length,
      onPageChanged: (index) {
        widget.onItemSelected(index, _allItems[index]);
      },
      itemBuilder: (context, index) {
        final item = _allItems[index];
        final isActive = index == widget.currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(
            horizontal: isActive ? 8 : 16,
            vertical: isActive ? 0 : 8,
          ),
          child: Transform.scale(
            scale: isActive ? 1.0 : 0.9,
            child: EnhancedLocationCard(
              item: item,
              isSelected: isActive,
              onTap: () => widget.onItemSelected(index, item),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 280,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noLocationsAvailable,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.stationsAndHubsWillAppearHere,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (widget.onRefresh != null)
              ElevatedButton.icon(
                onPressed: widget.onRefresh,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.refreshData),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
