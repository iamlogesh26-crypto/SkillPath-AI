import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================
// ============================================================

// Paste your NEW Gemini API key between the quotes. Do not commit the key to GitHub.
const String geminiApiKey = 'YOUR_API_KEY';

const String geminiPrimaryModel = 'gemini-3.5-flash';
const String geminiFallbackModel = 'gemini-3.5-flash-lite';
const Color kPrimary = Color(0xFF5B5FEF);
const Color kPrimaryDark = Color(0xFF3F46C8);
const Color kAccent = Color(0xFF7C4DFF);
const Color kSurface = Color(0xFFF7F8FC);
const Color kText = Color(0xFF15162A);
const Color kMuted = Color(0xFF6B7280);

BoxDecoration appCardDecoration({double radius = 24}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: const Color(0xFFE8EAF4)),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF2F3573).withOpacity(0.07),
        blurRadius: 24,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

LinearGradient get appGradient => const LinearGradient(
  colors: [kPrimaryDark, kPrimary, kAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);


// ============================================================
// COURSE RECOMMENDATIONS
// ============================================================

class CourseRecommendation {
  final String skill;
  final String title;
  final String provider;
  final String duration;
  final String difficulty;
  final String url;

  const CourseRecommendation({
    required this.skill,
    required this.title,
    required this.provider,
    required this.duration,
    required this.difficulty,
    required this.url,
  });
}

class CourseCatalog {
  static const List<CourseRecommendation> courses = [
    CourseRecommendation(
      skill: 'python',
      title: 'Python Certification',
      provider: 'freeCodeCamp',
      duration: 'Self-paced',
      difficulty: 'Beginner',
      url: 'https://www.freecodecamp.org/learn/python-v9/',
    ),
    CourseRecommendation(
      skill: 'data structures',
      title: 'Algorithms and Data Structure Certification',
      provider: 'freeCodeCamp',
      duration: 'Self-paced',
      difficulty: 'Intermediate',
      url: 'https://www.freecodecamp.org/learn/algorithms-and-data-structure/',
    ),
    CourseRecommendation(
      skill: 'algorithms',
      title: 'Algorithms and Data Structure Certification',
      provider: 'freeCodeCamp',
      duration: 'Self-paced',
      difficulty: 'Intermediate',
      url: 'https://www.freecodecamp.org/learn/algorithms-and-data-structure/',
    ),
    CourseRecommendation(
      skill: 'git',
      title: 'Introduction to Git',
      provider: 'GitHub Skills',
      duration: 'Short interactive course',
      difficulty: 'Beginner',
      url: 'https://skills.github.com/',
    ),
    CourseRecommendation(
      skill: 'github',
      title: 'GitHub Skills',
      provider: 'GitHub',
      duration: 'Self-paced',
      difficulty: 'Beginner',
      url: 'https://skills.github.com/',
    ),
    CourseRecommendation(
      skill: 'machine learning',
      title: 'Machine Learning Crash Course',
      provider: 'Google for Developers',
      duration: 'Self-paced',
      difficulty: 'Intermediate',
      url: 'https://developers.google.com/machine-learning/crash-course',
    ),
    CourseRecommendation(
      skill: 'sql',
      title: 'Relational Database Certification',
      provider: 'freeCodeCamp',
      duration: 'Self-paced',
      difficulty: 'Beginner',
      url: 'https://www.freecodecamp.org/learn/relational-database/',
    ),
    CourseRecommendation(
      skill: 'html',
      title: 'Responsive Web Design Certification',
      provider: 'freeCodeCamp',
      duration: 'Self-paced',
      difficulty: 'Beginner',
      url: 'https://www.freecodecamp.org/learn/2022/responsive-web-design/',
    ),
    CourseRecommendation(
      skill: 'css',
      title: 'Responsive Web Design Certification',
      provider: 'freeCodeCamp',
      duration: 'Self-paced',
      difficulty: 'Beginner',
      url: 'https://www.freecodecamp.org/learn/2022/responsive-web-design/',
    ),
    CourseRecommendation(
      skill: 'javascript',
      title: 'JavaScript Certification',
      provider: 'freeCodeCamp',
      duration: 'Self-paced',
      difficulty: 'Beginner',
      url: 'https://www.freecodecamp.org/learn/javascript-algorithms-and-data-structures-v8/',
    ),
  ];

  static List<CourseRecommendation> forSkills(List<String> skills) {
    final result = <CourseRecommendation>[];
    final seen = <String>{};

    for (final rawSkill in skills) {
      final normalized = rawSkill.toLowerCase().trim();
      for (final course in courses) {
        if (normalized.contains(course.skill) ||
            course.skill.contains(normalized)) {
          final key = course.title.toLowerCase();
          if (seen.add(key)) result.add(course);
        }
      }
    }

    return result;
  }
}


// ============================================================
// PROJECT -> SKILL MAPPING
// ============================================================

class ProjectRecommendation {
  final String skill;
  final String title;
  final String description;
  final String level;
  final String duration;
  final String tech;
  final String outcome;

  const ProjectRecommendation({
    required this.skill,
    required this.title,
    required this.description,
    required this.level,
    required this.duration,
    required this.tech,
    required this.outcome,
  });
}

class ProjectCatalog {
  static const List<ProjectRecommendation> projects = [
    ProjectRecommendation(
      skill: 'python',
      title: 'Smart Study Planner',
      description: 'Build a Python app that tracks subjects, deadlines, study hours and completion status.',
      level: 'Beginner',
      duration: '3–5 days',
      tech: 'Python • JSON • CLI/UI',
      outcome: 'Practice Python logic, files and application design.',
    ),
    ProjectRecommendation(
      skill: 'data structures',
      title: 'DSA Visualizer',
      description: 'Create an interactive visualizer for stacks, queues, linked lists, trees and searching.',
      level: 'Intermediate',
      duration: '5–7 days',
      tech: 'Flutter • Dart • DSA',
      outcome: 'Demonstrate data structures with a portfolio-ready interface.',
    ),
    ProjectRecommendation(
      skill: 'algorithms',
      title: 'Algorithm Race Arena',
      description: 'Compare sorting and searching algorithms using random datasets and animated results.',
      level: 'Intermediate',
      duration: '4–6 days',
      tech: 'Flutter • Dart • Algorithms',
      outcome: 'Understand complexity and algorithm performance visually.',
    ),
    ProjectRecommendation(
      skill: 'git',
      title: 'Team Git Workflow Lab',
      description: 'Create a small team project and practice branches, pull requests, issues and releases.',
      level: 'Beginner',
      duration: '2–3 days',
      tech: 'Git • GitHub • Markdown',
      outcome: 'Build real collaboration experience for your portfolio.',
    ),
    ProjectRecommendation(
      skill: 'github',
      title: 'Open-Source Contribution Sprint',
      description: 'Find a beginner-friendly repository, fix documentation or a small issue, then submit a pull request.',
      level: 'Beginner',
      duration: '2–4 days',
      tech: 'Git • GitHub • Markdown',
      outcome: 'Create a public contribution you can show during placements.',
    ),
    ProjectRecommendation(
      skill: 'machine learning',
      title: 'Student Performance Predictor',
      description: 'Train a simple model to estimate student performance from study-related features.',
      level: 'Intermediate',
      duration: '5–7 days',
      tech: 'Python • Pandas • ML',
      outcome: 'Practice data preparation, model training and evaluation.',
    ),
    ProjectRecommendation(
      skill: 'sql',
      title: 'College Placement Database',
      description: 'Design a relational database for students, companies, applications, interviews and offers.',
      level: 'Beginner',
      duration: '3–4 days',
      tech: 'SQL • Relational DB',
      outcome: 'Practice schema design, joins, queries and reporting.',
    ),
    ProjectRecommendation(
      skill: 'javascript',
      title: 'Campus Event Dashboard',
      description: 'Build a responsive dashboard for college events, registrations and announcements.',
      level: 'Beginner',
      duration: '4–6 days',
      tech: 'HTML • CSS • JavaScript',
      outcome: 'Demonstrate frontend fundamentals and interactive UI skills.',
    ),
    ProjectRecommendation(
      skill: 'html',
      title: 'Student Portfolio Website',
      description: 'Create a responsive personal portfolio with projects, certifications, skills and contact sections.',
      level: 'Beginner',
      duration: '2–4 days',
      tech: 'HTML • CSS',
      outcome: 'Create a deployable portfolio for internships and placements.',
    ),
  ];

  static List<ProjectRecommendation> forSkills(List<String> skills) {
    final result = <ProjectRecommendation>[];
    final seen = <String>{};
    for (final rawSkill in skills) {
      final normalized = rawSkill.toLowerCase().trim();
      for (final project in projects) {
        if (normalized.contains(project.skill) || project.skill.contains(normalized)) {
          if (seen.add(project.title)) result.add(project);
        }
      }
    }
    return result;
  }
}

// ============================================================
// MAIN
// ============================================================

void main() {
  runApp(const SkillPathAI());
}

// ============================================================
// GEMINI SERVICE
// ============================================================

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

    // Try the main model first. If Gemini is temporarily busy (503/429/5xx),
    // retry with exponential backoff before moving to the fallback model.
    for (final model in <String>[
      geminiPrimaryModel,
      geminiFallbackModel,
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
            'x-goog-api-key': geminiApiKey,
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
          return _parseGeminiResponse(response.body);
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

        // Timeout/network failures are also transient. Retry them.
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

  static Map<String, dynamic> _parseGeminiResponse(String body) {
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

      // Safety cleanup in case the model adds a markdown JSON fence despite
      // the responseMimeType setting.
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

// ============================================================
// APP
// ============================================================


// ============================================================
// SKILLPATH AI — REFERENCE DASHBOARD UI
// ============================================================

const Color kNavy = Color(0xFF090B18);
const Color kPanel = Color(0xFF111426);
const Color kPanel2 = Color(0xFF171A30);
const Color kLine = Color(0xFF292D4B);
const Color kPurple = Color(0xFF8B5CF6);
const Color kBlue = Color(0xFF6D7CFF);
const Color kCyan = Color(0xFF38D9FF);
const Color kOrange = Color(0xFFFFA62B);
const Color kPink = Color(0xFFFF4FD8);
const Color kGreen = Color(0xFF45E6A0);
const Color kWhite = Color(0xFFF7F7FF);
const Color kSoft = Color(0xFFB9BDD7);

class SkillPathAI extends StatelessWidget {
  const SkillPathAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillPath AI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kNavy,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: kPurple, brightness: Brightness.dark),
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      ),
      home: const CareerDashboard(),
    );
  }
}

class CareerDashboard extends StatefulWidget {
  const CareerDashboard({super.key});

