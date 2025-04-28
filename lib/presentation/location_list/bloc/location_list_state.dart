part of 'location_list_bloc.dart';

enum LocationListStatus {
  initial,
  loading,
  loaded,
  error,
}

class LocationListState extends Equatable {
  const LocationListState({
    required this.status,
  });

  const LocationListState.initial()
      : this(        
          status: LocationListStatus.initial,
        );

  final LocationListStatus status;

  LocationListState copyWith({
    LocationListStatus? status,
  }) {
    return LocationListState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        status,
      ];
}
