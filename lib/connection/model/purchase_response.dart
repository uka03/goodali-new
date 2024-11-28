import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'purchase_response.g.dart';

@JsonSerializable()
class PurchaseResponse extends BaseResponse {
  final PurchaseResponseData? data;

  PurchaseResponse({
    required this.data,
    super.error,
    super.success,
    super.message,
  });

  factory PurchaseResponse.fromJson(Map<String, dynamic> json) => _$PurchaseResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PurchaseResponseToJson(this);
}

@JsonSerializable()
class PurchaseResponseData {
  final List<PurchaseAlbumData>? albums;
  final List<PurchaseTrainingData>? training;
  final List<PodcastResponseData>? book;

  PurchaseResponseData({
    this.albums,
    this.training,
    this.book,
  });

  factory PurchaseResponseData.fromJson(Map<String, dynamic> json) => _$PurchaseResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseResponseDataToJson(this);
}

@JsonSerializable()
class PurchaseTrainingData {
  final int? id;
  final String? name;
  final String? banner;
  final PurchasePackageData? package;

  PurchaseTrainingData({
    required this.id,
    required this.name,
    required this.banner,
    required this.package,
  });

  factory PurchaseTrainingData.fromJson(Map<String, dynamic> json) => _$PurchaseTrainingDataFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseTrainingDataToJson(this);
}

@JsonSerializable()
class PurchasePackageData {
  final int? id;
  final String? name;
  @JsonKey(name: "openned_date")
  final String? opennedDate;
  @JsonKey(name: "expired_date")
  final String? expiredDate;
  final int? productId;

  PurchasePackageData({
    required this.id,
    required this.name,
    required this.opennedDate,
    required this.expiredDate,
    required this.productId,
  });
  factory PurchasePackageData.fromJson(Map<String, dynamic> json) => _$PurchasePackageDataFromJson(json);
  Map<String, dynamic> toJson() => _$PurchasePackageDataToJson(this);
}

@JsonSerializable()
class PurchaseAlbumData {
  final String? albumTitle;
  final List<PodcastResponseData>? lectures;
  PurchaseAlbumData({
    required this.albumTitle,
    required this.lectures,
  });

  factory PurchaseAlbumData.fromJson(Map<String, dynamic> json) => _$PurchaseAlbumDataFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseAlbumDataToJson(this);
}