  @override
  State<CareerDashboard> createState() => _CareerDashboardState();
}

class _CareerDashboardState extends State<CareerDashboard> {
  int selectedPage = 0;
  String? selectedCareer;
  String resumeStatus = 'Upload your resume to begin';
  String resumeText = '';
  String? resumeName;
  bool isExtracting = false;
  bool isAnalyzing = false;
  Map<String, dynamic>? aiData;
  Map<String, dynamic>? previousAiData;

  final careers = const [
    'Embedded Systems Engineer',
    'IoT Engineer',
    'Software Developer',
    'AI/ML Engineer',
    'Data Analyst',
    'Cybersecurity Engineer',
  ];

  Future<void> pickResume() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (file == null) return;
      setState(() {
        isExtracting = true;
        resumeName = file.name;
        resumeStatus = 'Processing resume...';
      });
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final extracted = PdfTextExtractor(document).extractText();
      document.dispose();
      if (extracted.trim().isEmpty) {
        setState(() {
          isExtracting = false;
          resumeText = '';
          resumeStatus = 'No readable text found in this PDF.';
        });
        return;
      }
      setState(() {
        isExtracting = false;
        resumeText = extracted;
        resumeStatus = 'Resume processed successfully';
      });
      if (mounted) _toast('Resume extracted successfully');
    } catch (e) {
      setState(() {
        isExtracting = false;
        resumeStatus = 'Could not read resume';
      });
      if (mounted) _toast('Could not read PDF: $e');
    }
  }

  Future<void> analyzeCareer() async {
    if (resumeText.isEmpty) {
      _toast('Upload a readable PDF resume first.');
      return;
    }
    if (selectedCareer == null) {
      _toast('Choose a target career first.');
      return;
    }
    if (geminiApiKey == 'PASTE_YOUR_NEW_GEMINI_API_KEY_HERE' || geminiApiKey.trim().isEmpty) {
      _toast('Add your Gemini API key in main.dart first.');
      return;
    }
    setState(() => isAnalyzing = true);
    try {
      final result = await GeminiService.analyzeResume(
        resumeText: resumeText,
        career: selectedCareer!,
      );
      if (!mounted) return;
      setState(() {
        isAnalyzing = false;
        if (aiData != null) previousAiData = Map<String, dynamic>.from(aiData!);
        aiData = result;
        selectedPage = 1;
      });
      _toast('AI career analysis completed');
    } catch (e) {
      if (!mounted) return;
      setState(() => isAnalyzing = false);
      _toast('AI analysis failed: $e', seconds: 8);
    }
  }

  void _toast(String message, {int seconds = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: seconds)),
    );
  }

  void goTo(int page) {
    if (page != 0 && page != 7 && aiData == null) {
      _toast('Complete your resume analysis first.');
      return;
    }
    setState(() => selectedPage = page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNavy,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 1050;
            return Row(
              children: [
                if (desktop) _Sidebar(selectedPage: selectedPage, onSelect: goTo),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(
                        career: selectedCareer,
                        onNotification: () => _toast('You are all caught up.'),
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          child: _pageFor(selectedPage, desktop),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 1050
          ? _MobileNav(selectedPage: selectedPage, onSelect: goTo)
          : null,
    );
  }

  Widget _pageFor(int page, bool desktop) {
    switch (page) {
      case 1:
        return AnalysisPage(
          key: const ValueKey('analysis'),
          career: selectedCareer ?? 'Target career',
          aiData: aiData!,
          onRoadmap: () => goTo(2),
          onCourses: () => goTo(3),
          onProjects: () => goTo(4),
          onReanalyze: () => setState(() => selectedPage = 0),
          onGrowth: () => goTo(5),
        );
      case 2:
        return RoadmapPage(
          key: const ValueKey('roadmap'),
          career: selectedCareer ?? 'Target career',
          aiData: aiData!,
        );
      case 3:
        return CoursesPage(
          key: const ValueKey('courses'),
          career: selectedCareer ?? 'Target career',
          aiData: aiData!,
        );
      case 5:
        return GrowthPage(
          key: const ValueKey('growth'),
          career: selectedCareer ?? 'Target career',
          currentData: aiData!,
          previousData: previousAiData,
          onReanalyze: () => setState(() => selectedPage = 0),
        );
      case 6:
        return JobsPage(
          key: const ValueKey('jobs'),
          career: selectedCareer ?? 'Target career',
          aiData: aiData!,
        );
      case 4:
        return ProjectsPage(
          key: const ValueKey('projects'),
          career: selectedCareer ?? 'Target career',
          aiData: aiData!,
        );
      case 7:
        return ProfilePage(
          key: const ValueKey('profile'),
          career: selectedCareer,
          aiData: aiData,
        );
      default:
        return DashboardPage(
          key: const ValueKey('home'),
          career: selectedCareer,
          careers: careers,
          resumeName: resumeName,
          resumeStatus: resumeStatus,
          isExtracting: isExtracting,
          isAnalyzing: isAnalyzing,
          aiData: aiData,
          onUpload: pickResume,
          onAnalyze: analyzeCareer,
          onCareerChanged: (value) => setState(() => selectedCareer = value),
          onAnalysis: () => goTo(1),
          onRoadmap: () => goTo(2),
          onCourses: () => goTo(3),
          onProjects: () => goTo(4),
        );
    }
  }
}

class _TopBar extends StatelessWidget {
  final String? career;
  final VoidCallback onNotification;
  const _TopBar({required this.career, required this.onNotification});

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 1050;
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Color(0xFF080B19),
        border: Border(bottom: BorderSide(color: kLine)),
      ),
      child: Row(children: [
        if (mobile) ...[
          Container(width: 34, height: 34, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: const LinearGradient(colors: [kPurple, kBlue])), child: const Icon(Icons.auto_awesome_rounded, size: 18)),
          const SizedBox(width: 9),
        ],
        if (!mobile) const Spacer(),
        Expanded(
          child: Container(
            height: 38,
            constraints: const BoxConstraints(maxWidth: 430),
            margin: EdgeInsets.only(left: mobile ? 8 : 40),
            decoration: BoxDecoration(color: const Color(0xFF10152A), borderRadius: BorderRadius.circular(12), border: Border.all(color: kLine)),
            child: const Row(children: [
              SizedBox(width: 12),
              Icon(Icons.search_rounded, color: kSoft, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('Search anything...', style: TextStyle(color: kSoft, fontSize: 11))),
              Padding(padding: EdgeInsets.only(right: 10), child: Text('⌘ K', style: TextStyle(color: kSoft, fontSize: 9))),
            ]),
          ),
        ),
        const Spacer(),
        IconButton(onPressed: onNotification, tooltip: 'Notifications', icon: const Icon(Icons.notifications_none_rounded, color: kSoft, size: 20)),
        const SizedBox(width: 5),
        Container(width: 34, height: 34, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [kPurple, kBlue]), boxShadow: [BoxShadow(color: kPurple.withOpacity(.3), blurRadius: 14)]), child: const Center(child: Text('LS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)))),
        const SizedBox(width: 7),
        if (!mobile) const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text('Logesh S', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: kWhite)), Text('Student • ECE', style: TextStyle(fontSize: 8, color: kSoft))]),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_arrow_down_rounded, color: kSoft, size: 17),
      ]),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int selectedPage;
  final ValueChanged<int> onSelect;
  const _Sidebar({required this.selectedPage, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 218,
      decoration: const BoxDecoration(color: Color(0xFF080B19), border: Border(right: BorderSide(color: kLine))),
      child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 20, 16, 26), child: Row(children: [
          Container(width: 34, height: 34, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: const LinearGradient(colors: [kPurple, kBlue]), boxShadow: [BoxShadow(color: kPurple.withOpacity(.3), blurRadius: 18)]), child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 19)),
          const SizedBox(width: 10),
          const Text('SkillPath', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: kWhite)),
          const Text(' AI', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: kPurple)),
        ])),
        _sectionLabel('WORKSPACE'),
        _sideItem(Icons.dashboard_rounded, 'Dashboard', 0),
        _sideItem(Icons.description_outlined, 'Resume Analysis', 1),
        _sideItem(Icons.trending_up_rounded, 'Career Growth', 5),
        _sideItem(Icons.work_outline_rounded, 'Jobs & Internships', 6),
        _sideItem(Icons.route_rounded, 'Roadmap', 2),
        _sideItem(Icons.school_outlined, 'Courses', 3),
        _sideItem(Icons.code_rounded, 'Projects', 4),
        _sideItem(Icons.insights_outlined, 'Progress', 5),
        _sideItem(Icons.person_outline_rounded, 'Profile', 7),
        const Spacer(),
        _sideItem(Icons.settings_outlined, 'Settings', -1),
        _sideItem(Icons.logout_rounded, 'Logout', -1),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _sectionLabel(String text) => Padding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 8), child: Align(alignment: Alignment.centerLeft, child: Text(text, style: const TextStyle(fontSize: 8, letterSpacing: 1.2, fontWeight: FontWeight.w900, color: Color(0xFF68708F)))));

  Widget _sideItem(IconData icon, String label, int index) {
    final active = selectedPage == index && index >= 0;
    return InkWell(
      onTap: index >= 0 ? () => onSelect(index) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: active ? const LinearGradient(colors: [Color(0xFF653ED8), Color(0xFF3858D8)]) : null, border: active ? Border.all(color: kPurple.withOpacity(.38)) : null, boxShadow: active ? [BoxShadow(color: kPurple.withOpacity(.16), blurRadius: 16)] : null),
        child: Row(children: [Icon(icon, size: 17, color: active ? Colors.white : kSoft), const SizedBox(width: 11), Expanded(child: Text(label, style: TextStyle(fontSize: 10.5, color: active ? Colors.white : kSoft, fontWeight: active ? FontWeight.w800 : FontWeight.w600))), if (active) const Icon(Icons.chevron_right_rounded, size: 14, color: Colors.white54)]),
      ),
    );
  }
}

