// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqResponse _$FaqResponseFromJson(Map<String, dynamic> json) => FaqResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FaqResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$FaqResponseToJson(FaqResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

FaqResponseData _$FaqResponseDataFromJson(Map<String, dynamic> json) =>
    FaqResponseData(
      id: (json['id'] as num?)?.toInt(),
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FaqResponseDataToJson(FaqResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'status': instance.status,
    };
