import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_response.g.dart';

@JsonSerializable()
class VideoResponse extends BaseResponse {
  final List<VideoResponseData>? data;

  VideoResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) => _$VideoResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$VideoResponseToJson(this);
}

@JsonSerializable()
class VideoResponseData {
  final int? id;
  final String? title;
  final String? banner;
  final String? body;
  @JsonKey(name: "video_url")
  final String? videoUrl;
  final int? status;
  @JsonKey(name: "created_at")
  final String? createdAt;

  VideoResponseData({
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.status,
    required this.title,
    required this.videoUrl,
  });

  factory VideoResponseData.fromJson(Map<String, dynamic> json) => _$VideoResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$VideoResponseDataToJson(this);
}
