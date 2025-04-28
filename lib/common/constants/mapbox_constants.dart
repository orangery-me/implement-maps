enum MapboxSourceEnum {
  lineSourceID('lineSource'),
  waypointSourceID('waypointSource');

  final String value;

  const MapboxSourceEnum(this.value);

  static List<String> get stringValues =>
      MapboxSourceEnum.values.map((e) => e.value).toList();
}

enum MapBoxLayerEnum {
  lineLayerID('lineLayer'),
  waypointCircleLayerID('waypointCircleLayer'),
  waypointLabelLayerID('waypointLabelLayer'),
  orgDestLabelLayerID('waypointOrgDestLabelLayer');

  final String value;
  const MapBoxLayerEnum(this.value);

  static List<String> get stringValues =>
      MapBoxLayerEnum.values.map((e) => e.value).toList();
}

enum MapBoxConstants {
  originIconID('originImageID'),
  destinationIconID('destinationIconID');

  final String value;
  const MapBoxConstants(this.value);
}
