import 'package:flutter/material.dart';
import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'podcast_response.g.dart';

@JsonSerializable()
class PodcastResponse extends BaseResponse {
  final List<PodcastResponseData>? data;

  PodcastResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory PodcastResponse.fromJson(Map<String, dynamic> json) => _$PodcastResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PodcastResponseToJson(this);
}

@JsonSerializable()
class PodcastResponseData {
  final int? id;
  final String? banner;
  final String? body;
  final String? title;
  final String? audio;
  final String? intro;
  @JsonKey(name: "audio_duration")
  final int? audioDuration;
  @JsonKey(name: "intro_duration")
  final int? introDuration;
  @JsonKey(name: "created_at")
  final String? createdAt;
  final int? statis;
  final int? order;
  final int? price;
  @JsonKey(name: "album_id")
  final int? albumId;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "is_special")
  final bool? isSpecial;
  final bool? isPaid;
  @JsonKey(fromJson: _valueNotifierNullableFromJson, toJson: _valueNotifierNullableToJson, name: "paused_time")
  late ValueNotifier<int?> pausedTime;

  PodcastResponseData({
    required this.audio,
    required this.audioDuration,
    required this.banner,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.title,
    required this.intro,
    required this.introDuration,
    required this.isPaid,
    required this.isSpecial,
    required this.order,
    required this.productId,
    required this.statis,
    required this.albumId,
    required this.price,
    required this.pausedTime,
  });

  factory PodcastResponseData.fromJson(Map<String, dynamic> json) => _$PodcastResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$PodcastResponseDataToJson(this);
}

class ValueNotifierBoolNullableConverter implements JsonConverter<ValueNotifier<int?>, int?> {
  const ValueNotifierBoolNullableConverter();

  @override
  ValueNotifier<int?> fromJson(int? json) {
    return ValueNotifier<int?>(json);
  }

  @override
  int? toJson(ValueNotifier<int?> object) {
    return object.value;
  }
}

// Хөрвүүлэхэд ашиглах функцүүд
ValueNotifier<int?> _valueNotifierNullableFromJson(int? json) => ValueNotifier<int?>(json);

int? _valueNotifierNullableToJson(ValueNotifier<int?> notifier) => notifier.value;
