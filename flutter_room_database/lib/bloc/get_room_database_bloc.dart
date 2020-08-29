import 'dart:async';
import 'package:flutterroomdatabase/bloc/bloc.dart';
import 'package:flutterroomdatabase/database_helper/database_helper.dart';
import 'package:flutterroomdatabase/models/items.dart';
import 'package:flutterroomdatabase/models/room_list.dart';

class GetRoomDatabaseBloc implements Bloc{

  // VARIABLES
  DatabaseHelper _databaseHelper;
  StreamController<List<RoomList>> roomListController;
  StreamController<List<Items>> itemListController;

  Stream<List<RoomList>> get roomListStream => roomListController.stream;
  Stream<List<Items>> get itemListStream => itemListController.stream;

  List<RoomList> _roomList = [];
  List<Items> _itemList = [];

  GetRoomDatabaseBloc() {
    roomListController = StreamController<List<RoomList>>();
    itemListController = StreamController<List<Items>>();
    _databaseHelper = DatabaseHelper();
    _fetchRoomFromDatabase();
  }

  // FETCH ROOMS
  _fetchRoomFromDatabase() async {

      var rooms = await _databaseHelper.fetchRooms();
      rooms.forEach((element) {
        var room = RoomList.fromJson(element);
        _roomList.add(room);
      });

      roomListController.sink.add(_roomList);
      fetchItemsFromDatabase(_roomList.first.roomId);
  }

  // FETCH ROOM ITEMS
  fetchItemsFromDatabase(String roomID) async{
    var rooms = await _databaseHelper.fetchRoomItems(roomID);
    rooms.forEach((element) {
      var item = Items.fromJson(element);
      _itemList.add(item);
    });
    itemListController.sink.add(_itemList);
  }

  // SEARCH ROOM
  searchRoomWithQuery(String query) {
    if (query.isNotEmpty) {
      var list = _roomList.where((element) => element.roomName.toLowerCase().contains(query)).toList();
      roomListController.sink.add(list);
    } else {
      roomListController.sink.add(_roomList);
    }
  }

  // SEARCH ITEM
  searchItemWithQuery(String query) {
    if (query.isNotEmpty) {
      var list = _itemList.where((element) => element.cFieldName.toLowerCase().contains(query)).toList();
      itemListController.sink.add(list);
    } else {
      itemListController.sink.add(_itemList);
    }
  }

  @override
  void dispose() {
    roomListController.close();
    itemListController.close();
  }
}