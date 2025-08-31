import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import './gemini_client.dart';
import './gemini_service.dart';

class AiSkincareService {
  static final AiSkincareService _instance = AiSkincareService._internal();
  late final GeminiClient _geminiClient;

  factory AiSkincareService() {
    return _instance;
  }

  AiSkincareService._internal() {
    final service = GeminiService();
    _geminiClient = GeminiClient(service.dio, service.authApiKey);
  }

  Future<Map<String, dynamic>> generatePersonalizedRoutine({
    required int age,
    required String gender,
    required String skinType,
    required List<String> skinGoals,
    String? additionalInfo,
  }) async {
    try {
      final prompt =
          _buildRoutinePrompt(age, gender, skinType, skinGoals, additionalInfo);

      final message = Message(role: 'user', content: prompt);
      final response = await _geminiClient.createChat(
        messages: [message],
        model: 'gemini-1.5-flash-002',
        maxTokens: 2048,
        temperature: 0.7,
      );

      // Parse JSON response from Gemini
      final routineData = _parseRoutineResponse(response.text);

      // Cache the routine locally
      await _cacheRoutine(routineData);

      return routineData;
    } catch (e) {
      throw Exception('Failed to generate personalized routine: $e');
    }
  }

  Future<String> getSkincareAdvice({
    required String question,
    String? skinType,
    String? currentRoutine,
  }) async {
    try {
      final prompt = _buildAdvicePrompt(question, skinType, currentRoutine);

      final message = Message(role: 'user', content: prompt);
      final response = await _geminiClient.createChat(
        messages: [message],
        model: 'gemini-1.5-flash-002',
        maxTokens: 1024,
        temperature: 0.8,
      );

      return response.text;
    } catch (e) {
      throw Exception('Failed to get skincare advice: $e');
    }
  }

  Stream<String> getStreamingAdvice({
    required String question,
    String? skinType,
    String? currentRoutine,
  }) async* {
    try {
      final prompt = _buildAdvicePrompt(question, skinType, currentRoutine);

      final message = Message(role: 'user', content: prompt);
      await for (final chunk in _geminiClient.streamChat(
        messages: [message],
        model: 'gemini-1.5-flash-002',
        maxTokens: 1024,
        temperature: 0.8,
      )) {
        yield chunk;
      }
    } catch (e) {
      throw Exception('Failed to get streaming skincare advice: $e');
    }
  }

  String _buildRoutinePrompt(int age, String gender, String skinType,
      List<String> skinGoals, String? additionalInfo) {
    return '''
You are an expert skincare AI consultant. Generate a personalized 5-step skincare routine based on the following profile:

Age: $age
Gender: $gender
Skin Type: $skinType
Skin Goals: ${skinGoals.join(', ')}
${additionalInfo != null ? 'Additional Information: $additionalInfo' : ''}

Please provide a JSON response with the following structure:
{
  "routine": {
    "morning": [
      {
        "step": 1,
        "category": "cleanser",
        "name": "Product Name",
        "description": "Why this product is recommended",
        "ingredients": ["key", "ingredients"],
        "application": "How to apply",
        "image": "https://images.unsplash.com/photo-skincare-product"
      }
    ],
    "evening": [
      // Similar structure
    ]
  },
  "tips": [
    "Personalized tip 1",
    "Personalized tip 2"
  ],
  "warnings": [
    "Important warning if applicable"
  ]
}

The 5 steps should be: cleanser, toner, serum, moisturizer, sunscreen (morning) / treatment (evening).
Use high-quality Unsplash image URLs for skincare products.
Focus on evidence-based recommendations suitable for the specified age, gender, and skin type.
''';
  }

  String _buildAdvicePrompt(
      String question, String? skinType, String? currentRoutine) {
    return '''
You are an expert skincare consultant and licensed esthetician. Answer the following question with professional, evidence-based advice:

Question: $question

${skinType != null ? 'User\'s Skin Type: $skinType' : ''}
${currentRoutine != null ? 'Current Routine: $currentRoutine' : ''}

Provide a helpful, personalized response that:
1. Addresses the specific question
2. Considers the user's skin type and current routine if provided
3. Includes practical, actionable advice
4. Mentions any important precautions or considerations
5. Is conversational but professional

Keep the response focused and practical, around 2-3 paragraphs.
''';
  }

  Map<String, dynamic> _parseRoutineResponse(String response) {
    try {
      // Clean the response to extract JSON
      String cleanedResponse = response.trim();

      // Find JSON boundaries
      int jsonStart = cleanedResponse.indexOf('{');
      int jsonEnd = cleanedResponse.lastIndexOf('}') + 1;

      if (jsonStart != -1 && jsonEnd > jsonStart) {
        cleanedResponse = cleanedResponse.substring(jsonStart, jsonEnd);
      }

      return jsonDecode(cleanedResponse);
    } catch (e) {
      // Fallback if JSON parsing fails
      return _createFallbackRoutine();
    }
  }

