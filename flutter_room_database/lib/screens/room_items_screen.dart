import 'package:flutter/material.dart';
import 'package:flutterroomdatabase/constants/strings.dart';

class RoomItemScreen extends StatefulWidget {
  @override
  _RoomItemScreenState createState() => _RoomItemScreenState();
}

class _RoomItemScreenState extends State<RoomItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
