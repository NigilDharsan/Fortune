class ItemsEditModel {
  bool? success;
  Data? data;
  String? message;

  ItemsEditModel({this.success, this.data, this.message});

  ItemsEditModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  ItemsEditData? data;

  Data({this.data});

  Data.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new ItemsEditData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ItemsEditData {
  int? id;
  int? itemId;
  String? itemName;
  String? itemType;
  String? itemCategory;
  int? addedBy;
  String? createdAt;
  String? updatedAt;

  ItemsEditData(
      {this.id,
      this.itemId,
      this.itemName,
      this.itemType,
      this.itemCategory,
      this.addedBy,
      this.createdAt,
      this.updatedAt});

  ItemsEditData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    itemCategory = json['item_category'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['item_name'] = this.itemName;
    data['item_type'] = this.itemType;
    data['item_category'] = this.itemCategory;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
