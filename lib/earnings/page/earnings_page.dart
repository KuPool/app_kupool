import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/earnings/widget/ecological_earnings_page.dart';
import 'package:Kupool/earnings/widget/standard_earnings_page.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningsPage extends StatelessWidget {
  final TabController tabController;

  const EarningsPage({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final dogeLtcListNotifier = context.watch<DogeLtcListNotifier>();

    if (dogeLtcListNotifier.isLoading) {
      return const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,));
    }
    
    return Container(
      color: ColorUtils.widgetBgColor,
      child: TabBarView(
        controller: tabController,
        children: const <Widget>[
          StandardEarningsPage(),
          EcologicalEarningsPage(),
        ],
      ),
    );
  }
}
