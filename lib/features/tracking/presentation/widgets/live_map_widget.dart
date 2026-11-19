import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/location_point_entity.dart';

class LiveMapWidget extends StatefulWidget {
  final LocationPointEntity? currentLocation;
  final List<LocationPointEntity> routePoints;
  final bool isTracking;

  const LiveMapWidget({
    super.key,
    required this.currentLocation,
    required this.routePoints,
    required this.isTracking,
  });

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  final MapController _mapController = MapController();

  static const LatLng _defaultCenter = LatLng(30.0444, 31.2357);

  @override
  void didUpdateWidget(covariant LiveMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentLocation != null &&
        (oldWidget.currentLocation == null ||
            oldWidget.currentLocation != widget.currentLocation)) {
      _mapController.move(
        LatLng(widget.currentLocation!.latitude, widget.currentLocation!.longitude),
        _mapController.camera.zoom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLatLng = widget.currentLocation != null
        ? LatLng(widget.currentLocation!.latitude, widget.currentLocation!.longitude)
        : _defaultCenter;

    final polylineCoordinates = widget.routePoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: currentLatLng,
            initialZoom: 16.5,
            minZoom: 4.0,
            maxZoom: 19.0,
          ),
          children: [
            TileLayer(
              urlTemplate: AppConstants.darkMapUrlTemplate,
              subdomains: AppConstants.mapSubdomains,
              userAgentPackageName: 'com.yousef.runpulse_app',
            ),

            PolylineLayer(
              polylines: [
                Polyline(
                  points: polylineCoordinates,
                  strokeWidth: 9.0,
                  color: AppTheme.primaryVolt.withOpacity(0.35),
                  strokeJoin: StrokeJoin.round,
                  strokeCap: StrokeCap.round,
                ),
                Polyline(
                  points: polylineCoordinates,
                  strokeWidth: 4.5,
                  color: AppTheme.primaryVolt,
                  strokeJoin: StrokeJoin.round,
                  strokeCap: StrokeCap.round,
                ),
              ],
            ),

            if (widget.currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentLatLng,
                    width: 36,
                    height: 36,
                    child: _buildUserLocationMarker(),
                  ),
                ],
              ),
          ],
        ),

        Positioned(
          right: 20,
          top: 50,
          child: FloatingActionButton.small(
            backgroundColor: AppTheme.surface.withOpacity(0.85),
            foregroundColor: AppTheme.primaryVolt,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppTheme.primaryVolt.withOpacity(0.3)),
            ),
            onPressed: () {
              if (widget.currentLocation != null) {
                _mapController.move(
                  LatLng(widget.currentLocation!.latitude,
                      widget.currentLocation!.longitude),
                  17.0,
                );
              }
            },
            child: const Icon(Icons.my_location, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildUserLocationMarker() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.secondaryCyan.withOpacity(0.25),
      ),
      child: Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.secondaryCyan,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondaryCyan.withOpacity(0.7),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}