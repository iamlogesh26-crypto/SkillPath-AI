import 'package:flutter_test/flutter_test.dart';
import 'package:skillpath_ai/main.dart';

void main() {
  group('Widget & App Startup Tests', () {
    testWidgets('SkillPathAI app startup test', (WidgetTester tester) async {
      await tester.pumpWidget(const SkillPathAI());
      expect(find.text('SkillPath AI'), findsWidgets);
    });
  });

  group('CourseCatalog & ProjectCatalog Tests', () {
    test('forSkills returns matching courses for python and git', () {
      final courses = CourseCatalog.forSkills(['python', 'git']);
      expect(courses, isNotEmpty);
      expect(courses.any((c) => c.skill == 'python'), isTrue);
      expect(courses.any((c) => c.skill == 'git'), isTrue);
    });

    test('forSkills returns empty list when no matching skills', () {
      final courses = CourseCatalog.forSkills(['nonexistent_skill_xyz']);
      expect(courses, isEmpty);
    });

    test('forSkills returns matching projects for python', () {
      final projects = ProjectCatalog.forSkills(['python']);
      expect(projects, isNotEmpty);
      expect(projects.first.skill, equals('python'));
    });
  });

  group('GeminiService Response Parsing Tests', () {
    test('parseGeminiResponse successfully parses valid JSON candidate response', () {
      const mockResponseBody = '''
      {
        "candidates": [
          {
            "content": {
              "parts": [
                {
                  "text": "{\\"readiness\\": 75, \\"summary\\": \\"Good alignment\\", \\"current_skills\\": [\\"python\\"]}"
                }
              ]
            }
          }
        ]
      }
      ''';

      final result = GeminiService.parseGeminiResponse(mockResponseBody);
      expect(result['readiness'], equals(75));
      expect(result['summary'], equals('Good alignment'));
      expect(result['current_skills'], contains('python'));
    });

    test('parseGeminiResponse cleans markdown fences correctly', () {
      const mockResponseBody = '''
      {
        "candidates": [
          {
            "content": {
              "parts": [
                {
                  "text": "```json\\n{\\"readiness\\": 80, \\"summary\\": \\"Solid\\"} \\n```"
                }
              ]
            }
          }
        ]
      }
      ''';

      final result = GeminiService.parseGeminiResponse(mockResponseBody);
      expect(result['readiness'], equals(80));
    });

    test('parseGeminiResponse throws Exception on invalid JSON format', () {
      const mockResponseBody = '{"invalid": true}';
      expect(() => GeminiService.parseGeminiResponse(mockResponseBody), throwsException);
    });
  });
}
