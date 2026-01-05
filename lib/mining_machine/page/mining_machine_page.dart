import 'dart:math';
import 'package:Kupool/utils/color_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MiningMachinePage extends StatefulWidget {
  const MiningMachinePage({super.key});

  @override
  State<MiningMachinePage> createState() => _MiningMachinePageState();
}

class _MiningMachinePageState extends State<MiningMachinePage> {
  // 主轴（算力）和次轴（拒绝率）的最大值
  final double _hashrateMaxY = 50.0;
  final double _rejectionMaxY = 100.0;

  // 存储原始数据和归一化后的数据
  late List<FlSpot> _hashrateSpots;
  late List<FlSpot> _rejectionRateSpots;

  @override
  void initState() {
    super.initState();
    _hashrateSpots = _generateRandomData(20, _hashrateMaxY, 24);
    final originalRejectionSpots = _generateRandomData(2, 20, 24, isRejection: true);
    _rejectionRateSpots = originalRejectionSpots.map((spot) {
      final normalizedY = (spot.y / _rejectionMaxY) * _hashrateMaxY;
      return FlSpot(spot.x, normalizedY);
    }).toList();
  }

  List<FlSpot> _generateRandomData(double min, double max, int count, {bool isRejection = false}) {
    final random = Random();
    double value = min + random.nextDouble() * (max - min);
    return List.generate(count, (index) {
      int randomNumber = random.nextInt(10) + 1;
      if (isRejection) {
        value += random.nextDouble() * 0.25 - 0.1;
      } else {
        value += random.nextDouble() * 2 - randomNumber;
      }
      value = value.clamp(min, max);
      return FlSpot(index.toDouble(), value);
    });
  }

  // 手动构建水平网格线
  List<HorizontalLine> _buildHorizontalGridLines() {
    final List<HorizontalLine> lines = [];
    // We start from 3 because we don't want a line at y=0 (which is the border)
    for (double i = 3; i <= _hashrateMaxY; i += 3) {
      lines.add(
        HorizontalLine(
          y: i,
          color:  ColorUtils.colorBe,
          strokeWidth: 0.5,
          dashArray: [2,2], // 添加dashArray属性以创建虚线
        ),
      );
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hash Chart', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ToggleButtons(
              isSelected: const [false, true],
              onPressed: (index) {},
              borderRadius: BorderRadius.circular(4),
              selectedColor: Colors.black,
              color: Colors.grey[600],
              fillColor: Colors.grey[200],
              constraints: const BoxConstraints(minHeight: 32.0, minWidth: 60.0),
              children: const [Text('1 Hour'), Text('1 Day')],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 180,
            color: Colors.yellow,
          ),
          Padding(
            // 恢复顶部的 Padding
            padding: const EdgeInsets.fromLTRB(16, 0, 20, 16),
            child: AspectRatio(
              aspectRatio: 1.8,
              child: LineChart(
                LineChartData(
                  clipData: FlClipData.horizontal(), // <-- 允许 Tooltip 超出边界
                  minY: 0,
                  maxY: 50,
                  minX: 0,
                  maxX: 24,

                  gridData: const FlGridData(show: false),

                  // 虚线绘制
                  // extraLinesData: ExtraLinesData(
                  //   horizontalLines: _buildHorizontalGridLines(),
                  // ),

                  // 绘制 X, Y 轴线
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Color(0xffbebebe), width: 1),
                      // left: BorderSide(color: Colors.grey[300]!, width: 2),
                      // right: BorderSide(color: Colors.grey[300]!, width: 2),
                      top: BorderSide.none, // 顶部不显示
                    ),
                  ),

                  lineBarsData: [
                    LineChartBarData(
                      spots: _hashrateSpots,
                      isCurved: true,
                      color: ColorUtils.mainColor,
                      barWidth: 1,
                      dotData: const FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: _rejectionRateSpots,
                      // isCurved: true,
                      color: Colors.redAccent,
                      barWidth: 1,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  titlesData: _buildTitlesData(),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // fitInsideVertically: true,
                      // fitInsideHorizontally: true,
                        tooltipPadding:EdgeInsets.zero,
                      getTooltipColor: (index){
                        return Colors.black;
                      },
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        // --- 错误修复开始 ---
                        if (touchedSpots.isEmpty) {
                          return [];
                        }

                        // 首先聚合所有数据
                        final time = _getBottomTitle(touchedSpots.first.x, isTooltip: true);
                        String hashrateText = '';
                        String rejectionText = '';

                        for (var spot in touchedSpots) {
                          if (spot.barIndex == 0) { // 算力线
                            hashrateText = '算力: ${spot.y.toStringAsFixed(3)} PH/s';
                          } else if (spot.barIndex == 1) { // 拒绝率线
                            final originalY = (spot.y / _hashrateMaxY) * _rejectionMaxY;
                            rejectionText = '拒绝率: ${originalY.toStringAsFixed(3)}%';
                          }
                        }

                        // 创建一个和 touchedSpots 等长的列表
                        return touchedSpots.map((touchedSpot) {
                          // 只在第一个 item 中显示所有文本
                          if (touchedSpot.barIndex == touchedSpots.first.barIndex) {
                            final text = '$time\n$hashrateText\n$rejectionText';
                            return LineTooltipItem(
                              text,
                              const TextStyle(color: Colors.white, fontSize: 12),
                            );
                          }
                        }).toList();
                        // --- 错误修复结束 ---
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitlesWidget: (value, meta) {
            const style = TextStyle(fontSize: 9);
            Widget text;
            if (value == meta.min) {
               text = Text('TH/s          ', style: style.copyWith(color: ColorUtils.color000), textAlign: TextAlign.left);
            } else if (value == meta.max) {
               text = Text('拒绝率%', style: style.copyWith(color: ColorUtils.color000), textAlign: TextAlign.left);
            } else {
              return Container();
            }
             return SideTitleWidget(
              axisSide: meta.axisSide,
              child: text,
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            reservedSize: 20,
            getTitlesWidget: (value, meta) {
              return Text(value.toInt().toString(), style:  TextStyle(color: ColorUtils.color555, fontSize: 8), textAlign: TextAlign.left);
            }),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          interval: 10,
          getTitlesWidget: (value, meta) {
            // if (value == 0) return Container();
            final rejectionValue = (value / _hashrateMaxY) * _rejectionMaxY;
            return Text(rejectionValue.toInt().toString(), style: TextStyle(color: ColorUtils.color555, fontSize: 8),textAlign: TextAlign.right);
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
            child: Text(_getBottomTitle(value), style: const TextStyle(color: ColorUtils.color555, fontSize: 8)),
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
