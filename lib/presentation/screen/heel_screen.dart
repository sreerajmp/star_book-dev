import 'package:flutter/material.dart';
import 'package:star_book/presentation/utils/extension.dart';

import '../routes/routes.dart';
import '../shared/app_bar.dart';
import '../theme/styling/theme_color_style.dart';

class HeelScreen extends StatefulWidget implements Screen<HeelScreenRoute> {
  @override
  final HeelScreenRoute arg;

  const HeelScreen({super.key, required this.arg});

  @override
  _HeelScreenState createState() => _HeelScreenState();
}

class _HeelScreenState extends State<HeelScreen> {
  final List<String> questions = [
    '😃 How are you feeling today?',
    '💤 Did you get enough sleep last night?',
    '🏃 Have you engaged in any physical activity recently?',
    '👨‍👩‍👧‍👦 Are you connecting with friends and family?',
    '🧘 Have you tried any relaxation techniques lately?',
  ];

  List<int> answers = List.filled(5, -1);

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
                'Knowing yourself is the best remedy',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium!
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            for (var questionIndex = 0;
                questionIndex < questions.length;
                questionIndex++)
              QuestionWidget(
                question: questions[questionIndex],
                options: [
                  '😄 Excellent',
                  '😊 Good',
                  '😐 Average',
                  '😕 Poor',
                  '😞 Very Poor',
                ],
                onAnswerSelected: (answerIndex) {
                  setState(() {
                    answers[questionIndex] = answerIndex;
                  });

                  if (areAllQuestionsAnswered()) {
                    _showSuggestionDialog();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  bool areAllQuestionsAnswered() {
    return answers.every((answer) => answer != -1);
  }

  void _showSuggestionDialog() {
    String overallSuggestion = getOverallSuggestion(answers);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Complete Suggestion'),
          content: Text(overallSuggestion),
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
  }

  String getOverallSuggestion(List<int> answers) {
    int totalScore = answers.fold(0, (sum, answer) => sum + answer);

    String suggestion = '';

    if (totalScore >= 0 && totalScore <= 5) {
      suggestion =
          '🌟 You are doing great! Keep up the positive mindset. Try taking a leisurely walk in nature to refresh your mind and body.';
    } else if (totalScore >= 6 && totalScore <= 10) {
      suggestion =
          '🌈 Your mental health is in a good place. Maintain healthy habits. Consider trying out a new hobby or spending quality time with loved ones.';
    } else if (totalScore >= 11 && totalScore <= 15) {
      suggestion =
          '🌱 It\'s important to take care of your mental well-being. Consider seeking support if needed. Try practicing mindfulness meditation or enjoying a soothing cup of herbal tea.';
    } else {
      suggestion =
          '🌻 Your mental health seems to be struggling. Please consider talking to a professional. Additionally, engage in activities you enjoy, connect with loved ones, and practice deep breathing exercises.';
    }

    return suggestion;
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
