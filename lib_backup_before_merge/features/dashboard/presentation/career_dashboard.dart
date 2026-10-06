import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/pdf_helper.dart';
import '../../../services/gemini_service.dart';
import 'pages/analysis_page.dart';
import 'pages/courses_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/growth_page.dart';
import 'pages/jobs_page.dart';
import 'pages/projects_page.dart';
import 'pages/roadmap_page.dart';

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
      final extracted = await PdfHelper.extractTextFromBytes(bytes);

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
    if (ApiConstants.geminiApiKey == 'PASTE_YOUR_NEW_GEMINI_API_KEY_HERE' ||
        ApiConstants.geminiApiKey.trim().isEmpty) {
      _toast('Add your Gemini API key in api_constants.dart first.');
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
    if (page != 0 && aiData == null) {
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
    final desktop = MediaQuery.of(context).size.width >= 1050;
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Color(0xFF07102A),
        border: Border(bottom: BorderSide(color: kLine)),
      ),
      child: Row(children: [
        if (!desktop) ...[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(colors: [kBlue, kPurple]),
            ),
            child: const Icon(Icons.auto_awesome_rounded, size: 19, color: Colors.white),
          ),
          const SizedBox(width: 9),
          const Text('SkillPath AI', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: kWhite)),
        ],
        if (desktop) const Spacer(),
        if (desktop)
          SizedBox(
            width: 260,
            height: 38,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search anything...',
                hintStyle: const TextStyle(color: kSoft, fontSize: 11),
                prefixIcon: const Icon(Icons.search_rounded, size: 18, color: kSoft),
                filled: true,
                fillColor: const Color(0xFF0B1534),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: kLine)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: kLine)),
              ),
            ),
          ),
        const Spacer(),
        if (career != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(color: kPanel2, borderRadius: BorderRadius.circular(10), border: Border.all(color: kLine)),
            child: Text(career!, style: const TextStyle(fontSize: 10, color: kSoft)),
          ),
        const SizedBox(width: 8),
        IconButton(onPressed: onNotification, icon: const Icon(Icons.notifications_none_rounded, color: kSoft, size: 20)),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [kBlue, kPurple]),
            boxShadow: [BoxShadow(color: kPurple.withValues(alpha: .3), blurRadius: 16)],
          ),
          child: const Center(child: Text('LS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900))),
        ),
        const SizedBox(width: 6),
        if (desktop)
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Logesh S', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kWhite)),
              Text('Student • ECE', style: TextStyle(fontSize: 8, color: kSoft)),
            ],
          ),
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
      width: 214,
      decoration: const BoxDecoration(
        color: Color(0xFF06102A),
        border: Border(right: BorderSide(color: kLine)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 14, 22),
            child: Row(children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  gradient: const LinearGradient(colors: [kBlue, kPurple]),
                  boxShadow: [BoxShadow(color: kPurple.withValues(alpha: .25), blurRadius: 18)],
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 9),
              const Text('SkillPath ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: kWhite)),
              const Text('AI', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: kPurple)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(children: [
              _sideItem(Icons.dashboard_rounded, 'Dashboard', 0),
              _sideItem(Icons.description_outlined, 'Resume Analysis', 1),
              _sideItem(Icons.trending_up_rounded, 'Career Growth', 5),
              _sideItem(Icons.work_outline_rounded, 'Jobs & Internships', 6),
              _sideItem(Icons.route_rounded, 'Roadmap', 2),
              _sideItem(Icons.school_outlined, 'Courses', 3),
              _sideItem(Icons.code_rounded, 'Projects', 4),
            ]),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _sideItem(Icons.settings_outlined, 'Settings', -1),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 7, 20, 18),
            child: Row(children: [
              Icon(Icons.logout_rounded, size: 17, color: kSoft),
              SizedBox(width: 10),
              Text('Logout', style: TextStyle(color: kSoft, fontSize: 11, fontWeight: FontWeight.w700)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _sideItem(IconData icon, String label, int index) {
    final active = selectedPage == index;
    return InkWell(
      onTap: index >= 0 ? () => onSelect(index) : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 39,
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          gradient: active ? const LinearGradient(colors: [Color(0xFF3C45B7), Color(0xFF6644C9)]) : null,
          borderRadius: BorderRadius.circular(10),
          border: active ? Border.all(color: kPurple.withOpacity(.45)) : null,
          boxShadow: active ? [BoxShadow(color: kPurple.withOpacity(.18), blurRadius: 16)] : null,
        ),
        child: Row(children: [
          Icon(icon, size: 17, color: active ? Colors.white : kSoft),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                color: active ? Colors.white : kSoft,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _MobileNav extends StatelessWidget {
  final int selectedPage;
  final ValueChanged<int> onSelect;

  const _MobileNav({required this.selectedPage, required this.onSelect});

  @override
  Widget build(BuildContext context) => NavigationBar(
        backgroundColor: const Color(0xFF06102A),
        indicatorColor: kPurple.withOpacity(.22),
        selectedIndex: selectedPage,
        onDestinationSelected: onSelect,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description), label: 'Analysis'),
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Roadmap'),
          NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.code_outlined), selectedIcon: Icon(Icons.code), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.trending_up_outlined), selectedIcon: Icon(Icons.trending_up), label: 'Growth'),
          NavigationDestination(icon: Icon(Icons.work_outline_rounded), selectedIcon: Icon(Icons.work_rounded), label: 'Jobs'),
        ],
      );
}
