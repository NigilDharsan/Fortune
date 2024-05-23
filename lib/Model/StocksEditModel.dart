import 'package:fortune/Model/StockItemModel.dart';

class StocksEditModel {
  bool? success;
  Data? data;
  String? message;

  StocksEditModel({this.success, this.data, this.message});

  StocksEditModel.fromJson(Map<String, dynamic> json) {
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
  List<StockItemData>? items;
  StocksEditData? data;

  Data({this.items, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <StockItemData>[];
      json['items'].forEach((v) {
        items!.add(new StockItemData.fromJson(v));
      });
    }
    data =
        json['data'] != null ? new StocksEditData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StocksEditData {
  int? id;
  String? itemName;
  String? availableStock;
  int? companyId;
  int? branchId;
  int? addedBy;
  String? createdAt;
  String? updatedAt;

  StocksEditData(
      {this.id,
      this.itemName,
      this.availableStock,
      this.companyId,
      this.branchId,
      this.addedBy,
      this.createdAt,
      this.updatedAt});

  StocksEditData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    availableStock = json['available_stock'];
    companyId = json['company_id'];
    branchId = json['branch_id'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_name'] = this.itemName;
    data['available_stock'] = this.availableStock;
    data['company_id'] = this.companyId;
    data['branch_id'] = this.branchId;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
