import 'package:flutter/material.dart';
import 'package:goodali/connection/model/post_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/article/provider/article_provider.dart';
import 'package:goodali/pages/home/components/home_title.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({super.key});

  static const String path = "/article-detail";

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  final _controller = ScrollController();
  late final ArticleProvider _articleProvider;
  PostResponseData? post;

  @override
  void initState() {
    super.initState();
    _articleProvider = Provider.of<ArticleProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoader();
      final id = ModalRoute.of(context)?.settings.arguments as int?;
      await _fetchData(id);
      dismissLoader();
    });
  }

  _fetchData(int? id) async {
    final response = await _articleProvider.getPostById(id);
    _articleProvider.getSimilarArticles(id);
    setState(() {
      post = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ArticleProvider, List<PostResponseData>>(
      selector: (p0, p1) => p1.similarArticles,
      builder: (context, items, _) {
        return GeneralScaffold(
          appBar: CustomAppBar(),
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                Container(),
                CachedImage(
                  imageUrl: post?.banner.toUrl() ?? "",
                  width: 230,
                  borderRadius: 20,
                  height: 230,
                ),
                VSpacer(),
                Text(
                  post?.title ?? "",
                  style: GeneralTextStyle.titleText(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                VSpacer(),
                HtmlWidget(post?.body ?? ""),
                VSpacer(),
                HomeTitle(title: "Төстэй бичвэрүүд"),
                VSpacer(),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Divider(
                    color: GeneralColors.borderColor,
                  ),
                  itemBuilder: (context, index) {
                    final simPost = items[index];
                    return ArticleItem(
                      post: simPost,
                      onPressed: () {
                        _controller.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Easing.linear,
                        );
                        _fetchData(simPost.id);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
