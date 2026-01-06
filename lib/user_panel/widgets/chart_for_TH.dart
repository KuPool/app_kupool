import 'dart:math';
import 'package:Kupool/utils/color_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartForTHPage extends StatefulWidget {
  const ChartForTHPage({super.key});

  @override
  State<ChartForTHPage> createState() => _ChartForTHPageState();
}

class _ChartForTHPageState extends State<ChartForTHPage> {
  // 主轴（算力）和次轴（拒绝率）的最大值
  final double _hashrateMaxY = 21.0;
  final double _rejectionMaxY = 10.0;

  // 存储原始数据和归一化后的数据
  late List<FlSpot> _hashrateSpots;
  late List<FlSpot> _rejectionRateSpots;

  @override
  void initState() {
    super.initState();
    _hashrateSpots = _generateRandomData(18, 19, 25);
    final originalRejectionSpots = _generateRandomData(0.01, 0.5, 25, isRejection: true);
    _rejectionRateSpots = originalRejectionSpots.map((spot) {
      final normalizedY = (spot.y / _rejectionMaxY) * _hashrateMaxY;
      return FlSpot(spot.x, normalizedY);
    }).toList();
  }

  List<FlSpot> _generateRandomData(double min, double max, int count, {bool isRejection = false}) {
    final random = Random();
    double value = min + random.nextDouble() * (max - min);
    return List.generate(count, (index) {
      if (isRejection) {
        value += random.nextDouble() * 0.2 - 0.1;
      } else {
        value += random.nextDouble() * 0.5 - 0.25;
      }
      value = value.clamp(min, max);
      return FlSpot(index.toDouble(), value);
    });
  }

  // 手动构建水平网格线
  List<HorizontalLine> _buildHorizontalGridLines() {
    final List<HorizontalLine> lines = [];
    for (double i = 3; i <= _hashrateMaxY; i += 3) {
      lines.add(
        HorizontalLine(
          y: i,
          color: ColorUtils.colorBe,
          strokeWidth: 0.5,
          dashArray: [2, 2],
        ),
      );
    }
    return lines;
  }

  /// 根据传入的文本和样式，计算其渲染宽度
  double _calculateTextWidth(String text, TextStyle style) {
    final textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout();
    return textPainter.size.width;
  }

  /// 构建 Tooltip 的 TextSpan 列表
  List<TextSpan> _getTooltipSpans(String time, String hashrate, String rejection) {
    const labelStyle = TextStyle(color: Colors.white60, fontSize: 10,fontWeight: FontWeight.w500);
    const valueStyle = TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold);
    const totalWidth = 140.0; // 期望的总宽度

    // 计算标签和圆点的宽度
    final dotWidth = _calculateTextWidth('● ', labelStyle);
    final hashrateLabelWidth = _calculateTextWidth('算力', labelStyle) + dotWidth;
    final rejectionLabelWidth = _calculateTextWidth('拒绝率', labelStyle) + dotWidth;

    // 计算数值的宽度
    final hashrateValueWidth = _calculateTextWidth(hashrate, valueStyle);
    final rejectionValueWidth = _calculateTextWidth(rejection, valueStyle);

    // 计算需要的空格填充
    final spaceWidth = _calculateTextWidth(' ', labelStyle);
    final hashratePadding = spaceWidth > 0 ? ' ' * ((totalWidth - hashrateLabelWidth - hashrateValueWidth -16) / spaceWidth).floor() : '';
    final rejectionPadding = spaceWidth > 0 ? ' ' * ((totalWidth - rejectionLabelWidth - rejectionValueWidth -16) / spaceWidth).floor() : '';


