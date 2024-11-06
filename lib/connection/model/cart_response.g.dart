// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponse _$CartResponseFromJson(Map<String, dynamic> json) => CartResponse(
      data: CartResponseData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$CartResponseToJson(CartResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

CartResponseData _$CartResponseDataFromJson(Map<String, dynamic> json) =>
    CartResponseData(
      cartItems: (json['cartItems'] as List<dynamic>?)
          ?.map(
              (e) => CartItemsResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CartResponseDataToJson(CartResponseData instance) =>
    <String, dynamic>{
      'totalPrice': instance.totalPrice,
      'cartItems': instance.cartItems,
    };

CartItemsResponseData _$CartItemsResponseDataFromJson(
        Map<String, dynamic> json) =>
    CartItemsResponseData(
      price: (json['price'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      productType: (json['productType'] as num?)?.toInt(),
      thumbImg: json['thumbImg'] as String?,
      total: (json['total'] as num?)?.toInt(),
      productName: json['productName'] as String?,
    );

Map<String, dynamic> _$CartItemsResponseDataToJson(
        CartItemsResponseData instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'productType': instance.productType,
      'thumbImg': instance.thumbImg,
      'price': instance.price,
      'total': instance.total,
    };
