import 'package:flutter/material.dart';
import 'package:goodali/connection/model/feed_response.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/feed/components/feed_item.dart';
import 'package:goodali/pages/feed/components/filter_page.dart';
import 'package:goodali/pages/feed/create_post.dart';
import 'package:goodali/pages/feed/provider/feed_provider.dart';
import 'package:goodali/pages/home/components/type_bar.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_text_field.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/empty_state.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final FeedProvider _feedProvider;
  final PagingController<int, FeedResponseData> _pagingController = PagingController(firstPageKey: 1);
  final PagingController<int, FeedResponseData> _pagingSecretController = PagingController(firstPageKey: 1);
  final PagingController<int, FeedResponseData> _pagingMyController = PagingController(firstPageKey: 1);

  final int limit = 10;

  @override
  void initState() {
    super.initState();
    _feedProvider = Provider.of<FeedProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey: pageKey, controller: _pagingController, id: 0);
    });
    _pagingSecretController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey: pageKey, controller: _pagingSecretController, id: 1);
    });
    _pagingMyController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey: pageKey, controller: _pagingMyController, id: 2);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _feedProvider.fetchTags();
    });
  }

  Future<void> _fetchPage({
    required int pageKey,
    required PagingController<int, FeedResponseData> controller,
    required int id,
  }) async {
    try {
      final FeedResponse newItems = await _feedProvider.getFeedPost(
        id,
        page: pageKey,
        limit: limit,
      );
      if (newItems.data == null) {
        _pagingController.error = newItems.message;
      }
      final isLastPage = (newItems.data?.length ?? 0) < limit;
      if (isLastPage) {
        controller.appendLastPage(newItems.data ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        controller.appendPage(newItems.data ?? [], nextPageKey);
      }
    } catch (error) {
      controller.error = error;
    }
  }

  refreshPage(int page) {
    /// 0 : Хүнбайгаль
    /// 1 : Нууц бүлгэм
    /// 2 : Миний нандин
    /// 3 : Бүгд
    switch (page) {
      case 0:
        _pagingController.refresh();

        break;
      case 1:
        _pagingSecretController.refresh();

        break;
      case 2:
        _pagingSecretController.refresh();
        break;
      case 3:
        _pagingController.refresh();
        _pagingSecretController.refresh();
        _pagingSecretController.refresh();
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return GeneralScaffold(
          horizontalPadding: 0,
          appBar: CustomAppBar(
            title: Text(
              "Сэтгэл",
              style: GeneralTextStyle.titleText(
                fontSize: 32,
              ),
            ),
            action: [
              Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  return ActionItem(
                    iconPath: "assets/icons/ic_cart.png",
                    count: cartProvider.cartData?.cartItems?.length,
                    onPressed: () {
                      Navigator.pushNamed(context, CartPage.path);
                    },
                  );
                },
              ),
            ],
          ),
          child: Stack(
            children: [
              Consumer<FeedProvider>(builder: (context, feedProvider, _) {
                return Consumer<NavigatorProvider>(
                  builder: (context, provider, _) {
                    return DefaultTabController(
                      length: 3,
                      initialIndex: provider.fireSelectedPage,
                      child: NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomTextField(
                                  hintText: "Пост нэмэх",
                                  readonly: true,
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(context, CreatePost.path) as bool?;
                                    if (result ?? false) {
                                      refreshPage(3);
                                    }
                                  },
                                  controller: TextEditingController(),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: VSpacer(),
                            ),
                            if (feedProvider.selectedTags.isNotEmpty)
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 40,
                                  child: ListView.separated(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final tag = feedProvider.selectedTags[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: GeneralColors.borderColor,
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              tag?.name ?? "",
                                              style: GeneralTextStyle.titleText(
                                                fontSize: 14,
                                              ),
                                            ),
                                            HSpacer.xs(),
                                            CustomButton(
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                              ),
                                              onTap: () {
                                                _feedProvider.removeTag(tag);
                                                refreshPage(provider.fireSelectedPage);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => HSpacer(),
                                    itemCount: feedProvider.selectedTags.length,
                                  ),
                                ),
                              ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _StickyHeaderDelegate(
                                  child: TypeBar(
                                onChanged: (index) {
                                  provider.setFire(index);
                                },
                                selectedType: provider.fireSelectedPage,
                                typeItems: fireTypes,
                              )),
                            ),
                          ];
                        },
                        body: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            pagedView(_pagingController, authProvider),
                            pagedView(_pagingSecretController, authProvider, id: 1),
                            pagedView(_pagingMyController, authProvider),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              if (authProvider.user != null)
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: CustomButton(
                    onTap: () {
                      showModalSheet(
                        context,
                        isScrollControlled: true,
                        height: MediaQuery.of(context).size.height * 0.88,
                        withExpanded: true,
                        child: FilterPage(
                          tags: _feedProvider.tags,
                          selectedTags: _feedProvider.selectedTags,
                          onFinished: (tags) {
                            _feedProvider.setTags(tags);
                            refreshPage(3);
                          },
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: GeneralColors.primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        "assets/icons/ic_filter.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  Widget pagedView(
    PagingController<int, FeedResponseData> pagingController,
    AuthProvider provider, {
    int? id,
  }) {
    if (id == 1 && pagingController.itemList?.isEmpty == true) {
      return Column(
        children: [
          VSpacer(),
          EmptyState(
            title: "Сайн байна уу? Та дээрх үйлдлийг \n хийхийн тулд сургалт авсан байх хэрэгтэй.",
          ),
          VSpacer(size: 50),
          SizedBox(
            width: 200,
            child: PrimaryButton(
              onPressed: () {
                final navProvider = context.read<NavigatorProvider>();
                navProvider.setIndex(0);
                navProvider.setHomePage(3);
              },
              title: "Сургалт харах",
            ),
          )
        ],
      );
    }

    if (provider.user == null) {
      return Center(
        child: Column(
          children: [
            VSpacer(size: 40),
            EmptyState(
              title: "Сайн байна уу? Та дээрх үйлдлийг \n хийхийн тулд нэвтэрсэн  байх хэрэгтэй.",
            ),
            VSpacer(),
            VSpacer(),
            SizedBox(
              width: 200,
              child: Hero(
                tag: "loginButton",
                child: PrimaryButton(
                  onPressed: () {
                    final navProvider = context.read<NavigatorProvider>();
                    navProvider.setIndex(2);
                  },
                  title: "Нэвтрэх",
                ),
              ),
            )
          ],
        ),
      );
    }
    return PagedListView.separated(
      padding: EdgeInsets.all(16),
      pagingController: pagingController,
      separatorBuilder: (context, index) => Divider(),
      builderDelegate: PagedChildBuilderDelegate<FeedResponseData>(
        firstPageErrorIndicatorBuilder: (context) {
          return Column(
            children: [
              EmptyState(
                title: "Сайн байна уу? Та дээрх үйлдлийг \n хийхийн тулд сургалт авсан байх хэрэгтэй.",
              ),
              VSpacer(size: 50),
              SizedBox(
                width: 200,
                child: PrimaryButton(
                  onPressed: () {
                    final navProvider = context.read<NavigatorProvider>();
                    navProvider.setIndex(0);
                    navProvider.setHomePage(3);
                  },
                  title: "Сургалт харах",
                ),
              )
            ],
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return Center(
            child: EmptyState(
              title: "Одоогоор энэхүү хэсэг хоосон байна.",
            ),
          );
        },
        itemBuilder: (BuildContext context, item, int index) {
          return PostItem(
            item: item,
            provider: _feedProvider,
            authProvider: provider,
            pagingController: pagingController,
            onEdit: () async {
              final result = await Navigator.pushNamed(context, CreatePost.path, arguments: item);
              if (result != null) {
                refreshPage(3);
              }
            },
          );
        },
      ),
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
