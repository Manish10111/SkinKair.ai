import './consultation_question_model.dart';

final List<ConsultationQuestion> consultationQuestions = [
  ConsultationQuestion(
    id: 'age_range',
    questionText: "What's your age range?",
    subText: 'This helps us recommend age-appropriate skincare products.',
    options: ['18-','18-25', '26-35', '36-45', '46-55', '55+'],
  ),
  ConsultationQuestion(
    id: 'gender',
    questionText: "What's your gender identity?",
    subText: 'This helps us provide more personalized recommendations.',
    options: ['female', 'male', 'non-binary', 'prefer not to say'],
  ),
  ConsultationQuestion(
    id: 'skin_type',
    questionText: "What's your skin type?",
    subText: 'Understanding your skin type is crucial for effective skincare',
    options: ['oily', 'dry', 'combination', 'normal', 'sensitive'],
  ),
  ConsultationQuestion(
    id: 'allergies',
    questionText: 'Do you have any known skincare allergies ?',
    subText: 'Mention any specific ingredients or say none if you don\'t have any.',
    options: ['none', 'fragrance', 'sulfates', 'parabens', 'other'],
  ),
  ConsultationQuestion(
    id: 'skin_concern',
    questionText: "What's your primary skin concern?",
    subText: 'Tell us what you\'d like to focus on.',
    options: ['acne', 'anti-aging', 'dark spots', 'dryness', 'sensitivity', 'general maintenance'],
  ),
];
