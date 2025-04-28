import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/common/constants/mapbox_constants.dart';
import 'package:flutter_template/common/helpers/mapbox_helper.dart';
import 'package:flutter_template/common/utils/toast_util.dart';
import 'package:flutter_template/data/models/marker.model.dart';
import 'package:flutter_template/flavors.dart';
import 'package:flutter_template/generated/assets.gen.dart';
import 'package:flutter_template/presentation/maps/maps.dart';
import 'package:flutter_template/presentation/maps/widget/map_drawer.dart';
import 'package:flutter_template/presentation/widgets/common_app_bar.dart';
import 'package:flutter_template/presentation/widgets/common_rounded_button.dart';
import 'package:flutter_template/router/app_router.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapsView extends StatelessWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapboxOptions.setAccessToken(AppFlavor.mapboxPublicKey);

    return BlocListener<MapsBloc, MapsState>(
      listener: (context, state) async {
        if (state.error != null && context.mounted) {
          ToastUtil.showError(context, text: state.error);
        }
      },
      child: const _MapsForm(),
    );
  }
}

class _MapsForm extends StatefulWidget {
  const _MapsForm();

  @override
  State<_MapsForm> createState() => _MapsFormState();
}

class _MapsFormState extends State<_MapsForm> {
  MapboxMap? _mapBoxMap;

  void _onMapCreated(BuildContext context, MapboxMap mapboxMap) async {
    _mapBoxMap = mapboxMap;

    _mapBoxMap?.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        showAccuracyRing: true,
        pulsingEnabled: true,
      ),
    );

    await MapboxHelper.addStyleImage(
      path: Assets.icons.map.pin.path,
      iconId: MapBoxConstants.destinationIconID.value,
      style: _mapBoxMap?.style,
      width: 40,
      height: 40,
    );
    await MapboxHelper.addStyleImage(
      path: Assets.icons.map.start.path,
      iconId: MapBoxConstants.originIconID.value,
      style: _mapBoxMap?.style,
      width: 20,
      height: 20,
    );
  }

  void _onUpdateLocation(BuildContext context) async {
    context.read<MapsBloc>().add(const MapUpdateLocation());
  }

  void _onGotRoute(MapsState state) async {
    if (_mapBoxMap == null || _mapBoxMap?.style == null) {
      return;
    }
    await MapboxHelper.clearOptimizedRoute(
      style: _mapBoxMap!.style,
      layerIds: MapBoxLayerEnum.stringValues,
      sourceIds: MapboxSourceEnum.stringValues,
    );

    final cameraOptions = await _mapBoxMap?.cameraForCoordinateBounds(
      state.bounds!,
      MbxEdgeInsets(top: 120, left: 120, bottom: 120, right: 120),
      0,
      0,
      null,
      null,
    );

    if (cameraOptions != null) {
      _mapBoxMap?.flyTo(cameraOptions, MapAnimationOptions(duration: 3000));
    }

    final currentZoom = (cameraOptions?.zoom ?? 0);

    await _mapBoxMap?.style.addSource(
      GeoJsonSource(
        id: MapboxSourceEnum.lineSourceID.value,
        data: state.optimizedRouteGeoJSON,
      ),
    );

    await _mapBoxMap?.style.addSource(
      GeoJsonSource(
        id: MapboxSourceEnum.waypointSourceID.value,
        data: state.waypointsGeoJSON,
      ),
    );
    await MapboxHelper.addRoute(_mapBoxMap?.style, currentZoom);
  }

  void _onGotLocation(MapsState state) async {
    await _mapBoxMap?.flyTo(
      CameraOptions(
        center: state.myLocation?.point,
        zoom: 12,
      ),
      MapAnimationOptions(),
    );
  }

  void _onListen(MapsState state) async {
    if (state.status == MapsStatus.getCurrentPositionSuccess) {
      _onGotLocation(state);
      return;
    }
    if (state.status == MapsStatus.optimizeSuccess) {
      _onGotRoute(state);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    log('build MapsForm');
    return BlocListener<MapsBloc, MapsState>(
      listener: (context, state) {
        _onListen(state);
      },
      child: Scaffold(
        drawer: const MapsDrawer(),

        floatingActionButton: FloatingActionButton(
          onPressed: (() => _onUpdateLocation(context)),
          child: const Icon(Icons.navigation_sharp),
        ),
        appBar: CommonAppBar(
          title: '',
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
          bottom: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CommonRoundedButton(
                width: double.infinity,
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRouter.locationList,
                  );

                  if (result != null && result is List<MarkerModel>) {
                    if (context.mounted) {
                      context.read<MapsBloc>().add(
                            MapPlacesGet(places: result),
                          );
                    }
                  }
                },
                backgroundColor: Colors.white,
                content: 'Search Location',
                borderRadius: 15,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          toolbarHeight: kToolbarHeight + 50,
        ),
        // extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: MapWidget(
          cameraOptions: CameraOptions(zoom: 2),
          onMapCreated: (mapBoxMap) => _onMapCreated(context, mapBoxMap),
        ),
      ),
    );
  }
}
