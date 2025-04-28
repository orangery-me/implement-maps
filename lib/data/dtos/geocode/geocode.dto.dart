// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'geocode.dto.g.dart';

@JsonSerializable(createFactory: false)
class GeocodeDTO {
  final GeocodeParamDTO params;

  GeocodeDTO({required String address, required String key})
      : params = GeocodeParamDTO(key: key, address: address);
  Map<String, dynamic> toJson() => _$GeocodeDTOToJson(this);

  @override
  String toString() => 'GeocodeDTO(params: $params)';
}

@JsonSerializable(createFactory: false)
class GeocodeParamDTO {
  final String key;
  final String address;

  GeocodeParamDTO({required this.key, required this.address});

  Map<String, dynamic> toJson() => _$GeocodeParamDTOToJson(this);

  @override
  String toString() => 'GeocodeParamDTO(key: $key, address: $address)';
}
