import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/catalogs/course_catalog.dart';
import '../../../../models/course_recommendation.dart';
import '../widgets/common_widgets.dart';

class CoursesPage extends StatefulWidget {
  final String career;
  final Map<String, dynamic> aiData;

  const CoursesPage({
    super.key,
    required this.career,
    required this.aiData,
  });

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  Set<String> completed = {};

  String get keyName => 'skillpath_courses_${Uri.encodeComponent(widget.career)}';

  List<String> get skills {
    final raw = widget.aiData['missing_skills'];
    if (raw is! List) return [];
    return raw.map((e) => e is Map ? e['skill'].toString() : e.toString()).where((e) => e.trim().isNotEmpty).toList();
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
    final aiCourses = widget.aiData['courses'] is List ? (widget.aiData['courses'] as List).map((e) => e.toString()).toList() : <String>[];
    final completedCurated = courses.where((course) => completed.contains(course.title)).length;
    final progress = courses.isEmpty ? 0.0 : completedCurated / courses.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            title: 'Learning Path',
            subtitle: 'Personalized courses mapped to the skills you need for ${widget.career}.',
          ),
          const SizedBox(height: 18),
          Panel(
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
            const Panel(
              child: Column(
                children: [
                  Icon(
                    Icons.school_outlined,
                    color: kPurple,
                    size: 44,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No curated course match yet',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 5),
                  Text(
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
            Panel(
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
    return Panel(
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
              if (done) const Icon(Icons.verified_rounded, color: kGreen, size: 20),
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
              GlowChip(course.difficulty, kBlue),
              GlowChip(course.duration, kOrange),
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
