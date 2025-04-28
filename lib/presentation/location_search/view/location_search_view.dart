import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/models/marker.model.dart';

import 'package:flutter_template/presentation/location_search/location_search.dart';
import 'package:flutter_template/presentation/widgets/common_app_bar.dart';

class LocationSearchView extends StatelessWidget {
  const LocationSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationSearchBloc, LocationSearchState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: const CommonAppBar(
          title: 'Search Location',
        ),
        body: _LocationSearchForm(),
      ),
    );
  }
}

// ignore: must_be_immutable
class _LocationSearchForm extends StatelessWidget {
  _LocationSearchForm();

  Timer? _timer;

  void _onChanged(BuildContext context, String value) {
    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(
      const Duration(milliseconds: 300),
      () async => context.read<LocationSearchBloc>().add(
            LocationSearchChanged(input: value),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextFormField(
              autofocus: true,
              onChanged: (value) => _onChanged(context, value),
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Search Location',
                prefixIcon: Icon(Icons.location_on_outlined),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
        ),
        Divider(
          height: 4,
          thickness: 2,
          color: Colors.grey[200],
        ),
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: CommonRoundedButton(
        //     onPressed: () {
        //       Navigator.of(context).pop({
        //         'description': 'Current Location',
        //         'place_id': context.read<MapsBloc>().state.myLocation,
        //       });
        //     },
        //     content: 'Use Current Location',
        //     textStyle: const TextStyle(color: Colors.white),
        //     width: double.infinity,
        //     prefixIcon: const Icon(
        //       Icons.location_history_outlined,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        // Divider(
        //   height: 4,
        //   thickness: 1,
        //   color: Colors.grey[200],
        // ),
        Expanded(
          child: BlocBuilder<LocationSearchBloc, LocationSearchState>(
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.places.length,
                itemBuilder: (_, index) {
                  final MarkerModel currentPlace = state.places[index];

                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(
                      currentPlace.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: currentPlace.fullAddress != null
                        ? Text(currentPlace.fullAddress!)
                        : null,
                    onTap: () {
                      log(currentPlace.toString());
                      Navigator.of(context).pop(currentPlace);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
