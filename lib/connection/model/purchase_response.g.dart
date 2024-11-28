// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseResponse _$PurchaseResponseFromJson(Map<String, dynamic> json) =>
    PurchaseResponse(
      data: json['data'] == null
          ? null
          : PurchaseResponseData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PurchaseResponseToJson(PurchaseResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

PurchaseResponseData _$PurchaseResponseDataFromJson(
        Map<String, dynamic> json) =>
    PurchaseResponseData(
      albums: (json['albums'] as List<dynamic>?)
          ?.map((e) => PurchaseAlbumData.fromJson(e as Map<String, dynamic>))
          .toList(),
      training: (json['training'] as List<dynamic>?)
          ?.map((e) => PurchaseTrainingData.fromJson(e as Map<String, dynamic>))
          .toList(),
      book: (json['book'] as List<dynamic>?)
          ?.map((e) => PodcastResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseResponseDataToJson(
        PurchaseResponseData instance) =>
    <String, dynamic>{
      'albums': instance.albums,
      'training': instance.training,
      'book': instance.book,
    };

PurchaseTrainingData _$PurchaseTrainingDataFromJson(
        Map<String, dynamic> json) =>
    PurchaseTrainingData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      banner: json['banner'] as String?,
      package: json['package'] == null
          ? null
          : PurchasePackageData.fromJson(
              json['package'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseTrainingDataToJson(
        PurchaseTrainingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'banner': instance.banner,
      'package': instance.package,
    };

PurchasePackageData _$PurchasePackageDataFromJson(Map<String, dynamic> json) =>
    PurchasePackageData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      opennedDate: json['openned_date'] as String?,
      expiredDate: json['expired_date'] as String?,
      productId: (json['productId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PurchasePackageDataToJson(
        PurchasePackageData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'openned_date': instance.opennedDate,
      'expired_date': instance.expiredDate,
      'productId': instance.productId,
    };

PurchaseAlbumData _$PurchaseAlbumDataFromJson(Map<String, dynamic> json) =>
    PurchaseAlbumData(
      albumTitle: json['albumTitle'] as String?,
      lectures: (json['lectures'] as List<dynamic>?)
          ?.map((e) => PodcastResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseAlbumDataToJson(PurchaseAlbumData instance) =>
    <String, dynamic>{
      'albumTitle': instance.albumTitle,
      'lectures': instance.lectures,
    };
