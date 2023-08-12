import 'dart:math';

import 'package:flutter/material.dart';
import 'package:star_book/domain/models/mood/mood.dart';
import 'package:star_book/domain/models/mood/mood_frequency.dart';
import 'package:star_book/presentation/theme/styling/theme_color_style.dart';
import 'package:star_book/presentation/utils/extension.dart';
import 'package:star_book/presentation/widgets/arrow_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MoodDoughnutChart extends StatelessWidget {
  final Map<Mood, Frequency> moodDataMap;

  const MoodDoughnutChart({
    Key? key,
    required this.moodDataMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MoodData> moodList = [];
    moodDataMap
        .forEach((k, v) => moodList.add(MoodData(mood: k, frequency: v)));

    if (moodList.isEmpty) {
      return Center(
        child: Text(
          "Fill up your emotions to the journal to know overall mood",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    List<Frequency> yValues = moodDataMap.entries.map((e) => e.value).toList();
    double highestSectorPercentage = 0.0;
    String highestSectorName = '';

    int highestSectorIndex = 0;
    Frequency highestSectorValue = yValues[0];

    for (int i = 1; i < yValues.length; i++) {
      if (yValues[i] > highestSectorValue) {
        highestSectorIndex = i;
        highestSectorValue = yValues[i];
      }
    }

    highestSectorName = moodList[highestSectorIndex].mood.label;

    Frequency totalValue = yValues.reduce((a, b) => a + b);
    highestSectorPercentage = (highestSectorValue / totalValue) * 100;

    final TextTheme textTheme = context.textTheme;
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final double deviceWidth = context.deviceWidth;
    return SfCircularChart(
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget:
              ArrowIndicator(direction: getHighestSectorCenterAngle(yValues)),
        ),
        CircularChartAnnotation(
          widget: CircleAvatar(
            radius: deviceWidth / 4,
            backgroundColor: themeColorStyle.quinaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your mood spectrum',
                  style: textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  '${highestSectorPercentage.toStringAsFixed(0)}%', // Percentage based on calculation
                  style: textTheme.headlineLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  highestSectorName,
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: themeColorStyle.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      series: <CircularSeries>[
        DoughnutSeries<MoodData, String>(
          animationDuration: 0,
          dataSource: moodList,
          xValueMapper: (MoodData data, _) {
            return data.mood.label;
          },
          yValueMapper: (MoodData data, _) {
            return data.frequency;
          },
          pointColorMapper: (datum, index) {
            List<int> colorList =
                moodDataMap.entries.map((e) => e.key.color).toList();
            return Color(colorList[index]);
          },
          radius: '105%',
          innerRadius: '60%',
        ),
      ],
    );
  }

  double getHighestSectorCenterAngle(List<Frequency> sectorValues) {
    int highestSectorIndex = 0;
    Frequency highestSectorValue = sectorValues[0];

    for (int i = 1; i < sectorValues.length; i++) {
      if (sectorValues[i] > highestSectorValue) {
        highestSectorIndex = i;
        highestSectorValue = sectorValues[i];
      }
    }

    List<double> sectorAngles = [];
    Frequency totalValue = sectorValues.reduce((a, b) => a + b);
    double startAngle = 0;

    for (int i = 0; i < sectorValues.length; i++) {
      double sectorAngle = (sectorValues[i] / totalValue) * 2 * pi;
      sectorAngles.add(startAngle + sectorAngle);
      startAngle += sectorAngle;
    }

    double centerAngle = 0.0;
    if (highestSectorIndex == 0) {
      centerAngle = sectorAngles[highestSectorIndex] / 2;
    } else {
      centerAngle = (sectorAngles[highestSectorIndex - 1] +
              sectorAngles[highestSectorIndex]) /
          2;
    }
    return centerAngle;
  }
}

class MoodData {
  final Mood mood;
  final Frequency frequency;
  const MoodData({required this.mood, required this.frequency});
}
