import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/DailyActivitiesModel.dart';
import 'package:fortune/Model/DashboardModel.dart';
import 'package:fortune/Model/EditModel.dart';
import 'package:fortune/Model/MarketingEditModel.dart';
import 'package:fortune/Model/MarketingHistoryModel.dart';
import 'package:fortune/Model/MarketingListModel.dart';
import 'package:fortune/Model/ServiceHistoryModel.dart';
import 'package:fortune/Model/ServiceListModel.dart';
import 'package:fortune/Model/ServiceModel.dart';
import 'package:fortune/Model/StockItemModel.dart';
import 'package:fortune/Model/StocksModel.dart';
import 'package:fortune/Model/SuccessModel.dart';
import 'package:fortune/utilits/ApiService.dart';
import 'package:tuple/tuple.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ApiService(dio);
});

final dashboardProvider =
    FutureProvider.autoDispose<DashboardModel?>((ref) async {
  return ref.watch(apiServiceProvider).getDashboardApi();
});

final serviceListProvider =
    FutureProvider.autoDispose<ServiceListModel?>((ref) async {
  return ref.watch(apiServiceProvider).getServiceListApi();
});

final serviceDataProvider = FutureProvider<ServiceModel?>((ref) async {
  return ref.watch(apiServiceProvider).getServiceDataApi();
});

final serviceEditProvider =
    FutureProvider.autoDispose.family<EditModel?, String>((ref, id) async {
  return ref.watch(apiServiceProvider).getServiceEditApi(id);
});

final serviceUpdateProvider = FutureProvider.autoDispose
    .family<SuccessModel?, Tuple2<String, FormData>>((ref, tuple) async {
  final id = tuple.item1;
  final formData = tuple.item2;

  return ref.watch(apiServiceProvider).EditServiceData(id, formData);
});

final servicePostProvider = FutureProvider.autoDispose
    .family<SuccessModel?, FormData>((ref, formData) async {
  return ref.watch(apiServiceProvider).AddServiceData(formData);
});

final serviceHistoryProvider = FutureProvider.autoDispose
    .family<ServiceHistoryModel?, String>((ref, id) async {
  return ref.watch(apiServiceProvider).getServiceHistoryApi(id);
});

final marketingListProvider =
    FutureProvider.autoDispose<MarketingListModel?>((ref) async {
  return ref.watch(apiServiceProvider).getMarketingListApi();
});

final marketingDataProvider =
    FutureProvider.autoDispose<ServiceModel?>((ref) async {
  return ref.watch(apiServiceProvider).getMarketingDataApi();
});

final marketingEditProvider = FutureProvider.autoDispose
    .family<MarketingEditModel?, String>((ref, id) async {
  return ref.watch(apiServiceProvider).getMarketingEditApi(id);
});

final marketingHistoryProvider = FutureProvider.autoDispose
    .family<MarketingHistoryModel?, String>((ref, id) async {
  return ref.watch(apiServiceProvider).getMarketingHistoryApi(id);
});

final activityListProvider =
    FutureProvider.autoDispose<DailyActivitiesModel?>((ref) async {
  return ref.watch(apiServiceProvider).getDailyStockListApi();
});

final stocksListProvider =
    FutureProvider.autoDispose<StocksModel?>((ref) async {
  return ref.watch(apiServiceProvider).getStocksListApi();
});

final stocksItemProvider =
    FutureProvider.autoDispose<StockItemModel?>((ref) async {
  return ref.watch(apiServiceProvider).getStocksItemApi();
});

final stocksEditProvider =
    FutureProvider.autoDispose.family<StockItemModel?, String>((ref, id) async {
  return ref.watch(apiServiceProvider).getStocksEditApi(id);
});

// PAGINATION IMPLEMENTATION
// final serviceListProvider1 = StateProvider<List<ServicesData>>((ref) => []);
// final currentPageProvider = StateProvider<int>((ref) => 1);

// final fetchDataProvider = FutureProvider.autoDispose<List<ServicesData>>((ref) async {
//   // final currentPage = ref.watch(currentPageProvider).state;

//   final currentPage =
//     ref.watch(currentPageProvider); // Correctly accessing the provider

// // Now you can use `currentPage` to access the state value
// final currentPageValue = currentPage; // This will be an integer

//   final formData = FormData.fromMap({
//     "executive_id": "",
//     "client_id": "",
//     "status_id": "",
//     "daterange": "",
//     "page": "currentPage",
//   });

//   // Make your API call here using formData
//   final newData = await yourApiCall(formData);

//   return newData;
// });
final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});

final serviceListPaginationProvider =
    FutureProvider.autoDispose<List<ServicesData>?>((ref) async {
  return ref.watch(apiServiceProvider).getServiceListPaginationApi();
});

final serviceListPagination = FutureProvider<List<ServicesData>?>((ref) async {
  return ref.watch(apiServiceProvider).getServiceListPaginationApi();
});

final serviceListPagination1 = FutureProvider<List<ServicesData>?>((ref) async {
  return ref.watch(apiServiceProvider).getServiceListPaginationApi();
});

final itemListFutureProvider = FutureProvider<List<ServicesData>>((ref) async {
  // Simulate an asynchronous operation, e.g., fetching data from an API
  await Future.delayed(Duration(seconds: 1));

  // Get the existing list of items from the itemListProvider
  final List<ServicesData> existingItems =
      await ref.read(apiServiceProvider).getServiceListPaginationApi();

  // Simulate appending new items to the existing list
  final List<ServicesData> fetchedItems = await ref
      .watch(apiServiceProvider)
      .getServiceListPaginationApi(); // Fetch data from your API or other source

  // Combine existing items with newly fetched items
  final List<ServicesData> updatedList = List.from(existingItems)
    ..addAll(fetchedItems);

  return updatedList;
});
