// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'maps_bloc.dart';

abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object?> get props => [];
}

class MapsPermissionRequest extends MapsEvent {}

class MapsMarkersGet extends MapsEvent {
  const MapsMarkersGet({
    required this.markers,
    required this.descriptions,
    this.optimizeWaypoints = false,
  });

  final Set<Marker> markers;
  final Set<String> descriptions;
  final bool? optimizeWaypoints;

  @override
  List<Object?> get props => [
        markers,
        descriptions,
        optimizeWaypoints,
      ];
}

///Receive [Set<PlaceModel>] for optimizing route
class MapPlacesGet extends MapsEvent {
  final List<MarkerModel> places;
  final bool? optimizeWaypoints;

  const MapPlacesGet({
    required this.places,
    this.optimizeWaypoints = false,
  });
  @override
  List<Object?> get props => [
        places,
        optimizeWaypoints,
      ];
}

class MapUpdateLocation extends MapsEvent {
  const MapUpdateLocation();
}
