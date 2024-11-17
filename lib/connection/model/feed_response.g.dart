// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) => FeedResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FeedResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$FeedResponseToJson(FeedResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

FeedResponseData _$FeedResponseDataFromJson(Map<String, dynamic> json) =>
    FeedResponseData(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      likes: (json['likes'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      selfLike: json['self_like'] as bool?,
      replys: (json['replys'] as List<dynamic>?)
          ?.map((e) => ReplyResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      nickName: json['nick_name'] as String?,
      avatar: json['avatar'] as String?,
      isLike: _valueNotifierNullableFromJson(json['isLike'] as bool?),
      userId: (json['user_id'] as num?)?.toInt(),
    )..replyCount = _valueNotifierIntNullableFromJson(
        (json['replyCount'] as num?)?.toInt());

Map<String, dynamic> _$FeedResponseDataToJson(FeedResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'likes': instance.likes,
      'tags': instance.tags,
      'created_at': instance.createdAt,
      'self_like': instance.selfLike,
      'replys': instance.replys,
      'nick_name': instance.nickName,
      'user_id': instance.userId,
      'avatar': instance.avatar,
      'isLike': _valueNotifierNullableToJson(instance.isLike),
      'replyCount': _valueNotifierIntNullableToJson(instance.replyCount),
    };

ReplyResponse _$ReplyResponseFromJson(Map<String, dynamic> json) =>
    ReplyResponse(
      data: json['data'] == null
          ? null
          : ReplyResponseData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$ReplyResponseToJson(ReplyResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

ReplyResponseData _$ReplyResponseDataFromJson(Map<String, dynamic> json) =>
    ReplyResponseData(
      body: json['body'] as String?,
      nickName: json['nick_name'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      avatar: json['avatar'] as String?,
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ReplyResponseDataToJson(ReplyResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'nick_name': instance.nickName,
      'user_id': instance.userId,
      'avatar': instance.avatar,
      'created_at': instance.createdAt,
    };
