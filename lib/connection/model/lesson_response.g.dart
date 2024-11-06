// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonResponse _$LessonResponseFromJson(Map<String, dynamic> json) =>
    LessonResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LessonResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$LessonResponseToJson(LessonResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

LessonResponseData _$LessonResponseDataFromJson(Map<String, dynamic> json) =>
    LessonResponseData(
      allTask: (json['all_task'] as num?)?.toInt(),
      banner: json['banner'] as String?,
      done: (json['done'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      locked: json['locked'] as bool?,
      name: json['name'] as String?,
      openDate: json['openDate'] as String?,
    );

Map<String, dynamic> _$LessonResponseDataToJson(LessonResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'banner': instance.banner,
      'all_task': instance.allTask,
      'done': instance.done,
      'openDate': instance.openDate,
      'locked': instance.locked,
    };

TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) => TaskResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TaskResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$TaskResponseToJson(TaskResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

TaskResponseData _$TaskResponseDataFromJson(Map<String, dynamic> json) =>
    TaskResponseData(
      answerData: json['answer_data'] as String?,
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isAnswer: (json['is_answer'] as num?)?.toInt(),
      isAnswered: (json['is_answered'] as num?)?.toInt(),
      lessonId: (json['lesson_id'] as num?)?.toInt(),
      listenAudio: json['listen_audio'] as String?,
      question: json['question'] as String?,
      type: (json['type'] as num?)?.toInt(),
      videoUrl: json['video_url'] as String?,
    );

Map<String, dynamic> _$TaskResponseDataToJson(TaskResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'question': instance.question,
      'body': instance.body,
      'banner': instance.banner,
      'listen_audio': instance.listenAudio,
      'video_url': instance.videoUrl,
      'lesson_id': instance.lessonId,
      'is_answer': instance.isAnswer,
      'is_answered': instance.isAnswered,
      'answer_data': instance.answerData,
    };
