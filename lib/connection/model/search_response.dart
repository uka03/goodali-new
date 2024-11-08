import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'search_response.g.dart';

@JsonSerializable()
class SearchResponse extends BaseResponse {
  final List<SearchResponseData>? data;

  SearchResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) => _$SearchResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class SearchResponseData {
  final String? module;
  final int? id;
  final String? title;
  final String? body;
  final int? album;

  SearchResponseData({
    required this.album,
    required this.body,
    required this.id,
    required this.module,
    required this.title,
  });

  factory SearchResponseData.fromJson(Map<String, dynamic> json) => _$SearchResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseDataToJson(this);
}
