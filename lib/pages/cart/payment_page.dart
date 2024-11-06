import 'package:flutter/material.dart';
import 'package:goodali/pages/cart/card_page.dart';
import 'package:goodali/pages/cart/components/payment_item.dart';
import 'package:goodali/pages/cart/qpay_page.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  static String path = "/payment_page";

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: CustomAppBar(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Төлөх хэлбэр сонгох",
            style: GeneralTextStyle.titleText(
              fontSize: 24,
            ),
          ),
          Column(
            children: [
              PaymentItem(
                onPressed: () {
                  Navigator.pushNamed(context, QpayPage.path);
                },
                logoPath: "assets/icons/ic_scan.png",
                text: 'Qpay',
              ),
              VSpacer(),
              PaymentItem(
                onPressed: () {
                  Navigator.pushNamed(context, CardPage.path);
                },
                logoPath: "assets/icons/ic_visa.png",
                text: 'Карт',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
