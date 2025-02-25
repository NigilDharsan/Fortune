import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/ActivityEditModel.dart';
import 'package:fortune/Model/AttendanceLogsModel.dart';
import 'package:fortune/Model/ClientsModel.dart';
import 'package:fortune/Model/DailyActivitiesModel.dart';
import 'package:fortune/Model/DashboardModel.dart';
import 'package:fortune/Model/EditGeneralModel.dart';
import 'package:fortune/Model/EditModel.dart';
import 'package:fortune/Model/EditSpareModel.dart';
import 'package:fortune/Model/ExectiveModel.dart';
import 'package:fortune/Model/GeneralListModel.dart';
import 'package:fortune/Model/ItemsEditModel.dart';
import 'package:fortune/Model/ItemsModel.dart';
import 'package:fortune/Model/LoginModel.dart';
import 'package:fortune/Model/MarketingEditModel.dart';
import 'package:fortune/Model/MarketingHistoryModel.dart';
import 'package:fortune/Model/MarketingListModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/Model/SparesListModel.dart';
import 'package:fortune/Model/StockItemModel.dart';
import 'package:fortune/Model/StocksEditModel.dart';
import 'package:fortune/Model/StocksModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:fortune/utilits/MakeApiCall.dart';

import 'ConstantsApi.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(LogInterceptor(responseBody: true)); // For debugging
  return dio;
});

class ApiService {
  final Dio _dio;
  ApiService(this._dio);

  T _fromJson<T>(dynamic json) {
    if (json != null) {
      if (T == LoginModel) {
        return LoginModel.fromJson(json) as T;
      } else if (T == SuccessModel) {
        return SuccessModel.fromJson(json) as T;
      }
    } else {
      final jsonResponse = {
        'status': false,
        'message': ConstantApi.SOMETHING_WRONG, //Server not responding
      };
      json = jsonResponse;
    }

    // Add more conditionals for other model classes as needed
    throw Exception("Unknown model type");
  }

  Future<T> _requestGET<T>(BuildContext context, String path) async {
    try {
      final response = await _dio.get(path);
      return _fromJson<T>(response.data);
    } on DioException catch (e) {
      // Handle DioError, you can log or display an error message.
      return _fromJson<T>(e.response?.data);
    } catch (e) {
      // Handle other exceptions here
      throw e;
    }
  }

  Future<T> _requestPOST<T>(
    String path, {
    FormData? data,
  }) async {
    try {
      final response = await _dio.post(path, data: data);

      return _fromJson<T>(response.data);
    } on DioException catch (e) {
      // Handle DioError, you can log or display an error message.

      return _fromJson<T>(e.response?.data);
    } catch (e) {
      // Handle other exceptions here

      throw e;
    }
  }

