import 'package:flutter/material.dart';
import 'package:goodali/connection/model/post_response.dart';
import 'package:goodali/connection/model/tag_response.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/article/provider/article_provider.dart';
import 'package:goodali/pages/feed/components/filter_page.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/dailogs.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  static const String path = "/articles";

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  late final ArticleProvider provider;
  final PagingController<int, PostResponseData> _pagingController = PagingController(firstPageKey: 1);
  List<TagResponseData?> selectedTags = [];

  final int limit = 10;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ArticleProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getTags();
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final tagIds = selectedTags.map((e) => e?.id).toList().join(",");
      final PostResponse newItems = await provider.getArticles(
        page: pageKey.toString(),
        limit: limit.toString(),
        tagIds: tagIds,
      );
      final isLastPage = (newItems.data?.length ?? 0) < limit;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.data ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ArticleProvider, List<TagResponseData>>(
        selector: (p0, p1) => p1.tags,
        builder: (context, tags, _) {
          return GeneralScaffold(
            verticalPadding: 0,
            appBar: CustomAppBar(),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Бичвэр",
                      style: GeneralTextStyle.titleText(fontSize: 32),
                    ),
                    if (selectedTags.isNotEmpty)
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final tag = selectedTags[index];
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
                                      setState(() {
                                        selectedTags.remove(tag);
                                      });
                                      _pagingController.refresh();
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => HSpacer(),
                          itemCount: selectedTags.length,
                        ),
                      ),
                    VSpacer(),
                    Expanded(
                      child: PagedListView.separated(
                        pagingController: _pagingController,
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: GeneralColors.borderColor),
                        ),
                        builderDelegate: PagedChildBuilderDelegate<PostResponseData>(
                          itemBuilder: (BuildContext context, item, int index) {
                            return ArticleItem(
                              post: item,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
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
                          tags: tags,
                          selectedTags: selectedTags,
                          onFinished: (filteredTags) {
                            setState(() {
                              selectedTags = filteredTags;
                            });
                            _pagingController.refresh();
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
        });
  }
}
