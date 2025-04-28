import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/models/marker.model.dart';

import 'package:flutter_template/data/repositories/place.repository.dart';

part 'location_search_event.dart';
part 'location_search_state.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  final PlaceRepository _placeRepository;

  LocationSearchBloc({required PlaceRepository placeRepository})
      : _placeRepository = placeRepository,
        super(const LocationSearchState()) {
    on<LocationSearchChanged>(_onChangedSearch);
  }

  Future<void> _onChangedSearch(
    LocationSearchChanged event,
    Emitter<LocationSearchState> emit,
  ) async {
    if (event.input.isEmpty) {
      emit(state.copyWith(places: []));
      return;
    }
    try {
      final List<MarkerModel> places =
          await _placeRepository.getSuggestPlaces(event.input);

      emit(state.copyWith(places: places));
    } catch (err) {
      log(err.toString());
      emit(state.copyWith(places: []));
    }
  }
}
