import 'dart:ui' as ui;

import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final Function(int) onTabSelected;
  final double selectedFontSize;
  final double unselectedFontSize;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    required this.onTabSelected,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 14.0,
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

    final bool isSelected = animation.value.round() == index;
    final FontWeight fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;
    final double fontSize = isSelected ? selectedFontSize : unselectedFontSize;

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
        padding: const EdgeInsets.only(right: 16, bottom: 9, top: 8), // Spacing between tabs
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }

  double _calculateIndicatorPosition() {
    const double spacing = 16;
    final animationValue = controller.animation!.value;

    final tabWidths = tabs.asMap().entries.map((entry) {
      final index = entry.key;
      final text = entry.value;

      final bool isSelected = animationValue.round() == index;
      final double fontSize = isSelected ? selectedFontSize : unselectedFontSize;
      final FontWeight fontWeight = isSelected ? FontWeight.w600 : FontWeight.normal;

      return _getTextWidth(text, TextStyle(fontSize: fontSize, fontWeight: fontWeight));
    }).toList();

    final fromIndex = animationValue.floor().clamp(0, tabs.length - 1);
    final toIndex = animationValue.ceil().clamp(0, tabs.length - 1);
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
