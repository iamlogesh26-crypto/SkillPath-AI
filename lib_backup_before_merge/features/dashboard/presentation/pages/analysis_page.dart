import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class AnalysisPage extends StatelessWidget {
  final String career;
  final Map<String, dynamic> aiData;
  final VoidCallback onRoadmap;
  final VoidCallback onCourses;
  final VoidCallback onProjects;
  final VoidCallback onReanalyze;
  final VoidCallback onGrowth;

  const AnalysisPage({
    super.key,
    required this.career,
    required this.aiData,
    required this.onRoadmap,
    required this.onCourses,
    required this.onProjects,
    required this.onReanalyze,
    required this.onGrowth,
  });

  List<dynamic> list(String key) => aiData[key] is List ? aiData[key] as List : [];

  @override
  Widget build(BuildContext context) {
    final readiness = ((aiData['readiness'] ?? 0) as num).round();
    final current = list('current_skills');
    final missing = list('missing_skills');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            title: 'Resume Analysis',
            subtitle: 'AI-powered comparison between your resume and $career.',
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: kPurple),
                          const SizedBox(width: 8),
                          const Text('AI Analysis Results', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: onReanalyze,
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('New Analysis'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [kPurple.withOpacity(.18), kBlue.withOpacity(.08)]),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kPurple.withOpacity(.3)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 104,
                              height: 104,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: readiness / 100,
                                    strokeWidth: 9,
                                    color: kPurple,
                                    backgroundColor: kLine,
                                  ),
                                  Text('$readiness%', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Career Readiness', style: TextStyle(color: kSoft, fontSize: 12)),
                                  const SizedBox(height: 5),
                                  Text(career, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 6),
                                  Text(
                                    aiData['summary']?.toString() ?? 'AI summary unavailable.',
                                    style: const TextStyle(color: kSoft, height: 1.4, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(child: _analysisStat('Current Skills', '${current.length}', kCyan)),
                          const SizedBox(width: 10),
                          Expanded(child: _analysisStat('Missing Skills', '${missing.length}', kOrange)),
                          const SizedBox(width: 10),
                          Expanded(child: _analysisStat('Plan', '30 / 60 / 90', kPurple)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text('Current Skills', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: current.map((s) => GlowChip(s.toString(), kCyan)).toList(),
                      ),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    ActionPanel(
                      title: 'Personalized Roadmap',
                      icon: Icons.route_rounded,
                      text: 'Turn your skill gaps into a trackable learning path.',
                      button: 'Open Roadmap',
                      color: kPurple,
                      onTap: onRoadmap,
                    ),
                    const SizedBox(height: 12),
                    ActionPanel(
                      title: 'Course Recommendations',
                      icon: Icons.school_rounded,
                      text: 'Learn the highest-priority missing skills.',
                      button: 'Explore Courses',
                      color: kBlue,
                      onTap: onCourses,
                    ),
                    const SizedBox(height: 12),
                    ActionPanel(
                      title: 'Project Lab',
                      icon: Icons.code_rounded,
                      text: 'Build portfolio evidence for the skills you need.',
                      button: 'Build Projects',
                      color: kOrange,
                      onTap: onProjects,
                    ),
                    const SizedBox(height: 12),
                    Panel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AI Recommendation', style: TextStyle(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Text(
                            aiData['recommendation']?.toString() ?? 'No recommendation available.',
                            style: const TextStyle(color: kSoft, fontSize: 11, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ActionPanel(
                      title: 'Career Growth',
                      icon: Icons.trending_up_rounded,
                      text: 'Compare your latest resume analysis with the previous one.',
                      button: 'View Growth',
                      color: kGreen,
                      onTap: onGrowth,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _analysisStat(String title, String value, Color color) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 3),
            Text(title, style: const TextStyle(fontSize: 9, color: kSoft)),
          ],
        ),
      );

  Widget _priority(String value) {
    final c = value.toLowerCase() == 'high'
        ? kPink
        : value.toLowerCase() == 'low'
            ? kCyan
            : kOrange;
    return GlowChip(value, c);
  }
}
