import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/home/components/type_bar.dart';
import 'package:goodali/pages/home/pages/home_feel.dart';
import 'package:goodali/pages/home/pages/home_listen.dart';
import 'package:goodali/pages/home/pages/home_read.dart';
import 'package:goodali/pages/home/pages/home_training.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_text_field.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeProvider _homeProvider;
  final TextEditingController _searchController = TextEditingController();
  final controller = ScrollController();

  List<Widget> homePage = [];

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _homeProvider.getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, NavigatorProvider>(
      builder: (context, homeProvider, navigatorProvider, _) {
        return GeneralScaffold(
          horizontalPadding: 0,
          appBar: CustomAppBar(
            title: Text(
              "Сэтгэл",
              style: GeneralTextStyle.titleText(fontSize: 32),
            ),
            action: [
              ActionItem(
                iconPath: "assets/icons/ic_cart.png",
                onPressed: () {
                  Navigator.pushNamed(context, CartPage.path);
                },
              ),
            ],
          ),
          child: DefaultTabController(
            initialIndex: navigatorProvider.homeSelectedPage,
            length: homeTypes.length,
            child: NestedScrollView(
              controller: controller,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  if (homeProvider.banners.isNotEmpty)
                    SliverToBoxAdapter(
                      child: CarouselSlider.builder(
                        itemCount: homeProvider.banners.length,
                        options: CarouselOptions(
                          padEnds: false,
                          autoPlay: true,
                          disableCenter: true,
                          viewportFraction: 1,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          final banner = homeProvider.banners[index];
                          return CachedImage(
                            imageUrl: banner.banner.toUrl(),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  const SliverToBoxAdapter(child: VSpacer()),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomTextField(
                        controller: _searchController,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: VSpacer()),

                  // Sticky Header
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                      child: TypeBar(
                        onChanged: (index) {
                          navigatorProvider.setHomePage(index);
                        },
                        selectedType: navigatorProvider.homeSelectedPage,
                        typeItems: homeTypes,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(height: 1, color: GeneralColors.borderColor),
                  ),
                  const SliverToBoxAdapter(child: VSpacer()),
                ];
              },
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  HomeListen(homeData: homeProvider.homeFeel, key: PageStorageKey('HomeListen')),
                  HomeRead(homeData: homeProvider.homeRead, key: PageStorageKey('HomeRead')),
                  HomeFeel(
                    homeData: homeProvider.homeData,
                    key: PageStorageKey('HomeFeel'),
                  ),
                  HomeTraining(
                    homeData: homeProvider.homeTraining,
                    key: PageStorageKey('HomeTraining'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Custom SliverPersistentHeaderDelegate for sticky header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      elevation: shrinkOffset > 0 ? 4 : 0,
      child: child,
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
