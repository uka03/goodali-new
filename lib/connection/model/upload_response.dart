import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'upload_response.g.dart';

@JsonSerializable()
class UploadResponse extends BaseResponse {
  final List<UploadResponseData>? data;

  UploadResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) => _$UploadResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);
}

@JsonSerializable()
class UploadResponseData {
  final String? label;
  final String? filePath;
  final String? url;

  UploadResponseData({
    required this.filePath,
    required this.label,
    required this.url,
  });

  factory UploadResponseData.fromJson(Map<String, dynamic> json) => _$UploadResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$UploadResponseDataToJson(this);
}