class _MobileNav extends StatelessWidget {
  final int selectedPage;
  final ValueChanged<int> onSelect;
  const _MobileNav({required this.selectedPage, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedPage.clamp(0, 7).toInt();
    return NavigationBar(
      backgroundColor: const Color(0xFF080B19),
      indicatorColor: kPurple.withOpacity(.22),
      selectedIndex: safeIndex,
      onDestinationSelected: onSelect,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description), label: 'Resume'),
        NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Roadmap'),
        NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
        NavigationDestination(icon: Icon(Icons.code_outlined), selectedIcon: Icon(Icons.code), label: 'Projects'),
        NavigationDestination(icon: Icon(Icons.trending_up_outlined), selectedIcon: Icon(Icons.trending_up), label: 'Growth'),
        NavigationDestination(icon: Icon(Icons.work_outline_rounded), selectedIcon: Icon(Icons.work_rounded), label: 'Jobs'),
        NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String? career;
  final List<String> careers;
  final String? resumeName;
  final String resumeStatus;
  final bool isExtracting;
  final bool isAnalyzing;
  final Map<String, dynamic>? aiData;
  final VoidCallback onUpload;
  final VoidCallback onAnalyze;
  final ValueChanged<String?> onCareerChanged;
  final VoidCallback onAnalysis;
  final VoidCallback onRoadmap;
  final VoidCallback onCourses;
  final VoidCallback onProjects;

  const DashboardPage({super.key, required this.career, required this.careers, required this.resumeName, required this.resumeStatus, required this.isExtracting, required this.isAnalyzing, required this.aiData, required this.onUpload, required this.onAnalyze, required this.onCareerChanged, required this.onAnalysis, required this.onRoadmap, required this.onCourses, required this.onProjects});

  @override
  Widget build(BuildContext context) {
    final readiness = aiData == null ? 0 : ((aiData!['readiness'] ?? 0) as num).round().clamp(0, 100);
    final skills = aiData?['current_skills'] is List ? (aiData!['current_skills'] as List) : const [];
    final gaps = aiData?['missing_skills'] is List ? (aiData!['missing_skills'] as List) : const [];
    final projects = aiData?['projects'] is List ? (aiData!['projects'] as List) : const [];
    final courses = aiData?['courses'] is List ? (aiData!['courses'] as List) : const [];
    final wide = MediaQuery.of(context).size.width >= 1150;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(wide ? 28 : 16, 24, wide ? 28 : 16, 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Good Morning, Logesh 👋', style: TextStyle(fontSize: wide ? 25 : 21, fontWeight: FontWeight.w900, color: kWhite)),
            const SizedBox(height: 4),
            const Text('Your skills today build your tomorrow', style: TextStyle(fontSize: 11, color: kSoft)),
          ])),
          if (career != null) _GlowChip(career!, kPurple),
        ]),
        const SizedBox(height: 18),
        if (wide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 7, child: _Panel(child: _dashboardMain(readiness, skills, gaps, projects, courses))),
            const SizedBox(width: 14),
            SizedBox(width: 285, child: _dashboardSide(readiness, skills, gaps)),
          ])
        else ...[
          _Panel(child: _dashboardMain(readiness, skills, gaps, projects, courses)),
          const SizedBox(height: 14),
          _dashboardSide(readiness, skills, gaps),
        ],
        const SizedBox(height: 14),
        _TargetSetup(careers: careers, career: career, onChanged: onCareerChanged, onAnalyze: onAnalyze, loading: isAnalyzing),
        const SizedBox(height: 14),
        _Pipeline(),
      ]),
    );
  }

  Widget _dashboardMain(int readiness, List<dynamic> skills, List<dynamic> gaps, List<dynamic> projects, List<dynamic> courses) {
    final target = career ?? 'Target Role';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Expanded(child: Text('Your Career Journey', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: kWhite))),
        _GlowChip(aiData == null ? 'GET STARTED' : 'AI GENERATED', aiData == null ? kOrange : kGreen),
      ]),
      const SizedBox(height: 4),
      const Text('From Skills to Success', style: TextStyle(fontSize: 9, color: kSoft)),
      const SizedBox(height: 14),
      Container(height: 218, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Color(0xFF101734), Color(0xFF0C1023)]), border: Border.all(color: kLine)), child: LayoutBuilder(builder: (context, c) {
        return Stack(children: [
          Positioned.fill(child: CustomPaint(painter: _EnhancedJourneyPainter())),
          Positioned(left: 18, top: 20, child: _JourneyNode(icon: Icons.auto_awesome_rounded, title: 'Current Skills', subtitle: '${skills.length} analyzed', color: kCyan)),
          Positioned(left: c.maxWidth * .31, top: 94, child: _JourneyNode(icon: Icons.psychology_rounded, title: 'Gap Analysis', subtitle: '${gaps.length} identified', color: kOrange, onTap: onAnalysis)),
          Positioned(right: c.maxWidth * .27, top: 20, child: _JourneyNode(icon: Icons.school_rounded, title: 'Learning Path', subtitle: 'Personalized', color: kPurple, onTap: onRoadmap)),
          Positioned(right: 18, top: 94, child: _JourneyNode(icon: Icons.workspace_premium_rounded, title: 'Target Role', subtitle: target, color: kPink)),
          Positioned(left: c.maxWidth / 2 - 48, top: 69, child: _ReadinessOrb(value: readiness)),
        ]);
      })),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: _ReferenceStatCard(icon: Icons.auto_awesome_rounded, title: 'Current Skills', value: '${skills.length}', sub: 'Analyzed', color: kCyan)),
        const SizedBox(width: 8),
        Expanded(child: _ReferenceStatCard(icon: Icons.warning_amber_rounded, title: 'Skill Gaps', value: '${gaps.length}', sub: 'To improve', color: kOrange)),
        const SizedBox(width: 8),
        Expanded(child: _ReferenceStatCard(icon: Icons.school_rounded, title: 'Courses', value: '${courses.length}', sub: 'Recommended', color: kPurple)),
        const SizedBox(width: 8),
        Expanded(child: _ReferenceStatCard(icon: Icons.code_rounded, title: 'Projects', value: '${projects.length}', sub: 'Recommended', color: kGreen)),
      ]),
      const SizedBox(height: 14),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _RecentActivity(aiData: aiData)),
        const SizedBox(width: 12),
        Expanded(child: _QuickActions(onUpload: onUpload, onAnalysis: onAnalysis, onRoadmap: onRoadmap, onCourses: onCourses, onProjects: onProjects, resumeName: resumeName, extracting: isExtracting)),
      ]),
    ]);
  }

  Widget _dashboardSide(int readiness, List<dynamic> skills, List<dynamic> gaps) => Column(children: [
    _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Text('Career Readiness', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)), const Spacer(), const Icon(Icons.more_horiz, color: kSoft, size: 18)]),
      const SizedBox(height: 14),
      Center(child: _ReadinessOrb(value: readiness)),
      const SizedBox(height: 12),
      Center(child: Text(readiness >= 70 ? 'On Track' : readiness >= 40 ? 'Building Momentum' : 'Start Your Journey', style: const TextStyle(fontSize: 11, color: kGreen, fontWeight: FontWeight.w800))),
      const SizedBox(height: 10),
      const Text('Keep learning and building projects to reach your target role.', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: kSoft, height: 1.4)),
    ])),
    const SizedBox(height: 12),
    _InsightsPanel(aiData: aiData),
  ]);
}

class _ReferenceStatCard extends StatelessWidget {
  final IconData icon; final String title, value, sub; final Color color;
  const _ReferenceStatCard({required this.icon, required this.title, required this.value, required this.sub, required this.color});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: const Color(0xFF11162C), borderRadius: BorderRadius.circular(11), border: Border.all(color: color.withOpacity(.16))), child: Row(children: [Container(width: 30, height: 30, decoration: BoxDecoration(color: color.withOpacity(.11), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 15)), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)), Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8.5, color: kWhite, fontWeight: FontWeight.w700)), Text(sub, style: const TextStyle(fontSize: 7.5, color: kSoft))]))]));
}

class _RecentActivity extends StatelessWidget {
  final Map<String, dynamic>? aiData;
  const _RecentActivity({required this.aiData});
  @override Widget build(BuildContext context) => _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Recent Activity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)), const SizedBox(height: 10), _activity(Icons.description_outlined, 'Resume analysis updated', aiData == null ? 'Waiting for upload' : 'Ready for review', kCyan), _activity(Icons.school_outlined, 'Learning path prepared', aiData == null ? 'Choose a target career' : 'Personalized courses available', kPurple), _activity(Icons.code_rounded, 'Project portfolio', aiData == null ? 'Projects appear after analysis' : 'Build projects to strengthen your profile', kGreen)]));
  Widget _activity(IconData icon, String title, String sub, Color color) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Container(width: 29, height: 29, decoration: BoxDecoration(color: color.withOpacity(.11), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 15)), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, color: kSoft))]))]));
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onUpload, onAnalysis, onRoadmap, onCourses, onProjects; final String? resumeName; final bool extracting;
  const _QuickActions({required this.onUpload, required this.onAnalysis, required this.onRoadmap, required this.onCourses, required this.onProjects, required this.resumeName, required this.extracting});
  @override Widget build(BuildContext context) => _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Quick Actions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)), const SizedBox(height: 10), Wrap(spacing: 7, runSpacing: 7, children: [
    _action(Icons.upload_file_rounded, 'Upload Resume', onUpload, kBlue), _action(Icons.analytics_outlined, 'View Analysis', onAnalysis, kCyan), _action(Icons.route_rounded, 'View Roadmap', onRoadmap, kPurple), _action(Icons.school_outlined, 'Find Courses', onCourses, kGreen), _action(Icons.code_rounded, 'Find Projects', onProjects, kOrange),
  ]), const SizedBox(height: 10), Text(extracting ? 'Reading resume...' : resumeName ?? 'No resume uploaded yet', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8.5, color: kSoft))]));
  Widget _action(IconData icon, String text, VoidCallback tap, Color color) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(9), child: Container(width: 106, padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: color.withOpacity(.07), borderRadius: BorderRadius.circular(9), border: Border.all(color: color.withOpacity(.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color, size: 17), const SizedBox(height: 7), Text(text, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800))])));
}

class _PageHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  const _PageHeading({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kWhite)),
    const SizedBox(height: 5),
    Text(subtitle, style: const TextStyle(color: kSoft, fontSize: 13, height: 1.5)),
  ]);
}

class _Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _Panel({required this.child, this.padding = const EdgeInsets.all(18)});
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(16), border: Border.all(color: kLine), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.18), blurRadius: 24, offset: const Offset(0, 12))]),
    child: child,
  );
}

