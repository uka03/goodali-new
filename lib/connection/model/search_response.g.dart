// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SearchResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

SearchResponseData _$SearchResponseDataFromJson(Map<String, dynamic> json) =>
    SearchResponseData(
      album: (json['album'] as num?)?.toInt(),
      body: json['body'] as String?,
      id: (json['id'] as num?)?.toInt(),
      module: json['module'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$SearchResponseDataToJson(SearchResponseData instance) =>
    <String, dynamic>{
      'module': instance.module,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'album': instance.album,
    };
