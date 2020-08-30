import 'dart:async';
import 'package:flutterroomdatabase/bloc/bloc.dart';
import 'package:flutterroomdatabase/database_helper/database_helper.dart';
import 'package:flutterroomdatabase/models/items.dart';
import 'package:flutterroomdatabase/models/room_list.dart';
import 'package:flutterroomdatabase/models/selected_items_model.dart';

class GetRoomDatabaseBloc implements Bloc{

  // VARIABLES
  DatabaseHelper _databaseHelper;
  StreamController<List<RoomList>> _roomListController;
  StreamController<List<Items>> _itemListController;
  StreamController<List<SelectedItems>> _selectedItemController;

  Stream<List<RoomList>> get roomListStream => _roomListController.stream;
  Stream<List<Items>> get itemListStream => _itemListController.stream;
  Stream<List<SelectedItems>> get selectedItemStream => _selectedItemController.stream;

  List<RoomList> _roomList = [];
  List<Items> _itemList = [];
  List<SelectedItems> _selectedItemList = [];

  GetRoomDatabaseBloc() {
    _roomListController = StreamController<List<RoomList>>();
    _itemListController = StreamController<List<Items>>();
    _selectedItemController = StreamController<List<SelectedItems>>();
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

      _roomListController.sink.add(_roomList);
      fetchItemsFromDatabase(_roomList.first.roomId);
  }

  // FETCH ROOM ITEMS
  fetchItemsFromDatabase(String roomID) async{
    var rooms = await _databaseHelper.fetchRoomItems(roomID);
    rooms.forEach((element) {
      var item = Items.fromJson(element);
      _itemList.add(item);
    });
    _itemListController.sink.add(_itemList);
  }

  // SAVE SELECTED ITEMS TO DATABASE
  saveItemToDatabase() {
    if (_selectedItemList.length > 0) {
      _selectedItemList.forEach((element) {
        addSelectedItem(element);
      });
    }
  }

  // ADD SELECTED ROOM ITEM IN THE LIST
  addSelectedItem(SelectedItems selectedItems) {

  }

  // SEARCH ROOM
  searchRoomWithQuery(String query) {
    if (query.isNotEmpty) {
      var list = _roomList.where((element) => element.roomName.toLowerCase().contains(query)).toList();
      _roomListController.sink.add(list);
    } else {
      _roomListController.sink.add(_roomList);
    }
  }

  // SEARCH ITEM
  searchItemWithQuery(String query) {
    if (query.isNotEmpty) {
      var list = _itemList.where((element) => element.cFieldName.toLowerCase().contains(query)).toList();
      _itemListController.sink.add(list);
    } else {
      _itemListController.sink.add(_itemList);
    }
  }

  // ADD TO SELECTED LIST
  addSelectedItemToList(Items item, int quantity) {
    var room = _roomList.firstWhere((element) => element.roomId == item.roomId, orElse: () {
      return null;
    });
    var objSelectedItem = SelectedItems(
        roomId: item.roomId,
        roomName: room!=null ? room.roomName : "",
        cId: item.cId,
        cFieldName:  item.cFieldName,
        density: item.density,
        quantity: quantity
    );
    _selectedItemList.add(objSelectedItem);
    _selectedItemController.sink.add(_selectedItemList);
  }

  // DELETE SELECTED ITEM
  deleteSelectedItem(SelectedItems selectedItems) {
    var itemToUpdate = _itemList.firstWhere((element) => element.roomId == selectedItems.roomId && element.cId == selectedItems.cId, orElse: () {
      return null;
    });
    _selectedItemList.remove(selectedItems);
    _selectedItemController.sink.add(_selectedItemList);
    if (itemToUpdate != null) {
      itemToUpdate.isSelected = false;
      _itemListController.sink.add(_itemList);
    }
  }

  // UPDATE SELECTED ITEM QUANTITY
  updateSelectedItem(SelectedItems selectedItems, int quantity) {
    var itemToUpdate = _selectedItemList.firstWhere((element) => element.roomId == selectedItems.roomId && element.cId == selectedItems.roomId, orElse: () {
      return null;
    });
    itemToUpdate.quantity = quantity;
    print("${itemToUpdate.quantity}");
    _selectedItemController.sink.add(_selectedItemList);

  }

  @override
  void dispose() {
    _roomListController.close();
    _itemListController.close();
    _selectedItemController.close();
  }
}