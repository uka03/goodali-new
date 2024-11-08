import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'lesson_response.g.dart';

@JsonSerializable()
class LessonResponse extends BaseResponse {
  final List<LessonResponseData>? data;

  LessonResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) => _$LessonResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$LessonResponseToJson(this);
}

@JsonSerializable()
class LessonResponseData {
  final int? id;
  final String? name;
  final String? banner;
  @JsonKey(name: "all_task")
  final int? allTask;
  final int? done;
  final String? openDate;
  final bool? locked;

  LessonResponseData({
    required this.allTask,
    required this.banner,
    required this.done,
    required this.id,
    required this.locked,
    required this.name,
    required this.openDate,
  });

  factory LessonResponseData.fromJson(Map<String, dynamic> json) => _$LessonResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$LessonResponseDataToJson(this);
}

@JsonSerializable()
class TaskResponse extends BaseResponse {
  final List<TaskResponseData>? data;

  TaskResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) => _$TaskResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);
}

@JsonSerializable()
class TaskResponseData {
  final int? id;
  final int? type;
  final String? question;
  final String? body;
  final String? banner;
  @JsonKey(name: "listen_audio")
  final String? listenAudio;
  @JsonKey(name: "video_url")
  final String? videoUrl;
  @JsonKey(name: "lesson_id")
  final int? lessonId;
  @JsonKey(name: "is_answer")
  final int? isAnswer;
  @JsonKey(name: "is_answered")
  int? isAnswered;
  @JsonKey(name: "answer_data")
  String? answerData;

  TaskResponseData({
    required this.answerData,
    required this.banner,
    required this.body,
    required this.id,
    required this.isAnswer,
    required this.isAnswered,
    required this.lessonId,
    required this.listenAudio,
    required this.question,
    required this.type,
    required this.videoUrl,
  });

  factory TaskResponseData.fromJson(Map<String, dynamic> json) => _$TaskResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$TaskResponseDataToJson(this);
}
