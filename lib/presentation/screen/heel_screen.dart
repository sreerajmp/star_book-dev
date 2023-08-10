import 'package:flutter/material.dart';
import 'package:star_book/presentation/utils/extension.dart';

import '../routes/routes.dart';
import '../shared/app_bar.dart';
import '../theme/styling/theme_color_style.dart';

class HeelScreen extends StatelessWidget implements Screen<HeelScreenRoute> {
  @override
  final HeelScreenRoute arg;

  const HeelScreen({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ThemeColorStyle themeColorStyle = context.themeColorStyle;
    final List<String> questions = [
      'How are you feeling today?',
      'Did you get enough sleep last night?',
      'Have you engaged in any physical activity recently?',
      'Are you connecting with friends and family?',
      'Have you tried any relaxation techniques lately?',
    ];
    return Scaffold(
      appBar: SecondaryAppBar(
        leading: const Image(
          image: AssetImage('assets/icons/shooting_star.png'),
        ),
        trailing: Icons.menu_outlined,
        trailingOnTap: () =>
            context.pushScreen(arg: const SettingsScreenRoute()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'How is your mental health?',
                style: TextStyle(fontSize: 18),
              ),
            ),
            for (var questionIndex = 0;
                questionIndex < questions.length;
                questionIndex++)
              QuestionWidget(
                question: questions[questionIndex],
                options: [
                  'Excellent',
                  'Good',
                  'Average',
                  'Poor',
                  'Very Poor',
                ],
                onAnswerSelected: (answerIndex) {
                  String suggestion = getSuggestion(
                    questions[questionIndex],
                    answerIndex,
                  );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Suggestion'),
                        content: Text(suggestion),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  String getSuggestion(String question, int answerIndex) {
    if (answerIndex == 0) {
      return 'For the question "$question", you are doing great! Keep up the positive mindset.';
    } else if (answerIndex == 1) {
      return 'For the question "$question", your mental health is in a good place. Maintain healthy habits.';
    } else if (answerIndex == 2) {
      return 'For the question "$question", it\'s important to take care of your mental well-being. Consider seeking support if needed.';
    } else if (answerIndex == 3) {
      return 'For the question "$question", you\'ve indicated your mental health could be better. Reach out to someone for assistance.';
    } else if (answerIndex == 4) {
      return 'For the question "$question", your mental health seems to be struggling. Please consider talking to a professional.';
    } else {
      return 'Unknown answer';
    }
  }
}

class QuestionWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final ValueChanged<int> onAnswerSelected;

  const QuestionWidget({
    required this.question,
    required this.options,
    required this.onAnswerSelected,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int _selectedAnswerIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.question,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        for (var index = 0; index < widget.options.length; index++)
          RadioListTile<int>(
            title: Text(widget.options[index]),
            value: index,
            groupValue: _selectedAnswerIndex,
            onChanged: (newValue) {
              setState(() {
                _selectedAnswerIndex = newValue!;
                widget.onAnswerSelected(newValue);
              });
            },
          ),
        Divider(),
      ],
    );
  }
}
