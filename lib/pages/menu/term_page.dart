import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/shared/components/custom_app_bar.dart';
import 'package:goodali/shared/general_scaffold.dart';
import 'package:goodali/utils/globals.dart';

class TermPage extends StatefulWidget {
  const TermPage({super.key});

  static String path = "/term_page";

  @override
  State<TermPage> createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
  String htmlData = "";
  @override
  void initState() {
    super.initState();
    getHtml();
  }

  Future<void> getHtml() async {
    showLoader();
    final response = await rootBundle.loadString('assets/goodali.html');
    setState(() {
      htmlData = response;
    });
    dismissLoader();
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: CustomAppBar(
        title: Text("Үйлчилгээний нөхцөл"),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: HtmlWidget(htmlData),
        ),
      ),
    );
  }
}