  Map<String, dynamic> _createFallbackRoutine() {
    return {
      "routine": {
        "morning": [
          {
            "step": 1,
            "category": "cleanser",
            "name": "Gentle Foam Cleanser",
            "description": "A mild cleanser to remove overnight buildup",
            "ingredients": ["ceramides", "hyaluronic acid"],
            "application":
                "Massage gently for 30 seconds, rinse with lukewarm water",
            "image":
                "https://images.unsplash.com/photo-1556228720-195a672e8a03?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          },
          {
            "step": 2,
            "category": "toner",
            "name": "Hydrating Toner",
            "description": "Balances pH and adds moisture",
            "ingredients": ["niacinamide", "glycerin"],
            "application": "Pat gently into skin with hands or cotton pad",
            "image":
                "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          },
          {
            "step": 3,
            "category": "serum",
            "name": "Vitamin C Serum",
            "description": "Antioxidant protection and brightening",
            "ingredients": ["vitamin c", "vitamin e"],
            "application": "Apply 2-3 drops, press gently into skin",
            "image":
                "https://images.unsplash.com/photo-1571781926291-c477ebfd024b?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          },
          {
            "step": 4,
            "category": "moisturizer",
            "name": "Daily Moisturizer",
            "description": "Hydrates and strengthens skin barrier",
            "ingredients": ["ceramides", "peptides"],
            "application": "Apply evenly to face and neck",
            "image":
                "https://images.unsplash.com/photo-1556228578-8c89e6adf883?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          },
          {
            "step": 5,
            "category": "sunscreen",
            "name": "Broad Spectrum SPF 50",
            "description": "Essential UV protection for daily use",
            "ingredients": ["zinc oxide", "titanium dioxide"],
            "application": "Apply 15-20 minutes before sun exposure",
            "image":
                "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          }
        ],
        "evening": [
          {
            "step": 1,
            "category": "cleanser",
            "name": "Deep Cleansing Oil",
            "description": "Removes makeup and daily buildup",
            "ingredients": ["jojoba oil", "vitamin e"],
            "application": "Massage onto dry skin, rinse with warm water",
            "image":
                "https://images.unsplash.com/photo-1556228720-195a672e8a03?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          },
          {
            "step": 2,
            "category": "toner",
            "name": "Exfoliating Toner",
            "description": "Gentle exfoliation and pore refinement",
            "ingredients": ["bha", "niacinamide"],
            "application": "Apply with cotton pad, avoid eye area",
            "image":
                "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          },
          {
            "step": 3,
            "category": "serum",
            "name": "Retinol Serum",
            "description": "Anti-aging and skin renewal",
            "ingredients": ["retinol", "peptides"],
            "application": "Start 2-3 times per week, build tolerance",
            "image":
                "https://images.unsplash.com/photo-1571781926291-c477ebfd024b?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          },
          {
            "step": 4,
            "category": "moisturizer",
            "name": "Night Moisturizer",
            "description": "Rich overnight hydration and repair",
            "ingredients": ["ceramides", "hyaluronic acid"],
            "application": "Apply generously before bed",
            "image":
                "https://images.unsplash.com/photo-1556228578-8c89e6adf883?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          },
          {
            "step": 5,
            "category": "treatment",
            "name": "Overnight Treatment",
            "description": "Intensive repair while you sleep",
            "ingredients": ["peptides", "growth factors"],
            "application": "Apply thin layer to targeted areas",
            "image":
                "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?fm=jpg&q=60&w=400&ixlib=rb-4.0.3"
          }
        ]
      },
      "tips": [
        "Always patch test new products",
        "Introduce new products gradually",
        "Consistency is key for results"
      ],
      "warnings": [
        "Use sunscreen daily, especially when using active ingredients"
      ]
    };
  }

  Future<void> _cacheRoutine(Map<String, dynamic> routine) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_routine', jsonEncode(routine));
    await prefs.setString(
        'routine_timestamp', DateTime.now().toIso8601String());
  }

  Future<Map<String, dynamic>?> getCachedRoutine() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_routine');
      final timestamp = prefs.getString('routine_timestamp');

      if (cachedData != null && timestamp != null) {
        final cacheTime = DateTime.parse(timestamp);
        final now = DateTime.now();

        // Cache expires after 24 hours
        if (now.difference(cacheTime).inHours < 24) {
          return jsonDecode(cachedData);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
