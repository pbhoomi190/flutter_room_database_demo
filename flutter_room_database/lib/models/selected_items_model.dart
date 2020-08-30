class SelectedItems {
  String roomId;
  String roomName;
  String cId;
  String cFieldName;
  String density;
  int quantity;

  SelectedItems(
      {this.roomId, this.roomName, this.cId, this.cFieldName, this.density, this.quantity});

  SelectedItems.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    cId = json['c_id'];
    cFieldName = json['c_field_name'];
    density = json['density'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['c_id'] = this.cId;
    data['c_field_name'] = this.cFieldName;
    data['density'] = this.density;
    data['quantity'] = this.quantity;
    return data;
  }
}
