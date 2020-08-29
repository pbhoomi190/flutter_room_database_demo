import 'package:flutterroomdatabase/api_helper/api_helper.dart';
import 'package:flutterroomdatabase/constants/common_enums.dart';
import 'dart:async';
import 'package:flutterroomdatabase/constants/strings.dart';
import 'package:flutterroomdatabase/models/room_response.dart';

class GetRoomRepository {

  APIHelper _apiHelper = APIHelper();

  Future<RoomResponse> getRoomData() async {
    var result = await _apiHelper.sendRequest(roomDataURL, HttpRequestType.get);
    return RoomResponse.fromJson(result);
  }
}