  Future<T> _requestPOST1<T>(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(path, data: data);

      return _fromJson<T>(response.data);
    } on DioException catch (e) {
      // Handle DioError, you can log or display an error message.

      return _fromJson<T>(e.response?.data);
    } catch (e) {
      // Handle other exceptions here

      throw e;
    }
  }

  Future<T> _requestPOST2<T>(
    String path, {
    FormData? data,
  }) async {
    try {
      final response = await _dio.put(path, data: data);

      return _fromJson<T>(response.data);
    } on DioException catch (e) {
      // Handle DioError, you can log or display an error message.

      return _fromJson<T>(e.response?.data);
    } catch (e) {
      // Handle other exceptions here

      throw e;
    }
  }

  Future<T> _requestPOST3<T>(
    String path, {
    FormData? data,
  }) async {
    try {
      String? accessToken = await getToken();

      _dio.options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };

      final response = await _dio.post(path, data: data);

      return _fromJson<T>(response.data);
    } on DioException catch (e) {
      // Handle DioError, you can log or display an error message.

      return _fromJson<T>(e.response?.data);
    } catch (e) {
      // Handle other exceptions here

      throw e;
    }
  }

  Future<dynamic> get<T>(BuildContext context, String path) async {
    return _requestGET<T>(context, path);
  }

  Future<T> post<T>(String path, FormData data) async {
    return _requestPOST<T>(path, data: data);
  }

  Future<T> post1<T>(String path, Map<String, dynamic> data) async {
    return _requestPOST1<T>(path, data: data);
  }

  Future<T> post2<T>(String path, FormData data) async {
    return _requestPOST2<T>(path, data: data);
  }

  Future<T> post3<T>(String path, FormData data) async {
    return _requestPOST3<T>(path, data: data);
  }

  Future<T> login<T>(String path, FormData data) async {
    Dio dio = Dio();

    dio.options = BaseOptions(
      baseUrl: ConstantApi.SERVER_ONE, // Your base URL
      validateStatus: (status) {
        // Return true if the status code is between 200 and 299 (inclusive)
        // Return false if you want to throw an error for this status code
        return status! >= 200 && status < 300 || status == 404;
      },
    );

    try {
      Response response = await dio.post(path, data: data);
      // Handle successful response

      print(response.data);
      return _fromJson<T>(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 404) {
        // Handle 404 error

        print('Resource not found');
        return _fromJson<T>(e.response!.data);
      } else {
        if (T == LoginModel) {
          return LoginModel() as T;
        } else if (T == SuccessModel) {
          return SuccessModel() as T;
        }
        throw e;
      }
    }
  }

  Future<AttendanceLogsModel> getUserLogApi(FormData formData) async {
    final result = await requestPOST(
        url: ConstantApi.usersLogListUrl, formData: formData, dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return AttendanceLogsModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = AttendanceLogsModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return AttendanceLogsModel();
  }

  Future<DashboardModel> getDashboardApi() async {
    final result = await requestGET(url: ConstantApi.dashboardUrl, dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return DashboardModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = DashboardModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return DashboardModel();
  }

  Future<ServiceListModel> getServiceListApi() async {
    // var formData = FormData.fromMap({
    //   "executive_id": "",
    //   "client_id": "",
    //   "status_id": "",
    //   "daterange": ""
    // });
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.servicesList, formData: singleTon.formData, dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ServiceListModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ServiceListModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ServiceListModel();
  }

  Future<List<ServicesData>> getServiceListPaginationApi() async {
    // var formData = FormData.fromMap({
    //   "executive_id": "",
    //   "client_id": "",
    //   "status_id": "",
    //   "daterange": ""
    // });
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.servicesList, formData: singleTon.formData, dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      final results = ServiceListModel?.fromJson(result["response"]);

      return results.data?.services?.data ?? [];
    } else {
      try {
        var resultval = ServiceListModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval.data?.services?.data ?? [];
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return [];
  }

  Future<EditModel> getServiceEditApi(String service_id) async {
    final result = await requestGET(
        url: ConstantApi.servicesStore + "/${service_id}/" + "edit", dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return EditModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = EditModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return EditModel();
  }

  Future<SuccessModel> EditServiceData(
      String service_id, FormData formData) async {
    final result = await requestMultiPart(
        url: ConstantApi.servicesStore + "/${service_id}", formData: formData);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return SuccessModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = SuccessModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return SuccessModel();
  }

  Future<SuccessModel> AddServiceData(FormData formData) async {
    final result = await requestMultiPart(
        url: ConstantApi.servicesStore, formData: formData);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return SuccessModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = SuccessModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return SuccessModel();
  }

  Future<ServiceHistoryModel> getServiceHistoryApi(String service_id) async {
    var formData = FormData.fromMap({});

    final result = await requestPOST(
        url: ConstantApi.servicesHistory + service_id,
        formData: formData,
        dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ServiceHistoryModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ServiceHistoryModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ServiceHistoryModel();
  }

  Future<DailyActivitiesModel> getDailyStockListApi() async {
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.activitiesList,
        formData: singleTon.formData,
        dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return DailyActivitiesModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = DailyActivitiesModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return DailyActivitiesModel();
  }

  Future<ActivityEditModel> getActivityEditApi(String activity_id) async {
    final result = await requestGET(
        url: ConstantApi.activitiesCreate + "/${activity_id}/" + "edit",
        dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ActivityEditModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ActivityEditModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ActivityEditModel();
  }

  Future<StockItemModel> getActivityItemApi() async {
    final result = await requestGET(
        url: ConstantApi.activitiesCreate + "/create", dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return StockItemModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = StockItemModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return StockItemModel();
  }

  Future<StocksModel> getStocksListApi() async {
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.stocksList, formData: singleTon.formData, dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return StocksModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = StocksModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return StocksModel();
  }

  Future<StockItemModel> getStocksItemApi() async {
    final result =
        await requestGET(url: ConstantApi.stocksCreate + "/create", dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return StockItemModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = StockItemModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return StockItemModel();
  }

  Future<StocksEditModel> getStocksEditApi(String stocks_id) async {
    final result = await requestGET(
        url: ConstantApi.stocksCreate + "/${stocks_id}/" + "edit", dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return StocksEditModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = StocksEditModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return StocksEditModel();
  }

  Future<MarketingHistoryModel> getMarketingHistoryApi(
      String service_id) async {
    var formData = FormData.fromMap({});

    final result = await requestPOST(
        url: ConstantApi.marketingHistory + service_id,
        formData: formData,
        dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return MarketingHistoryModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = MarketingHistoryModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return MarketingHistoryModel();
  }

  Future<ServiceModel> getServiceDataApi() async {
    final result = await requestGET(url: ConstantApi.servicesCreate, dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ServiceModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ServiceModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ServiceModel();
  }

  Future<MarketingListModel> getMarketingListApi() async {
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.marketingList,
        formData: singleTon.formData,
        dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return MarketingListModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = MarketingListModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return MarketingListModel();
  }

  Future<MarketingEditModel> getMarketingEditApi(String service_id) async {
    final result = await requestGET(
        url: ConstantApi.marketingStore + "/${service_id}/" + "edit",
        dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return MarketingEditModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = MarketingEditModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return MarketingEditModel();
  }

  Future<ServiceModel> getMarketingDataApi() async {
    final result =
        await requestGET(url: ConstantApi.marketingCreate, dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ServiceModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ServiceModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ServiceModel();
  }

  Future<GeneralListModel> getGeneralListApi() async {
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.generalListUrl,
        formData: singleTon.formData,
        dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return GeneralListModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = GeneralListModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return GeneralListModel();
  }

  Future<EditGeneralModel> getGeneralEditApi(String service_id) async {
    final result = await requestGET(
        url: ConstantApi.editGeneralUrl + "/${service_id}", dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return EditGeneralModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = EditGeneralModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return EditGeneralModel();
  }
//Spare List

  Future<SparesListModel> getSparesListApi() async {
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.sparesListUrl,
        formData: singleTon.formData,
        dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return SparesListModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = SparesListModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return SparesListModel();
  }

  Future<StockItemModel> getSparesItemApi() async {
    final result = await requestGET(url: ConstantApi.sparesItemUrl, dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return StockItemModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = StockItemModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return StockItemModel();
  }

  Future<EditSpareModel> getSparesEditApi(String stocks_id) async {
    final result = await requestGET(
        url: ConstantApi.editSparesItemUrl + "/${stocks_id}/", dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return EditSpareModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = EditSpareModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return EditSpareModel();
  }

  Future<ExectiveModel> getExecutiveListApi() async {
    final result =
        await requestGET(url: ConstantApi.getExecutiveListUrl, dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ExectiveModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ExectiveModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ExectiveModel();
  }
  // Client Api

  Future<ClientsModel> getClientListApi() async {
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.clientList, formData: singleTon.formData, dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ClientsModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ClientsModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ClientsModel();
  }

  Future<ActivityEditModel> getClientEditApi(String client_id) async {
    final result = await requestGET(
        url: ConstantApi.clientCreate + "/${client_id}/" + "edit", dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ActivityEditModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ActivityEditModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ActivityEditModel();
  }

// Items Api

  Future<ItemsModel> getItemsListApi() async {
    SingleTon singleTon = SingleTon();

    final result = await requestPOST(
        url: ConstantApi.itemsList, formData: FormData(), dio: _dio);
    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ItemsModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ItemsModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ItemsModel();
  }

  Future<ItemsEditModel> getItemsEditApi(String item_id) async {
    final result = await requestGET(
        url: ConstantApi.itemsCreate + "/${item_id}/" + "edit", dio: _dio);

    if (result["success"] == true) {
      print("resultOTP:$result");
      print("resultOTPsss:${result["success"]}");
      return ItemsEditModel?.fromJson(result["response"]);
    } else {
      try {
        var resultval = ItemsEditModel.fromJson(result["response"]);
        // Toast.show(resultval.message.toString(), context);
        print(result["response"]);
        return resultval;
      } catch (e) {
        print(result["response"]);
        // Toast.show(result["response"], context);
      }
    }
    return ItemsEditModel();
  }
}
