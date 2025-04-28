// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocode_response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListGeocodeResponseDTO _$ListGeocodeResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ListGeocodeResponseDTO(
      features: (json['features'] as List<dynamic>)
          .map((e) => GeocodeResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

GeocodeResponseDTO _$GeocodeResponseDTOFromJson(Map<String, dynamic> json) =>
    GeocodeResponseDTO(
      geometry: GeometryResponseDTO.fromJson(
          json['geometry'] as Map<String, dynamic>),
      properties: PropertiesResponseDTO.fromJson(
          json['properties'] as Map<String, dynamic>),
    );

GeometryResponseDTO _$GeometryResponseDTOFromJson(Map<String, dynamic> json) =>
    GeometryResponseDTO(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

PropertiesResponseDTO _$PropertiesResponseDTOFromJson(
        Map<String, dynamic> json) =>
    PropertiesResponseDTO(
      name: json['name'] as String,
      fullAddress: json['full_address'] as String?,
      id: json['mapbox_id'] as String,
    );
