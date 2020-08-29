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
  double _screenHeight = 0.0;
  TextEditingController roomSearchController = TextEditingController(text: "");
  TextEditingController itemSearchController = TextEditingController(text: "");

  // HELPER METHODS
  void initialSetup() {
    checkDatabaseAdded();
    listenTextFieldChanges();
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

  void listenTextFieldChanges() {
    roomSearchController.addListener(() {
      if (_getRoomDatabaseBloc != null) {
        _getRoomDatabaseBloc.searchRoomWithQuery(roomSearchController.text.trim().toLowerCase());
      }
    });

    itemSearchController.addListener(() {
      if (_getRoomDatabaseBloc != null) {
        _getRoomDatabaseBloc.searchItemWithQuery(itemSearchController.text.trim().toLowerCase());
      }
    });
  }

  // WIDGETS

  Widget centerMessage(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget apiCallingWidget(GetRoomAPIBloc bloc) {
    return StreamBuilder<APICallModel>(
      stream: bloc.isLoadingStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isApiCalling == true) {
            return centerMessage(apiCallingMessage);
          } else if (snapshot.data.isApiCalling == false && snapshot.data.isInternet == true) {
            _getRoomDatabaseBloc = GetRoomDatabaseBloc();
            return centerMessage(databaseFetchMessage);
          } else {
            return centerMessage(noData);
          }
        } else {
          return centerMessage(noData);
        }
      },
    );
  }

  Widget roomListWidget(GetRoomDatabaseBloc bloc) {
    return StreamBuilder<List<RoomList>>(
      stream: bloc.roomListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                bloc.fetchItemsFromDatabase(snapshot.data[index].roomId);
              },
              title: Text(snapshot.data[index].roomName),
            );
          },
            itemCount: snapshot.data.length,
          );
        } else {
          return centerMessage(databaseFetchMessage);
        }

      },
    );
  }

  Widget itemListWidget(GetRoomDatabaseBloc bloc) {
    return StreamBuilder<List<Items>>(
      stream: bloc.itemListStream,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data[index].cFieldName),
            );
          },
            itemCount: snapshot.data.length,
          );
        } else {
          return centerMessage(databaseFetchMessage);
        }
      },
    );
  }

  Widget dataTable() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Table(
          border: TableBorder.all(width: 1, color: Colors.black),
            children: [
              TableRow(children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(rooms,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(items,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
              ]),
              TableRow(children: [
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: roomSearchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey,),
                        border: InputBorder.none,
                        labelText: search,
                      ),
                  ),
                )),
                TableCell(child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: itemSearchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey,),
                      border: InputBorder.none,
                      labelText: search,
                    ),
                  ),
                )),
              ]),
              TableRow(children: [
                TableCell(
                  child: Container(
                    height: _screenHeight * 0.4,
                    child: roomListWidget(_getRoomDatabaseBloc),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: _screenHeight * 0.4,
                    child: itemListWidget(_getRoomDatabaseBloc),
                  ),
                )
              ])
            ],
        ),
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
    itemSearchController.dispose();
    roomSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: <Widget>[
          isOfflineDataAvailable ? dataTable()  :
          _getRoomAPIBloc != null ? apiCallingWidget(_getRoomAPIBloc) : Center()
        ],
      ),
    );
  }
}

