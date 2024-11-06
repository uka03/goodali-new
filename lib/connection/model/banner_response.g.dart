// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerResponse _$BannerResponseFromJson(Map<String, dynamic> json) =>
    BannerResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BannerResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$BannerResponseToJson(BannerResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

BannerResponseData _$BannerResponseDataFromJson(Map<String, dynamic> json) =>
    BannerResponseData(
      banner: json['banner'] as String?,
      id: (json['id'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      productType: (json['product_type'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$BannerResponseDataToJson(BannerResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'banner': instance.banner,
      'status': instance.status,
      'product_type': instance.productType,
      'product_id': instance.productId,
    };
