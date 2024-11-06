// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PostResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$PostResponseToJson(PostResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

PostResponseData _$PostResponseDataFromJson(Map<String, dynamic> json) =>
    PostResponseData(
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isSpecial: json['isSpecial'] as bool?,
      order: (json['order'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$PostResponseDataToJson(PostResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'banner': instance.banner,
      'order': instance.order,
      'isSpecial': instance.isSpecial,
      'tags': instance.tags,
      'created_at': instance.createdAt,
    };
