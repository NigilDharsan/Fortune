import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/LoginModel.dart';

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
    BuildContext context,
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

  Future<dynamic> get<T>(BuildContext context, String path) async {
    return _requestGET<T>(context, path);
  }

  Future<T> post<T>(BuildContext context, String path, FormData data) async {
    return _requestPOST<T>(context, path, data: data);
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
      Response response = await dio.post(ConstantApi.loginUrl, data: data);
      // Handle successful response

      print(response.data);
      return _fromJson<T>(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 404) {
        // Handle 404 error

        print('Resource not found');
        return _fromJson<T>(e.response!.data);
      } else {
        // Handle other Dio errors
        print('Error: ${e.message}');
        throw e;
      }
    }
  }
}
