import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:ildonor/src/harita_servis/harita_Model.dart';

class PlacesService {
  final key = 'YOUR_API_KEY';
  final url="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=41.0025984,29.2225024&type=hospital&rankby=distance&key=YOUR_API_KEY";
  Future<List<Place>> getPlaces(double lat, double lng) async {
    var response = await http.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=hospital&rankby=distance&key=$key'
        );
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
    //'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=hospital&rankby=distance&key=$key'
  }
}
