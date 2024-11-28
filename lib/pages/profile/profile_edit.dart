import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/auth_text_field.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  static String path = "/edit";

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late AuthProvider authProvider;
  final name = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? fileImage;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final me = await authProvider.getMe();
      name.text = me?.nickname ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        final me = provider.user;
        return KeyboardHider(
          child: GeneralScaffold(
            appBar: CustomAppBar(),
            bottomBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PrimaryButton(
                  title: "Хадгалах",
                  onPressed: () async {
                    if (me?.nickname != name.text) {
                      showLoader();
                      final response = await authProvider.userUpdate(name.text);
                      if (response.success == true && context.mounted) {
                        Toast.success(context, description: response.message ?? response.error);
                      } else if (context.mounted) {
                        Toast.success(context, description: response.message ?? response.error);
                      }
                    }
                    if (fileImage != null) {
                      final response = await authProvider.uploadAvatar(fileImage);
                      if (response.success == true && context.mounted) {
                        Toast.success(context, description: response.message ?? response.error);
                      } else if (context.mounted) {
                        Toast.error(context, description: response.message ?? response.error);
                      }
                    }
                    await authProvider.getMe();
                    dismissLoader();
                    if (context.mounted) {
                      // Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: fileImage == null
                                  ? CachedNetworkImage(
                                      imageUrl: me?.avatar.toUrl(isUser: true) ?? placeholder,
                                      width: 170,
                                      height: 170,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    )
                                  : Image.file(
                                      fileImage!,
                                      width: 170,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            VSpacer(),
                            CustomButton(
                              onTap: () {
                                pckerImage(context);
                              },
                              child: Text(
                                "Зураг солих",
                                style: GeneralTextStyle.bodyText(
                                  fontSize: 14,
                                  textColor: GeneralColors.primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      VSpacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "И-мэйл хаяг",
                          style: GeneralTextStyle.bodyText(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      AuthTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: TextEditingController(text: me?.email ?? ""),
                        onChanged: (value) {},
                      ),
                      VSpacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Нууц нэр",
                          style: GeneralTextStyle.bodyText(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      AuthTextField(
                        keyboardType: TextInputType.name,
                        controller: name,
                        hintText: "Нууц нэр",
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Та өөртөө хүссэн нэрээ өгөөрэй.",
                          style: GeneralTextStyle.bodyText(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  pckerImage(BuildContext context) {
    showModalSheet(
      context,
      // title: "Зураг солих",
      withExpanded: true,
      height: 250,
      child: Column(
        children: [
          VSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Зураг солих",
                style: GeneralTextStyle.titleText(
                  fontSize: 24,
                ),
              ),
            ],
          ),
          VSpacer(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: pickerBtn(
                    context,
                    onPressed: () async {
                      final imageFile = await _picker.pickImage(source: ImageSource.camera);
                      if (imageFile != null) {
                        setState(() {
                          fileImage = File(imageFile.path);
                        });
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    iconPath: "assets/icons/ic_camera.png",
                    title: 'Камер',
                  ),
                ),
                HSpacer(),
                Expanded(
                  child: pickerBtn(
                    context,
                    onPressed: () async {
                      final imageFile = await _picker.pickImage(source: ImageSource.gallery);
                      if (imageFile != null) {
                        setState(() {
                          fileImage = File(imageFile.path);
                        });
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    iconPath: "assets/icons/ic_image.png",
                    title: 'Галлерей',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomButton pickerBtn(
    BuildContext context, {
    required Function() onPressed,
    required String iconPath,
    required String title,
  }) {
    return CustomButton(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: GeneralColors.borderColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 60,
                height: 60,
              ),
              VSpacer.sm(),
              Text(
                title,
                style: GeneralTextStyle.bodyText(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
