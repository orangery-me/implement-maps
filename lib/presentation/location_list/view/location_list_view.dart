import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/common/utils/toast_util.dart';
import 'package:flutter_template/data/models/marker.model.dart';
import 'package:flutter_template/presentation/location_list/location_list.dart';
import 'package:flutter_template/presentation/widgets/common_app_bar.dart';
import 'package:flutter_template/presentation/widgets/common_text_form_field.dart';
import 'package:flutter_template/router/app_router.dart';

class LocationListView extends StatelessWidget {
  const LocationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationListBloc, LocationListState>(
      listener: (context, state) {
        if (state.status == LocationListStatus.error) {
          // Handle Error
          Navigator.of(context).pop();
        }
      },
      child: const _LocationListForm(),
    );
  }
}

class _LocationListForm extends StatefulWidget {
  const _LocationListForm();

  @override
  State<_LocationListForm> createState() => _LocationListFormState();
}

class _LocationListFormState extends State<_LocationListForm> {
  List<TextEditingController> controllers = [];
  List<bool> visibilityList = [];
  List<MarkerModel> selectedPlaces = [];

  @override
  void initState() {
    super.initState();
    // Initialize with one controller and visibility set to true
    controllers.add(TextEditingController());
    visibilityList.add(true);
  }

  Future<void> _onTextFieldTapped(int index) async {
    final result = await Navigator.pushNamed(context, AppRouter.locationSearch);

    if (result != null && result is MarkerModel) {
      setState(() {
        if (index == controllers.length - 1) {
          log('markers: ${selectedPlaces.toString()} - result: ${result.latLng}');
          // Check if the last location is the same as all the previous marker ones
          if (selectedPlaces.isNotEmpty &&
              selectedPlaces.any(
                (element) => element == result,
              )) {
            ToastUtil.showError(
              context,
              text: 'Please select a different location from the previous ones',
            );
            return;
          }

          controllers[index].text = result.name;
          controllers.add(TextEditingController());
          visibilityList.add(true);
          selectedPlaces.add(
            result
            // Marker(
            //   markerId: MarkerId(result.mapbox_id String),
            //   //icon with number
            //   icon: BitmapDescriptor.defaultMarkerWithHue(
            //     BitmapDescriptor.hueAzure,
            //   ),
            // ),
            ,
          );
        }
        // Handle when edit
        else {
          if (selectedPlaces.isNotEmpty &&
              selectedPlaces.any((element) => element == result)) {
            ToastUtil.showError(
              context,
              text: 'Please select a different location from the previous ones',
            );
            return;
          }
          controllers[index].text = result.name;
          log('old marker: ${selectedPlaces.toString()}');
          List<MarkerModel> tempMarkers = [];
          tempMarkers.addAll(selectedPlaces.toList());
          //remove where by index
          tempMarkers.removeAt(index);
          log('new old marker: ${tempMarkers.toString()}');

          tempMarkers.insert(
            index,
            result,
          );
          log('new old marker insert: ${tempMarkers.toString()}');

          selectedPlaces = tempMarkers;
        }
        // Hide the next text field if the current one is empty
        visibilityList[index + 1] = controllers[index].text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Location List'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //at least 2 markers to draw a route
          if (selectedPlaces.length < 2) {
            ToastUtil.showError(
              context,
              text: 'Please add at least 2 locations',
            );
            return;
          }
          // context.read<MapsBloc>().add(MapsMarkersGet(markers: markers));
          //skip empty text field
          Navigator.of(context).pop(selectedPlaces);
        },
        child: const Icon(Icons.directions_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: controllers.length,
          itemBuilder: (context, index) {
            return Visibility(
              visible: visibilityList[index],
              child: CommonTextFormField(
                textController: controllers[index],
                onTap: () => _onTextFieldTapped(index),
                readOnly: true,
                labelText: index == 0
                    ? 'Start'
                    : index == controllers.length - 2
                        ? 'End'
                        : index == controllers.length - 1
                            ? 'Add Waypoint'
                            : 'Waypoint ${index + 1}',
              ),
            );
          },
        ),
      ),
    );
  }
}
