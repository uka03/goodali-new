import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/podcast_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'album_response.g.dart';

@JsonSerializable()
class AlbumResponse extends BaseResponse {
  final List<AlbumResponseData>? data;
  AlbumResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory AlbumResponse.fromJson(Map<String, dynamic> json) => _$AlbumResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AlbumResponseToJson(this);
}

@JsonSerializable()
class AlbumResponseData {
  final int? id;
  final String? banner;
  final String? body;
  final String? title;
  final int? order;
  final int? totalLectures;
  final String? audio;
  final num? price;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "audio_duration")
  final int? audioDuration;
  @JsonKey(name: "product_id")
  final int? productId;
  final bool? isPaid;

  AlbumResponseData({
    required this.audio,
    required this.audioDuration,
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.isPaid,
    required this.order,
    required this.price,
    required this.productId,
    required this.title,
    required this.totalLectures,
  });
  factory AlbumResponseData.fromJson(Map<String, dynamic> json) => _$AlbumResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumResponseDataToJson(this);
}

@JsonSerializable()
class AlbumDetailResponse extends BaseResponse {
  final AlbumDetailResponseData? data;

  AlbumDetailResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory AlbumDetailResponse.fromJson(Map<String, dynamic> json) => _$AlbumDetailResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AlbumDetailResponseToJson(this);
}

@JsonSerializable()
class AlbumDetailResponseData {
  final AlbumInfoResponseDaata album;
  final List<PodcastResponseData>? lectures;

  AlbumDetailResponseData({
    required this.lectures,
    required this.album,
  });

  factory AlbumDetailResponseData.fromJson(Map<String, dynamic> json) => _$AlbumDetailResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumDetailResponseDataToJson(this);
}

@JsonSerializable()
class AlbumInfoResponseDaata {
  final int? id;
  final String? banner;
  final String? body;
  final String? title;
  final int? status;
  final int? order;
  final int? price;
  final String? audio;
  @JsonKey(name: "audio_duration")
  final int? audioDuration;
  @JsonKey(name: "is_special")
  final bool? isSpecial;
  @JsonKey(name: "product_id")
  final int? productId;
  final int? totalLectures;
  @JsonKey(name: "created_at")
  final String? createdAt;
  final bool? isPaid;

  AlbumInfoResponseDaata({
    required this.audio,
    required this.audioDuration,
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.isSpecial,
    required this.order,
    required this.price,
    required this.productId,
    required this.status,
    required this.title,
    required this.totalLectures,
    required this.isPaid,
  });
  factory AlbumInfoResponseDaata.fromJson(Map<String, dynamic> json) => _$AlbumInfoResponseDaataFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumInfoResponseDaataToJson(this);
}
