import 'dart:async';
import 'package:cruiser_driver/configs/providers/appDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LiveLocationUpdates {
  static late StreamSubscription<Position> homeTabPageSubscription;
  static Future<void> liveLocationUpdates(BuildContext context) async {
    homeTabPageSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
      await Geofire.setLocation(
          Provider.of<AppData>(context, listen: false).currentDriverInfo.id!,
          position.latitude,
          position.longitude);

      ///creating latLng variable for live position
      LatLng latLng = LatLng(position.latitude, position.longitude);

      ///updating latLng in provider
      Provider.of<AppData>(context, listen: false).updateLatLng(latLng);
    });
  }

  ///removing live location tracking
  static Future<void> liveLocationDispose(BuildContext context) async {
    await Geofire.stopListener();
    await homeTabPageSubscription.cancel();
    await Geofire.removeLocation(
        Provider.of<AppData>(context, listen: false).currentDriverInfo.id!);
    Provider.of<AppData>(context, listen: false).clearDriverOnline();
  }
}
