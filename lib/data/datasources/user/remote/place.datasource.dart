import 'dart:io';

import 'package:flutter_template/common/constants/endpoints.dart';
import 'package:flutter_template/common/helpers/dio_helper.dart';
import 'package:flutter_template/data/dtos/geocode/geocode.dto.dart';
import 'package:flutter_template/data/dtos/mapbox_geocode/geocode_response.dto.dart';
import 'package:flutter_template/data/dtos/optimize/optimize_route.dto.dart';
import 'package:flutter_template/data/dtos/optimize/optimize_route_response.dto.dart';
import 'package:flutter_template/data/models/latlng.model.dart';
import 'package:flutter_template/data/models/marker.model.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class PlaceDataSource {
  final DioHelper _dioHelper;

  PlaceDataSource({required DioHelper dioHelper}) : _dioHelper = dioHelper;

  Future<List<MarkerModel>> getSuggestPlaces(String input) async {
    //Get device's country code for more localized suggestions
    //Ex: "en_US" -> "en"
    final String language = Platform.localeName.split('_')[0];

    // final HttpRequestResponse response = await _dioHelper
    //     .get('${Endpoints.autocompletePlace}&input=$input&language=$country');

    final HttpRequestResponse response = await _dioHelper.get(
      '${Endpoints.mapboxGeocode}&language=$language&q=$input',
    );

    final List<MarkerModel> markers =
        ListGeocodeResponseDTO.fromJson(response.data).toMarkerModel();

    return markers;
  }

  Future<LatLngModel> geocodePlace(GeocodeDTO data) async {
    final HttpRequestResponse response =
        await _dioHelper.post(Endpoints.mapSorterGeocode, data: data.toJson());

    final out = LatLngModel.fromJson(response.data['location']);

    return out;
  }

  Future<List<RouteDTO>> optimizeRoute(OptimizeRouteDTO data) async {
    final HttpRequestResponse response = await _dioHelper
        .post(Endpoints.mapSorterOptimizeRoute, data: data.toJson());

    final out = OptimizeRouteResponseDTO.fromJson(response.data);

    return out.routes.map((e) {
      e.waypoints.sort((a, b) => a.waypointIndex.compareTo(b.waypointIndex));

      return e;
    }).toList();

    // return out.routes;
  }
}
