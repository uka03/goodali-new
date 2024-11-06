// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      data: json['data'] == null
          ? null
          : OrderResponseData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

OrderResponseData _$OrderResponseDataFromJson(Map<String, dynamic> json) =>
    OrderResponseData(
      deeplinks: (json['deeplinks'] as List<dynamic>?)
          ?.map((e) => BankResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      invoiceId: json['invoiceId'] as String?,
      qpayInvoiceId: json['qpayInvoiceId'] as String?,
      qr: json['qr'] == null
          ? null
          : QrResponseData.fromJson(json['qr'] as Map<String, dynamic>),
      transactionId: json['transactionId'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$OrderResponseDataToJson(OrderResponseData instance) =>
    <String, dynamic>{
      'qpayInvoiceId': instance.qpayInvoiceId,
      'invoiceId': instance.invoiceId,
      'qr': instance.qr,
      'deeplinks': instance.deeplinks,
      'transactionId': instance.transactionId,
      'url': instance.url,
    };

QrResponseData _$QrResponseDataFromJson(Map<String, dynamic> json) =>
    QrResponseData(
      base64: json['base64'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$QrResponseDataToJson(QrResponseData instance) =>
    <String, dynamic>{
      'text': instance.text,
      'base64': instance.base64,
    };

BankResponseData _$BankResponseDataFromJson(Map<String, dynamic> json) =>
    BankResponseData(
      description: json['description'] as String?,
      link: json['link'] as String?,
      logo: json['logo'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$BankResponseDataToJson(BankResponseData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'logo': instance.logo,
      'link': instance.link,
    };
