import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/book/book_page.dart';
import 'package:goodali/pages/home/components/home_title.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';

class HomeRead extends StatelessWidget {
  const HomeRead({super.key, required this.homeData});

  final List<HomeDataType> homeData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: homeData.length,
      separatorBuilder: (context, index) => VSpacer(size: 20),
      itemBuilder: (context, index) {
        final data = homeData[index];
        return Column(
          children: [
            if (data.title?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    HomeTitle(
                      title: data.title ?? "",
                      onPressed: data.path?.isNotEmpty == true
                          ? () {
                              Navigator.pushNamed(context, data.path ?? "/");
                            }
                          : null,
                    ),
                    VSpacer(),
                  ],
                ),
              ),
            if (data.item.book?.isNotEmpty == true)
              SizedBox(
                height: 265,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.item.book?.length ?? 0,
                  separatorBuilder: (context, index) => HSpacer(),
                  itemBuilder: (context, index) {
                    final book = data.item.book?[index];
                    return CustomButton(
                      onTap: () {
                        Navigator.pushNamed(context, BookPage.path, arguments: book?.id);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImage(
                            imageUrl: book?.banner.toUrl() ?? placeholder,
                            height: 200,
                            width: 160,
                            borderRadius: 12,
                          ),
                          VSpacer(),
                          Text(
                            book?.title ?? "",
                            style: GeneralTextStyle.titleText(),
                          ),
                          Text(
                            formatCurrency(book?.price ?? 0),
                            style: GeneralTextStyle.bodyText(
                              fontSize: 14,
                              textColor: GeneralColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (data.item.post != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ArticleItem(post: data.item.post),
              ),
          ],
        );
      },
    );
  }
}
