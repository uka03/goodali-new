// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodResponse _$MoodResponseFromJson(Map<String, dynamic> json) => MoodResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MoodResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$MoodResponseToJson(MoodResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

MoodResponseData _$MoodResponseDataFromJson(Map<String, dynamic> json) =>
    MoodResponseData(
      banner: json['banner'] as String?,
      id: (json['id'] as num?)?.toInt(),
      moodId: (json['mood_id'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$MoodResponseDataToJson(MoodResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'banner': instance.banner,
      'title': instance.title,
      'order': instance.order,
      'mood_id': instance.moodId,
    };

MoodItemResponse _$MoodItemResponseFromJson(Map<String, dynamic> json) =>
    MoodItemResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => MoodItemResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$MoodItemResponseToJson(MoodItemResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

MoodItemResponseData _$MoodItemResponseDataFromJson(
        Map<String, dynamic> json) =>
    MoodItemResponseData(
      audio: json['audio'] as String?,
      audioDuration: (json['audio_duration'] as num?)?.toInt(),
      body: json['body'] as String?,
      banner: json['banner'] as String?,
      id: (json['id'] as num?)?.toInt(),
      moodListId: (json['mood_list_id'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$MoodItemResponseDataToJson(
        MoodItemResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'banner': instance.banner,
      'body': instance.body,
      'title': instance.title,
      'order': instance.order,
      'audio': instance.audio,
      'audio_duration': instance.audioDuration,
      'mood_list_id': instance.moodListId,
      'status': instance.status,
    };
