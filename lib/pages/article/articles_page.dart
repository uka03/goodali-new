import 'package:flutter/material.dart';
import 'package:goodali/connection/model/post_response.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/article/provider/article_provider.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
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

  final int limit = 10;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ArticleProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final PostResponse newItems = await provider.getArticles(
        page: pageKey.toString(),
        limit: limit.toString(),
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
    return GeneralScaffold(
      verticalPadding: 0,
      appBar: CustomAppBar(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Бичвэр",
            style: GeneralTextStyle.titleText(fontSize: 32),
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
    );
  }
}
