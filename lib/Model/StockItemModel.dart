class StockItemModel {
  bool? success;
  List<StockItemData>? data;
  String? message;

  StockItemModel({this.success, this.data, this.message});

  StockItemModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <StockItemData>[];
      json['data'].forEach((v) {
        data!.add(new StockItemData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class StockItemData {
  int? id;
  String? itemName;

  StockItemData({this.id, this.itemName});

  StockItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_name'] = this.itemName;
    return data;
  }
}
