// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_template/data/models/marker.model.dart';

part 'geocode_response.dto.g.dart';

@JsonSerializable(
  createToJson: false,
  fieldRename: FieldRename.snake,
)
class ListGeocodeResponseDTO {
  final List<GeocodeResponseDTO> features;
  ListGeocodeResponseDTO({
    required this.features,
  });

  factory ListGeocodeResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$ListGeocodeResponseDTOFromJson(json);

  List<MarkerModel> toMarkerModel() {
    return features.map((dto) => dto.toMarkerModel()).toList();
  }
}

@JsonSerializable(
  createToJson: false,
  fieldRename: FieldRename.snake,
)
class GeocodeResponseDTO {
  final GeometryResponseDTO geometry;
  final PropertiesResponseDTO properties;
  GeocodeResponseDTO({
    required this.geometry,
    required this.properties,
  });

  factory GeocodeResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$GeocodeResponseDTOFromJson(json);

  MarkerModel toMarkerModel() {
    return MarkerModel.parse(
      name: properties.name,
      fullAddress: properties.fullAddress,
      lat: geometry.coordinates[1],
      lng: geometry.coordinates[0],
    );
  }
}

@JsonSerializable(
  createToJson: false,
  fieldRename: FieldRename.snake,
)
class GeometryResponseDTO {
  final List<double> coordinates;

  GeometryResponseDTO({required this.coordinates});

  factory GeometryResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$GeometryResponseDTOFromJson(json);
}

@JsonSerializable(
  createToJson: false,
  fieldRename: FieldRename.snake,
)
class PropertiesResponseDTO {
  final String name;

  @JsonKey(name: 'full_address')
  final String? fullAddress;

  @JsonKey(name: 'mapbox_id')
  final String id;

  PropertiesResponseDTO(
      {required this.name, this.fullAddress, required this.id,});

  factory PropertiesResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$PropertiesResponseDTOFromJson(json);
}
