// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodcastResponse _$PodcastResponseFromJson(Map<String, dynamic> json) =>
    PodcastResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PodcastResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$PodcastResponseToJson(PodcastResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

PodcastResponseData _$PodcastResponseDataFromJson(Map<String, dynamic> json) =>
    PodcastResponseData(
      audio: json['audio'] as String?,
      audioDuration: (json['audio_duration'] as num?)?.toInt(),
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      intro: json['intro'] as String?,
      introDuration: (json['intro_duration'] as num?)?.toInt(),
      isPaid: json['isPaid'] as bool?,
      isSpecial: json['is_special'] as bool?,
      order: (json['order'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      statis: (json['statis'] as num?)?.toInt(),
      albumId: (json['album_id'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      pausedTime: _valueNotifierNullableFromJson(
          (json['paused_time'] as num?)?.toInt()),
    );

Map<String, dynamic> _$PodcastResponseDataToJson(
        PodcastResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'banner': instance.banner,
      'body': instance.body,
      'title': instance.title,
      'audio': instance.audio,
      'intro': instance.intro,
      'audio_duration': instance.audioDuration,
      'intro_duration': instance.introDuration,
      'created_at': instance.createdAt,
      'statis': instance.statis,
      'order': instance.order,
      'price': instance.price,
      'album_id': instance.albumId,
      'product_id': instance.productId,
      'is_special': instance.isSpecial,
      'isPaid': instance.isPaid,
      'paused_time': _valueNotifierNullableToJson(instance.pausedTime),
    };
