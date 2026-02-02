import 'dart:ui' as ui;

import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final Function(int) onTabSelected; // New callback

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    required this.onTabSelected, // New required parameter
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.animation!,
      builder: (context, _) {
        return Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(tabs.length, (index) {
                return _buildTabItem(context, text: tabs[index], index: index);
              }),
            ),
            Positioned(
              bottom: 0,
              left: _calculateIndicatorPosition(),
              child: Container(
                height: 3, // Indicator height
                width: 18, // Indicator width
                decoration: BoxDecoration(
                  color: ColorUtils.mainColor, // Indicator color
                  borderRadius: BorderRadius.circular(1.5), // Indicator corner radius
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabItem(BuildContext context, {required String text, required int index}) {
    final animation = controller.animation!;
    final double selectionFactor = (1.0 - (animation.value - index).abs()).clamp(0.0, 1.0);
    final Color textColor = Color.lerp(ColorUtils.colorT2, ColorUtils.mainColor, selectionFactor)!;
    final FontWeight fontWeight = FontWeight.lerp(FontWeight.normal, FontWeight.w600, selectionFactor)!;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if(controller.index == index){
          return;
        }
        controller.animateTo(index);
        onTabSelected(index); // Call the callback on tap
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 24, bottom: 9, top: 8), // Spacing between tabs
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }

  double _calculateIndicatorPosition() {
    const double spacing = 24;
    final animationValue = controller.animation!.value;
    
    final tabWidths = tabs.map((text) => _getTextWidth(text, const TextStyle(fontSize: 14))).toList();

    final fromIndex = animationValue.floor();
    final toIndex = animationValue.ceil();
    final t = animationValue - fromIndex;

    double startPos = 0;
    for (int i = 0; i < fromIndex; i++) {
      startPos += tabWidths[i] + spacing;
    }

    double endPos = 0;
    for (int i = 0; i < toIndex; i++) {
      endPos += tabWidths[i] + spacing;
    }
    
    final indicatorWidth = 18.0;
    final fromPos = startPos + (tabWidths[fromIndex] - indicatorWidth) / 2;
    final toPos = endPos + (tabWidths[toIndex] - indicatorWidth) / 2;

    return ui.lerpDouble(fromPos, toPos, t)!;
  }

  double _getTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout();
    return textPainter.size.width;
  }
}
