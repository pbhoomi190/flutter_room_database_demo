import 'package:flutter/material.dart';
import 'package:flutterroomdatabase/bloc/get_room_api_bloc.dart';
import 'package:flutterroomdatabase/bloc/get_room_database_bloc.dart';
import 'package:flutterroomdatabase/constants/strings.dart';
import 'package:flutterroomdatabase/models/items.dart';
import 'package:flutterroomdatabase/models/room_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomItemScreen extends StatefulWidget {
  @override
  _RoomItemScreenState createState() => _RoomItemScreenState();
}

class _RoomItemScreenState extends State<RoomItemScreen> {
  // VARIABLES
  GetRoomAPIBloc _getRoomAPIBloc;
  GetRoomDatabaseBloc _getRoomDatabaseBloc;
  bool isOfflineDataAvailable = false;

  // HELPER METHODS
  void initialSetup() {
    checkDatabaseAdded();
  }

  void checkDatabaseAdded() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isOfflineDataAvailable = sharedPreferences.getBool(isDatabaseAdded) ?? false;
    if (isOfflineDataAvailable) {
     setState(() {
       _getRoomDatabaseBloc = GetRoomDatabaseBloc();
     });
    } else {
        _getRoomAPIBloc = GetRoomAPIBloc();
    }
  }

  // WIDGETS
  Widget apiCallingWidget(GetRoomAPIBloc bloc) {
    return StreamBuilder<APICallModel>(
      stream: bloc.isLoadingStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isApiCalling == true) {
            return Center(
              child: Text(apiCallingMessage),
            );
          } else if (snapshot.data.isApiCalling == false && snapshot.data.isInternet == true) {
            _getRoomDatabaseBloc = GetRoomDatabaseBloc();
            return Center(
              child: Text(databaseFetchMessage),
            );
          } else {
            return Center(
              child: Text(noData),
            );
          }
        } else {
          return Center(
            child: Text(noData),
          );
        }
      },
    );
  }

  Widget roomListWidget(GetRoomDatabaseBloc bloc) {
    return StreamBuilder<List<RoomList>>(
      stream: bloc.roomListStream,
      builder: (context, snapshot) {
        return ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: Text(snapshot.data[index].roomName),
          );
        },
          itemCount: snapshot.data.length,
        );
      },
    );
  }

  Widget itemListWidget(GetRoomDatabaseBloc bloc) {
    return StreamBuilder<List<Items>>(
      stream: bloc.itemListStream,
      builder: (context, snapshot) {
        return ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: Text(snapshot.data[index].cFieldName),
          );
        },
          itemCount: snapshot.data.length,
        );
      },
    );
  }

  Widget dataTable() {
      return Table(
        border: TableBorder.all(width: 1, color: Colors.black),
          children: [
            TableRow(children: [
              TableCell(child: Text(rooms, textAlign: TextAlign.center,)),
              TableCell(child: Text(items, textAlign: TextAlign.center,)),
            ]),
            TableRow(children: [
              TableCell(child: TextField(

              )),
              TableCell(child: TextField(

              )),
            ]),
          ],
      );
  }

  // LIFECYCLE METHODS

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  void dispose() {
    _getRoomAPIBloc.dispose();
    _getRoomDatabaseBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: <Widget>[
          isOfflineDataAvailable ? Center(child: Text("Show offline data"),) :
          _getRoomAPIBloc != null ? apiCallingWidget(_getRoomAPIBloc) : Center()
        ],
      ),
    );
  }
}

