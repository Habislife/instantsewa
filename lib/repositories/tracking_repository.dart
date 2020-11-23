import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:instantsewa/application/InstantSewa_api.dart';
import 'package:instantsewa/application/classes/errors/common_error.dart';
import 'package:instantsewa/application/classes/user/ongoing_tracker.dart';
import 'package:instantsewa/application/storage/localstorage.dart';
import 'package:instantsewa/application/storage/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
abstract class TrackingRepository {
  Future<List<OperationTracker>> getOngoingProject();
  Future<List<OperationTracker>> getCompletedProject();
}
class TrackingRepositoryImpl implements TrackingRepository {
  @override
  Future<List<OperationTracker>> getOngoingProject() async{
    try {
      String id;
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user = jsonDecode(localStorage.getString('user'));
      id = user['id'].toString();
      Response response = await InstantSewaAPI.dio
          .post("/ongoingtracker", data: {
        "service_user_id": id,
      }, options: Options(headers: {
        'Authorization': "Bearer ${LocalStorage.getItem(TOKEN)}"
      }));
      List _temp = response.data['data'];
      List<OperationTracker> _serviceProviders = _temp
          .map((serviceprovider) => OperationTracker.fromJson(serviceprovider))
          .toList();
      return _serviceProviders;
    } on DioError catch (e) {
      throw showNetworkError(e);
    }
  }
  @override
  Future<List<OperationTracker>> getCompletedProject() async{
    try {
      String id;
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user = jsonDecode(localStorage.getString('user'));
      id = user['id'].toString();
      Response response = await InstantSewaAPI.dio
          .post("/completedtracker", data: {
        "service_user_id": id,
      }, options: Options(headers: {
        'Authorization': "Bearer ${LocalStorage.getItem(TOKEN)}"
      }));
      List _temp = response.data['data'];
      List<OperationTracker> _serviceProviders = _temp
          .map((serviceprovider) => OperationTracker.fromJson(serviceprovider))
          .toList();
      return _serviceProviders;
    } on DioError catch (e) {
      throw showNetworkError(e);
    }
  }
}
