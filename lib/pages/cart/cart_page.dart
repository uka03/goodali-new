import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/album/album_detail.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/payment_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/training/training_page.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const String path = "/cart-page";

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartProvider _cartProvider;
  late final AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cartProvider.getItems();
      _authProvider.getMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, _) {
        final cartItem = provider.cartData?.cartItems;
        return GeneralScaffold(
          appBar: CustomAppBar(),
          bottomBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Нийт төлөх дүн: ",
                      children: [
                        TextSpan(
                            text: formatCurrency(provider.cartData?.totalPrice ?? 0),
                            style: GeneralTextStyle.titleText(
                              textColor: GeneralColors.primaryColor,
                            )),
                      ],
                    ),
                  ),
                  VSpacer(),
                  PrimaryButton(
                    isEnable: cartItem?.isNotEmpty == true,
                    onPressed: () {
                      if (_authProvider.user != null) {
                        if (_authProvider.user?.email != "surgalt9@gmail.com") {
                          Navigator.pushNamed(context, PaymentPage.path);
                        } else {
                          Toast.error(
                            context,
                            description: "Та goodali.mn сайтаар орж худалдан авалт хийнэ үү.",
                          );
                        }
                      } else {
                        Toast.error(context, description: "Та эхлээд нэвтрэх хэрэгтэй");
                      }
                    },
                    title: "Худалдаж авах",
                  ),
                ],
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Таны сагс",
                style: GeneralTextStyle.titleText(
                  fontSize: 32,
                ),
              ),
              VSpacer(),
              cartItem?.isNotEmpty == true
                  ? Expanded(
                      child: ListView.separated(
                        itemCount: cartItem?.length ?? 0,
                        separatorBuilder: (context, index) => VSpacer(),
                        itemBuilder: (context, index) {
                          final item = cartItem?[index];
                          return CustomButton(
                            onTap: () {
                              // 0: album 1:lecture 2: training 3:book 4:package

                              switch (item?.productType) {
                                case 0:
                                  Navigator.pushNamed(context, AlbumDetail.path, arguments: item?.productId);
                                  break;
                                case 1:
                                  // Navigator.pushNamed(context, AlbumDetail.path, arguments: item?.productId);
                                  break;
                                case 2:
                                  Navigator.pushNamed(context, TrainingPage.path, arguments: item?.productId);
                                  break;
                                case 4:
                                  Navigator.pushNamed(context, TrainingPage.path, arguments: item?.productId);
                                  break;
                                default:
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: GeneralColors.inputColor,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedImage(
                                      imageUrl: item?.thumbImg?.toUrl() ?? placeholder,
                                      width: 40,
                                      height: 40,
                                      size: "",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  HSpacer(),
                                  Expanded(
                                    child: Text(item?.productName ?? ""),
                                  ),
                                  HSpacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomButton(
                                        onTap: () {
                                          provider.removeCart(item?.productId);
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: GeneralColors.grayColor,
                                        ),
                                      ),
                                      VSpacer.sm(),
                                      Text(
                                        "${formatNumber(item?.price ?? 0)}₮",
                                        style: GeneralTextStyle.bodyText(fontSize: 16),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: EmptyState(
                          title: "Таны сагс хоосон байна...",
                          imagePath: "assets/images/empty_cart.png",
                        ),
                      ),
                    )
            ],
          ),
        );
      },
    );
  }
}
