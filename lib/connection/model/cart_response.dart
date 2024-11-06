import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'cart_response.g.dart';

@JsonSerializable()
class CartResponse extends BaseResponse {
  final CartResponseData data;
  CartResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory CartResponse.fromJson(Map<String, dynamic> json) => _$CartResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CartResponseToJson(this);
}

@JsonSerializable()
class CartResponseData {
  final int? totalPrice;
  final List<CartItemsResponseData>? cartItems;

  CartResponseData({
    required this.cartItems,
    required this.totalPrice,
  });
  factory CartResponseData.fromJson(Map<String, dynamic> json) => _$CartResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$CartResponseDataToJson(this);
}

@JsonSerializable()
class CartItemsResponseData {
  final int? productId;
  final String? productName;
  final int? productType;
  final String? thumbImg;
  final int? price;
  final int? total;

  CartItemsResponseData({
    required this.price,
    required this.productId,
    required this.productType,
    required this.thumbImg,
    required this.total,
    required this.productName,
  });

  factory CartItemsResponseData.fromJson(Map<String, dynamic> json) => _$CartItemsResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemsResponseDataToJson(this);
}
