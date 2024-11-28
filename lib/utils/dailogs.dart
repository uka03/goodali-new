import 'package:flutter/material.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';

showAlertDialog(
  BuildContext context, {
  Widget? title,
  Widget? content,
  required VoidCallback onSuccess,
  required VoidCallback onDismiss,
  List<Widget>? actions,
  bool dismissible = true,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: dismissible,
    // barrierColor: barrierColor,
    builder: (BuildContext context) {
      return AlertDialog(
        // actionsPadding: EdgeInsets.only(
        //   bottom: bottomSpacerHeight,
        // ),
        backgroundColor: GeneralColors.primaryBGColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsAlignment: MainAxisAlignment.center,
        // contentPadding: contentPadding,
        // titlePadding: titlePadding,
        // insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        title: title,
        content: content,
        actions: actions ??
            <Widget>[
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          title: "Үгүй",
                          backgroundColor: GeneralColors.grayColor,
                          onPressed: onDismiss,
                          radius: 8,
                        ),
                      ),
                      HSpacer(),
                      Expanded(
                        child: PrimaryButton(
                          title: "Тийм",
                          radius: 8,
                          onPressed: onSuccess,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
      );
    },
  );
}

showModalSheet(
  BuildContext context, {
  required Widget child,
  VoidCallback? onPressed,
  String? buttonText,
  bool withExpanded = true,
  bool dismissable = true,
  bool isScrollControlled = false,
  double? height,
}) {
  return showModalBottomSheet(
    context: context,
    isDismissible: dismissable,
    elevation: 0,
    backgroundColor: GeneralColors.primaryBGColor,
    isScrollControlled: isScrollControlled,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: height,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 24, left: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 6,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
                withExpanded
                    ? Expanded(
                        child: child,
                      )
                    : child,
              ],
            ),
          ),
        ),
      );
    },
  );
}
