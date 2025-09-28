import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
// import '../../theme/app_theme.dart';
import 'models/consultation_data.dart';
import 'models/consultation_question_model.dart';
import 'widgets/answer_option_widget.dart';
import 'widgets/progress_indicator_widget.dart';
import 'widgets/question_display_widget.dart';
import 'widgets/voice_visualization_widget.dart';

class VoiceOnboarding extends StatefulWidget {
  const VoiceOnboarding({super.key});

  @override
  State<VoiceOnboarding> createState() => _VoiceOnboardingState();
}

class _VoiceOnboardingState extends State<VoiceOnboarding> {
  // All state variables are declared here at the top
  final supabase = Supabase.instance.client;
  int _currentQuestionIndex = 0;
  String? _selectedOption;
  bool _isProcessing = false;
  final Map<String, String> _userAnswers = {};
  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initializeVoiceServices();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speechToText.stop();
    super.dispose();
  }

  Future<void> saveUserQuiz(Map<String, String> answers) async {
    try {
      print("save quiz in");
      print("{$answers}");
      print("{$answers['age_range']}");
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("No user logged in");

      final response = await supabase.from('user_quiz').insert({
        'id': userId, // assuming you have a user_id foreign key
        'age_range': answers['age_range'],
        'gender': answers['gender'],
        'skin_type': answers['skin_type'],
        'allergies': answers['allergies'],
        'skin_concern': answers['skin_concern'],
      }).select();

      print("Quiz saved successfully! {$response} rows inserted.");
    } catch (e) {
      print("Exception while saving quiz: $e");
    }
  }

  Future<void> _initializeVoiceServices() async {
    print("Hi");

    var status = await Permission.microphone.request();
    print("Microphone permission status: $status");

    if (status.isGranted) {
      bool isInitialized = await _speechToText.initialize(
        onStatus: (status) {
          print("New speech status: $status");
          if (status == 'notListening' || status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          print("Speech recognition error: $error");
        },
      );
      print("Speech-to-Text Initialized: $isInitialized");

      if (isInitialized) {
        await _flutterTts.setSpeechRate(0.5);
        await _flutterTts.awaitSpeakCompletion(true);
        _speakQuestion(
            consultationQuestions[_currentQuestionIndex].questionText);
      }
    }
  }

  Future<void> _speakQuestion(String text) async {
    await _flutterTts.speak(text);
  }

  void _handleAnswerSelected(String option) {
    print("handle");
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _selectedOption = option;
      _userAnswers[consultationQuestions[_currentQuestionIndex].id] = option;
      print(option);
      for (var entry in _userAnswers.entries) {
        print("Question ID: ${entry.key} → Answer: ${entry.value}");
      }
    });
    Future.delayed(const Duration(milliseconds: 500), _nextQuestion);
  }

  void _nextQuestion() async {
    print("ques still");
    if (_currentQuestionIndex < consultationQuestions.length - 1) {
      setState(() {
        print("ques yes");
        _currentQuestionIndex++;
        _selectedOption = null;
        _isProcessing = false;
        _lastWords = '';
      });
      _speakQuestion(consultationQuestions[_currentQuestionIndex].questionText);
    } else {
      await saveUserQuiz(_userAnswers);
      print("User ANswer ---------- {$_userAnswers}");
      print("ques end");
      for (var entry in _userAnswers.entries) {
        print("Question ID: ${entry.key} → Answer: ${entry.value}");
      }
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.productRoutine,
        arguments: _userAnswers,
      );
    }
  }

  void _handleVoiceInput() {
    if (!_speechToText.isAvailable || _isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    setState(() => _isListening = true);
    _speechToText.listen(
      onResult: (result) {
        setState(() => _lastWords = result.recognizedWords);
        _matchVoiceToOption();
      },
      listenFor: const Duration(seconds: 30), // increased from 10
      pauseFor: const Duration(seconds: 5), // wait before auto-stop
      localeId: 'en_US', // force English (US)
    );
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _matchVoiceToOption() {
    if (_lastWords.isEmpty) return;
    final currentOptions = consultationQuestions[_currentQuestionIndex].options;
    for (String option in currentOptions) {
      if (_lastWords.toLowerCase().contains(option.toLowerCase())) {
        if (mounted) {
          _stopListening();
          _handleAnswerSelected(option);
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // This check prevents errors if the question list is somehow empty
    if (consultationQuestions.isEmpty) {
      return const Scaffold(
          body: Center(child: Text("No questions available.")));
    }
    final ConsultationQuestion currentQuestion =
        consultationQuestions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: _currentQuestionIndex > 0
            ? IconButton(
                icon:
                    Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex--;
                    _selectedOption = null;
                    _lastWords = '';
                  });
                  _speakQuestion(consultationQuestions[_currentQuestionIndex]
                      .questionText);
                },
              )
            : null,
        title: Text('Voice Consultation', style: theme.textTheme.titleLarge),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard),
              child: Text('Skip', style: theme.textTheme.bodyLarge),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    (AppBar().preferredSize.height) -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    5.h,
              ),
              child: Column(
                children: [
                  ProgressIndicatorWidget(
                    currentStep: _currentQuestionIndex + 1,
                    totalSteps: consultationQuestions.length,
                  ),
                  SizedBox(height: 4.h),
                  QuestionDisplayWidget(
                    question: currentQuestion.questionText,
                    subtitle: currentQuestion.subText,
                    onReplay: () =>
                        _speakQuestion(currentQuestion.questionText),
                  ),
                  SizedBox(height: 4.h),
                  Wrap(
                    spacing: 3.w,
                    runSpacing: 2.h,
                    alignment: WrapAlignment.center,
                    children: currentQuestion.options.map((option) {
                      return AnswerOptionWidget(
                        text: option,
                        isSelected: _selectedOption == option,
                        onTap: () => _handleAnswerSelected(option),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Tap to speak your answer',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 2.h),
                  VoiceVisualizationWidget(
                    isListening: _isListening,
                    onMicrophoneTap: _handleVoiceInput,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
