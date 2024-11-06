import 'package:json_annotation/json_annotation.dart';
part 'base_response.g.dart';
// flutter pub run build_runner build --delete-conflicting-outputs

@JsonSerializable()
class BaseResponse {
  final bool? success;
  final String? error;
  final String? message;

  BaseResponse({
    required this.error,
    required this.success,
    required this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
