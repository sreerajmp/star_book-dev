import 'package:animations/animations.dart'; // For animations
import 'package:flutter/material.dart';

import '../routes/routes.dart';

class HeelScreen extends StatefulWidget implements Screen<HeelScreenRoute> {
  @override
  final HeelScreenRoute arg;

  const HeelScreen({super.key, required this.arg});

  @override
  _HeelScreenState createState() => _HeelScreenState();
}

class _HeelScreenState extends State<HeelScreen> {
  final List<String> questions = [
    'Have you been feeling down, depressed, irritable, or hopeless today?',
    'Have you had little interest or pleasure in doing things?',
    'Have you had trouble falling asleep, staying asleep, or have you been sleeping too much?',
    'Have you had poor appetite, weight loss, or have you been overeating?',
    'Have you been feeling tired, or have you had little energy?',
    'Have you been feeling bad about yourself - or feeling that you are a failure, or that you have let yourself or your family down?',
    'Have you had trouble concentrating on things like schoolwork, reading, or work?',
    'Have you been moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you were moving around a lot more than usual?',
    'Have you had thoughts that you would be better off dead, or of hurting yourself in some way?',
  ];

  final List<List<int>> answerPoints = [
    [0, 1, 2, 3], // Points for question 1 options
    [0, 1, 2, 3], // Points for question 2 options
    [0, 1, 2, 3], // Points for question 3 options
    [0, 1, 2, 3], // Points for question 4 options
    [0, 1, 2, 3], // Points for question 5 options
    [0, 1, 2, 3], // Points for question 6 options
    [0, 1, 2, 3], // Points for question 7 options
    [0, 1, 2, 3], // Points for question 8 options
    [0, 1, 2, 3], // Points for question 9 options
  ];

  Map<int, int> selectedAnswers = {};
  int currentQuestionIndex = 0;

  void resetQuestions() {
    setState(() {
      selectedAnswers.clear();
      currentQuestionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Check'),
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
                style:
                    textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            if (currentQuestionIndex < questions.length)
              QuestionWidget(
                question: questions[currentQuestionIndex],
                options: const {
                  1: 'Not at all',
                  2: 'Several days',
                  3: 'More than half the days',
                  4: 'Nearly every day',
                },
                onAnswerSelected: (answerIndex) {
                  setState(() {
                    selectedAnswers[currentQuestionIndex] = answerIndex;
                    currentQuestionIndex++;
                  });

                  if (currentQuestionIndex == questions.length) {
                    _showSuggestionDialog();
                  }
                },
                selectedAnswer: selectedAnswers[currentQuestionIndex],
              ),
            if (currentQuestionIndex == questions.length)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'All questions answered!',
                      style: textTheme.titleMedium,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: resetQuestions,
                    child: const Text('Reset'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showSuggestionDialog() {
    String overallSuggestion =
        getOverallSuggestion(selectedAnswers.values.toList());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Complete Suggestion'),
          content: Text(overallSuggestion),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetQuestions();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String getOverallSuggestion(List<int> answerValues) {
    int totalScore = 0;
    for (int i = 0; i < answerValues.length; i++) {
      totalScore += answerPoints[i][answerValues[i] - 1];
    }

    String suggestion = '';
    String activities = '';

    if (totalScore >= 0 && totalScore <= 5) {
      suggestion =
          '🌟 Wonderful news! Your responses suggest that you are sailing smoothly on the sea of positivity. Keep embracing your radiant spirit and indulge in activities that ignite your passion and happiness.';
      activities =
          'Consider spending time in nature, trying out a new hobby, or practicing gratitude journaling to amplify your positive energy.';
    } else if (totalScore >= 6 && totalScore <= 10) {
      suggestion =
          '🌈 It looks like you might be experiencing a gentle drizzle of emotions. Remember, rainbows often follow the rain. Engage in small acts of self-kindness, reach out to friends, and treat yourself to moments of joy.';
      activities =
          'Find solace in reading a book, watching a heartwarming movie, or engaging in creative activities like painting or cooking.';
    } else if (totalScore >= 11 && totalScore <= 15) {
      suggestion =
          '🌱 Your responses reveal the complex landscape of your feelings. Just like a garden needs tending, your well-being deserves care. Seek out supportive conversations, engage in creative endeavors, and surround yourself with moments of tranquility.';
      activities =
          'Practice meditation, deep breathing, or yoga to nurture your emotional well-being. Connect with friends and loved ones through heartfelt conversations.';
    } else {
      suggestion =
          '🌻 It seems like you\'re navigating stormier emotional seas. Remember, even the darkest nights lead to dawn. Don’t hesitate to lean on the anchors of your support system. Professional guidance can be a lighthouse in the darkness. Embrace self-compassion and let moments of sunshine warm your soul.';
      activities =
          'Reach out to a mental health professional to discuss your feelings. Engage in activities you used to enjoy, spend time with pets, and take walks to clear your mind.';
    }

    return '$suggestion\n\nFor an uplifted mood, consider the following activities:\n\n$activities';
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final Map<int, String> options;
  final ValueChanged<int> onAnswerSelected;
  final int? selectedAnswer;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.options,
    required this.onAnswerSelected,
    this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            question,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        for (var entry in options.entries)
          AnimatedRadioButton(
            title: entry.value,
            value: entry.key,
            groupValue: selectedAnswer,
            onChanged: (int? value) {
              // Accept nullable integer
              onAnswerSelected(value!);
            },
          ),
        const Divider(),
      ],
    );
  }
}

class AnimatedRadioButton extends StatelessWidget {
  final String title;
  final int value;
  final int? groupValue;
  final ValueChanged<int?>? onChanged;

  const AnimatedRadioButton({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return RadioListTile<int>(
          title: Text(title),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        );
      },
      openBuilder: (BuildContext _, VoidCallback closeContainer) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (groupValue == value)
                Text(
                  value == 1
                      ? '🙂'
                      : value == 2
                          ? '😕'
                          : value == 3
                              ? '😔'
                              : '😞',
                  style: const TextStyle(fontSize: 24),
                ),
              const SizedBox(height: 16),
              RadioListTile<int>(
                title: Text(title),
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: closeContainer,
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
