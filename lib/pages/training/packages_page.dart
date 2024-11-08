import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/model/training_response.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_check_box.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});
  static const String path = "/packages";

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  List<int?> isAgreed = [];
  late final TrainingProvider _trainingProvider;
  List<PackageResponseData> data = [];
  @override
  void initState() {
    _trainingProvider = Provider.of<TrainingProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final detail = ModalRoute.of(context)?.settings.arguments as TrainingInfoResponseData?;
      showLoader();
      final respoonse = await _trainingProvider.getPackages(detail?.id);
      dismissLoader();
      setState(() {
        data = respoonse.data ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      bottom: false,
      appBar: CustomAppBar(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Та өөрт тохирох багц\nсонгоно уу",
              style: GeneralTextStyle.titleText(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            VSpacer(),
            data.isNotEmpty == true
                ? ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    separatorBuilder: (context, index) => VSpacer(),
                    itemBuilder: (context, index) {
                      final package = data[index];
                      return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: GeneralColors.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package.name ?? "",
                              style: GeneralTextStyle.titleText(),
                            ),
                            HtmlWidget(package.body ?? ""),
                            VSpacer(),
                            CustomButton(
                              onTap: () {
                                if (!isAgreed.contains(package.id)) {
                                  isAgreed.add(package.id);
                                } else {
                                  isAgreed.remove(package.id);
                                }
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  CustomCheckBox(
                                    value: isAgreed.contains(package.id),
                                    onChanged: (_) {
                                      if (!isAgreed.contains(package.id)) {
                                        isAgreed.add(package.id);
                                      } else {
                                        isAgreed.remove(package.id);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  HSpacer(),
                                  Expanded(
                                    child: Text("Гэрээтэй танилцан, зөвшөөрсөн"),
                                  )
                                ],
                              ),
                            ),
                            VSpacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  onTap: () async {
                                    if (isAgreed.contains(package.id)) {
                                      final cart = context.read<CartProvider>();
                                      await cart.addCart(package.productId);
                                      if (context.mounted) {
                                        Navigator.pushNamed(context, CartPage.path);
                                      }
                                    } else {
                                      Toast.error(context, description: "Та гэрээтэй танилцан зөвшөөрөх хэрэгтэй");
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: GeneralColors.primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Сонгох',
                                          style: GeneralTextStyle.titleText(
                                            textColor: Colors.white,
                                          ),
                                        ),
                                        HSpacer.sm(),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  formatCurrency(package.price ?? 0),
                                  style: GeneralTextStyle.titleText(),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )
                : Column(
                    children: const [
                      VSpacer(size: 120),
                      Center(
                        child: EmptyState(
                          title: " Тухайн сургалтанд идэвхитэй\n багц олдсонгүй.",
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
