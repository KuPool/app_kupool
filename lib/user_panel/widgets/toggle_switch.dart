import 'package:Kupool/utils/color_utils.dart';
import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isSelected = true; // true for '15 分钟'

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: 160,
        height: 40,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40 / 2),
          color: Color(0xff767680).withAlpha(30), // Light gray track color from the image
        ),
        child: Stack(
          children: [
            // Animated blue selection thumb
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: isSelected ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 160 / 2, // Takes up half the space
                decoration: BoxDecoration(
                  color: ColorUtils.mainColor,
                  borderRadius: BorderRadius.circular(40 / 2),
                ),
              ),
            ),
            // Text labels that animate their style (color and weight)
            Row(
              children: [
                _buildToggleOption('15 分钟', isSelected),
                _buildToggleOption('1 天', !isSelected),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for text options to avoid repetition
  Widget _buildToggleOption(String text, bool selected) {
    return Expanded(
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Colors.black,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
