class RoomModel {
  String roomId;
  String roomName;
  String surveyId;

  RoomModel({this.roomId, this.roomName, this.surveyId});

  RoomModel.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    surveyId = json['survey_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['survey_id'] = this.surveyId;
    return data;
  }
}