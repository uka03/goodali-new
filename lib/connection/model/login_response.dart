import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/user_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends BaseResponse {
  final LoginResponseData? data;

  LoginResponse({
    required this.data,
    super.error,
    super.success,
    super.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginResponseData {
  final String? token;
  final UserResponseData? user;

  LoginResponseData({
    required this.token,
    required this.user,
  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) => _$LoginResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDataToJson(this);
}
