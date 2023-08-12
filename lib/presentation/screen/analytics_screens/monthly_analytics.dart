import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_book/domain/models/mood/mood_frequency.dart';
import 'package:star_book/domain/repository/mood_repo.dart';
import 'package:star_book/presentation/cubits/analytiics_screen_cubit.dart';
import 'package:star_book/presentation/cubits/cubit_state/cubit_state.dart';
import 'package:star_book/presentation/injector/injector.dart';
import 'package:star_book/presentation/shared/legends_chart.dart';
import 'package:star_book/presentation/shared/loader.dart';
import 'package:star_book/presentation/theme/styling/theme_color_style.dart';
import 'package:star_book/presentation/utils/extension.dart';
import 'package:star_book/presentation/utils/padding_style.dart';
import 'package:star_book/presentation/widgets/doughnut_chart.dart';

class MonthlyAnalyticsTab extends StatelessWidget {
  const MonthlyAnalyticsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = context.deviceHeight;

    // Get the current month
    final currentMonth = DateTime.now().month;

    return BlocProvider<AnalyticsScreenCubit>(
      create: (context) => AnalyticsScreenCubit(
        moodRepo: Injector.resolve<MoodRepo>(),
      )..getMoodFrequencyByMonth(month: currentMonth, year: 2023),
      child: BlocBuilder<AnalyticsScreenCubit, CubitState<MoodFrequency>>(
        builder: (context, state) {
          return state.when(
              initial: () => const Loader(),
              loading: () => const Loader(),
              loaded: (mood) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CustomPadding.mediumPadding),
                  child: Column(
                    children: [
                      MoodDoughnutChart(moodDataMap: mood.info),
                      SizedBox(height: deviceHeight * 0.05),
                      const SelectableTab(),
                      SizedBox(height: deviceHeight * 0.03),
                      const LegendsChart(),
                    ],
                  ),
                );
              },
              error: (e) => Text(e.toString()));
        },
      ),
    );
  }
}

class SelectableTab extends StatefulWidget {
  const SelectableTab({super.key});

  @override
  State<SelectableTab> createState() => _SelectableTabState();
}

class _SelectableTabState extends State<SelectableTab> {
  String selectedMonth = ''; // Initially empty

  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
    // Set the selected month to the current month
    selectedMonth = months[DateTime.now().month - 1]; // Months are 1-indexed
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final double deviceHeight = context.deviceHeight;
    final double deviceWidth = context.deviceWidth;

    return BlocBuilder<AnalyticsScreenCubit, CubitState<MoodFrequency>>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Scroll horizontally
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: months.map((month) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMonth = month;
                  });

                  final year = DateTime.now().year;

                  // Call the getMoodFrequencyByMonth with the selected month and year
                  context.read<AnalyticsScreenCubit>().getMoodFrequencyByMonth(
                        month:
                            months.indexOf(month) + 1, // Months are 1-indexed
                        year: year,
                      );
                },
                child: Container(
                  width: deviceWidth * 0.105,
                  height: deviceHeight * 0.03,
                  decoration: BoxDecoration(
                    color: (month == selectedMonth)
                        ? themeColorStyle.secondaryColor
                        : themeColorStyle.secondaryColor.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    month,
                    style: textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: (month == selectedMonth)
                          ? themeColorStyle.quinaryColor
                          : themeColorStyle.secondaryColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
