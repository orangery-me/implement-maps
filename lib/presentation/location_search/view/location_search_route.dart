import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/repositories/place.repository.dart';
import 'package:flutter_template/di/di.dart';
import 'package:flutter_template/presentation/location_search/location_search.dart';

class LocationSearchRoute extends StatelessWidget {
  const LocationSearchRoute({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (ctx) {
        return BlocProvider(
          create: (_) => LocationSearchBloc(
            placeRepository: getIt.get<PlaceRepository>(),
          ),
          child: const LocationSearchView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const LocationSearchView();
  }
}
