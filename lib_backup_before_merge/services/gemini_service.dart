import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class GeminiService {
  static const int maxRetriesPerModel = 3;

  static Future<Map<String, dynamic>> analyzeResume({
    required String resumeText,
    required String career,
  }) async {
    final prompt = '''
You are an AI career advisor inside an application called SkillPath AI.

Analyze the candidate's resume and target career.

TARGET CAREER:
$career

RESUME:
$resumeText

Your task:
1. Identify skills that are actually present in the resume.
2. Identify important skills missing for the target career.
3. Calculate a realistic career readiness percentage from 0 to 100.
4. Explain the important skill gaps.
5. Create a practical 30-day plan.
6. Create a practical 60-day plan.
7. Create a practical 90-day plan.
8. Recommend practical projects.
9. Recommend useful courses or certification topics.
10. Give a short personalized recommendation.
11. Estimate a 0-100 level for each current skill based only on resume evidence. Put these in skill_levels.

IMPORTANT:
- Do not invent skills that are not supported by the resume.
- Do not assume the candidate knows a skill just because it is related to their degree.
- Compare the resume against the target career.
- Keep the recommendations realistic for a college student.
- Return ONLY valid JSON.
- Do not use markdown.
- Do not put ```json around the response.
- Keep the response concise enough to fit within the output limit.

Return exactly this structure:

{
  "readiness": 0,
  "summary": "short assessment",
  "current_skills": [
    "skill 1",
    "skill 2"
  ],
  "skill_levels": {
    "skill 1": 65,
    "skill 2": 40
  },
  "missing_skills": [
    {
      "skill": "skill name",
      "priority": "High",
      "reason": "why this skill matters"
    }
  ],
  "plan_30_days": [
    "task 1",
    "task 2",
    "task 3"
  ],
  "plan_60_days": [
    "task 1",
    "task 2",
    "task 3"
  ],
  "plan_90_days": [
    "task 1",
    "task 2",
    "task 3"
  ],
  "projects": [
    {
      "title": "project title",
      "description": "short description"
    }
  ],
  "courses": [
    "course or certification topic 1",
    "course or certification topic 2"
  ],
  "recommendation": "short personalized recommendation"
}
''';

    Object? lastError;

    for (final model in <String>[
      ApiConstants.geminiPrimaryModel,
      ApiConstants.geminiFallbackModel,
    ]) {
      try {
        return await _requestModel(
          model: model,
          prompt: prompt,
        );
      } catch (e) {
        lastError = e;
      }
    }

    throw Exception(
      'Gemini is temporarily unavailable. '
          'Both AI models were unable to process the request. '
          'Please wait a few seconds and try again.\n\n'
          'Details: $lastError',
    );
  }

  static Future<Map<String, dynamic>> _requestModel({
    required String model,
    required String prompt,
  }) async {
    Object? lastError;

    for (int attempt = 1; attempt <= maxRetriesPerModel; attempt++) {
      try {
        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/'
              'models/$model:generateContent',
        );

        final response = await http
            .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': ApiConstants.geminiApiKey,
          },
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.3,
              'maxOutputTokens': 4000,
              'responseMimeType': 'application/json',
            },
          }),
        )
            .timeout(const Duration(seconds: 60));

        if (response.statusCode == 200) {
          return parseGeminiResponse(response.body);
        }

        final retryable = <int>{
          429,
          500,
          502,
          503,
          504,
        }.contains(response.statusCode);

        lastError = Exception(
          'Gemini API Error ${response.statusCode}: ${response.body}',
        );

        if (!retryable) {
          return Future<Map<String, dynamic>>.error(lastError!);
        }

        if (attempt < maxRetriesPerModel) {
          await Future<void>.delayed(
            Duration(seconds: 2 * (1 << (attempt - 1))),
          );
        }
      } catch (e) {
        lastError = e;

        if (attempt < maxRetriesPerModel) {
          await Future<void>.delayed(
            Duration(seconds: 2 * (1 << (attempt - 1))),
          );
        }
      }
    }

    throw Exception(
      'Model $model failed after $maxRetriesPerModel attempts. '
          '$lastError',
    );
  }

  static Map<String, dynamic> parseGeminiResponse(String body) {
    try {
      final dynamic data = jsonDecode(body);
      final dynamic candidates = data['candidates'];

      if (candidates is! List || candidates.isEmpty) {
        throw Exception('Gemini returned no response candidates.');
      }

      final dynamic content = candidates[0]['content'];
      final dynamic parts = content is Map ? content['parts'] : null;

      if (parts is! List || parts.isEmpty) {
        throw Exception('Gemini returned an empty response.');
      }

      final String resultText = parts
          .whereType<Map>()
          .map((part) => part['text']?.toString() ?? '')
          .join();

      if (resultText.trim().isEmpty) {
        throw Exception('Gemini returned empty text.');
      }

      String cleaned = resultText.trim();

      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.substring(7).trim();
      } else if (cleaned.startsWith('```')) {
        cleaned = cleaned.substring(3).trim();
      }

      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3).trim();
      }

      final dynamic decoded = jsonDecode(cleaned);

      if (decoded is! Map) {
        throw Exception('Gemini returned JSON in an unexpected format.');
      }

      return Map<String, dynamic>.from(decoded);
    } catch (e) {
      throw Exception('Could not parse Gemini response: $e');
    }
  }
}
