import 'package:flutter/material.dart';
import 'package:flutter_template/data/repositories/place.repository.dart';
import 'package:flutter_template/di/di.dart';
import 'package:flutter_template/presentation/maps/maps.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapsRoute extends StatelessWidget {
  const MapsRoute({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (ctx) {
        return BlocProvider(
          create: (_) => MapsBloc(
            placeRepository: getIt.get<PlaceRepository>(),
          ),
          child: const MapsView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const MapsView();
  }
}
