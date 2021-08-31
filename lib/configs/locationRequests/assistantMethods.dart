import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cruiser_driver/configs/locationRequests/requestAssistant.dart';
import 'package:cruiser_driver/models/directionDetails.dart';

class AssistantMethods {
  static Future<DirectionDetails?> obtainPlaceDirectionsDetails(
      LatLng pickupLocation, LatLng dropOffLocation) async {
    String directionUrl =
        "https://graphhopper.com/api/1/route?point=${pickupLocation.latitude},${pickupLocation.longitude}&point=${dropOffLocation.latitude},${dropOffLocation.longitude}&vehicle=car&locale=en&calc_points=true&points_encoded=true&key=e10c263a-349c-4913-9873-afb4ac9695d6";
    var _response = await RequestAssistant.getRequest(directionUrl);
    if (_response == 'Failed') {
      print("Failed to get placeDirection details");
      return null;
    }
    DirectionDetails? _directionDetails = DirectionDetails();
    _directionDetails.distanceText =
        (_response["paths"][0]["distance"] / 1000.0).toString() + "Km";
    _directionDetails.distanceValue =
        _response["paths"][0]["distance"] / 1000.0;
    _directionDetails.durationText =
        ((_response["paths"][0]["time"] / 2000000.0) * 60).toString() + "m";
    _directionDetails.durationValue =
        _response["paths"][0]["time"] / 2000000.0 * 60.0;
    _directionDetails.minLong = _response["paths"][0]["bbox"][0];
    _directionDetails.minLat = _response["paths"][0]["bbox"][1];
    _directionDetails.maxLong = _response["paths"][0]["bbox"][2];
    _directionDetails.maxLat = _response["paths"][0]["bbox"][3];
    _directionDetails.encodedPoints = _response["paths"][0]["points"];
    return _directionDetails;
  }

  static int calculateFares(DirectionDetails _directionDetails) {
    ///fare calculations in rupees
    double _timeTravelledFare = _directionDetails.durationValue! * .5;
    double _distanceTravelledFare = _directionDetails.distanceValue! * 9;
    double _totalFare = _timeTravelledFare + _distanceTravelledFare;
    return _totalFare.toInt();
  }
}
