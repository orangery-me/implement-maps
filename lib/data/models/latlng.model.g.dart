// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latlng.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLngModel _$LatLngModelFromJson(Map<String, dynamic> json) => LatLngModel(
      (json['lat'] as num).toDouble(),
      (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngModelToJson(LatLngModel instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
