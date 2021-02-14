import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:ildonor/src/services_kls/authservice.dart';
import 'package:provider/provider.dart';
import 'package:ildonor/src/harita_servis/geoservis.dart';
import 'package:ildonor/src/harita_servis/harita_Model.dart';
import 'package:ildonor/src/harita_servis/yer_Servis.dart';
import 'package:geolocator/geolocator.dart';

class App extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();
  @override
  Widget build(BuildContext context) {
        return MultiProvider(
      providers: [
        FutureProvider(create: (context) => locatorService.getLocation()),
        ProxyProvider<Position, Future<List<Place>>>(
          update: (context, position, places) {
            return (position != null)
                ? placesService.getPlaces(position.latitude, position.longitude)
                : null;
          },
        )
      ],
    child: MaterialApp(
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
    ));
  }
}
