import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:client_app/l10n/app_localizations.dart';

import '../../data/models/hub_model.dart' as hub_models;
import '../../data/models/station_model.dart';
import 'location_card.dart';

class MapCarouselSlider extends StatefulWidget {
  final List<Station> stations;
  final List<hub_models.HubDetail> hubs;
  final int currentIndex;
  final Function(int index, dynamic item) onItemSelected;

  const MapCarouselSlider({
    super.key,
    required this.stations,
    required this.hubs,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  State<MapCarouselSlider> createState() => _MapCarouselSliderState();
}

class _MapCarouselSliderState extends State<MapCarouselSlider> {
  late CarouselSliderController _carouselController;
  late List<dynamic> _allItems;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    _allItems = [...widget.stations, ...widget.hubs];
  }

  @override
  void didUpdateWidget(MapCarouselSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _allItems = [...widget.stations, ...widget.hubs];
  }

  @override
  Widget build(BuildContext context) {
    if (_allItems.isEmpty) {
      return Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
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
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header with title and indicators
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  )!.locationsCount(_allItems.length),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children:
                      _allItems.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                widget.currentIndex == entry.key
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          // Carousel
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: _allItems.length,
                itemBuilder: (context, index, realIndex) {
                  final item = _allItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LocationCard(
                      item: item,
                      onTap: () => widget.onItemSelected(index, item),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 0.8,
                  initialPage: widget.currentIndex,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  onPageChanged: (index, reason) {
                    if (reason == CarouselPageChangedReason.manual) {
                      widget.onItemSelected(index, _allItems[index]);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
