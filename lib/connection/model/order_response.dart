import 'package:goodali/connection/model/base_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_response.g.dart';

@JsonSerializable()
class OrderResponse extends BaseResponse {
  final OrderResponseData? data;

  OrderResponse({
    required this.data,
    super.error,
    super.message,
    super.success,
  });
  factory OrderResponse.fromJson(Map<String, dynamic> json) => _$OrderResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}

@JsonSerializable()
class OrderResponseData {
  final String? qpayInvoiceId;
  final String? invoiceId;
  final QrResponseData? qr;
  final List<BankResponseData>? deeplinks;

  //// Social pay
  final String? transactionId;
  final String? url;

  OrderResponseData({
    required this.deeplinks,
    required this.invoiceId,
    required this.qpayInvoiceId,
    required this.qr,
    required this.transactionId,
    required this.url,
  });
  factory OrderResponseData.fromJson(Map<String, dynamic> json) => _$OrderResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseDataToJson(this);
}

@JsonSerializable()
class QrResponseData {
  final String? text;
  final String? base64;

  QrResponseData({
    required this.base64,
    required this.text,
  });
  factory QrResponseData.fromJson(Map<String, dynamic> json) => _$QrResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$QrResponseDataToJson(this);
}

@JsonSerializable()
class BankResponseData {
  final String? name;
  final String? description;
  final String? logo;
  final String? link;
  BankResponseData({
    required this.description,
    required this.link,
    required this.logo,
    required this.name,
  });
  factory BankResponseData.fromJson(Map<String, dynamic> json) => _$BankResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$BankResponseDataToJson(this);
}
