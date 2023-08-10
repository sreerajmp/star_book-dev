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
            for (var questionIndex = 0; questionIndex < 5; questionIndex++)
              QuestionWidget(
                question: 'Question ${questionIndex + 1}:',
                options: [
                  'Excellent',
                  'Good',
                  'Average',
                  'Poor',
                  'Very Poor',
                ],
                onAnswerSelected: (answerIndex) {
                  // Provide suggestions based on the answer
                  String suggestion = getSuggestion(answerIndex);
                  // Show the suggestion using a dialog or other UI element
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

  String getSuggestion(int answerIndex) {
    if (answerIndex == 0) {
      return 'You are doing great! Keep up the positive mindset.';
    } else if (answerIndex == 1) {
      return 'Your mental health is in a good place. Maintain healthy habits.';
    } else if (answerIndex == 2) {
      return 'It\'s important to take care of your mental well-being. Consider seeking support if needed.';
    } else if (answerIndex == 3) {
      return 'You\'ve indicated your mental health could be better. Reach out to someone for assistance.';
    } else if (answerIndex == 4) {
      return 'Your mental health seems to be struggling. Please consider talking to a professional.';
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
