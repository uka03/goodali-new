import 'package:flutter/material.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';

class AuthTextField extends StatelessWidget {
  AuthTextField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.maxLength,
    this.extend = false,
    this.textInputAction,
  });
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool extend;
  final TextInputAction? textInputAction;

  final ValueNotifier<bool> isTyping = ValueNotifier(false);
  final border = UnderlineInputBorder(
    borderSide: BorderSide(
      color: GeneralColors.borderColor,
    ),
  );
  final focusedBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: GeneralColors.primaryColor,
    ),
  );

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
            controller: controller,
            maxLength: maxLength,
            maxLines: extend ? null : 1,
            textInputAction: textInputAction,
            keyboardType: keyboardType ?? TextInputType.emailAddress,
            validator: (value) {
              if (validator != null) {
                return validator!(value);
              }
              return null;
            },
            onChanged: (value) {
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
              hintText: hintText ?? "И-мэйл хаяг",
              suffixIcon: value
                  ? CustomButton(
                      onTap: () {
                        controller.clear();
                      },
                      child: Icon(Icons.close))
                  : null,
              border: border,
              errorBorder: border,
              enabledBorder: border,
              focusedBorder: focusedBorder,
              focusedErrorBorder: focusedBorder,
              disabledBorder: border,
            ),
          );
        },
      ),
    );
  }
}
