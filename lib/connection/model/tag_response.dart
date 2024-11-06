import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tag_response.g.dart';

@JsonSerializable()
class TagResponse extends BaseResponse {
  final List<TagResponseData> data;

  TagResponse({
    required this.data,
    super.error,
    super.success,
    super.message,
  });

  factory TagResponse.fromJson(Map<String, dynamic> json) => _$TagResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TagResponseToJson(this);
}

@JsonSerializable()
class TagResponseData {
  final int? id;
  final String? name;
  final String? description;
  final String? banner;
  final int? status;
  @JsonKey(name: "created_at")
  final String? createdAt;

  TagResponseData({
    this.id,
    this.name,
    this.description,
    this.banner,
    this.status,
    this.createdAt,
  });

  factory TagResponseData.fromJson(Map<String, dynamic> json) => _$TagResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$TagResponseDataToJson(this);
}
