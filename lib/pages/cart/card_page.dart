import 'package:flutter/material.dart';
import 'package:goodali/connection/model/order_response.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  static String path = "/card_page";

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late final WebViewController _controller;

  late CartProvider cartProvider;
  late HomeProvider homeProvider;
  OrderResponseData? order;

  @override
  void initState() {
    super.initState();

    cartProvider = Provider.of<CartProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (value) {
          print(value);
          if (value.contains("status_code=000")) {
            cartProvider.checkPayment(order?.transactionId, 0);
            Toast.success(context, description: "Худалдан авалт амжилттай.");
            homeProvider.getHomeData(refresh: true);
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final response = await cartProvider.createOrder(1);
      final uriUrl = Uri.parse(response?.url ?? "");
      _controller.loadRequest(uriUrl);
      order = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: CustomAppBar(),
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
