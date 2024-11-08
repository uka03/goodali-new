import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/training/packages_page.dart';
import 'package:goodali/pages/training/provider/training_provider.dart';
import 'package:goodali/shared/components/cached_image.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/components/primary_button.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  static const path = "/training-detail";

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  late final TrainingProvider _trainingProvider;

  @override
  void initState() {
    super.initState();
    _trainingProvider = Provider.of<TrainingProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = ModalRoute.of(context)?.settings.arguments as int?;
      _trainingProvider.getTraining(id);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _trainingProvider.trainingInfo = null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingProvider>(builder: (context, provider, _) {
      final detail = provider.trainingInfo;
      return GeneralScaffold(
        horizontalPadding: 0,
        verticalPadding: 0,
        appBar: CustomAppBar(),
        bottomBar: Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
          color: Colors.transparent,
          child: PrimaryButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                PackagesPage.path,
                arguments: provider.trainingInfo,
              );
            },
            title: "Худалдаж авах",
          ),
        ),
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedImage(
                imageUrl: detail?.banner.toUrl() ?? "",
              ),
            ),
            VSpacer(),
            Center(
              child: Text(
                detail?.name ?? "",
                style: GeneralTextStyle.titleText(fontSize: 24),
              ),
            ),
            VSpacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HtmlWidget(
                detail?.body ?? "",
              ),
            ),
            Container(),
          ],
        ),
      );
    });
  }
}
