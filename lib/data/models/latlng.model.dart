// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:flutter_template/common/extensions/double_extension.dart';

part 'latlng.model.g.dart';

@JsonSerializable(
  createToJson: true,
  fieldRename: FieldRename.snake,
)
class LatLngModel {
  final double lat;
  final double lng;

  //MapBox platform-specific properties
  @JsonKey(includeToJson: false, includeFromJson: false)
  late Position position = Position(lng, lat);

  @JsonKey(includeToJson: false, includeFromJson: false)
  late Point point = Point(coordinates: position);

  LatLngModel(double lat, double lng)
      : lat = (lat < -90.0 ? -90.0 : (90.0 < lat ? 90.0 : lat))
            .roundToDecimalPlace(5),
        lng = (lng >= -180 && lng < 180 ? lng : ((lng + 180.0) % 360.0 - 180.0))
            .roundToDecimalPlace(5);

  @override
  String toString() => 'LatLngModel(lat: $lat, lng: $lng)';

  factory LatLngModel.fromJson(Map<String, dynamic> json) =>
      _$LatLngModelFromJson(json);

  Map<String, dynamic> toJson() => _$LatLngModelToJson(this);

  List<double> get toLngLatList => [lng, lat];

  @override
  bool operator ==(covariant LatLngModel other) {
    if (identical(this, other)) return true;

    return other.lat == lat && other.lng == lng;
  }

  bool isNearlyEqual({required LatLngModel to, required int decimalPoint}) {
    return lat.roundToDecimalPlace(decimalPoint) ==
            to.lat.roundToDecimalPlace(decimalPoint) &&
        lng.roundToDecimalPlace(decimalPoint) ==
            to.lng.roundToDecimalPlace(decimalPoint);
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}
