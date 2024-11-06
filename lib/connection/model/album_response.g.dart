// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumResponse _$AlbumResponseFromJson(Map<String, dynamic> json) =>
    AlbumResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AlbumResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$AlbumResponseToJson(AlbumResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

AlbumResponseData _$AlbumResponseDataFromJson(Map<String, dynamic> json) =>
    AlbumResponseData(
      audio: json['audio'] as String?,
      audioDuration: (json['audio_duration'] as num?)?.toInt(),
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isPaid: json['isPaid'] as bool?,
      order: (json['order'] as num?)?.toInt(),
      price: json['price'] as num?,
      productId: (json['product_id'] as num?)?.toInt(),
      title: json['title'] as String?,
      totalLectures: (json['totalLectures'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AlbumResponseDataToJson(AlbumResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'banner': instance.banner,
      'body': instance.body,
      'title': instance.title,
      'order': instance.order,
      'totalLectures': instance.totalLectures,
      'audio': instance.audio,
      'price': instance.price,
      'created_at': instance.createdAt,
      'audio_duration': instance.audioDuration,
      'product_id': instance.productId,
      'isPaid': instance.isPaid,
    };

AlbumDetailResponse _$AlbumDetailResponseFromJson(Map<String, dynamic> json) =>
    AlbumDetailResponse(
      data: json['data'] == null
          ? null
          : AlbumDetailResponseData.fromJson(
              json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$AlbumDetailResponseToJson(
        AlbumDetailResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

AlbumDetailResponseData _$AlbumDetailResponseDataFromJson(
        Map<String, dynamic> json) =>
    AlbumDetailResponseData(
      lectures: (json['lectures'] as List<dynamic>?)
          ?.map((e) => PodcastResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      album: AlbumInfoResponseDaata.fromJson(
          json['album'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlbumDetailResponseDataToJson(
        AlbumDetailResponseData instance) =>
    <String, dynamic>{
      'album': instance.album,
      'lectures': instance.lectures,
    };

AlbumInfoResponseDaata _$AlbumInfoResponseDaataFromJson(
        Map<String, dynamic> json) =>
    AlbumInfoResponseDaata(
      audio: json['audio'] as String?,
      audioDuration: (json['audio_duration'] as num?)?.toInt(),
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isSpecial: json['is_special'] as bool?,
      order: (json['order'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      title: json['title'] as String?,
      totalLectures: (json['totalLectures'] as num?)?.toInt(),
      isPaid: json['isPaid'] as bool?,
    );

Map<String, dynamic> _$AlbumInfoResponseDaataToJson(
        AlbumInfoResponseDaata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'banner': instance.banner,
      'body': instance.body,
      'title': instance.title,
      'status': instance.status,
      'order': instance.order,
      'price': instance.price,
      'audio': instance.audio,
      'audio_duration': instance.audioDuration,
      'is_special': instance.isSpecial,
      'product_id': instance.productId,
      'totalLectures': instance.totalLectures,
      'created_at': instance.createdAt,
      'isPaid': instance.isPaid,
    };
