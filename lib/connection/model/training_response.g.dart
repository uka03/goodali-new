// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingResponse _$TrainingResponseFromJson(Map<String, dynamic> json) =>
    TrainingResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TrainingResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$TrainingResponseToJson(TrainingResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

TrainingDetailResponse _$TrainingDetailResponseFromJson(
        Map<String, dynamic> json) =>
    TrainingDetailResponse(
      data: TrainingInfoResponseData.fromJson(
          json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$TrainingDetailResponseToJson(
        TrainingDetailResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

TrainingResponseData _$TrainingResponseDataFromJson(
        Map<String, dynamic> json) =>
    TrainingResponseData(
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: (json['id'] as num?)?.toInt(),
      isSpecial: json['is_special'] as bool?,
      name: json['name'] as String?,
      order: (json['order'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TrainingResponseDataToJson(
        TrainingResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'body': instance.body,
      'order': instance.order,
      'status': instance.status,
      'banner': instance.banner,
      'is_special': instance.isSpecial,
      'created_at': instance.createdAt,
    };

TrainingInfoResponseData _$TrainingInfoResponseDataFromJson(
        Map<String, dynamic> json) =>
    TrainingInfoResponseData(
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      canPurchase: json['canPurchase'] as bool?,
      id: (json['id'] as num?)?.toInt(),
      isPaid: json['isPaid'] as bool?,
      name: json['name'] as String?,
      order: (json['order'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      expireAt: json['expire_at'] as String?,
      opennedDate: json['openned_date'] as String?,
    );

Map<String, dynamic> _$TrainingInfoResponseDataToJson(
        TrainingInfoResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'body': instance.body,
      'order': instance.order,
      'status': instance.status,
      'banner': instance.banner,
      'isPaid': instance.isPaid,
      'canPurchase': instance.canPurchase,
      'price': instance.price,
      'openned_date': instance.opennedDate,
      'expire_at': instance.expireAt,
    };

PackageResponse _$PackageResponseFromJson(Map<String, dynamic> json) =>
    PackageResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PackageResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$PackageResponseToJson(PackageResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

PackageResponseData _$PackageResponseDataFromJson(Map<String, dynamic> json) =>
    PackageResponseData(
      banner: json['banner'] as String?,
      body: json['body'] as String?,
      createdAt: json['created_at'] as String?,
      id: (json['id'] as num?)?.toInt(),
      opennedDate: json['openned_date'] as String?,
      order: (json['order'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      trainingId: (json['training_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      isPaid: json['isPaid'] as bool?,
    );

Map<String, dynamic> _$PackageResponseDataToJson(
        PackageResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'body': instance.body,
      'order': instance.order,
      'status': instance.status,
      'banner': instance.banner,
      'price': instance.price,
      'training_id': instance.trainingId,
      'product_id': instance.productId,
      'created_at': instance.createdAt,
      'openned_date': instance.opennedDate,
      'isPaid': instance.isPaid,
    };
