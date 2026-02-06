import 'dart:math';

import 'package:Kupool/drawer/model/sub_account_mini_info_entity.dart';
import 'package:Kupool/drawer/page/doge_ltc_list_page.dart';
import 'package:Kupool/user_panel/model/panel_chart_hashrate_entity.dart';
import 'package:Kupool/user_panel/provider/chart_notifier.dart';
import 'package:Kupool/utils/color_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChartForTHPage extends StatefulWidget {
  const ChartForTHPage({super.key});

  @override
  State<ChartForTHPage> createState() => _ChartForTHPageState();
}

class _ChartForTHPageState extends State<ChartForTHPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chartNotifier = context.watch<ChartNotifier>();


    if (chartNotifier.isLoading && chartNotifier.chartData == null) {
      return SizedBox(height: 140,child: const Center(child: CircularProgressIndicator(color: ColorUtils.mainColor,)));
    }

    final chartData = chartNotifier.chartData;

    if (chartData == null || chartData.ticks == null || chartData.ticks!.isEmpty) {
      return SizedBox(
        height: 140,
        child: Center(
          child: const Text('暂无图表数据'),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        _buildChart(chartData, chartNotifier.dimension),
        Offstage(
          offstage: !chartNotifier.isLoading,
          child: CupertinoActivityIndicator(color: ColorUtils.mainColor,radius: 15,),
        ),
      ],
    );
  }
  List<int> _getEvenlySpacedIndexes(int totalCount, int numberOfPoints) {
    if (totalCount <= numberOfPoints) {
      return List<int>.generate(totalCount, (index) => index);
    }
    final List<int> indexes = [];
    final double step = (totalCount - 1) / (numberOfPoints - 1);
    for (int i = 0; i < numberOfPoints; i++) {
      final index = (i * step).round();
      if (indexes.isEmpty || indexes.last != index) {
        indexes.add(index);
      }
    }
    return indexes;
  }
  Widget _buildTimeLabelsRow(List<PanelChartHashrateTicks> ticks, String dimension) {
    if (ticks.length < 2) {
      return const SizedBox.shrink();
    }

    // 1. 使用我们之前写的算法获取5个均匀分布的索引
    final targetIndexes = _getEvenlySpacedIndexes(ticks.length, 5);

    // 2. 根据索引获取对应的时间字符串
    final labels = targetIndexes.map((index) {
      final tick = ticks[index];
      final parsedAsLocal = DateTime.parse(tick.datetime!);
      final utcDateTime = DateTime.utc(
          parsedAsLocal.year, parsedAsLocal.month, parsedAsLocal.day,
          parsedAsLocal.hour, parsedAsLocal.minute, parsedAsLocal.second
      );
      final dt = utcDateTime.toLocal();
      final format = dimension != '15m' ? DateFormat('MM-dd') : DateFormat('HH:mm');
      return format.format(dt);
    }).toList();
    return Row(
      children: [
        // 第一个标签，左对齐
        Align(
          alignment: Alignment.centerLeft,
          child: Text(labels[0], style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ),
        // 中间的3个标签，使用 Expanded 来均分空间
        if (labels.length > 2)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: labels.sublist(1, labels.length - 1).map((label) {
                return Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10));
              }).toList(),
            ),
          ),
        // 最后一个标签，右对齐
        if (labels.length > 1)
          Align(
            alignment: Alignment.centerRight,
            child: Text(labels.last, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ),
      ],
    );
  }

  Widget _buildChart(PanelChartHashrateEntity chartData, String dimension) {
    var maxHashrateY = chartData.ticks!
        .map((tick) => double.tryParse(tick.hashrate ?? '0') ?? 0.0)
        .fold(0.0, (prev, e) => e > prev ? e : prev);
    if (maxHashrateY <= 0.0) {
      maxHashrateY = 5.0;
    }else{
      maxHashrateY = (maxHashrateY * 1.2).ceilToDouble();
    }

    final spotsData = _generateSpots(chartData.ticks!, maxHashrateY);
    final rejectionSpots = _generateRejectionSpots(chartData.ticks!);

    if (spotsData.spots.isEmpty) {
      return const Center(child: Text('暂无图表数据'));
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.8,
          child: LineChart(
            LineChartData(
              clipData: const FlClipData.none(),
              minY: 0,
              maxY: 100,
              minX: spotsData.minX,
              maxX: spotsData.maxX,
              gridData: const FlGridData(show: false),
              extraLinesData: ExtraLinesData(
                horizontalLines: _buildHorizontalGridLines(),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: ColorUtils.colorBe, width: 1),
                  top: BorderSide.none,
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  spots: rejectionSpots,
                  color: Colors.red,
                  barWidth: 2,
                  curveSmoothness: 0.5,
                  preventCurveOverShooting:true,
                  preventCurveOvershootingThreshold: 1,
                  dotData: const FlDotData(show: false),
                ),
                LineChartBarData(
                  isCurved: true,
                  spots: spotsData.spots,
                  color: ColorUtils.mainColor,
                  barWidth: 2,
                  curveSmoothness: 0.5,
                  preventCurveOverShooting:true,
                  preventCurveOvershootingThreshold: 1,
                  dotData: const FlDotData(show: false),
                ),
              ],
              titlesData: _buildTitlesData(chartData.unit ?? "",chartData.ticks!, maxHashrateY, spotsData.minX, spotsData.maxX, dimension),
              lineTouchData: _buildLineTouchData(chartData, spotsData.maxY),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 8),
          child: _buildTimeLabelsRow(chartData.ticks!, dimension),
        ),
      ],
    );
  }

  ({List<FlSpot> spots, double minX, double maxX, double maxY}) _generateSpots(List<PanelChartHashrateTicks> ticks, double maxHashrateY) {
    if (ticks.isEmpty) {
      return (spots: [], minX: 0, maxX: 0, maxY: 0);
    }
    double minX = double.maxFinite;
    double maxX = double.negativeInfinity;

    final spotList = <FlSpot>[];
    for (var tick in ticks) {
      final parsedAsLocal = DateTime.parse(tick.datetime!);
      final utcDateTime = DateTime.utc(
          parsedAsLocal.year, parsedAsLocal.month, parsedAsLocal.day,
          parsedAsLocal.hour, parsedAsLocal.minute, parsedAsLocal.second
      );
      final dt = utcDateTime.toLocal();
      final x = dt.millisecondsSinceEpoch.toDouble();

      var hashrate = double.tryParse(tick.hashrate ?? '0') ?? 0.0;
      final staleHashrate = double.tryParse(tick.staleHashrate ?? '0') ?? 0.0;
      final rejectHashrate = double.tryParse(tick.rejectHashrate ?? '0') ?? 0.0;
      // 新增算法
      final chartProvider = context.read<ChartNotifier>();
      final dimension = chartProvider.dimension;
      if(dimension == "15m"){
        hashrate = max(hashrate - rejectHashrate, 0.0);
      }else{
        hashrate = max(hashrate - rejectHashrate - staleHashrate, 0.0);
      }

      final y = maxHashrateY > 0 ? (hashrate / maxHashrateY) * 100 : 0.0;

      spotList.add(FlSpot(x, y));
      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
    }
    return (spots: spotList, minX: minX, maxX: maxX, maxY: 100);
  }

  List<FlSpot> _generateRejectionSpots(List<PanelChartHashrateTicks> ticks) {
    final List<FlSpot> rejectionSpots = [];
    for (var tick in ticks) {
      final parsedAsLocal = DateTime.parse(tick.datetime!);
      final utcDateTime = DateTime.utc(
          parsedAsLocal.year, parsedAsLocal.month, parsedAsLocal.day,
          parsedAsLocal.hour, parsedAsLocal.minute, parsedAsLocal.second
      );
      final dt = utcDateTime.toLocal();
      final x = dt.millisecondsSinceEpoch.toDouble();

      final hashrate = double.tryParse(tick.hashrate ?? '0') ?? 0.0;
      final rejectHashrate = double.tryParse(tick.rejectHashrate ?? '0') ?? 0.0;
      double y = 0.0; // 默认为 0

      // 安全检查，防止除以零
      if (hashrate + rejectHashrate > 0) {
        y = (rejectHashrate / (hashrate + rejectHashrate)) * 100;
      }

      rejectionSpots.add(FlSpot(x, y));
    }
    return rejectionSpots;
  }

  List<HorizontalLine> _buildHorizontalGridLines() {
    final List<HorizontalLine> lines = [];
    for (double i = 0; i <= 100; i += 20) {
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

  FlTitlesData _buildTitlesData(String unit,List<PanelChartHashrateTicks> ticks, double maxHashrateY, double minX, double maxX, String dimension) {
    return FlTitlesData(
      topTitles:  AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(fontSize: 10);
                Widget text;
                if (value == meta.min) {
                  text = Text('${unit}H/s', style: style.copyWith(color: ColorUtils.color000), textAlign: TextAlign.left);
                  return Container(margin: EdgeInsets.only(bottom: 12,right: 18),color: Colors.white,child:text,);
                } else if (value == meta.max) {
                  text = Text('拒绝率%', style: style.copyWith(color: ColorUtils.color000), textAlign: TextAlign.right);
                  return Container(margin: EdgeInsets.only(bottom: 12,left: 10),color: Colors.white,child:text,);
                } else {
                  return const SizedBox.shrink();
                }
              }
          )),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20,
          reservedSize: 20,
          getTitlesWidget: (value, meta) {
            if (value > 100) {
              return const SizedBox.shrink();
            }
            final realHashrate = (value / 100) * maxHashrateY;

            final String labelText;
            if (maxHashrateY > 0 && maxHashrateY < 5) {
              labelText = realHashrate.toStringAsFixed(1);
            } else {
              labelText = realHashrate.toStringAsFixed(0);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(labelText, style: const TextStyle(color: ColorUtils.color555, fontSize: 10), textAlign: TextAlign.left),
            );
          },
        ),
        // sideTitles: SideTitles(
        //   showTitles: true,
        //   interval: 20,
        //   reservedSize: 20,
        //   getTitlesWidget: (value, meta) {
        //     if (value > 100 || value < 0) return const SizedBox.shrink();
        //     final realHashrate = (value / 100) * maxHashrateY;
        //     return Padding(
        //       padding: const EdgeInsets.only(bottom: 10),
        //       child: Text(realHashrate.toStringAsFixed(0), style: const TextStyle(color: ColorUtils.color555, fontSize: 10), textAlign: TextAlign.left),
        //     );
        //   },
        // ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20, 
          reservedSize: 24,
          getTitlesWidget: (value, meta) {
            if (value > 100 || value < 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('${value.toInt()}', style: const TextStyle(color: Colors.red, fontSize: 10), textAlign: TextAlign.right),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          interval: (maxX - minX) / 1000,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {

            if (value < meta.min || value > meta.max) {
              return const SizedBox.shrink();
            }

            final List<double> labelPositions = [
              meta.min,                                  // 起点 (0%)
              meta.min + (meta.max - meta.min) * 0.25,   // 四分之一点 (25%)
              meta.min + (meta.max - meta.min) * 0.5,    // 中间点 (50%)
              meta.min + (meta.max - meta.min) * 0.75,   // 四分之三点 (75%)
              meta.max,                                  // 终点 (100%)
            ];

            // 2. 找到与当前 value 最接近的关键点
            double closestPosition = labelPositions.reduce(
                    (a, b) => (value - a).abs() < (value - b).abs() ? a : b);

            // 3. 判断当前 value 是否就是那个最接近的关键点 (在小容差范围内)
            //    如果不是，就说明这个点不需要显示标签，返回空SizedBox
            //    容差可以设为 interval 的一半，保证每个区间最多只有一个标签
            if ((value - closestPosition).abs() > ((maxX - minX) / 1000) / 2) {
              return const SizedBox.shrink();
            }

            final parsedAsLocal = DateTime.fromMillisecondsSinceEpoch(value.toInt());
            final format = dimension != '15m' ? DateFormat('MM-dd') : DateFormat('HH:mm');

            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(format.format(parsedAsLocal), style: const TextStyle(color: Colors.grey, fontSize: 10)),
            );
          },
        ),
      ),
    );
  }

  LineTouchData _buildLineTouchData(PanelChartHashrateEntity chartData, double hashrateMaxY) {
    return LineTouchData(
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
        tooltipPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        getTooltipColor: (spot) => Colors.black87,
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          if (touchedSpots.isEmpty) return [];

          final spotIndex = touchedSpots.first.spotIndex;
          if (spotIndex >= chartData.ticks!.length) return List.generate(touchedSpots.length, (_) => null);

          final tick = chartData.ticks![spotIndex];

          final parsedAsLocal = DateTime.parse(tick.datetime!);
          final utcDateTime = DateTime.utc(
              parsedAsLocal.year, parsedAsLocal.month, parsedAsLocal.day,
              parsedAsLocal.hour, parsedAsLocal.minute, parsedAsLocal.second
          );
          final dt = utcDateTime.toLocal();

          final time = DateFormat('MM-dd HH:mm').format(dt);


          var hashrateX = double.tryParse(tick.hashrate ?? '0') ?? 0.0;
          final rejectHashrateX = double.tryParse(tick.rejectHashrate ?? '0') ?? 0.0;

          final staleHashrate = double.tryParse(tick.staleHashrate ?? '0') ?? 0.0;
          // 新增算法
          final chartProvider = context.read<ChartNotifier>();
          final dimension = chartProvider.dimension;
          if(dimension == "15m"){
            hashrateX = max(hashrateX - rejectHashrateX, 0.0);
          }else{
            hashrateX = max(hashrateX - rejectHashrateX - staleHashrate, 0.0);
          }
          final hashrateStr = hashrateX.toStringAsFixed(2);
          final hashrate = '$hashrateStr ${chartData.unit}';


          double rejectionPercentage = 0.0;

          if (hashrateX + rejectHashrateX > 0) {
            rejectionPercentage = (rejectHashrateX / (hashrateX + rejectHashrateX)) * 100;
          }

          final rejection = '${rejectionPercentage.toStringAsFixed(2)}%';

          final children = [
            TextSpan(
              text: '$time\n',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const TextSpan(text: '● ', style: TextStyle(color: ColorUtils.mainColor, fontSize: 10)),
            const TextSpan(text: '算力 ', style: TextStyle(color: Colors.white60, fontSize: 10)),
            TextSpan(text: hashrate, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            const TextSpan(text: '\n'),
            const TextSpan(text: '● ', style: TextStyle(color: Colors.red, fontSize: 10)),
            const TextSpan(text: '拒绝率 ', style: TextStyle(color: Colors.white60, fontSize: 10)),
            TextSpan(text: rejection, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ];
          
          final tooltipItems = <LineTooltipItem?>[];
          tooltipItems.add(LineTooltipItem(
            '',
            const TextStyle(),
            children: children,
            textAlign: TextAlign.left,
          ));
          
          for (var i = 1; i < touchedSpots.length; i++) {
            tooltipItems.add(null);
          }
          
          return tooltipItems;
        },
      ),
    );
  }
}
