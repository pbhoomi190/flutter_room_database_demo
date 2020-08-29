import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterroomdatabase/bloc/bloc.dart';
import 'package:flutterroomdatabase/bloc/get_room_api_repository.dart';
import 'package:flutterroomdatabase/constants/strings.dart';
import 'package:flutterroomdatabase/database_helper/database_helper.dart';
import 'package:flutterroomdatabase/models/items.dart';
import 'package:flutterroomdatabase/models/room_database_model.dart';
import 'package:flutterroomdatabase/models/room_list.dart';
import 'package:flutterroomdatabase/models/room_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APICallModel {
  bool isApiCalling;
  bool isInternet;

  APICallModel({this.isApiCalling, this.isInternet});
}

class GetRoomAPIBloc implements Bloc {
  // VARIABLES
  GetRoomRepository _getRoomRepository;
  DatabaseHelper _databaseHelper;
  StreamController<APICallModel> _isLoadingController;
  Stream<APICallModel> get isLoadingStream => _isLoadingController.stream;

  GetRoomAPIBloc() {
    _isLoadingController = StreamController<APICallModel>();
    _databaseHelper = DatabaseHelper();
    _getRoomRepository = GetRoomRepository();
    _checkConnectivity();
  }

  // CHECK CONNECTIVITY
  _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none) {
      var objModel = APICallModel(isApiCalling: false, isInternet: false);
      _isLoadingController.sink.add(objModel);
    } else {
      _fetchRooms();
    }
  }

  // FETCH FROM API
  _fetchRooms() async {
      _isLoadingController.sink.add(APICallModel(isApiCalling: true, isInternet: true));
      var roomResult = await _getRoomRepository.getRoomData();
      if (roomResult != null) {
        _saveToTheDatabase(roomResult);
      } else {
        _isLoadingController.sink.add(APICallModel(isApiCalling: false, isInternet: true));
      }
  }

  // SAVE DATABASE AFTER FETCHING
  _saveToTheDatabase(RoomResponse roomResponse) async {
    List<RoomList> rooms = roomResponse.data.roomList;
    rooms.forEach((element) {
      var roomModel = RoomModel(roomId: element.roomId, roomName: element.roomName, surveyId: element.surveyId);
      addRoomToDatabase(roomModel);
      element.items.forEach((item) {
        item.roomId = element.roomId; // SET ROOM ID IN ITEM
        addItemToDatabase(item);
      });
    });
    _storePreferences();
    _isLoadingController.sink.add(APICallModel(isApiCalling: false, isInternet: true));
  }

  addRoomToDatabase(RoomModel room) async{
    var roomAddResult = await _databaseHelper.insert(room.toJson(), roomTable);
    debugPrint("Added ${room.roomName} room response = $roomAddResult ");
  }

  addItemToDatabase(Items item) async{
    var itemAddResult = await _databaseHelper.insert(item.toJson(), itemTable);
    debugPrint("Added ${item.cFieldName} item response = $itemAddResult ");
  }

  // STORE PREFERENCES TO CHECK IF DATABASE AVAILABLE OR NOT
  _storePreferences() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(isDatabaseAdded, true);
  }

  @override
  void dispose() {
    // CLOSE ALL STREAMS TO AVOID MEMORY LEAKS
    _isLoadingController.close();
  }
}