    return [
      TextSpan(
        text: '$time\n',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      TextSpan(text: '● ', style: const TextStyle(color: ColorUtils.mainColor, fontSize: 10)),
      TextSpan(text: '算力$hashratePadding', style: labelStyle),
      TextSpan(text: '$hashrate\n', style: valueStyle),
      TextSpan(text: '● ', style: const TextStyle(color: Colors.orange, fontSize: 10)),
      TextSpan(text: '拒绝率$rejectionPadding', style: labelStyle),
      TextSpan(text: rejection, style: valueStyle),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: AspectRatio(
            aspectRatio: 1.8,
            child: LineChart(
              LineChartData(
                clipData: const FlClipData.none(),
                minY: 0,
                maxY: _hashrateMaxY,
                minX: 0,
                maxX: 24,

                gridData: const FlGridData(show: false),

                extraLinesData: ExtraLinesData(
                  horizontalLines: _buildHorizontalGridLines(),
                ),

                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: ColorUtils.colorBe, width: 1),
                    // left: BorderSide(color: Colors.grey[300]!, width: 2),
                    // right: BorderSide(color: Colors.grey[300]!, width: 2),
                    top: BorderSide.none,
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: _hashrateSpots,
                    // isCurved: true,
                    color: ColorUtils.mainColor,
                    barWidth: 1,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: _rejectionRateSpots,
                    // isCurved: true,
                    color: Colors.red,
                    barWidth: 1,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                titlesData: _buildTitlesData(),
                lineTouchData: LineTouchData(
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: ColorUtils.color64,
                          strokeWidth: 0.5,
                          dashArray: [3, 3],
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            final dotColor = barData.color ?? ColorUtils.mainColor;
                            return FlDotCirclePainter(
                              radius: 3,
                              color: dotColor,
                              strokeWidth: 3,
                              strokeColor: dotColor.withAlpha(50),
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 140,
                    fitInsideHorizontally: true,
                    tooltipPadding: EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                    getTooltipColor: (pot) => Colors.black87,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      if (touchedSpots.isEmpty) return [];

                      final time = _getBottomTitle(touchedSpots.first.x, isTooltip: true);
                      final spot1 = _hashrateSpots.firstWhere((s) => s.x == touchedSpots.first.x, orElse: () => touchedSpots.first);
                      final spot2 = _rejectionRateSpots.firstWhere((s) => s.x == touchedSpots.first.x, orElse: () => touchedSpots.first);
                      final originalRejectionY = (spot2.y / _hashrateMaxY) * _rejectionMaxY;

                      final children = _getTooltipSpans(time, '${spot1.y.toStringAsFixed(2)} GH/s', '${originalRejectionY.toStringAsFixed(2)}%');

                      return touchedSpots.map((barSpot) {
                        if (barSpot.barIndex == touchedSpots.first.barIndex) {

                          return LineTooltipItem(
                            "",
                            TextStyle(),
                            children: children,
                            textAlign: TextAlign.left,
                          );
                        } else {
                          return LineTooltipItem('', const TextStyle(fontSize: 0));
                        }
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 26,
          getTitlesWidget: (value, meta) {
            const style = TextStyle(fontSize: 10);
            Widget text;
            if (value == meta.min) {
              text = Text('TH/s      ', style: style.copyWith(color: ColorUtils.color000), textAlign: TextAlign.left);
            } else if (value == meta.max) {
              text = Text('拒绝率%', style: style.copyWith(color: ColorUtils.color000), textAlign: TextAlign.right);
            } else {
              return const Spacer();
            }
            return Container(margin: EdgeInsets.only(bottom: 6),color: Colors.white,child:text,);
            //  return SideTitleWidget(
            //   axisSide: meta.axisSide,
            //   child: text,
            // );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: true,
            interval: 3,
            reservedSize: 20,
            getTitlesWidget: (value, meta) {
              // if (value == 0) return Container();
              return Text(value.toInt().toString(), style: const TextStyle(color: ColorUtils.color555, fontSize: 10), textAlign: TextAlign.left);
            }),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          interval: _hashrateMaxY / (_rejectionMaxY / 2),
          getTitlesWidget: (value, meta) {
            // if (value == 0) return Container();
            final rejectionValue = (value / _hashrateMaxY) * _rejectionMaxY;
            return Text(rejectionValue.toInt().toString(), style: const TextStyle(color: ColorUtils.color555, fontSize: 10), textAlign: TextAlign.right);
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 30,
          getTitlesWidget: (value, meta) => SideTitleWidget(
            axisSide: meta.axisSide,
            child: Text(_getBottomTitle(value), style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ),
        ),
      ),
    );
  }

  String _getBottomTitle(double value, {bool isTooltip = false}) {
    if (isTooltip) {
      final totalHours = 19 + value;
      final day = totalHours >= 24 ? 15 : 14;
      final hourInDay = totalHours.toInt() % 24;
      return '2017/10/${day.toString().padLeft(2, '0')} ${hourInDay.toString().padLeft(2, '0')}:00:00';
    }
    switch (value.toInt()) {
      case 0: return '19:00';
      case 3: return '22:00';
      case 6: return '01:00';
      case 9: return '04:00';
      case 12: return '07:00';
      case 15: return '10:00';
      case 18: return '13:00';
      case 21: return '16:00';
      case 24: return '19:00';
      default: return '';
    }
  }
}
