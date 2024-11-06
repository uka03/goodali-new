import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'banner_response.g.dart';

@JsonSerializable()
class BannerResponse extends BaseResponse {
  final List<BannerResponseData>? data;

  BannerResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) => _$BannerResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$BannerResponseToJson(this);
}

@JsonSerializable()
class BannerResponseData {
  final int? id;
  final String? title;
  final String? banner;
  final int? status;
  @JsonKey(name: "product_type")
  final int? productType;
  @JsonKey(name: "product_id")
  final int? productId;

  BannerResponseData({
    required this.banner,
    required this.id,
    required this.productId,
    required this.productType,
    required this.status,
    required this.title,
  });
  factory BannerResponseData.fromJson(Map<String, dynamic> json) => _$BannerResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$BannerResponseDataToJson(this);
  //  factory UserResponseData.fromJson(Map<String, dynamic> json) => _$UserResponseDataFromJson(json);

  // Map<String, dynamic> toJson() => _$UserResponseDataToJson(this);
}
