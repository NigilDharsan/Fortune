import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/utilits/ApiService.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ApiService(dio);
});

final serviceDataProvider = FutureProvider<ServiceModel?>((ref) async {
  return ref.watch(apiServiceProvider).getServiceDataApi();
});

final marketingDataProvider = FutureProvider<ServiceModel?>((ref) async {
  return ref.watch(apiServiceProvider).getMarketingDataApi();
});