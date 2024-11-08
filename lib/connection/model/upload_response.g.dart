// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) =>
    UploadResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UploadResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$UploadResponseToJson(UploadResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

UploadResponseData _$UploadResponseDataFromJson(Map<String, dynamic> json) =>
    UploadResponseData(
      filePath: json['filePath'] as String?,
      label: json['label'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$UploadResponseDataToJson(UploadResponseData instance) =>
    <String, dynamic>{
      'label': instance.label,
      'filePath': instance.filePath,
      'url': instance.url,
    };
