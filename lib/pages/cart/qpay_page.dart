import 'package:flutter/material.dart';
import 'package:goodali/connection/model/order_response.dart';
import 'package:goodali/pages/cart/components/payment_item.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QpayPage extends StatefulWidget {
  const QpayPage({super.key});

  static const String path = "/qpay-page";

  @override
  State<QpayPage> createState() => _QpayPageState();
}

class _QpayPageState extends State<QpayPage> {
  late final CartProvider _cartProvider;
  late HomeProvider homeProvider;
  OrderResponseData? data;

  @override
  void initState() {
    super.initState();
    _cartProvider = Provider.of(context, listen: false);

    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await _cartProvider.createOrder(0);
      setState(() {
        data = response;
      });
    });
  }

  openBankApp(String url) async {
    // showLoader();
    final bool canLaunchApp = await launchUrlString(url);
    if (canLaunchApp) {
      await launchUrlString(url);
    } else {
      if (mounted) {
        Toast.error(context, description: "Тухайн банкны аппликейшн олдсонгүй.");
      }
    }
    // dismissLoader();
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: CustomAppBar(),
      bottomBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PrimaryButton(
            title: "Төлбөр шалгах",
            onPressed: () async {
              showLoader();
              final response = await _cartProvider.checkPayment(data?.invoiceId, 1);
              dismissLoader();
              if (response.success == true && context.mounted) {
                Toast.success(context, description: "Худалдан авалт амжилттай.");
                homeProvider.getHomeData(refresh: true);
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (context.mounted) {
                Toast.error(context, description: response.error ?? response.message);
              }
            },
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            "Банк сонгох",
            style: GeneralTextStyle.titleText(
              fontSize: 24,
            ),
          ),
          VSpacer(),
          Expanded(
            child: ListView.separated(
              itemCount: data?.deeplinks?.length ?? 0,
              separatorBuilder: (context, index) => VSpacer(),
              itemBuilder: (context, index) {
                final item = data?.deeplinks?[index];
                return PaymentItem(
                  onPressed: () {
                    openBankApp(item?.link ?? "");
                  },
                  logoPath: item?.logo ?? placeholder,
                  logoOnline: true,
                  text: item?.name ?? "",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
