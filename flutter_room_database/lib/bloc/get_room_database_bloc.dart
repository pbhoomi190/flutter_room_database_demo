import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterroomdatabase/bloc/bloc.dart';
import 'package:flutterroomdatabase/database_helper/database_helper.dart';
import 'package:flutterroomdatabase/models/items.dart';
import 'package:flutterroomdatabase/models/room_list.dart';

class GetRoomDatabaseBloc implements Bloc{

  // VARIABLES
  DatabaseHelper _databaseHelper;
  StreamController<bool> isFetchingFromDatabaseController;
  StreamController<List<RoomList>> roomListController;
  StreamController<List<Items>> itemListController;

  Stream<bool> get isFetchingFromDatabaseStream => isFetchingFromDatabaseController.stream;
  Stream<List<RoomList>> get roomListStream => roomListController.stream;
  Stream<List<Items>> get itemListStream => itemListController.stream;

  GetRoomDatabaseBloc() {
    isFetchingFromDatabaseController = StreamController<bool>();
    roomListController = StreamController<List<RoomList>>();
    itemListController = StreamController<List<Items>>();
    _databaseHelper = DatabaseHelper();
    _fetchRoomFromDatabase();
  }

  // FETCH ROOMS
  _fetchRoomFromDatabase() async {
      isFetchingFromDatabaseController.sink.add(true);

      List<RoomList> roomList = [];
      var rooms = await _databaseHelper.fetchRooms();
      rooms.forEach((element) {
        var room = RoomList.fromJson(element);
        roomList.add(room);
      });

      roomListController.sink.add(roomList);
      fetchItemsFromDatabase(roomList.first.roomId);
      isFetchingFromDatabaseController.sink.add(false);
  }

  // FETCH ROOM ITEMS
  fetchItemsFromDatabase(String roomID) async{
    isFetchingFromDatabaseController.sink.add(true);
    List<Items> itemList = [];
    var rooms = await _databaseHelper.fetchRoomItems(roomID);
    rooms.forEach((element) {
      var item = Items.fromJson(element);
      itemList.add(item);
    });
    itemListController.sink.add(itemList);
    isFetchingFromDatabaseController.sink.add(false);
  }

  @override
  void dispose() {
    isFetchingFromDatabaseController.close();
    roomListController.close();
    itemListController.close();
  }
}