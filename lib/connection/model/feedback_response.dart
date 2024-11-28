import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'feedback_response.g.dart';

@JsonSerializable()
class FeedbackResponse extends BaseResponse {
  final List<FeedbackResponseData>? data;

  FeedbackResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) => _$FeedbackResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FeedbackResponseToJson(this);
}

@JsonSerializable()
class FeedbackResponseData {
  final String? text;
  final String? lectureName;
  final String? trainingName;
  final String? nickName;
  final String? avatar;
  final String? createdAt;

  FeedbackResponseData({
    required this.avatar,
    required this.lectureName,
    required this.nickName,
    required this.text,
    required this.createdAt,
    required this.trainingName,
  });

  factory FeedbackResponseData.fromJson(Map<String, dynamic> json) => _$FeedbackResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackResponseDataToJson(this);
  //  {
  //     "createdAt": "2024-11-23T11:31:11.000Z",
  //     "text": "Aaaaaa",
  //     "lectureName": "Хүний төрлүүд ба амьдралын зохиол",
  //     "nickName": "goodaliq",
  //     "avatar": "/static/img/uploads/medium/user_avatar_1731655447750.png"
  // },
}