class _ResumePanel extends StatelessWidget {
  final String? resumeName;
  final String status;
  final bool extracting;
  final VoidCallback onUpload;
  const _ResumePanel({required this.resumeName, required this.status, required this.extracting, required this.onUpload});
  @override
  Widget build(BuildContext context) => _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Resume Analysis & Skills', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: kWhite)),
    const SizedBox(height: 14),
    InkWell(onTap: extracting ? null : onUpload, borderRadius: BorderRadius.circular(12), child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF1B1E35), borderRadius: BorderRadius.circular(12), border: Border.all(color: kPurple.withOpacity(.45))),
      child: Column(children: [
        Icon(extracting ? Icons.hourglass_top_rounded : Icons.upload_file_rounded, size: 36, color: kPurple),
        const SizedBox(height: 7),
        Text(extracting ? 'Processing Resume...' : 'Upload Your Resume', style: const TextStyle(fontWeight: FontWeight.w800, color: kWhite)),
        const SizedBox(height: 5),
        Text(extracting ? 'Extracting PDF text' : 'PDF • AI skill extraction', style: const TextStyle(color: kSoft, fontSize: 11)),
        if (extracting) ...[const SizedBox(height: 10), LinearProgressIndicator(minHeight: 4, borderRadius: BorderRadius.circular(8), color: kPurple, backgroundColor: kLine)],
      ]),
    )),
    const SizedBox(height: 14),
    Container(height: 150, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFF0C0F20), borderRadius: BorderRadius.circular(12), border: Border.all(color: kLine)), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.picture_as_pdf_rounded, size: 38, color: resumeName == null ? kSoft : kPink), const SizedBox(height: 8), Text(resumeName ?? 'No resume uploaded', textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kSoft, fontSize: 11))]))),
    const SizedBox(height: 12),
    Text(status, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kSoft, fontSize: 11)),
    const SizedBox(height: 13),
    const Text('Identified Skills', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kWhite)),
    const SizedBox(height: 8),
    const Wrap(spacing: 6, runSpacing: 6, children: [
      _GlowChip('Python', kOrange), _GlowChip('Data Analysis', kPurple), _GlowChip('Communication', kBlue),
    ]),
  ]));
}

class _GlowChip extends StatelessWidget {
  final String text;
  final Color color;
  const _GlowChip(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(.13), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(.42))), child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)));
}

class _CareerJourneyCard extends StatelessWidget {
  final String? career;
  final Map<String, dynamic>? aiData;
  final VoidCallback onAnalysis;
  final VoidCallback onRoadmap;
  final VoidCallback onCourses;
  final VoidCallback onProjects;
  const _CareerJourneyCard({required this.career, required this.aiData, required this.onAnalysis, required this.onRoadmap, required this.onCourses, required this.onProjects});

  static List<dynamic> _list(dynamic value) => value is List ? value : <dynamic>[];

  @override
  Widget build(BuildContext context) {
    final readiness = aiData == null ? 0 : ((aiData!['readiness'] ?? 0) as num).round().clamp(0, 100);
    final current = _list(aiData?['current_skills']);
    final missing = _list(aiData?['missing_skills']);
    final target = career ?? 'Your target career';

    return _Panel(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(gradient: const LinearGradient(colors: [kPurple, kBlue]), borderRadius: BorderRadius.circular(11), boxShadow: [BoxShadow(color: kPurple.withOpacity(.22), blurRadius: 18)]), child: const Icon(Icons.route_rounded, color: Colors.white, size: 20)),
          const SizedBox(width: 11),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Personalized Career Roadmap', style: TextStyle(color: kSoft, fontSize: 11, fontWeight: FontWeight.w700)),
            SizedBox(height: 3),
            Text('Your Journey to Your Target Role', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kWhite)),
          ])),
          _tinyBadge(aiData == null ? 'NOT STARTED' : 'AI GENERATED', aiData == null ? kSoft : kGreen),
          const SizedBox(width: 4),
          IconButton(onPressed: onAnalysis, tooltip: 'Open analysis', icon: const Icon(Icons.more_horiz, color: kSoft)),
        ]),
        const SizedBox(height: 14),
        Container(
          height: 326,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF12162B), Color(0xFF0D1020)]),
            border: Border.all(color: kLine),
          ),
          child: LayoutBuilder(builder: (context, c) {
            final compact = c.maxWidth < 520;
            return Stack(children: [
              Positioned.fill(child: CustomPaint(painter: _EnhancedJourneyPainter())),
              Positioned(left: 18, top: 20, child: _JourneyNode(icon: Icons.person_rounded, title: 'Current Skills', subtitle: aiData == null ? 'Upload resume' : '${current.length} skills detected', color: kBlue)),
              Positioned(right: 18, top: compact ? 96 : 42, child: _JourneyNode(icon: Icons.warning_amber_rounded, title: 'Gap Analysis', subtitle: aiData == null ? 'Waiting for AI' : '${missing.length} gaps to close', color: kOrange, onTap: onAnalysis)),
              Positioned(left: compact ? 18 : c.maxWidth * .29, bottom: 20, child: _JourneyNode(icon: Icons.school_rounded, title: 'Learning Path', subtitle: 'Courses + projects', color: kPurple, onTap: onCourses)),
              Positioned(right: 18, bottom: 20, child: _JourneyNode(icon: Icons.workspace_premium_rounded, title: 'Target Role', subtitle: target, color: kOrange)),
              Positioned(left: c.maxWidth / 2 - 63, top: 111, child: _ReadinessOrb(value: readiness)),
              Positioned(left: c.maxWidth / 2 - 82, top: 214, child: _JourneyMiniStats(current: current.length, gaps: missing.length)),
            ]);
          }),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _journeyAction(Icons.route_rounded, 'Roadmap', 'Track skills', onRoadmap, kPurple)),
          const SizedBox(width: 8),
          Expanded(child: _journeyAction(Icons.school_rounded, 'Courses', 'Close gaps', onCourses, kBlue)),
          const SizedBox(width: 8),
          Expanded(child: _journeyAction(Icons.code_rounded, 'Projects', 'Build proof', onProjects, kCyan)),
        ]),
      ]),
    );
  }

  Widget _tinyBadge(String text, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: color.withOpacity(.09), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(.28))), child: Text(text, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: .7)));

  Widget _journeyAction(IconData icon, String title, String sub, VoidCallback tap, Color color) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(11), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(.11), color.withOpacity(.035)]), borderRadius: BorderRadius.circular(11), border: Border.all(color: color.withOpacity(.22))), child: Row(children: [Container(width: 31, height: 31, decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 17)), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: kWhite)), Text(sub, style: const TextStyle(fontSize: 8, color: kSoft))])), const Icon(Icons.arrow_forward_ios_rounded, color: kSoft, size: 10)])));
}

class _ReadinessOrb extends StatelessWidget {
  final int value;
  const _ReadinessOrb({required this.value});
  @override
  Widget build(BuildContext context) => Container(width: 126, height: 126, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPurple, kBlue]), boxShadow: [BoxShadow(color: kPurple.withOpacity(.28), blurRadius: 30), BoxShadow(color: kBlue.withOpacity(.16), blurRadius: 48)]), padding: const EdgeInsets.all(7), child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF101328)), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('$value%', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: kWhite)), const SizedBox(height: 1), const Text('CAREER READY', style: TextStyle(fontSize: 7.5, letterSpacing: 1.2, fontWeight: FontWeight.w900, color: kSoft))]))));
}

class _JourneyMiniStats extends StatelessWidget {
  final int current;
  final int gaps;
  const _JourneyMiniStats({required this.current, required this.gaps});
  @override
  Widget build(BuildContext context) => Row(children: [_journeyStat(Icons.check_circle_rounded, '$current', 'Skills', kGreen), const SizedBox(width: 7), _journeyStat(Icons.flag_rounded, '$gaps', 'Gaps', kOrange)]);
  Widget _journeyStat(IconData icon, String value, String label, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xCC111426), borderRadius: BorderRadius.circular(9), border: Border.all(color: color.withOpacity(.18))), child: Row(children: [Icon(icon, size: 12, color: color), const SizedBox(width: 5), Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: kWhite)), const SizedBox(width: 3), Text(label, style: const TextStyle(fontSize: 8, color: kSoft))]));
}

class _JourneyNode extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  const _JourneyNode({required this.icon, required this.title, required this.subtitle, required this.color, this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Container(width: 152, padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: const Color(0xEE181B31), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(.52)), boxShadow: [BoxShadow(color: color.withOpacity(.10), blurRadius: 22)]), child: Row(children: [Container(width: 35, height: 35, decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(.22), color.withOpacity(.06)]), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: kWhite)), const SizedBox(height: 3), Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8.5, color: kSoft, height: 1.2))]))])));
}

