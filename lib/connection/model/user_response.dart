import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_response.g.dart';

@JsonSerializable()
class UserResponse extends BaseResponse {
  final UserResponseData? data;

  UserResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class UserResponseData {
  final int? id;
  final String? email;
  final String? nickname;
  final String? avatar;
  @JsonKey(name: "created_at")
  final String? createdAt;
  final bool? hasTraining;

  UserResponseData({
    required this.avatar,
    required this.createdAt,
    required this.email,
    required this.id,
    required this.nickname,
    required this.hasTraining,
  });

  factory UserResponseData.fromJson(Map<String, dynamic> json) => _$UserResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseDataToJson(this);
}
