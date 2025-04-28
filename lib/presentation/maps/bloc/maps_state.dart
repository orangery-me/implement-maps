part of 'maps_bloc.dart';

enum MapsStatus {
  loading,
  initial,
  optimizeSuccess,
  getCurrentPositionSuccess,
  fail
}

class MapsState extends Equatable {
  const MapsState({
    required this.status,
    this.myLocation,
    this.waypointsGeoJSON,
    this.error,
    this.waypointOrder,
    this.optimizeWaypoints,
    this.bounds,
    this.subRoutes,
    this.optimizedRouteGeoJSON,
  });

  final MapsStatus status;
  final LatLngModel? myLocation;
  final String? waypointsGeoJSON;
  final List<int>? waypointOrder;
  final bool? optimizeWaypoints;
  final String? error;
  final String? optimizedRouteGeoJSON;

  final CoordinateBounds? bounds;
  final List<RouteModel>? subRoutes;

  MapsState.initial()
      : this(
          status: MapsStatus.initial,
          myLocation: LatLngModel(18.635370, 105.737148),
        );

  const MapsState.getLocationSuccess({
    required LatLngModel myLocation,
    String? waypointsGeoJSON,
    String? optimizedRouteGeoJSON,
    CoordinateBounds? bounds,
  }) : this(
          status: MapsStatus.getCurrentPositionSuccess,
          myLocation: myLocation,
          waypointsGeoJSON: waypointsGeoJSON,
          optimizedRouteGeoJSON: optimizedRouteGeoJSON,
          bounds: bounds,
        );

  const MapsState.optimizeSuccess({
    required LatLngModel myLocation,
    required String waypointsGeoJSON,
    required String optimizedRoute,
    required CoordinateBounds bounds,
  }) : this(
          status: MapsStatus.optimizeSuccess,
          myLocation: myLocation,
          waypointsGeoJSON: waypointsGeoJSON,
          optimizedRouteGeoJSON: optimizedRoute,
          bounds: bounds,
        );

  MapsState copyWith({
    MapsStatus? status,
    LatLngModel? myLocation,
    String? waypointsGeoJSON,
    String? error,
    List<int>? waypointOrder,
    bool? optimizeWaypoints,
    List<LatLngModel>? polylineCoordinates,
    CoordinateBounds? bounds,
    RouteModel? overviewRoute,
    List<RouteModel>? subRoutes,
    String? optimizedRouteGeoJSON,
  }) {
    return MapsState(
      status: status ?? this.status,
      myLocation: myLocation ?? this.myLocation,
      waypointsGeoJSON: waypointsGeoJSON ?? this.waypointsGeoJSON,
      error: error ?? this.error,
      waypointOrder: waypointOrder ?? this.waypointOrder,
      optimizeWaypoints: optimizeWaypoints ?? this.optimizeWaypoints,
      bounds: bounds ?? this.bounds,
      subRoutes: subRoutes ?? this.subRoutes,
      optimizedRouteGeoJSON: optimizedRouteGeoJSON ?? this.optimizedRouteGeoJSON,
    );
  }

  @override
  List<Object?> get props => [
        status,
        myLocation,
        waypointsGeoJSON,
        error,
        waypointOrder,
        optimizeWaypoints,
        bounds,
        subRoutes,
        optimizedRouteGeoJSON,
      ];
}
