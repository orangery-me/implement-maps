// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_template/data/models/latlng.model.dart';
// import 'package:flutter_template/data/models/marker.model.dart';

class RouteModel {
  // final List<MarkerModel> waypoints;
  final List<LatLngModel> waypoints;

  final String? polyLineString;
  final List<LatLngModel> polylinePoints;

  RouteModel({
    required this.waypoints,
    required this.polylinePoints,
    this.polyLineString,
  });

  @override
  String toString() =>
      'NewRouteModel(waypoints: $waypoints, polyLineString: $polyLineString)';
}
