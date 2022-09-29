import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _BarChart extends StatelessWidget {
  List<double> last10Score;
  _BarChart({required this.last10Score, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 15,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.toString(),
              TextStyle(
                color: rod.toY == 0 ? const Color(0xff2c4260) : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '1';
        break;
      case 1:
        text = '2';
        break;
      case 2:
        text = '3';
        break;
      case 3:
        text = '4';
        break;
      case 4:
        text = '5';
        break;
      // case 5:
      //   text = '6';
      //   break;
      // case 6:
      //   text = '7';
      //   break;
      // case 7:
      //   text = '8';
      //   break;
      // case 8:
      //   text = '9';
      //   break;
      // case 9:
      //   text = '10';
      //   break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: last10Score[0],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),

        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: last10Score[1],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),

        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: last10Score[2],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),

        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: last10Score[3],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),

        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: last10Score[4],
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        // BarChartGroupData(
        //   x: 5,
        //   barRods: [
        //     BarChartRodData(
        //       toY: last10Score[5],
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
        // BarChartGroupData(
        //   x: 6,
        //   barRods: [
        //     BarChartRodData(
        //       toY: last10Score[6],
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
        // BarChartGroupData(
        //   x: 7,
        //   barRods: [
        //     BarChartRodData(
        //       toY: last10Score[7],
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
        // BarChartGroupData(
        //   x: 8,
        //   barRods: [
        //     BarChartRodData(
        //       toY: last10Score[8],
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
        // BarChartGroupData(
        //   x: 9,
        //   barRods: [
        //     BarChartRodData(
        //       toY: last10Score[9],
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
      ];
}

// ignore: must_be_immutable
class BarChartSample3 extends StatefulWidget {
  List<double> last10;
  BarChartSample3({Key? key, required this.last10}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  Color backColor = const Color(0xff2c4260);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        color: backColor,
        child: _BarChart(last10Score: widget.last10),
      ),
    );
  }
}
