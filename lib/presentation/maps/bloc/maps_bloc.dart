import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/common/constants/constants.dart';
import 'package:flutter_template/common/helpers/polyline_decoder.helper.dart';
import 'package:flutter_template/data/models/latlng.model.dart';
import 'package:flutter_template/data/models/marker.model.dart';
import 'package:flutter_template/data/models/route_model.dart';

import 'package:flutter_template/data/repositories/place.repository.dart';

import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

part 'maps_state.dart';
part 'maps_event.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  MapsBloc({required PlaceRepository placeRepository})
      : _placeRepository = placeRepository,
        super(
          MapsState.initial(),
        ) {
    on<MapsPermissionRequest>(_onRequestPermission);
    on<MapPlacesGet>(_onReceivedPlaces);
    add(MapsPermissionRequest());

    on<MapUpdateLocation>(_onUpdateLocation);
  }

  final PlaceRepository _placeRepository;

  Future<LatLngModel> _getMyLocation(Emitter<MapsState> emiiter) async {
    try {
      final geolocator.Position userPosition =
          await geolocator.Geolocator.getCurrentPosition();

      return LatLngModel(userPosition.latitude, userPosition.longitude);
    } catch (err) {
      log('Error in get user location');
      emiiter(
        state.copyWith(
          error: 'Error in get user location',
        ),
      );
      return defaultLocation;
    }
  }

  Future<void> _onRequestPermission(
    MapsPermissionRequest event,
    Emitter<MapsState> emiiter,
  ) async {
    final bool isGranted = await Permission.location.isGranted;

    if (!isGranted) {
      await Permission.location.request();
    }

    emiiter(
      MapsState.getLocationSuccess(
        myLocation: await _getMyLocation(emiiter),
      ),
    );

    log('Current location: ${state.myLocation.toString()}');
  }

  Future<void> _onReceivedPlaces(
    MapPlacesGet event,
    Emitter<MapsState> emit,
  ) async {
    //Geocoding places
    final List<MarkerModel> markers = event.places;

    final List<RouteModel> rawRoutes =
        await _placeRepository.optimizeRoute(markers: markers);

    final pointFeatureCollection =
        FeatureCollection<GeometryObject>(features: []);

    final featureCollection = FeatureCollection<GeometryObject>(features: []);

    var pointIndex = 0;

    for (var route in rawRoutes) {
      final randomColor = Color((math.Random().nextInt(0xFFFFFF) + 0xFF000000));

      final lineFeature = Feature(
        id: 'route',
        geometry: LineString(
          coordinates: route.polylinePoints.map((e) => e.position).toList(),
        ),
        properties: {
          'route-color':
              'rgb(${randomColor.red}, ${randomColor.green}, ${randomColor.blue})',
        },
      );

      for (int i = 0; i < route.waypoints.length; i++) {
        pointFeatureCollection.features.add(
          Feature(
            id: pointIndex + i,
            geometry: route.waypoints[i].point,
            properties: {
              'index': pointIndex + i,
              'color':
                  'rgb(${randomColor.red}, ${randomColor.green}, ${randomColor.blue})',
              // 'name': route.waypoints[i].name,
              'role': (i == 0)
                  ? 'origin'
                  : (i == route.waypoints.length - 1)
                      ? 'destination'
                      : 'waypoint',
            },
          ),
        );
      }
      featureCollection.features.add(lineFeature);
      pointIndex += route.waypoints.length;

      
    }

    final boundingCoordinates = PolylineDecoderHelper.boundingBoxSWNE(
      markers.map((e) => e.latLng).toList(),
    );

    final bounds = CoordinateBounds(
      southwest: boundingCoordinates[1].point,
      northeast: boundingCoordinates[0].point,
      infiniteBounds: true,
    );

    emit(
      MapsState.optimizeSuccess(
        myLocation: state.myLocation ?? defaultLocation,
        waypointsGeoJSON: jsonEncode(pointFeatureCollection.toJson()),
        optimizedRoute: jsonEncode(featureCollection.toJson()),
        bounds: bounds,
      ),
    );
  }

  Future<void> _onUpdateLocation(
    MapUpdateLocation event,
    Emitter<MapsState> emitter,
  ) async {
    emitter(state.copyWith(status: MapsStatus.loading));
    final bool isGranted = await Permission.location.isGranted;

    if (!isGranted) {
      await Permission.location.request();
    }

    emitter(
      MapsState.getLocationSuccess(
        myLocation: await _getMyLocation(emitter),
        waypointsGeoJSON: state.waypointsGeoJSON,
        optimizedRouteGeoJSON: state.optimizedRouteGeoJSON,
        bounds: state.bounds,
      ),
    );
  }
}
