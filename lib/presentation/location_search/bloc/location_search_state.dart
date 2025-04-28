part of 'location_search_bloc.dart';

class LocationSearchState extends Equatable {
  final List<MarkerModel> places;

  const LocationSearchState({this.places = const []});

  @override
  List<Object> get props => [places];

  LocationSearchState copyWith({
    List<MarkerModel>? places,
  }) {
    return LocationSearchState(
      places: places ?? this.places,
    );
  }
}
