import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'training_response.g.dart';

@JsonSerializable()
class TrainingResponse extends BaseResponse {
  final List<TrainingResponseData>? data;
  TrainingResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory TrainingResponse.fromJson(Map<String, dynamic> json) => _$TrainingResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TrainingResponseToJson(this);
}

@JsonSerializable()
class TrainingDetailResponse extends BaseResponse {
  final TrainingInfoResponseData data;

  TrainingDetailResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory TrainingDetailResponse.fromJson(Map<String, dynamic> json) => _$TrainingDetailResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TrainingDetailResponseToJson(this);
}

@JsonSerializable()
class TrainingResponseData {
  final int? id;
  final String? name;
  final String? body;
  final int? order;
  final int? status;
  final String? banner;
  @JsonKey(name: "is_special")
  final bool? isSpecial;
  @JsonKey(name: "created_at")
  final String? createdAt;

  TrainingResponseData({
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.isSpecial,
    required this.name,
    required this.order,
    required this.status,
  });
  factory TrainingResponseData.fromJson(Map<String, dynamic> json) => _$TrainingResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$TrainingResponseDataToJson(this);
}

@JsonSerializable()
class TrainingInfoResponseData {
  final int? id;
  final String? name;
  final String? body;
  final int? order;
  final int? status;
  final String? banner;
  final bool? isPaid;
  final bool? canPurchase;
  final int? price;

  TrainingInfoResponseData({
    required this.banner,
    required this.body,
    required this.canPurchase,
    required this.id,
    required this.isPaid,
    required this.name,
    required this.order,
    required this.price,
    required this.status,
  });
  factory TrainingInfoResponseData.fromJson(Map<String, dynamic> json) => _$TrainingInfoResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$TrainingInfoResponseDataToJson(this);
}

@JsonSerializable()
class PackageResponse extends BaseResponse {
  final List<PackageResponseData>? data;
  PackageResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory PackageResponse.fromJson(Map<String, dynamic> json) => _$PackageResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PackageResponseToJson(this);
}

@JsonSerializable()
class PackageResponseData {
  final int? id;
  final String? name;
  final String? body;
  final int? order;
  final int? status;
  final String? banner;
  final int? price;
  @JsonKey(name: "training_id")
  final int? trainingId;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "openned_date")
  final String? opennedDate;
  PackageResponseData({
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.opennedDate,
    required this.order,
    required this.price,
    required this.productId,
    required this.status,
    required this.trainingId,
    required this.name,
  });

  factory PackageResponseData.fromJson(Map<String, dynamic> json) => _$PackageResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$PackageResponseDataToJson(this);
}