class _EnhancedJourneyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = const LinearGradient(colors: [kBlue, kPurple, kOrange]).createShader(Offset.zero & size);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 2.4..shader = gradient;
    final dashPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.3..color = kPurple.withOpacity(.42);
    final path = Path()
      ..moveTo(165, 75)
      ..cubicTo(size.width * .31, 45, size.width * .34, 104, size.width * .43, 132)
      ..cubicTo(size.width * .48, 148, size.width * .48, 170, size.width * .50, 186)
      ..cubicTo(size.width * .54, 206, size.width * .67, 198, size.width - 166, 102);
    canvas.drawPath(path, paint);
    final second = Path()
      ..moveTo(size.width * .50, 186)
      ..cubicTo(size.width * .43, 216, size.width * .37, 238, size.width * .32, size.height - 55)
      ..cubicTo(size.width * .46, size.height - 34, size.width * .65, size.height - 42, size.width - 170, size.height - 54);
    canvas.drawPath(second, paint);
    final glow = Paint()..style = PaintingStyle.stroke..strokeWidth = 7..color = kPurple.withOpacity(.05);
    canvas.drawPath(second, glow);
    final dots = [Offset(size.width * .33, 90), Offset(size.width * .50, 184), Offset(size.width * .68, 160), Offset(size.width * .46, size.height - 62)];
    final dot = Paint()..color = kPurple;
    for (final p in dots) { canvas.drawCircle(p, 3.5, dot); canvas.drawCircle(p, 8, dashPaint); }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InsightsPanel extends StatelessWidget {
  final Map<String, dynamic>? aiData;
  const _InsightsPanel({required this.aiData});

  @override
  Widget build(BuildContext context) {
    final missing = aiData == null ? <dynamic>[] : (aiData!['missing_skills'] is List ? aiData!['missing_skills'] as List : <dynamic>[]);
    final current = aiData == null ? <dynamic>[] : (aiData!['current_skills'] is List ? aiData!['current_skills'] as List : <dynamic>[]);
    final readiness = aiData == null ? 0 : ((aiData!['readiness'] ?? 0) as num).round().clamp(0, 100);
    final coverage = (current.length * 12.5).clamp(0, 100).toDouble();
    final gapPressure = (missing.length * 12.0).clamp(0, 100).toDouble();
    return Column(children: [
      _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Text('Skill Match', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: kWhite)), const Spacer(), _tinyStatus('LIVE AI', kGreen)]),
        const SizedBox(height: 13),
        _matchMetric('AI / Target Match', readiness.toDouble(), kPurple),
        const SizedBox(height: 11),
        _matchMetric('Skill Coverage', coverage, kCyan),
        const SizedBox(height: 11),
        _matchMetric('Gap Pressure', gapPressure, kOrange),
        const SizedBox(height: 14),
        Wrap(spacing: 6, runSpacing: 6, children: current.take(4).map((e) => _GlowChip(e.toString(), kBlue)).toList()),
      ])),
      const SizedBox(height: 12),
      _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Text('Career Signals', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: kWhite)), const Spacer(), const Icon(Icons.insights_rounded, color: kPurple, size: 18)]),
        const SizedBox(height: 12),
        _signal(Icons.trending_up_rounded, 'Role alignment', readiness >= 70 ? 'Strong alignment' : readiness >= 45 ? 'Building alignment' : 'Early stage', kPurple),
        _signal(Icons.auto_awesome_rounded, 'Top focus', missing.isEmpty ? 'Run AI analysis' : _skillNames(missing.take(2).toList()), kOrange),
        _signal(Icons.rocket_launch_rounded, 'Portfolio signal', 'Courses + projects', kBlue),
        _signal(Icons.timeline_rounded, 'Next milestone', readiness >= 70 ? 'Polish portfolio' : 'Close priority gaps', kCyan),
      ])),
      const SizedBox(height: 12),
      _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Career Readiness', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: kWhite)),
        const SizedBox(height: 12),
        Row(children: [
          SizedBox(width: 84, height: 84, child: Stack(alignment: Alignment.center, children: [CircularProgressIndicator(value: readiness / 100, strokeWidth: 8, color: kPurple, backgroundColor: kLine), Text('$readiness%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))])),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Readiness snapshot', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: kWhite)), const SizedBox(height: 4), Text(readiness >= 70 ? 'You are building strong evidence for your target role.' : 'Keep closing the highest-priority skill gaps.', style: const TextStyle(fontSize: 9, color: kSoft, height: 1.4))])),
        ]),
      ])),
    ]);
  }

  Widget _tinyStatus(String text, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(.22))), child: Text(text, style: TextStyle(color: color, fontSize: 7.5, fontWeight: FontWeight.w900, letterSpacing: .6)));
  Widget _matchMetric(String title, double value, Color color) { final v = value.clamp(0, 100); return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 10, color: kSoft))), Text('${v.round()}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: color))]), const SizedBox(height: 6), ClipRRect(borderRadius: BorderRadius.circular(8), child: Stack(children: [Container(height: 7, color: kLine), FractionallySizedBox(widthFactor: v / 100, child: Container(height: 7, decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(.75), color]), borderRadius: BorderRadius.circular(8))))]))]); }
  Widget _signal(IconData icon, String title, String text, Color color) => Padding(padding: const EdgeInsets.only(bottom: 9), child: Row(children: [Container(width: 30, height: 30, decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: color, size: 16)), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: kWhite)), const SizedBox(height: 2), Text(text, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8.5, color: kSoft, height: 1.25))]))]));
  String _skillNames(List<dynamic> items) => items.map((e) => e is Map ? e['skill'].toString() : e.toString()).join(', ');
}

class _TargetSetup extends StatelessWidget {
  final List<String> careers;
  final String? career;
  final ValueChanged<String?> onChanged;
  final VoidCallback onAnalyze;
  final bool loading;
  const _TargetSetup({required this.careers, required this.career, required this.onChanged, required this.onAnalyze, required this.loading});
  @override
  Widget build(BuildContext context) => _Panel(child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Target Career', style: TextStyle(fontSize: 11, color: kSoft)), const SizedBox(height: 7), DropdownButtonFormField<String>(value: career, dropdownColor: kPanel2, decoration: InputDecoration(hintText: 'Select your target role', hintStyle: const TextStyle(color: kSoft, fontSize: 12), prefixIcon: const Icon(Icons.work_outline_rounded, color: kPurple), filled: true, fillColor: const Color(0xFF0C0F20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: kLine)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: kLine))), style: const TextStyle(color: kWhite, fontSize: 12), items: careers.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: onChanged)])),
    const SizedBox(width: 12),
    SizedBox(height: 55, child: ElevatedButton.icon(onPressed: loading ? null : onAnalyze, icon: loading ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.auto_awesome_rounded, size: 18), label: Text(loading ? 'Analyzing...' : 'Run AI Career Analysis'), style: ElevatedButton.styleFrom(backgroundColor: kPurple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))))),
  ]));
}

class _Pipeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      (Icons.description_rounded, 'Resume Input', 'Upload PDF', kBlue),
      (Icons.document_scanner_rounded, 'Skill Extraction', 'Read skills', kPurple),
      (Icons.psychology_rounded, 'Gemini Analysis', 'Find gaps', kCyan),
      (Icons.route_rounded, 'Career Path', 'Build roadmap', kPurple),
      (Icons.school_rounded, 'Recommendations', 'Courses + projects', kOrange),
      (Icons.dashboard_rounded, 'Dashboard', 'Track growth', kBlue),
    ];
    return _Panel(padding: const EdgeInsets.fromLTRB(18, 16, 18, 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('AI Career Intelligence Pipeline', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: kWhite)), SizedBox(height: 3), Text('From resume input to an actionable career plan', style: TextStyle(fontSize: 9.5, color: kSoft))])), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: kGreen.withOpacity(.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: kGreen.withOpacity(.2))), child: const Text('6 STEPS', style: TextStyle(color: kGreen, fontSize: 7.5, fontWeight: FontWeight.w900, letterSpacing: .8)))]),
      const SizedBox(height: 14),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [for (int i = 0; i < steps.length; i++) ...[
        _PipelineItem(icon: steps[i].$1, title: steps[i].$2, subtitle: steps[i].$3, color: steps[i].$4, index: i + 1),
        if (i < steps.length - 1) const Padding(padding: EdgeInsets.symmetric(horizontal: 7), child: Icon(Icons.arrow_forward_rounded, color: kSoft, size: 16)),
      ]]))
    ]));
  }
}

class _PipelineItem extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final Color color; final int index;
  const _PipelineItem({required this.icon, required this.title, required this.subtitle, required this.color, required this.index});
  @override
  Widget build(BuildContext context) => Container(width: 142, padding: const EdgeInsets.fromLTRB(10, 10, 10, 11), decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(.10), const Color(0xFF0C0F20)]), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(.24)), boxShadow: [BoxShadow(color: color.withOpacity(.05), blurRadius: 14)]), child: Row(children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: color, size: 17)), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('0$index', style: TextStyle(fontSize: 7, color: color, fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: kWhite)), const SizedBox(height: 2), Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 7.5, color: kSoft))]))]));
}

class AnalysisPage extends StatelessWidget {
  final String career; final Map<String, dynamic> aiData; final VoidCallback onRoadmap, onCourses, onProjects, onReanalyze, onGrowth;
  const AnalysisPage({super.key, required this.career, required this.aiData, required this.onRoadmap, required this.onCourses, required this.onProjects, required this.onReanalyze, required this.onGrowth});
  List<dynamic> list(String key) => aiData[key] is List ? aiData[key] as List : [];
  @override
  Widget build(BuildContext context) {
    final readiness = ((aiData['readiness'] ?? 0) as num).round();
    final current = list('current_skills');
    final missing = list('missing_skills');
    return SingleChildScrollView(padding: const EdgeInsets.all(26), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _PageHeading(title: 'Resume Analysis', subtitle: 'AI-powered comparison between your resume and $career.'), const SizedBox(height: 18),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 7, child: _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.auto_awesome_rounded, color: kPurple), const SizedBox(width: 8), const Text('AI Analysis Results', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)), const Spacer(), TextButton.icon(onPressed: onReanalyze, icon: const Icon(Icons.refresh_rounded, size: 16), label: const Text('New Analysis'))]),
          const SizedBox(height: 14),
          Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: LinearGradient(colors: [kPurple.withOpacity(.18), kBlue.withOpacity(.08)]), borderRadius: BorderRadius.circular(14), border: Border.all(color: kPurple.withOpacity(.3))), child: Row(children: [SizedBox(width: 104, height: 104, child: Stack(alignment: Alignment.center, children: [CircularProgressIndicator(value: readiness / 100, strokeWidth: 9, color: kPurple, backgroundColor: kLine), Text('$readiness%', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900))])), const SizedBox(width: 18), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Career Readiness', style: TextStyle(color: kSoft, fontSize: 12)), const SizedBox(height: 5), Text(career, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(aiData['summary']?.toString() ?? 'AI summary unavailable.', style: const TextStyle(color: kSoft, height: 1.4, fontSize: 12))]))])),
          const SizedBox(height: 18),
          Row(children: [Expanded(child: _analysisStat('Current Skills', '${current.length}', kCyan)), const SizedBox(width: 10), Expanded(child: _analysisStat('Missing Skills', '${missing.length}', kOrange)), const SizedBox(width: 10), Expanded(child: _analysisStat('Plan', '30 / 60 / 90', kPurple))]),
          const SizedBox(height: 18),
          const Text('Current Skills', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 8), Wrap(spacing: 7, runSpacing: 7, children: current.map((s) => _GlowChip(s.toString(), kCyan)).toList()),
          const SizedBox(height: 18),
          const Text('Top Skill Gaps', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...missing.take(6).map((item) {
            final map = item is Map ? item : <dynamic, dynamic>{};
            final skill = map['skill']?.toString() ?? item.toString();
            final priority = map['priority']?.toString() ?? 'Medium';
            return Container(
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0C0F20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kLine),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 17, color: kPurple),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(skill, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        if (map['reason'] != null)
                          Text(map['reason'].toString(), style: const TextStyle(color: kSoft, fontSize: 10)),
                      ],
                    ),
                  ),
                  _priority(priority),
                ],
              ),
            );
          }),
        ]))),
        const SizedBox(width: 14),
        Expanded(flex: 4, child: Column(children: [
          _ActionPanel(title: 'Personalized Roadmap', icon: Icons.route_rounded, text: 'Turn your skill gaps into a trackable learning path.', button: 'Open Roadmap', color: kPurple, onTap: onRoadmap),
          const SizedBox(height: 12), _ActionPanel(title: 'Course Recommendations', icon: Icons.school_rounded, text: 'Learn the highest-priority missing skills.', button: 'Explore Courses', color: kBlue, onTap: onCourses),
          const SizedBox(height: 12), _ActionPanel(title: 'Project Lab', icon: Icons.code_rounded, text: 'Build portfolio evidence for the skills you need.', button: 'Build Projects', color: kOrange, onTap: onProjects),
          const SizedBox(height: 12), _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('AI Recommendation', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(aiData['recommendation']?.toString() ?? 'No recommendation available.', style: const TextStyle(color: kSoft, fontSize: 11, height: 1.4))])),
          const SizedBox(height: 12), _ActionPanel(title: 'Career Growth', icon: Icons.trending_up_rounded, text: 'Compare your latest resume analysis with the previous one.', button: 'View Growth', color: kGreen, onTap: onGrowth),
        ])),
      ]),
    ]));
  }
  Widget _analysisStat(String title, String value, Color color) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(.07), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)), const SizedBox(height: 3), Text(title, style: const TextStyle(fontSize: 9, color: kSoft))]));
  Widget _priority(String value) { final c = value.toLowerCase() == 'high' ? kPink : value.toLowerCase() == 'low' ? kCyan : kOrange; return _GlowChip(value, c); }
}

