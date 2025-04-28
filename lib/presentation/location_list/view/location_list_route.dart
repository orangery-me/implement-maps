import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/presentation/location_list/location_list.dart';

class LocationListRoute extends StatelessWidget {
  const LocationListRoute({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (ctx) {
        return BlocProvider(
          create: (_) => LocationListBloc(),
          child: const LocationListView(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const LocationListView();
  }
}