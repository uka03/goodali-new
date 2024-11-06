import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'mood_response.g.dart';

@JsonSerializable()
class MoodResponse extends BaseResponse {
  final List<MoodResponseData>? data;

  MoodResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory MoodResponse.fromJson(Map<String, dynamic> json) => _$MoodResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MoodResponseToJson(this);
}

@JsonSerializable()
class MoodResponseData {
  final int? id;
  final String? banner;
  final String? title;
  final int? order;
  @JsonKey(name: "mood_id")
  final int? moodId;

  MoodResponseData({
    required this.banner,
    required this.id,
    required this.moodId,
    required this.order,
    required this.title,
  });
  factory MoodResponseData.fromJson(Map<String, dynamic> json) => _$MoodResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$MoodResponseDataToJson(this);
}

@JsonSerializable()
class MoodItemResponse extends BaseResponse {
  final List<MoodItemResponseData> data;

  MoodItemResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory MoodItemResponse.fromJson(Map<String, dynamic> json) => _$MoodItemResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MoodItemResponseToJson(this);
}

@JsonSerializable()
class MoodItemResponseData {
  final int? id;
  final String? banner;
  final String? body;
  final String? title;
  final int? order;
  final String? audio;
  @JsonKey(name: "audio_duration")
  final int? audioDuration;
  @JsonKey(name: "mood_list_id")
  final int? moodListId;
  final int? status;

  MoodItemResponseData({
    required this.audio,
    required this.audioDuration,
    required this.body,
    required this.banner,
    required this.id,
    required this.moodListId,
    required this.order,
    required this.status,
    required this.title,
  });

  factory MoodItemResponseData.fromJson(Map<String, dynamic> json) {
    // "Audio failed to upload" бол audio-г null болгох
    String? audio = json['audio'] == "Audio failed to upload" ? null : json['audio'];
    String? banner = json['banner'] == "Image failed to upload" ? null : json['banner'];

    return MoodItemResponseData(
      audio: audio,
      audioDuration: json['audio_duration'],
      body: json['body'],
      banner: banner,
      id: json['id'],
      moodListId: json['mood_list_id'],
      order: json['order'],
      status: json['status'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => _$MoodItemResponseDataToJson(this);
}
