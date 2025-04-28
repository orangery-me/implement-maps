// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:flutter_template/data/models/latlng.model.dart';

class MarkerModel {
  final String name;
  final String? fullAddress;
  final LatLngModel latLng;
  late final PointAnnotationOptions _pointAnotation =
      PointAnnotationOptions(geometry: latLng.point, textField: name);

  MarkerModel({
    required this.name,
    this.fullAddress,
    required this.latLng,
  });

  MarkerModel.parse({
    required this.name,
    this.fullAddress,
    required double lat,
    required double lng,
  }) : latLng = LatLngModel(lat, lng);
  PointAnnotationOptions get getAnnotation => _pointAnotation;

  Point get point => latLng.point;

  @override
  String toString() => 'MarkerModel(name: $name, latLng: $latLng)';

  @override
  bool operator ==(covariant MarkerModel other) {
    if (identical(this, other)) return true;

    return other.latLng == latLng;
  }

  @override
  int get hashCode => name.hashCode ^ fullAddress.hashCode ^ latLng.hashCode;
}
