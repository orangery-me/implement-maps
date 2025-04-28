import 'package:flutter/services.dart';
import 'package:flutter_template/common/constants/mapbox_constants.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract final class MapboxHelper {
  static Future<void> addRoute(
    StyleManager? style,
    double currentCameraZoom,
  ) async {
    if (style == null) return;

    await style.addLayer(getLineLayer(currentCameraZoom));
    await style.addLayer(getWaypointCircleLayer(currentCameraZoom));

    await style.addLayer(
      getOriginDestinationSymbolLayer(currentCameraZoom),
    );

    await style.addLayer(getWaypointSymbolLayer(currentCameraZoom));
  }

  static Future<void> clearOptimizedRoute({
    required StyleManager style,
    required List<String> layerIds,
    required List<String> sourceIds,
  }) async {
    for (var layer in layerIds) {
      if (await style.styleLayerExists(layer) == true) {
        style.removeStyleLayer(layer);
      }
    }

    for (var source in sourceIds) {
      if (await style.styleSourceExists(source) == true) {
        style.removeStyleSource(source);
      }
    }
  }

  static Future<void> addStyleImage({
    required String path,
    required String iconId,
    required StyleManager? style,
    required int width,
    required int height,
  }) async {
    if (style == null) return;

    try {
      final pinBytes = await rootBundle.load(path);

      final pinDataList = pinBytes.buffer.asUint8List();

      style.addStyleImage(
        iconId,
        1.0,
        MbxImage(width: width, height: height, data: pinDataList),
        false,
        [],
        [],
        null,
      );
    } catch (e) {
      return;
    }
  }

  static LineLayer getLineLayer(double currentCameraZoom) {
    return LineLayer(
      lineWidth: 8,
      id: MapBoxLayerEnum.lineLayerID.value,
      sourceId: MapboxSourceEnum.lineSourceID.value,
      lineColorExpression: [
        'interpolate',
        ['exponential', 4],
        ['zoom'],
        currentCameraZoom,
        'rgb(51, 102, 255)',
        currentCameraZoom + 1.5,
        ['get', 'route-color'],
        // [
        //   'coalesce',
        //   ['get', 'route-color'],
        //   'rgb(51, 102, 255)',
        // ],
      ],
    );
  }

  static CircleLayer getWaypointCircleLayer(double currentZoom) {
    return CircleLayer(
      id: MapBoxLayerEnum.waypointCircleLayerID.value,
      sourceId: MapboxSourceEnum.waypointSourceID.value,
      circleOpacityExpression: [
        'interpolate',
        ['exponential', 4],
        ['zoom'],
        currentZoom,
        0.0,
        currentZoom + 1.5,
        1.0,
      ],
      circleStrokeOpacityExpression: [
        'interpolate',
        ['exponential', 4],
        ['zoom'],
        currentZoom,
        0.0,
        currentZoom + 2,
        1.0,
      ],
      circleStrokeWidthExpression: [
        'interpolate',
        ['exponential', 4],
        ['zoom'],
        currentZoom,
        1,
        currentZoom + 1.5,
        3,
      ],
      circleRadiusExpression: [
        'interpolate',
        ['exponential', 4],
        ['zoom'],
        currentZoom,
        12,
        currentZoom + 1.5,
        14,
      ],
      circleColorExpression: [
        'coalesce',
        ['get', 'color'],
        'rgb(51, 102, 255)',
      ],
    );
  }

  static SymbolLayer getWaypointSymbolLayer(double currentZoom) {
    return SymbolLayer(
      id: MapBoxLayerEnum.waypointLabelLayerID.value,
      sourceId: MapboxSourceEnum.waypointSourceID.value,
      textFieldExpression: ['get', 'index'],
      textOpacityExpression: [
        'interpolate',
        ['exponential', 4],
        ['zoom'],
        currentZoom,
        0.0,
        currentZoom + 1.5,
        1.0,
      ],
      textSizeExpression: getExpressionWithZoom(
        beforeZoom: currentZoom,
        beforeValue: 16,
        afterZoom: currentZoom + 2,
        afterValue: 14,
      ),
      textFont: ['Open Sans Bold'],
      textColor: 0xFFFFFFFF,
      filter: [
        '==',
        ['get', 'name'],
        'waypoints',
      ],
    );
  }

  static SymbolLayer getOriginDestinationSymbolLayer(double currentZoom) {
    return SymbolLayer(
      id: MapBoxLayerEnum.orgDestLabelLayerID.value,
      sourceId: MapboxSourceEnum.waypointSourceID.value,
      iconOpacityExpression: [
        'interpolate',
        ['exponential', 4],
        ['zoom'],
        currentZoom,
        1,
        currentZoom + 1.5,
        0,
      ],
      textFieldExpression: ['get', 'index'],
      iconImageExpression: [
        'case',
        [
          '==',
          ['get', 'role'],
          'origin',
        ],
        MapBoxConstants.originIconID.value,
        [
          '==',
          ['get', 'role'],
          'destination',
        ],
        MapBoxConstants.destinationIconID.value,
        '',
      ],
      iconOffsetExpression: [
        'case',
        [
          '==',
          ['get', 'role'],
          'destination',
        ],
        [0, -20],
        [0, 0],
      ],
      textOpacityExpression: [
        'interpolate',
        ['exponential', 4],
        ['zoom'],
        currentZoom,
        0.0,
        currentZoom + 1.5,
        1.0,
      ],
      textSize: 11,
      filter: [
        '!=',
        ['get', 'name'],
        'waypoints',
      ],
      textFont: ['Open Sans Bold'],
      textColor: 0xFFFFFFFF,
      iconAllowOverlap: true,
      iconIgnorePlacement: true,
    );
  }

  static List<Object> getExpressionWithZoom({
    required double beforeZoom,
    required double beforeValue,
    required double afterZoom,
    required double afterValue,
  }) {
    return [
      'interpolate',
      ['linear'],
      ['zoom'],
      beforeZoom,
      beforeValue,
      afterZoom,
      afterValue,
    ];
  }
}
