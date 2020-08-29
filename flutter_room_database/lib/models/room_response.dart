import 'package:flutterroomdatabase/models/categories.dart';
import 'package:flutterroomdatabase/models/item_list.dart';
import 'package:flutterroomdatabase/models/items.dart';

class RoomResponse {
  String code;
  String status;
  Data data;

  RoomResponse({this.code, this.status, this.data});

  RoomResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<ItemList> itemsList;
  List<Categories> categories;
  List<Items> cp;
  List<Items> pbo;

  Data({this.itemsList, this.categories, this.cp, this.pbo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['itemslist'] != null) {
      itemsList = new List<ItemList>();
      json['itemslist'].forEach((v) {
        itemsList.add(new ItemList.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['cp'] != null) {
      cp = new List<Items>();
      json['cp'].forEach((v) {
        cp.add(new Items.fromJson(v));
      });
    }
    if (json['pbo'] != null) {
      pbo = new List<Items>();
      json['pbo'].forEach((v) {
        pbo.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itemsList != null) {
      data['itemslist'] = this.itemsList.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.cp != null) {
      data['cp'] = this.cp.map((v) => v.toJson()).toList();
    }
    if (this.pbo != null) {
      data['pbo'] = this.pbo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
