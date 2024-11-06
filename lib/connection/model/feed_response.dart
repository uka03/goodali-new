import 'package:flutter/material.dart';
import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'feed_response.g.dart';

@JsonSerializable()
class FeedResponse extends BaseResponse {
  final List<FeedResponseData>? data;

  FeedResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory FeedResponse.fromJson(Map<String, dynamic> json) => _$FeedResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FeedResponseToJson(this);
}

@JsonSerializable()
class FeedResponseData {
  final int? id;
  String? title;
  String? body;
  int? likes;
  List<TagResponseData>? tags;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "self_like")
  bool? selfLike;
  final List<ReplyResponseData>? replys;
  @JsonKey(name: "nick_name")
  final String? nickName;
  @JsonKey(name: "user_id")
  final int? userId;
  final String? avatar;
  @JsonKey(fromJson: _valueNotifierNullableFromJson, toJson: _valueNotifierNullableToJson)
  late ValueNotifier<bool?> isLike;

  FeedResponseData({
    required this.id,
    required this.title,
    required this.body,
    required this.likes,
    required this.tags,
    required this.createdAt,
    required this.selfLike,
    required this.replys,
    required this.nickName,
    required this.avatar,
    required this.isLike,
    required this.userId,
  }) {
    isLike = ValueNotifier(selfLike ?? false);
  }

  factory FeedResponseData.fromJson(Map<String, dynamic> json) => _$FeedResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$FeedResponseDataToJson(this);
}

@JsonSerializable()
class ReplyResponse extends BaseResponse {
  final ReplyResponseData? data;

  ReplyResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory ReplyResponse.fromJson(Map<String, dynamic> json) => _$ReplyResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ReplyResponseToJson(this);
}

@JsonSerializable()
class ReplyResponseData {
  final int? id;
  final String? body;
  @JsonKey(name: "nick_name")
  final String? nickName;
  @JsonKey(name: "user_id")
  final int? userId;
  final String? avatar;
  @JsonKey(name: "created_at")
  final String? createdAt;

  ReplyResponseData({
    required this.body,
    required this.nickName,
    required this.userId,
    required this.avatar,
    required this.id,
    required this.createdAt,
  });

  factory ReplyResponseData.fromJson(Map<String, dynamic> json) => _$ReplyResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyResponseDataToJson(this);
}

class ValueNotifierBoolNullableConverter implements JsonConverter<ValueNotifier<bool?>, bool?> {
  const ValueNotifierBoolNullableConverter();

  @override
  ValueNotifier<bool?> fromJson(bool? json) {
    return ValueNotifier<bool?>(json);
  }

  @override
  bool? toJson(ValueNotifier<bool?> object) {
    return object.value;
  }
}

// Хөрвүүлэхэд ашиглах функцүүд
ValueNotifier<bool?> _valueNotifierNullableFromJson(bool? json) => ValueNotifier<bool?>(json);

bool? _valueNotifierNullableToJson(ValueNotifier<bool?> notifier) => notifier.value;
