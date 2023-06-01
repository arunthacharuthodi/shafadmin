import 'package:location/location.dart';
import 'package:notes_app/helper/firestore.dart';

class LocationServices {
  Future<void> getLocation() async {
    Location location = new Location();
    final firestoreHelper = FirestoreHelper();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    await firestoreHelper.updateLocation(
        latitude: _locationData.latitude!, longitude: _locationData.longitude!);
  }
}
