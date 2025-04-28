import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_template/data/models/latlng.model.dart';

part 'optimize_route.dto.g.dart';

@JsonSerializable(createFactory: false)
class OptimizeRouteDTO {
  final OptimizedRouteParamDTO params;
  final bool optimize;

  OptimizeRouteDTO({required this.params, required this.optimize});

  OptimizeRouteDTO.parse({
    required LatLngModel origin,
    required LatLngModel destination,
    required List<LatLngModel> waypoints,
    required String key,
    this.optimize = true,
  }) : params = OptimizedRouteParamDTO(
          key: key,
          origin: origin,
          destination: destination,
          waypoints: waypoints,
        );

  Map<String, dynamic> toJson() => _$OptimizeRouteDTOToJson(this);
}

class OptimizedRouteParamDTO {
  final String key;

  final LatLngModel origin;
  final LatLngModel destination;

  final List<LatLngModel> waypoints;

  OptimizedRouteParamDTO({
    required this.key,
    required this.origin,
    required this.destination,
    required this.waypoints,
  });

  // Map<String, dynamic> toJson() => _$OptimizedRouteParamDTOToJson(this);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'waypoints': waypoints.map((x) => x.toJson()).toList(),
    };
  }
}
