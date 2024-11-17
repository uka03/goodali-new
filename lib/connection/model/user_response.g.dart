// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      data: json['data'] == null
          ? null
          : UserResponseData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

UserResponseData _$UserResponseDataFromJson(Map<String, dynamic> json) =>
    UserResponseData(
      avatar: json['avatar'] as String?,
      createdAt: json['created_at'] as String?,
      email: json['email'] as String?,
      id: (json['id'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      hasTraining: json['hasTraining'] as bool?,
    );

Map<String, dynamic> _$UserResponseDataToJson(UserResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'created_at': instance.createdAt,
      'hasTraining': instance.hasTraining,
    };
