import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_response.g.dart';

@JsonSerializable()
class PostResponse extends BaseResponse {
  final List<PostResponseData>? data;

  PostResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostResponseToJson(this);
}

@JsonSerializable()
class PostResponseData {
  final int? id;
  final String? title;
  final String? body;
  final String? banner;
  final int? order;
  @JsonKey(name: "isSpecial")
  final bool? isSpecial;
  final List<TagResponseData>? tags;
  @JsonKey(name: "created_at")
  final String? createdAt;

  PostResponseData({
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.isSpecial,
    required this.order,
    required this.tags,
    required this.title,
  });
  factory PostResponseData.fromJson(Map<String, dynamic> json) => _$PostResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostResponseDataToJson(this);
}
