// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimize_route_response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptimizeRouteResponseDTO _$OptimizeRouteResponseDTOFromJson(
        Map<String, dynamic> json) =>
    OptimizeRouteResponseDTO(
      routes: (json['routes'] as List<dynamic>)
          .map((e) => RouteDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

RouteDTO _$RouteDTOFromJson(Map<String, dynamic> json) => RouteDTO(
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => WaypointDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      overviewPolyline: json['overview_polyline'] as String,
    );

WaypointDTO _$WaypointDTOFromJson(Map<String, dynamic> json) => WaypointDTO(
      distance: json['distance'] as num,
      name: json['name'] as String,
      location: (json['location'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      waypointIndex: (json['waypoint_index'] as num).toInt(),
    );
