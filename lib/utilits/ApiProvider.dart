import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/EditModel.dart';
import 'package:fortune/Model/MarketingListModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/utilits/ApiService.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ApiService(dio);
});

final serviceListProvider = FutureProvider<ServiceListModel?>((ref) async {
  return ref.watch(apiServiceProvider).getServiceListApi();
});

final serviceDataProvider = FutureProvider<ServiceModel?>((ref) async {
  return ref.watch(apiServiceProvider).getServiceDataApi();
});

final serviceEditProvider =
    FutureProvider.autoDispose.family<EditModel?, String>((ref, id) async {
  return ref.watch(apiServiceProvider).getServiceEditApi(id);
});

final serviceHistoryProvider = FutureProvider.autoDispose
    .family<ServiceHistoryModel?, String>((ref, id) async {
  return ref.watch(apiServiceProvider).getServiceHistoryApi(id);
});

final marketingListProvider = FutureProvider<MarketingListModel?>((ref) async {
  return ref.watch(apiServiceProvider).getMarketingListApi();
});

final marketingDataProvider = FutureProvider<ServiceModel?>((ref) async {
  return ref.watch(apiServiceProvider).getMarketingDataApi();
});
