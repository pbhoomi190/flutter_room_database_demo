import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutterroomdatabase/bloc/bloc.dart';
import 'package:flutterroomdatabase/bloc/get_room_api_repository.dart';
import 'package:flutterroomdatabase/constants/strings.dart';
import 'package:flutterroomdatabase/database_helper/database_helper.dart';
import 'package:flutterroomdatabase/models/room_list.dart';
import 'package:flutterroomdatabase/models/room_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetRoomAPIBloc implements Bloc {
  // Variables
  GetRoomRepository _getRoomRepository;
  DatabaseHelper _databaseHelper;
  StreamController _roomResponseController;
  StreamController _isLoadingController;
  Stream<List<RoomResponse>> get roomResponseStream => _roomResponseController.stream;
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  GetRoomAPIBloc() {
    _roomResponseController = StreamController<List<RoomResponse>>();
    _isLoadingController = StreamController<bool>();
    _databaseHelper = DatabaseHelper();
    _getRoomRepository = GetRoomRepository();
    _fetchRooms();
  }

  _fetchRooms() async {
      _isLoadingController.sink.add(true);
      var roomResult = await _getRoomRepository.getRoomData();
      if (roomResult != null) {
        _saveToTheDatabase(roomResult);
      } else {
        _roomResponseController.sink.add([]);
      }
  }

  _saveToTheDatabase(RoomResponse roomResponse) async {
    List<RoomList> rooms = roomResponse.data.roomList;
    rooms.forEach((element) async {
      var roomAddResult = await _databaseHelper.insert(element.toJson(), roomTable);
      debugPrint("Added ${element.roomName} room response = $roomAddResult ");
      element.items.forEach((item) async {
        var itemAddResult = await _databaseHelper.insert(item.toJson(), itemTable);
        debugPrint("Added ${item.cFieldName} item response = $itemAddResult ");
      });
    });
    _roomResponseController.sink.add(roomResponse.data.roomList);
    _isLoadingController.sink.add(false);
  }

  _storePreferences() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(isDatabaseAdded, true);
  }

  @override
  void dispose() {
    // CLOSE ALL STREAMS TO AVOID MEMORY LEAKS
    _roomResponseController.close();
    _isLoadingController.close();
  }
}