import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.items,
    required this.title,
    this.icon,
    required this.onChanged,
    required this.itemBuilder,
    this.hint,
    this.initialValue,
    this.offset,
    this.validator,
    this.checkEmpty = true,
    this.onMenuStateChanged,
    this.menu,
  });

  final List<T> items;
  final String title;
  final String? icon;
  final Function(T? value) onChanged;
  final Function(bool? value)? onMenuStateChanged;
  final Widget Function(T? data) itemBuilder;
  final String? hint;
  final Widget? menu;
  final T? initialValue;
  final Offset? offset;
  final String? Function(T? data)? validator;
  final bool checkEmpty;

  @override
  Widget build(BuildContext context) {
    const border = InputBorder.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GeneralTextStyle.titleText(
            fontSize: 14,
          ),
        ),
        VSpacer(size: 6),
        DropdownButtonFormField2<T>(
          isExpanded: true,
          enableFeedback: false,
          value: initialValue,
          onMenuStateChange: onMenuStateChanged,
          decoration: InputDecoration(
            border: border,
            focusedBorder: border,
            enabledBorder: border,
            errorBorder: border,
            disabledBorder: border,
            focusedErrorBorder: border,
            prefixIcon: icon != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icon ?? "",
                        width: 20,
                        height: 20,
                        color: Colors.grey,
                      ),
                    ],
                  )
                : null,
            contentPadding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
          ),
          hint: menu ??
              Text(
                hint ?? "",
                style: TextStyle(fontSize: 14),
              ),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: itemBuilder(item),
                  ))
              .toList(),
          validator: (data) {
            if (checkEmpty && data == null) {
              return "";
            }
            if (validator != null) {
              return validator!(data);
            }
            return null;
          },
          onChanged: onChanged,
          iconStyleData: const IconStyleData(
            icon: SizedBox(),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            elevation: 0,
            offset: offset ?? Offset(0, -5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: GeneralColors.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                )
              ],
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
    );
  }
}

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key, required this.items, required this.menu, required this.onChanged});
  final List<String> items;
  final Widget menu;
  final Function(String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: menu,
        onChanged: onChanged,
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    item,
                    style: GeneralTextStyle.bodyText(
                      textColor: GeneralColors.errorColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        dropdownStyleData: DropdownStyleData(
          width: 120,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: GeneralColors.primaryBGColor,
          ),
          offset: Offset(-90, -10),
        ),
      ),
    );
  }
}
