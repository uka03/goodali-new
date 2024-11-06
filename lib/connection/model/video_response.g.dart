// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoResponse _$VideoResponseFromJson(Map<String, dynamic> json) =>
    VideoResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => VideoResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$VideoResponseToJson(VideoResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

VideoResponseData _$VideoResponseDataFromJson(Map<String, dynamic> json) =>
    VideoResponseData(
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: (json['id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      title: json['title'] as String?,
      videoUrl: json['video_url'] as String?,
    );

Map<String, dynamic> _$VideoResponseDataToJson(VideoResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'banner': instance.banner,
      'body': instance.body,
      'video_url': instance.videoUrl,
      'status': instance.status,
      'created_at': instance.createdAt,
    };
