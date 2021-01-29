import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Getlocation {
  double latitude;
  double longitude;
  String city;
  //get current Location
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;

      city = await getCityName(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
  }

  //get city name
  Future<String> getCityName(double lat, double lon) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    print('kota kamu adalah: ${placemark[0].locality}');
    return placemark[0].locality;
  }
}