class _ActionPanel extends StatelessWidget {
  final String title, text, button; final IconData icon; final Color color; final VoidCallback onTap;
  const _ActionPanel({required this.title, required this.text, required this.button, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color)), const SizedBox(width: 10), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)))]), const SizedBox(height: 9), Text(text, style: const TextStyle(color: kSoft, fontSize: 10.5, height: 1.4)), const SizedBox(height: 12), SizedBox(width: double.infinity, child: OutlinedButton(onPressed: onTap, style: OutlinedButton.styleFrom(side: BorderSide(color: color.withOpacity(.45)), foregroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))), child: Text(button)))]));
}

class GrowthPage extends StatelessWidget {
  final String career;
  final Map<String, dynamic> currentData;
  final Map<String, dynamic>? previousData;
  final VoidCallback onReanalyze;
  const GrowthPage({super.key, required this.career, required this.currentData, required this.previousData, required this.onReanalyze});

  List<String> _skills(Map<String, dynamic>? data) {
    if (data == null || data['current_skills'] is! List) return [];
    return (data['current_skills'] as List).map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
  }

  Map<String, num> _levels(Map<String, dynamic>? data) {
    if (data == null || data['skill_levels'] is! Map) return {};
    final raw = data['skill_levels'] as Map;
    return raw.map((k, v) => MapEntry(k.toString(), v is num ? v : num.tryParse(v.toString()) ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final now = ((currentData['readiness'] ?? 0) as num).round();
    final before = previousData == null ? null : ((previousData!['readiness'] ?? 0) as num).round();
    final delta = before == null ? 0 : now - before;
    final oldSkills = _skills(previousData);
    final newSkills = _skills(currentData);
    final oldSet = oldSkills.map((e) => e.toLowerCase()).toSet();
    final newSet = newSkills.map((e) => e.toLowerCase()).toSet();
    final added = newSkills.where((e) => !oldSet.contains(e.toLowerCase())).toList();
    final retained = newSkills.where((e) => oldSet.contains(e.toLowerCase())).toList();
    final levelsBefore = _levels(previousData);
    final levelsNow = _levels(currentData);

    return SingleChildScrollView(padding: const EdgeInsets.all(26), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _PageHeading(title: 'Career Growth', subtitle: 'Track how your resume and skills change over time for $career.'),
      const SizedBox(height: 18),
      if (previousData == null)
        _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.insights_rounded, color: kGreen, size: 34), const SizedBox(height: 12),
          const Text('Growth tracking is ready', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          const Text('Run another resume analysis after completing courses, projects or roadmap tasks. SkillPath AI will compare the two analyses here.', style: TextStyle(color: kSoft, height: 1.5)),
          const SizedBox(height: 16),
          ElevatedButton.icon(onPressed: onReanalyze, icon: const Icon(Icons.upload_file_rounded), label: const Text('Upload Updated Resume')),
        ]))
      else ...[
        Row(children: [
          Expanded(child: _GrowthMetric(title: 'Previous Readiness', value: '$before%', color: kSoft)), const SizedBox(width: 10),
          Expanded(child: _GrowthMetric(title: 'Current Readiness', value: '$now%', color: kGreen)), const SizedBox(width: 10),
          Expanded(child: _GrowthMetric(title: 'Change', value: '${delta >= 0 ? '+' : ''}$delta%', color: delta >= 0 ? kGreen : kOrange)),
        ]),
        const SizedBox(height: 16),
        _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.show_chart_rounded, color: kGreen), const SizedBox(width: 8), const Text('Readiness Growth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)), const Spacer(), Text('$before% → $now%', style: const TextStyle(color: kSoft, fontWeight: FontWeight.w700))]),
          const SizedBox(height: 16),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: now / 100, minHeight: 12, color: kGreen, backgroundColor: kLine)),
          const SizedBox(height: 10),
          Text(delta > 0 ? 'Your latest analysis shows measurable progress.' : delta == 0 ? 'Your readiness score is unchanged in the latest analysis.' : 'The latest analysis shows a lower readiness score; review the new skill gaps below.', style: const TextStyle(color: kSoft, fontSize: 11)),
        ])),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('New Skills Detected', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 10), if (added.isEmpty) const Text('No new skills detected yet.', style: TextStyle(color: kSoft, fontSize: 11)) else Wrap(spacing: 7, runSpacing: 7, children: added.map((s) => _GlowChip(s, kGreen)).toList())]))),
          const SizedBox(width: 14),
          Expanded(child: _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Skills Retained', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 10), if (retained.isEmpty) const Text('No matching skills found.', style: TextStyle(color: kSoft, fontSize: 11)) else Wrap(spacing: 7, runSpacing: 7, children: retained.take(12).map((s) => _GlowChip(s, kCyan)).toList())]))),
        ]),
        if (levelsNow.isNotEmpty) ...[
          const SizedBox(height: 16),
          _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Skill Level Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)), const SizedBox(height: 12),
            ...levelsNow.entries.map((entry) {
              final old = levelsBefore[entry.key]; final current = entry.value; final change = old == null ? null : current - old;
              return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Expanded(child: Text(entry.key, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))), Text('${old?.round() ?? 0}% → ${current.round()}%', style: const TextStyle(color: kSoft, fontSize: 10)), if (change != null) Padding(padding: const EdgeInsets.only(left: 7), child: Text('${change >= 0 ? '+' : ''}${change.round()}%', style: TextStyle(color: change >= 0 ? kGreen : kOrange, fontSize: 10, fontWeight: FontWeight.w800))) ]),
                const SizedBox(height: 5), ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: current.clamp(0,100) / 100, minHeight: 7, color: kPurple, backgroundColor: kLine)),
              ]));
            }),
          ])),
        ],
        const SizedBox(height: 16),
        _Panel(child: Row(children: [const Icon(Icons.refresh_rounded, color: kPurple), const SizedBox(width: 10), const Expanded(child: Text('Keep learning, building projects and re-upload your resume to update this growth view.', style: TextStyle(color: kSoft, fontSize: 11, height: 1.4))), ElevatedButton(onPressed: onReanalyze, child: const Text('Re-analyze'))])),
      ],
    ]));
  }
}

class _GrowthMetric extends StatelessWidget {
  final String title, value; final Color color;
  const _GrowthMetric({required this.title, required this.value, required this.color});
  @override Widget build(BuildContext context) => _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: color)), const SizedBox(height: 5), Text(title, style: const TextStyle(color: kSoft, fontSize: 9))]));
}

class CoursesPage extends StatefulWidget {
  final String career;
  final Map<String, dynamic> aiData;

  const CoursesPage({super.key, required this.career, required this.aiData});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  Set<String> completed = {};

  String get keyName =>
      'skillpath_courses_${Uri.encodeComponent(widget.career)}';

