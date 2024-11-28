// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackResponse _$FeedbackResponseFromJson(Map<String, dynamic> json) =>
    FeedbackResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FeedbackResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$FeedbackResponseToJson(FeedbackResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

FeedbackResponseData _$FeedbackResponseDataFromJson(
        Map<String, dynamic> json) =>
    FeedbackResponseData(
      avatar: json['avatar'] as String?,
      lectureName: json['lectureName'] as String?,
      nickName: json['nickName'] as String?,
      text: json['text'] as String?,
      createdAt: json['createdAt'] as String?,
      trainingName: json['trainingName'] as String?,
    );

Map<String, dynamic> _$FeedbackResponseDataToJson(
        FeedbackResponseData instance) =>
    <String, dynamic>{
      'text': instance.text,
      'lectureName': instance.lectureName,
      'trainingName': instance.trainingName,
      'nickName': instance.nickName,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt,
    };
