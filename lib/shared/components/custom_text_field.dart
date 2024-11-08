import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.readonly = false,
    this.withIcon = true,
    this.onTap,
    this.onChange,
  });

  final TextEditingController controller;
  final String? Function(String? value)? validator, onChange;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool readonly;
  final bool withIcon;
  final VoidCallback? onTap;

  final ValueNotifier<bool> isTyping = ValueNotifier(false);
  final border = OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none);

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        isTyping.value = value;
      },
      child: ValueListenableBuilder(
        valueListenable: isTyping,
        builder: (context, value, _) {
          return TextFormField(
            onTap: onTap,
            readOnly: readonly,
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.emailAddress,
            validator: (value) {
              if (validator != null) {
                return validator!(value);
              }
              return null;
            },
            onChanged: (value) {
              if (onChange != null) {
                onChange!(value);
              }
              if (value.isNotEmpty) {
                if (!isTyping.value) {
                  isTyping.value = true;
                }
              } else {
                if (isTyping.value) {
                  isTyping.value = false;
                }
              }
            },
            style: GeneralTextStyle.bodyText(
              fontSize: 16,
              textColor: value ? GeneralColors.primaryColor : null,
            ),
            decoration: InputDecoration(
              hintText: hintText ?? "Хайх",
              suffixIcon: value
                  ? CustomButton(
                      onTap: () {
                        controller.clear();
                      },
                      child: Icon(Icons.close),
                    )
                  : null,
              hintStyle: GeneralTextStyle.bodyText(
                fontSize: 14,
                textColor: GeneralColors.grayColor,
              ),
              prefixIcon: withIcon
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          "assets/icons/ic_search.png",
                          color: GeneralColors.grayColor,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : null,
              filled: true,
              fillColor: GeneralColors.inputColor,
              border: border,
              errorBorder: border,
              enabledBorder: border,
              focusedBorder: border,
              focusedErrorBorder: border,
              disabledBorder: border,
            ),
          );
        },
      ),
    );
  }
}
