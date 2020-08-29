import 'package:flutter/material.dart';
import 'package:flutterroomdatabase/constants/route_names.dart';
import 'package:flutterroomdatabase/constants/strings.dart';
import 'package:flutterroomdatabase/screens/room_items_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteName.first,
      routes: {
        RouteName.first: (context) => RoomItemScreen(),
      },
      onUnknownRoute: (settings) {
        debugPrint("Unknown route settings: ${settings.arguments}");
        return MaterialPageRoute(builder: (context) => Center(child: Text(unknownRoute),));
      },
    );
  }
}
