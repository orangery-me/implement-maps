import 'package:flutter_template/common/extensions/double_extension.dart';
import 'package:flutter_template/data/models/latlng.model.dart';

import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_template/data/models/marker.model.dart';

part 'optimize_route_response.dto.g.dart';

@JsonSerializable(createToJson: false)
class OptimizeRouteResponseDTO {
  final List<RouteDTO> routes;
  OptimizeRouteResponseDTO({
    required this.routes,
  });

  factory OptimizeRouteResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$OptimizeRouteResponseDTOFromJson(json);

  @override
  String toString() => 'OptimizeRouteResponseDTO(routes: $routes)';
}

@JsonSerializable(createToJson: false)
class RouteDTO {
  final List<WaypointDTO> waypoints;

  @JsonKey(name: 'overview_polyline')
  final String overviewPolyline;
  RouteDTO({
    required this.waypoints,
    required this.overviewPolyline,
  });

  factory RouteDTO.fromJson(Map<String, dynamic> json) =>
      _$RouteDTOFromJson(json);

  @override
  String toString() =>
      'RouteDTO(waypoints: $waypoints, overview_polyline: $overviewPolyline)';
}

@JsonSerializable(createToJson: false)
class WaypointDTO {
  final num distance;
  final String name;
  final List<double> location;
  @JsonKey(name: 'waypoint_index')
  final int waypointIndex;

  WaypointDTO({
    required this.distance,
    required this.name,
    required List<double> location,
    required this.waypointIndex,
  }) : location = location.map((l) => l.roundToDecimalPlace(5)).toList();

  factory WaypointDTO.fromJson(Map<String, dynamic> json) =>
      _$WaypointDTOFromJson(json);

  MarkerModel toModel() =>
      MarkerModel.parse(name: name, lat: location[1], lng: location[0]);

  LatLngModel toLatLng() => LatLngModel(location[1], location[0]);

  @override
  String toString() {
    return 'WaypointDTO(distance: $distance, name: $name, location: $location, waypoint_index: $waypointIndex)';
  }
}
