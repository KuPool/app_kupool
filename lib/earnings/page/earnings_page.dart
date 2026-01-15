import 'package:Kupool/earnings/widget/ecological_earnings_page.dart';
import 'package:Kupool/earnings/widget/standard_earnings_page.dart';
import 'package:flutter/material.dart';

class EarningsPage extends StatelessWidget {
  final TabController tabController;

  const EarningsPage({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: const <Widget>[
        StandardEarningsPage(),
        EcologicalEarningsPage(),
      ],
    );
  }
}
