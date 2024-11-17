import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/model/base_response.dart';
import 'package:goodali/connection/model/cart_response.dart';
import 'package:goodali/connection/model/order_response.dart';

class CartProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  CartResponseData? cartData;

  Future<void> getItems() async {
    final response = await _dioClient.getItemFromCart();

    cartData = response.data;
    notifyListeners();
  }

  Future<BaseResponse> addCart(int? id) async {
    final response = await _dioClient.addToCart(id);
    getItems();
    return response;
  }

  Future<BaseResponse> checkPayment(String? id, int type) async {
    final response = await _dioClient.checkPayment(id, type);
    return response;
  }

  Future<BaseResponse> removeCart(int? id) async {
    final response = await _dioClient.deleteFromCart(id);
    getItems();
    notifyListeners();
    return response;
  }

  Future<OrderResponseData?> createOrder(int type) async {
    final ids = cartData?.cartItems?.map((e) => e.productId).toList();
    final response = await _dioClient.createOrder(ids ?? [], type);

    return response.data;
  }
}
