import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'faq_response.g.dart';

@JsonSerializable()
class FaqResponse extends BaseResponse {
  final List<FaqResponseData>? data;

  FaqResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) => _$FaqResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FaqResponseToJson(this);
}

@JsonSerializable()
class FaqResponseData {
  final int? id;
  final String? question;
  final String? answer;
  final int? status;

  FaqResponseData({this.id, this.question, this.answer, this.status});

  factory FaqResponseData.fromJson(Map<String, dynamic> json) => _$FaqResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$FaqResponseDataToJson(this);
}