  List<String> get skills {
    final raw = widget.aiData['missing_skills'];
    if (raw is! List) return [];
    return raw
        .map((e) => e is Map ? e['skill'].toString() : e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        completed = (p.getStringList(keyName) ?? []).toSet();
      });
    }
  }

  Future<void> _toggle(String title) async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      if (completed.contains(title)) {
        completed.remove(title);
      } else {
        completed.add(title);
      }
    });
    await p.setStringList(keyName, completed.toList());
  }

  @override
  Widget build(BuildContext context) {
    final courses = CourseCatalog.forSkills(skills);
    final aiCourses = widget.aiData['courses'] is List
        ? (widget.aiData['courses'] as List)
        .map((e) => e.toString())
        .toList()
        : <String>[];
    final completedCurated =
        courses.where((course) => completed.contains(course.title)).length;
    final progress = courses.isEmpty ? 0.0 : completedCurated / courses.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageHeading(
            title: 'Learning Path',
            subtitle:
            'Personalized courses mapped to the skills you need for ${widget.career}.',
          ),
          const SizedBox(height: 18),
          _Panel(
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        color: kPurple,
                        backgroundColor: kLine,
                        strokeWidth: 7,
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Course Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedCurated completed • ${courses.length} curated courses',
                        style: const TextStyle(color: kSoft, fontSize: 11),
                      ),
                      const SizedBox(height: 9),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          color: kPurple,
                          backgroundColor: kLine,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (courses.isEmpty)
            _Panel(
              child: Column(
                children: [
                  const Icon(
                    Icons.school_outlined,
                    color: kPurple,
                    size: 44,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'No curated course match yet',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Use the AI suggestions below while we expand the course catalog.',
                    style: TextStyle(color: kSoft, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width >= 1000
                    ? 3
                    : MediaQuery.of(context).size.width >= 700
                    ? 2
                    : 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.45,
              ),
              itemCount: courses.length,
              itemBuilder: (_, i) {
                final course = courses[i];
                return _CourseCard(
                  course: course,
                  done: completed.contains(course.title),
                  onToggle: () => _toggle(course.title),
                );
              },
            ),
          if (aiCourses.isNotEmpty) ...[
            const SizedBox(height: 18),
            _Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gemini Course Suggestions',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 9),
                  ...aiCourses.map(
                        (course) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: kPurple,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              course,
                              style: const TextStyle(
                                color: kSoft,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseRecommendation course;
  final bool done;
  final VoidCallback onToggle;

  const _CourseCard({
    required this.course,
    required this.done,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: kPurple.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school_rounded, color: kPurple),
              ),
              const Spacer(),
              if (done)
                const Icon(Icons.verified_rounded, color: kGreen, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            course.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            course.provider,
            style: const TextStyle(color: kSoft, fontSize: 10),
          ),
          const Spacer(),
          Wrap(
            spacing: 5,
            children: [
              _GlowChip(course.difficulty, kBlue),
              _GlowChip(course.duration, kOrange),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final uri = Uri.parse(course.url);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kBlue,
                    side: BorderSide(color: kBlue.withOpacity(.35)),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                  child: const Text(
                    'Open Course',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              IconButton(
                onPressed: onToggle,
                icon: Icon(
                  done ? Icons.check_circle : Icons.circle_outlined,
                  color: done ? kGreen : kSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectsPage extends StatefulWidget { final String career; final Map<String, dynamic> aiData; const ProjectsPage({super.key, required this.career, required this.aiData}); @override State<ProjectsPage> createState() => _ProjectsPageState(); }
class _ProjectsPageState extends State<ProjectsPage> {
  Set<String> completed = {};
  String get keyName => 'skillpath_projects_${Uri.encodeComponent(widget.career)}';
  List<String> get skills { final raw = widget.aiData['missing_skills']; if (raw is! List) return []; return raw.map((e) => e is Map ? e['skill'].toString() : e.toString()).where((e) => e.trim().isNotEmpty).toList(); }
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final p = await SharedPreferences.getInstance(); if (mounted) setState(() => completed = (p.getStringList(keyName) ?? []).toSet()); }
  Future<void> _toggle(String title) async { final p = await SharedPreferences.getInstance(); setState(() => completed.contains(title) ? completed.remove(title) : completed.add(title)); await p.setStringList(keyName, completed.toList()); }
  @override Widget build(BuildContext context) { final projects = ProjectCatalog.forSkills(skills); final progress = projects.isEmpty ? 0 : completed.where(projects.map((e) => e.title).contains).length / projects.length; return SingleChildScrollView(padding: const EdgeInsets.all(26), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _PageHeading(title: 'Project Lab', subtitle: 'Turn your missing skills into portfolio evidence with guided builds.'), const SizedBox(height: 18),
    _Panel(child: Row(children: [Container(width: 58, height: 58, decoration: BoxDecoration(color: kOrange.withOpacity(.12), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.code_rounded, color: kOrange, size: 28)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Build real proof', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), const SizedBox(height: 4), Text('${completed.length} completed • ${projects.length} matched projects', style: const TextStyle(color: kSoft, fontSize: 11)), const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress.toDouble(), minHeight: 6, color: kOrange, backgroundColor: kLine))]))])),
    const SizedBox(height: 18),
    if (projects.isEmpty) _Panel(child: const Text('No project match yet. Run an AI analysis with more detailed skill gaps.', style: TextStyle(color: kSoft))) else GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width >= 1000 ? 2 : 1, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.1), itemCount: projects.length, itemBuilder: (_, i) => _ProjectCard(project: projects[i], done: completed.contains(projects[i].title), onToggle: () => _toggle(projects[i].title))),
  ])); }
}
class _ProjectCard extends StatelessWidget {
  final ProjectRecommendation project;
  final bool done;
  final VoidCallback onToggle;

  const _ProjectCard({
    required this.project,
    required this.done,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: kOrange.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.code_rounded, color: kOrange),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (done)
                const Icon(Icons.check_circle, color: kGreen, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: kSoft, fontSize: 10, height: 1.35),
          ),
          const Spacer(),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              _GlowChip(project.level, kPurple),
              _GlowChip(project.duration, kBlue),
              _GlowChip(project.tech, kCyan),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  project.outcome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: kSoft, fontSize: 9),
                ),
              ),
              TextButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  done ? Icons.verified_rounded : Icons.play_arrow_rounded,
                  size: 16,
                  color: done ? kGreen : kOrange,
                ),
                label: Text(
                  done ? 'Completed' : 'Start Project',
                  style: TextStyle(
                    color: done ? kGreen : kOrange,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class JobsPage extends StatelessWidget {
  final String career;
  final Map<String, dynamic> aiData;
  const JobsPage({super.key, required this.career, required this.aiData});

  List<String> _skills() {
    final raw = aiData['current_skills'];
    if (raw is! List) return [];
    return raw.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).take(8).toList();
  }

  List<String> _gaps() {
    final raw = aiData['missing_skills'];
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => e['skill']?.toString() ?? '').where((e) => e.isNotEmpty).take(6).toList();
  }

  List<Map<String, dynamic>> _opportunities() {
    final c = career.toLowerCase();
    if (c.contains('embedded')) {
      return [
        {'title':'Embedded Systems Intern','type':'Internship','domain':'Embedded / Firmware','skills':['C','Microcontrollers','UART / SPI / I2C'],'level':'Student','match':88},
        {'title':'Firmware Engineer – Graduate / Intern','type':'Internship','domain':'Firmware','skills':['C / C++','RTOS','Debugging'],'level':'Entry level','match':82},
        {'title':'IoT / Embedded Developer','type':'Job','domain':'IoT','skills':['ESP32 / Arduino','MQTT','Sensors'],'level':'Entry level','match':76},
        {'title':'Junior Embedded Software Engineer','type':'Job','domain':'Embedded Software','skills':['C','Git','Linux'],'level':'Entry level','match':71},
      ];
    }
    if (c.contains('iot')) {
      return [
        {'title':'IoT Developer Intern','type':'Internship','domain':'IoT','skills':['ESP32','MQTT','Sensors'],'level':'Student','match':88},
        {'title':'IoT / Edge Computing Intern','type':'Internship','domain':'Edge / Cloud','skills':['Python','MQTT','Cloud'],'level':'Student','match':81},
        {'title':'Junior IoT Engineer','type':'Job','domain':'IoT','skills':['Embedded C','Networking','Cloud'],'level':'Entry level','match':76},
        {'title':'IoT Solutions Engineer – Graduate','type':'Job','domain':'IoT Solutions','skills':['APIs','Linux','Networking'],'level':'Entry level','match':70},
      ];
    }
    if (c.contains('ai/ml')) {
      return [
        {'title':'AI/ML Intern','type':'Internship','domain':'Artificial Intelligence','skills':['Python','ML','NumPy / Pandas'],'level':'Student','match':88},
        {'title':'Machine Learning Intern','type':'Internship','domain':'Machine Learning','skills':['Python','Scikit-learn','Statistics'],'level':'Student','match':82},
        {'title':'Junior AI Engineer','type':'Job','domain':'AI / ML','skills':['Python','ML','Git'],'level':'Entry level','match':74},
        {'title':'Data & AI Graduate Intern','type':'Internship','domain':'Data / AI','skills':['SQL','Python','Visualization'],'level':'Student','match':69},
      ];
    }
    if (c.contains('data analyst')) {
      return [
        {'title':'Data Analyst Intern','type':'Internship','domain':'Data Analytics','skills':['SQL','Excel','Python'],'level':'Student','match':89},
        {'title':'Business Data Analyst Intern','type':'Internship','domain':'Analytics','skills':['SQL','Power BI','Statistics'],'level':'Student','match':82},
        {'title':'Junior Data Analyst','type':'Job','domain':'Data Analytics','skills':['SQL','Python','Power BI'],'level':'Entry level','match':76},
        {'title':'Data & Reporting Intern','type':'Internship','domain':'Business Intelligence','skills':['Excel','SQL','Dashboards'],'level':'Student','match':71},
      ];
    }
    if (c.contains('cyber')) {
      return [
        {'title':'Cybersecurity Intern','type':'Internship','domain':'Security','skills':['Networking','Linux','Security Basics'],'level':'Student','match':87},
        {'title':'SOC Analyst Intern','type':'Internship','domain':'Security Operations','skills':['SIEM','Networking','Linux'],'level':'Student','match':80},
        {'title':'Junior Security Analyst','type':'Job','domain':'Cybersecurity','skills':['Networking','SIEM','Incident Response'],'level':'Entry level','match':73},
        {'title':'Security Engineering Intern','type':'Internship','domain':'Application Security','skills':['Web Security','Python','Git'],'level':'Student','match':68},
      ];
    }
    return [
      {'title':'Software Developer Intern','type':'Internship','domain':'Software Development','skills':['Programming','Git','Data Structures'],'level':'Student','match':88},
      {'title':'Flutter Developer Intern','type':'Internship','domain':'Mobile Development','skills':['Flutter','Dart','Git'],'level':'Student','match':83},
      {'title':'Junior Software Developer','type':'Job','domain':'Software Engineering','skills':['Programming','DSA','Git'],'level':'Entry level','match':76},
      {'title':'Full-Stack Developer Intern','type':'Internship','domain':'Web Development','skills':['JavaScript','APIs','Git'],'level':'Student','match':69},
    ];
  }

  Future<void> _openSearch(String query) async {
    final url = Uri.parse('https://www.linkedin.com/jobs/search/?keywords=${Uri.encodeComponent(query)}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {}
  }

  @override
  Widget build(BuildContext context) {
    final skills = _skills();
    final gaps = _gaps();
    final opportunities = _opportunities();
    final readiness = ((aiData['readiness'] ?? 0) as num).round();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _PageHeading(title: 'Jobs & Internships', subtitle: 'Career opportunities matched to your $career journey.'),
        const SizedBox(height: 18),
        _Panel(child: Row(children: [
          Container(width: 54, height: 54, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [kPurple,kBlue])), child: const Icon(Icons.work_rounded, color: Colors.white, size: 27)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('AI Career Match', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text('Your current readiness is $readiness%. Opportunities are organized around your target role, current skills and skill gaps.', style: const TextStyle(color: kSoft, fontSize: 11, height: 1.4)),
          ])),
        ])),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Your Match Signals', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 10),
            Text('${skills.length} current skills detected', style: const TextStyle(color: kGreen, fontSize: 11)), const SizedBox(height: 5),
            Text('${gaps.length} skills to strengthen', style: const TextStyle(color: kOrange, fontSize: 11)), const SizedBox(height: 9),
            Wrap(spacing: 5, runSpacing: 5, children: skills.take(5).map((s) => _GlowChip(s, kBlue)).toList()),
          ]))),
          const SizedBox(width: 14),
          Expanded(child: _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Top Skill Gaps', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 10),
            if (gaps.isEmpty) const Text('No major gaps returned by the analysis.', style: TextStyle(color: kSoft, fontSize: 11))
            else ...gaps.take(4).map((g) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [const Icon(Icons.bolt_rounded, color: kOrange, size: 15), const SizedBox(width: 6), Expanded(child: Text(g, style: const TextStyle(color: kSoft, fontSize: 10.5)))]))),
          ]))),
        ]),
        const SizedBox(height: 20),
        Row(children: [const Text('Recommended Opportunities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const Spacer(), Text('${opportunities.length} matches', style: const TextStyle(color: kSoft, fontSize: 10))]),
        const SizedBox(height: 12),
        ...opportunities.map((item) => _OpportunityCard(item: item, onExplore: () => _openSearch(item['title'].toString()))),
        const SizedBox(height: 18),
        _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.travel_explore_rounded, color: kCyan, size: 20), SizedBox(width: 8), Text('Explore Live Opportunities', style: TextStyle(fontWeight: FontWeight.w900))]),
          const SizedBox(height: 7),
          const Text('Search current LinkedIn opportunities using your selected career. Live listings can change frequently.', style: TextStyle(color: kSoft, fontSize: 10.5, height: 1.4)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _SmallAction(label: 'Search Jobs', icon: Icons.work_outline, color: kPurple, onTap: () => _openSearch(career)),
            _SmallAction(label: 'Search Internships', icon: Icons.school_outlined, color: kBlue, onTap: () => _openSearch('$career internship')),
          ]),
        ])),
      ]),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onExplore;
  const _OpportunityCard({required this.item, required this.onExplore});
  @override
  Widget build(BuildContext context) {
    final int match = (item['match'] as num).round();
    final bool internship = item['type'] == 'Internship';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(17), border: Border.all(color: kLine), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 18)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: (internship ? kBlue : kPurple).withOpacity(.12), borderRadius: BorderRadius.circular(12)), child: Icon(internship ? Icons.school_rounded : Icons.work_rounded, color: internship ? kBlue : kPurple)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['title'].toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)), const SizedBox(height: 3), Text('${item['type']} • ${item['domain']} • ${item['level']}', style: const TextStyle(color: kSoft, fontSize: 9.5))])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: kGreen.withOpacity(.10), borderRadius: BorderRadius.circular(10), border: Border.all(color: kGreen.withOpacity(.3))), child: Text('$match% match', style: const TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.w900))),
        ]),
        const SizedBox(height: 11),
        Wrap(spacing: 6, runSpacing: 6, children: (item['skills'] as List).map((s) => _GlowChip(s.toString(), kCyan)).toList()),
        const SizedBox(height: 10),
        Row(children: [const Icon(Icons.auto_awesome, color: kOrange, size: 15), const SizedBox(width: 5), Expanded(child: Text(match >= 80 ? 'Strong alignment with your current career profile.' : 'Build the highlighted skills to improve your opportunity match.', style: const TextStyle(color: kSoft, fontSize: 9.5))), TextButton.icon(onPressed: onExplore, icon: const Icon(Icons.open_in_new, size: 15), label: const Text('Explore', style: TextStyle(fontSize: 10)))])
      ]),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final String label; final IconData icon; final Color color; final VoidCallback onTap;
  const _SmallAction({required this.label, required this.icon, required this.color, required this.onTap});
  @override Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onTap, icon: Icon(icon, size: 16, color: color), label: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)), style: OutlinedButton.styleFrom(side: BorderSide(color: color.withOpacity(.35)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))));
}

