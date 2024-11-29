import 'package:flutter/material.dart';
import 'package:goodali/connection/model/purchase_response.dart';
import 'package:goodali/connection/model/user_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
// import 'package:goodali/pages/home/components/type_bar.dart';
import 'package:goodali/pages/lesson/item_page.dart';
import 'package:goodali/pages/menu/menu_page.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/pages/podcast/podcast_player.dart';
import 'package:goodali/pages/profile/profile_edit.dart';
import 'package:goodali/pages/profile/provider/profile_provider.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthProvider _authProvider;
  late final ProfileProvider _profileProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoader();
      await _authProvider.getMe();
      await _profileProvider.getUserData();
      dismissLoader();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _profileProvider.dataList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GeneralScaffold(
        horizontalPadding: 0,
        appBar: CustomAppBar(
          title: Text(
            "Би",
            style: GeneralTextStyle.titleText(
              fontSize: 32,
            ),
          ),
          action: [
            ActionItem(
              iconPath: "assets/icons/ic_horizontal_dots.png",
              onPressed: () {
                Navigator.pushNamed(context, MenuPage.path);
              },
            ),
          ],
        ),
        child: Consumer<AuthProvider>(
          builder: (context, provider, _) {
            return Consumer<NavigatorProvider>(
              builder: (context, navigatorProvider, _) {
                return Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                    return NestedScrollView(
                      body: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          RefreshIndicator(
                            onRefresh: () async {
                              profileProvider.getUserData();
                            },
                            child: profileProvider.dataList.isNotEmpty == true
                                ? ListView.separated(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    itemCount: profileProvider.dataList.length,
                                    separatorBuilder: (context, index) => VSpacer(),
                                    itemBuilder: (context, index) {
                                      final data = profileProvider.dataList[index];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (data.withTitle)
                                            Column(
                                              children: [
                                                Text(
                                                  data.title ?? "",
                                                  style: GeneralTextStyle.titleText(fontSize: 22),
                                                ),
                                                VSpacer(),
                                              ],
                                            ),
                                          if (data.items.podcast != null)
                                            PodcastItem(
                                              podcast: data.items.podcast,
                                              type: 'lecture',
                                            ),
                                          if (data.items.book != null)
                                            CustomButton(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  PodcastPlayer.path,
                                                  arguments: {
                                                    "id": data.items.book?.id,
                                                    "data": data.items.book,
                                                    "type": "book",
                                                  },
                                                );
                                              },
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CachedImage(
                                                    imageUrl: data.items.book?.banner.toUrl() ?? placeholder,
                                                    width: 80,
                                                    height: 100,
                                                    borderRadius: 10,
                                                  ),
                                                  HSpacer(),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          data.items.book?.title ?? "",
                                                          style: GeneralTextStyle.titleText(),
                                                        ),
                                                        VSpacer.sm(),
                                                        Text(
                                                          removeHtmlTags(data.items.book?.body ?? ""),
                                                          maxLines: 3,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          if (data.items.training != null)
                                            PurchasedTraining(
                                              training: data.items.training,
                                            )
                                        ],
                                      );
                                    },
                                  )
                                : EmptyState(),
                          ),
                          SizedBox(),
                        ],
                      ),
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ProfileItem(
                                user: provider.user,
                              ),
                            ),
                          ),
                          // SliverToBoxAdapter(
                          //   child: VSpacer(),
                          // ),
                          // SliverPersistentHeader(
                          //   pinned: true,
                          //   delegate: _StickyHeaderDelegate(
                          //     child: TypeBar(
                          //       onChanged: navigatorProvider.setProfile,
                          //       selectedType: navigatorProvider.profileSelectedPage,
                          //       typeItems: profileTypes,
                          //     ),
                          //   ),
                          // ),
                        ];
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class PurchasedTraining extends StatelessWidget {
  const PurchasedTraining({
    super.key,
    required this.training,
  });

  final PurchaseTrainingData? training;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () {
        Navigator.pushNamed(context, ItemPage.path, arguments: training);
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedImage(
              imageUrl: training?.banner.toUrl() ?? placeholder,
              borderRadius: 8,
            ),
          ),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              gradient: LinearGradient(
                stops: const [
                  0.6,
                  1
                ],
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned.fill(
            top: 20,
            bottom: 20,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  training?.name ?? "",
                  style: GeneralTextStyle.titleText(
                    fontSize: 18,
                    textColor: Colors.white,
                  ),
                ),
                Text(
                  "${formatDate(training?.package?.opennedDate)}-${formatDate(training?.package?.expiredDate)}",
                  style: GeneralTextStyle.titleText(
                    textColor: Colors.white,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Цааш үзэх",
                        style: GeneralTextStyle.titleText(
                          fontSize: 14,
                        ),
                      ),
                      HSpacer.sm(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.user,
  });
  final UserResponseData? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedImage(
          imageUrl: user?.avatar.toUrl() ?? "",
          width: 74,
          height: 74,
          size: "xs",
          borderRadius: 50,
        ),
        HSpacer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.nickname ?? "Хэрэглэгч",
                style: GeneralTextStyle.titleText(fontSize: 20),
              ),
              VSpacer.xs(),
              Text(
                user?.email ?? "",
                style: GeneralTextStyle.bodyText(
                  fontSize: 14,
                  textColor: GeneralColors.textGrayColor,
                ),
              ),
            ],
          ),
        ),
        HSpacer(),
        CustomButton(
          onTap: () {
            Navigator.pushNamed(context, ProfileEdit.path);
          },
          child: Text(
            "Засах",
            style: GeneralTextStyle.bodyText(
              fontSize: 14,
              textColor: GeneralColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

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
    return true;
  }
}
