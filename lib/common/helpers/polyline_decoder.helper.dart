import 'package:flutter_template/data/dtos/optimize/optimize_route_response.dto.dart';
import 'package:flutter_template/data/models/latlng.model.dart';
import 'package:flutter_template/data/models/marker.model.dart';
import 'package:flutter_template/data/models/route_model.dart';

import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

abstract final class PolylineDecoderHelper {
  // Return northeasternmost and southwesternmost points
  static List<LatLngModel> boundingBoxSWNE(List<LatLngModel> coordinates) {
    double minLng = double.infinity;
    double maxLng = double.negativeInfinity;
    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;

    for (var coord in coordinates) {
      if (coord.lng < minLng) minLng = coord.lng;
      if (coord.lng > maxLng) maxLng = coord.lng;
      if (coord.lat < minLat) minLat = coord.lat;
      if (coord.lat > maxLat) maxLat = coord.lat;
    }

    return [LatLngModel(minLat, minLng), LatLngModel(maxLat, maxLng)];
  }

  static List<LatLngModel> decodeToLatLng(String polyline) {
    //Default float accuracy: 5
    final toReturn = decodePolyline(polyline);

    return toReturn
        .map((raw) => LatLngModel(raw[0].toDouble(), raw[1].toDouble()))
        .toList();
  }

  static List<RouteModel> splitRoute(
    List<RouteDTO> rawRoutes,
    List<MarkerModel> markers,
  ) {
    List<RouteModel> toReturn = [];

    for (var k = 0; k < rawRoutes.length; k++) {
      final r = rawRoutes[k];

      final sortedWaypoints = r.waypoints;
      final polylinePoints = decodeToLatLng(r.overviewPolyline);

      final optimizedRoute = RouteModel(
        waypoints: [],
        polylinePoints: polylinePoints,
        polyLineString: rawRoutes[k].overviewPolyline,
      );

      optimizedRoute.waypoints.addAll(
        sortedWaypoints
            .map(
              (rawWaypoint) =>
                  LatLngModel(rawWaypoint.location[1], rawWaypoint.location[0]),
            )
            .toList(),
      );

      // for (int i = 1; i < sortedWaypoints.length - 1; i++) {
      //   final lat = sortedWaypoints[i].location[1];
      //   final lng = sortedWaypoints[i].location[0];

      //   optimizedRoute.waypoints.add(
      //     markers.firstWhere(
      //       (marker) => lat == marker.latLng.lat && lng == marker.latLng.lng,
      //       orElse: () => MarkerModel.parse(name: ' ', lat: lat, lng: lng),
      //     ),
      //   );
      // }
      // optimizedRoute.waypoints.add(markers.last);

      toReturn.add(optimizedRoute);
    }

    return toReturn;
  }
}
