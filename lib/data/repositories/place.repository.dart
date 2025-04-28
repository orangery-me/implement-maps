import 'package:flutter_template/common/helpers/polyline_decoder.helper.dart';
import 'package:flutter_template/data/datasources/user/remote/place.datasource.dart';
import 'package:flutter_template/data/dtos/geocode/geocode.dto.dart';
import 'package:flutter_template/data/dtos/optimize/optimize_route.dto.dart';

import 'package:flutter_template/data/models/latlng.model.dart';
import 'package:flutter_template/data/models/marker.model.dart';
import 'package:flutter_template/data/models/route_model.dart';
import 'package:flutter_template/flavors.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PlaceRepository {
  final PlaceDataSource _dataSource;

  PlaceRepository({required PlaceDataSource placeDataSource})
      : _dataSource = placeDataSource;

  Future<List<MarkerModel>> getSuggestPlaces(String input) {
    return _dataSource.getSuggestPlaces(input);
  }

  Future<LatLngModel> geocodePlace(String address) {
    final GeocodeDTO dataObject =
        GeocodeDTO(address: address, key: AppFlavor.mapboxPublicKey);

    return _dataSource.geocodePlace(dataObject);
  }

  Future<List<RouteModel>> optimizeRoute({
    required List<MarkerModel> markers,
  }) async {
    final data = OptimizeRouteDTO.parse(
      origin: markers.first.latLng,
      destination: markers.last.latLng,
      waypoints: markers
          .sublist(1, markers.length - 1)
          .map((marker) => marker.latLng)
          .toList(),
      key: AppFlavor.mapboxPublicKey,
    );

    return PolylineDecoderHelper.splitRoute(
      await _dataSource.optimizeRoute(data),
      markers,
    );
  }
}
