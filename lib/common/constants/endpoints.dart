import 'package:flutter_template/flavors.dart';

abstract class Endpoints {
  static String apiUrl = '${AppFlavor.apiBaseUrl}/api';

  //Auth
  static String login = '$apiUrl/auth/login';
  static String googleLogin = '$apiUrl/users/auth/google/login';
  static String userInfo = '$apiUrl/auth/me';

  //Geocoding
  static String mapSorterGeocode = '$apiUrl/maps/geocode';

  //Optimize route
  static String mapSorterOptimizeRoute = '$apiUrl/maps/optimized-route';

  //MAPBOX URLS
  static String baseMapBoxURL = 'https://api.mapbox.com';
  static String mapBoxAutoComplete =
      '/search/searchbox/v1/suggest?access_token=${AppFlavor.mapboxPublicKey}&limit=10&country=vn&session_token=DUMMY';

  static String mapboxGeocode =
      '$baseMapBoxURL/search/searchbox/v1/forward?access_token=${AppFlavor.mapboxPublicKey}&limit=10&country=vn&auto_complete=true';

  static String autocompletePlace =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=${AppFlavor.mapsAPIKey}&components=country:vn&region=vn';

  static String geoCode =
      'https://maps.googleapis.com/maps/api/geocode/json?key=${AppFlavor.mapsAPIKey}';

  static String directions =
      'https://maps.googleapis.com/maps/api/directions/json?key=${AppFlavor.mapsAPIKey}';
}
