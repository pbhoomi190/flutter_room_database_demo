import 'package:flutterroomdatabase/models/items.dart';

class RoomList {
  String roomId;
  String roomName;
  String surveyId;
  List<Items> items;

  RoomList({this.roomId, this.roomName, this.surveyId, this.items});

  RoomList.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    surveyId = json['survey_id'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['survey_id'] = this.surveyId;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}