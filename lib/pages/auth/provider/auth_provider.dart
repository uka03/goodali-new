import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/faq_response.dart';
import 'package:goodali/connection/model/login_response.dart';
import 'package:goodali/connection/model/user_response.dart';
import 'package:goodali/utils/types.dart';

class AuthProvider extends ChangeNotifier {
  final _dio = DioClient();
  UserResponseData? user;

  Future<LoginResponse> login(AuthInfo info) async {
    final response = await _dio.login(info);
    if (response.data?.token?.isNotEmpty == true) {
      const storage = FlutterSecureStorage();
      await storage.write(key: "token", value: response.data?.token);
      user = response.data?.user;
    }
    notifyListeners();
    return response;
  }

  Future<BaseResponse> verify(AuthInfo info) async {
    final response = await _dio.verify(info);
    notifyListeners();
    return response;
  }

  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: "token");
    user = null;
    notifyListeners();
  }

  Future<LoginResponse> register(AuthInfo info) async {
    final response = await _dio.register(info);
    if (response.data?.token?.isNotEmpty == true) {
      const storage = FlutterSecureStorage();
      await storage.write(key: "token", value: response.data?.token);
      user = response.data?.user;
    }
    notifyListeners();
    return response;
  }

  Future<BaseResponse> checkUser(String email) async {
    final response = await _dio.userCheck(email);

    return response;
  }

  Future<BaseResponse> sendOTP(String email) async {
    final response = await _dio.sendOTP(email);

    return response;
  }

  Future<BaseResponse> forgetPassword(AuthInfo info) async {
    final response = await _dio.forgot(info);
    return response;
  }

  Future<UserResponseData?> getMe() async {
    final store = FlutterSecureStorage();
    final token = await store.read(key: "token");
    if (token?.isNotEmpty == true) {
      final response = await _dio.getMe();
      user = response.data;
      notifyListeners();
      return user;
    } else {
      user = null;
      notifyListeners();
      return null;
    }
  }

  Future<FaqResponse> getFaq({String? page, String? limit}) async {
    final response = await _dio.getFaq(
      page: page,
      limit: limit,
    );
    return response;
  }

  Future<BaseResponse> changePassword(String? current, String? password) async {
    final response = await _dio.changePassword(current, password);
    return response;
  }
}
