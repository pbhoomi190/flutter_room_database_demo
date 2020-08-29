class Items {
  String cId;
  String cFieldName;
  String cComments;
  String cCubicFeet;
  String cWeight;
  String groupNameId;
  String density;

  Items(
      {this.cId,
        this.cFieldName,
        this.cComments,
        this.cCubicFeet,
        this.cWeight,
        this.groupNameId,
        this.density});

  Items.fromJson(Map<String, dynamic> json) {
    cId = json['c_id'];
    cFieldName = json['c_field_name'];
    cComments = json['c_comments'];
    cCubicFeet = json['c_cubic_feet'];
    cWeight = json['c_weight'];
    groupNameId = json['group_name_id'];
    density = json['density'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['c_id'] = this.cId;
    data['c_field_name'] = this.cFieldName;
    data['c_comments'] = this.cComments;
    data['c_cubic_feet'] = this.cCubicFeet;
    data['c_weight'] = this.cWeight;
    data['group_name_id'] = this.groupNameId;
    data['density'] = this.density;
    return data;
  }
}