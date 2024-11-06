import 'package:flutter/material.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/home/components/home_title.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/utils/spacer.dart';

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