class ProfilePage extends StatelessWidget {
  final String? career;
  final Map<String, dynamic>? aiData;
  const ProfilePage({super.key, required this.career, required this.aiData});
  @override
  Widget build(BuildContext context) {
    final readiness = aiData == null ? 0 : ((aiData!['readiness'] ?? 0) as num).round().clamp(0, 100);
    final skills = aiData?['current_skills'] is List ? (aiData!['current_skills'] as List).map((e) => e.toString()).toList() : <String>[];
    return SingleChildScrollView(padding: const EdgeInsets.all(26), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _PageHeading(title: 'My Profile', subtitle: 'Manage your account and view your career progress.'),
      const SizedBox(height: 18),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: _Panel(child: Column(children: [
          Row(children: [Container(width: 68, height: 68, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [kPurple, kBlue]), boxShadow: [BoxShadow(color: kPurple.withOpacity(.28), blurRadius: 22)]), child: const Center(child: Text('LS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)))), const SizedBox(width: 14), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Logesh S', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), SizedBox(height: 4), Text('Student • ECE', style: TextStyle(fontSize: 10, color: kSoft)), SizedBox(height: 3), Text('SkillPath AI learner', style: TextStyle(fontSize: 9, color: kPurple, fontWeight: FontWeight.w700))])), OutlinedButton(onPressed: () {}, child: const Text('Edit Profile'))]),
          const SizedBox(height: 18),
          Row(children: [Expanded(child: _ReferenceStatCard(icon: Icons.track_changes_rounded, title: 'Target Career', value: career == null ? '—' : career!.split(' ').take(2).join(' '), sub: 'Goal', color: kPurple)), const SizedBox(width: 9), Expanded(child: _ReferenceStatCard(icon: Icons.insights_rounded, title: 'Career Readiness', value: '$readiness%', sub: 'Overall', color: kCyan))]),
        ]))),
        const SizedBox(width: 14),
        SizedBox(width: 300, child: _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('My Stats', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)), const SizedBox(height: 12), _profileStat('Skills', '${skills.length}', kCyan), _profileStat('Courses', '${aiData?['courses'] is List ? (aiData!['courses'] as List).length : 0}', kPurple), _profileStat('Projects', '${aiData?['projects'] is List ? (aiData!['projects'] as List).length : 0}', kGreen)]))),
      ]),
      const SizedBox(height: 14),
      _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Skills', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)), const SizedBox(height: 10), if (skills.isEmpty) const Text('Analyze your resume to populate your skills.', style: TextStyle(color: kSoft, fontSize: 10)) else Wrap(spacing: 7, runSpacing: 7, children: skills.take(18).map((s) => _GlowChip(s, kBlue)).toList())])),
    ]));
  }
  Widget _profileStat(String title, String value, Color color) => Padding(padding: const EdgeInsets.only(bottom: 9), child: Row(children: [Container(width: 30, height: 30, decoration: BoxDecoration(color: color.withOpacity(.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.circle, color: color, size: 10)), const SizedBox(width: 9), Expanded(child: Text(title, style: const TextStyle(fontSize: 10, color: kSoft))), Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color))]));
}

class RoadmapPage extends StatefulWidget { final String career; final Map<String, dynamic> aiData; const RoadmapPage({super.key, required this.career, required this.aiData}); @override State<RoadmapPage> createState() => _RoadmapPageState(); }
class _RoadmapPageState extends State<RoadmapPage> {
  Map<String, bool> skillDone = {}; Map<String, bool> taskDone = {};
  String get keyName => 'skillpath_progress_${Uri.encodeComponent(widget.career)}';
  List<Map<String, dynamic>> get skills { final raw = widget.aiData['missing_skills']; if (raw is! List) return []; return raw.whereType<Map>().map((e) => {'skill': e['skill']?.toString() ?? 'Skill', 'priority': e['priority']?.toString() ?? 'Medium', 'reason': e['reason']?.toString() ?? ''}).toList(); }
  List<String> get tasks { final raw = widget.aiData['plan_30_days']; if (raw is! List) return []; return raw.map((e) => e.toString()).toList(); }
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final p = await SharedPreferences.getInstance(); final raw = p.getString(keyName); if (raw != null) { final m = jsonDecode(raw); if (mounted) setState(() { skillDone = Map<String, bool>.from((m['skills'] ?? {}).map((k,v) => MapEntry(k.toString(), v == true))); taskDone = Map<String, bool>.from((m['tasks'] ?? {}).map((k,v) => MapEntry(k.toString(), v == true))); }); } }
  Future<void> _save() async { final p = await SharedPreferences.getInstance(); await p.setString(keyName, jsonEncode({'skills': skillDone, 'tasks': taskDone, 'savedAt': DateTime.now().toIso8601String()})); }
  double get progress { final total = skills.length + tasks.length; if (total == 0) return 0; final done = skills.where((e) => skillDone[e['skill']] == true).length + tasks.where((e) => taskDone[e] == true).length; return done / total; }
  @override Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(26), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _PageHeading(title: 'Personalized Skill Roadmap', subtitle: 'A visual path from skill gaps to your ${widget.career} goal.'), const SizedBox(height: 18),
    _Panel(child: Column(children: [Row(children: [const Icon(Icons.route_rounded, color: kPurple), const SizedBox(width: 8), const Text('Your Journey', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)), const Spacer(), Text('${(progress * 100).round()}% complete', style: const TextStyle(color: kSoft, fontSize: 11))]), const SizedBox(height: 18), _RoadmapFlow(skills: skills, progress: progress)])),
    const SizedBox(height: 16),
    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Priority Skills', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 10), ...skills.map((s) => CheckboxListTile(value: skillDone[s['skill']] ?? false, onChanged: (v) { setState(() => skillDone[s['skill']] = v == true); _save(); }, activeColor: kPurple, contentPadding: EdgeInsets.zero, title: Text(s['skill'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), subtitle: Text('${s['priority']} priority • ${s['reason']}', style: const TextStyle(color: kSoft, fontSize: 9)), secondary: Icon(Icons.bolt_rounded, color: _priorityColor(s['priority']))) )]))), const SizedBox(width: 14), Expanded(child: _Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('30-Day Action Plan', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 10), ...tasks.map((task) => CheckboxListTile(value: taskDone[task] ?? false, onChanged: (v) { setState(() => taskDone[task] = v == true); _save(); }, activeColor: kBlue, contentPadding: EdgeInsets.zero, title: Text(task, style: const TextStyle(fontSize: 10.5, color: kSoft))) )]))),]),
  ]));
  Color _priorityColor(String p) { final x = p.toLowerCase(); return x == 'high' ? kPink : x == 'low' ? kCyan : kOrange; }
}
class _RoadmapFlow extends StatelessWidget { final List<Map<String, dynamic>> skills; final double progress; const _RoadmapFlow({required this.skills, required this.progress}); @override Widget build(BuildContext context) { final nodes = skills.take(5).toList(); return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [const _FlowNode(icon: Icons.upload_file_rounded, title: 'Resume', color: kBlue), _arrow(), const _FlowNode(icon: Icons.psychology_rounded, title: 'AI Gap Analysis', color: kOrange), _arrow(), ...nodes.asMap().entries.expand((entry) => [ _FlowNode(icon: Icons.auto_awesome_rounded, title: entry.value['skill'].toString(), color: entry.key == 0 ? kPink : kPurple), _arrow()]), const _FlowNode(icon: Icons.workspace_premium_rounded, title: 'Target Role', color: kOrange)])); } Widget _arrow() => const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward_rounded, color: kSoft, size: 18)); }
class _FlowNode extends StatelessWidget { final IconData icon; final String title; final Color color; const _FlowNode({required this.icon, required this.title, required this.color}); @override Widget build(BuildContext context) => Container(width: 145, padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: color.withOpacity(.08), borderRadius: BorderRadius.circular(13), border: Border.all(color: color.withOpacity(.45)), boxShadow: [BoxShadow(color: color.withOpacity(.07), blurRadius: 18)]), child: Column(children: [Icon(icon, color: color, size: 24), const SizedBox(height: 7), Text(title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kWhite))])); }
