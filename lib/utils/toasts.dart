import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class Toast {
  Toast._();

  static void success(
    BuildContext context, {
    String? description,
    String? title,
  }) {
    FToast fToast = FToast();
    fToast.removeCustomToast();
    fToast.init(context);
    return fToast.showToast(
      toastDuration: Duration(seconds: 3),
      gravity: ToastGravity.TOP,
      isDismissable: true,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: GeneralColors.grayColor.withOpacity(0.2),
              offset: Offset(1, 0),
              blurRadius: 12,
              spreadRadius: 10,
            ),
          ],
          color: const Color.fromARGB(255, 200, 238, 186),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/ic_success.png",
              width: 24,
              height: 24,
            ),
            HSpacer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "Амжилттай",
                    style: GeneralTextStyle.titleText(),
                  ),
                  VSpacer.sm(),
                  Text(
                    description ?? "",
                    style: GeneralTextStyle.bodyText(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static void error(
    BuildContext context, {
    String? description,
    String? title,
  }) {
    FToast fToast = FToast();
    fToast.removeCustomToast();
    fToast.init(context);
    return fToast.showToast(
      toastDuration: Duration(seconds: 3),
      gravity: ToastGravity.TOP,
      isDismissable: true,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: GeneralColors.grayColor.withOpacity(0.05),
              offset: Offset(1, 0),
              blurRadius: 12,
              spreadRadius: 10,
            ),
          ],
          color: const Color.fromARGB(255, 240, 196, 194),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/ic_error.png",
              width: 24,
              height: 24,
            ),
            HSpacer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? "Уучлаарай",
                    style: GeneralTextStyle.titleText(),
                  ),
                  Column(
                    children: [
                      VSpacer.sm(),
                      Text(
                        description ?? "Алдаа гарлаа.",
                        style: GeneralTextStyle.bodyText(),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
