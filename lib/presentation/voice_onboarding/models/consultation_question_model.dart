class ConsultationQuestion {
  final String id;
  final String questionText;
  final String subText;
  final List<String> options;

  ConsultationQuestion({
    required this.id,
    required this.questionText,
    required this.subText,
    required this.options,
  });
}