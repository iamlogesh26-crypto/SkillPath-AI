import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class JobsPage extends StatelessWidget {
  final String career;
  final Map<String, dynamic> aiData;

  const JobsPage({
    super.key,
    required this.career,
    required this.aiData,
  });

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
        {'title': 'Embedded Systems Intern', 'type': 'Internship', 'domain': 'Embedded / Firmware', 'skills': ['C', 'Microcontrollers', 'UART / SPI / I2C'], 'level': 'Student', 'match': 88},
        {'title': 'Firmware Engineer – Graduate / Intern', 'type': 'Internship', 'domain': 'Firmware', 'skills': ['C / C++', 'RTOS', 'Debugging'], 'level': 'Entry level', 'match': 82},
        {'title': 'IoT / Embedded Developer', 'type': 'Job', 'domain': 'IoT', 'skills': ['ESP32 / Arduino', 'MQTT', 'Sensors'], 'level': 'Entry level', 'match': 76},
        {'title': 'Junior Embedded Software Engineer', 'type': 'Job', 'domain': 'Embedded Software', 'skills': ['C', 'Git', 'Linux'], 'level': 'Entry level', 'match': 71},
      ];
    }
    if (c.contains('iot')) {
      return [
        {'title': 'IoT Developer Intern', 'type': 'Internship', 'domain': 'IoT', 'skills': ['ESP32', 'MQTT', 'Sensors'], 'level': 'Student', 'match': 88},
        {'title': 'IoT / Edge Computing Intern', 'type': 'Internship', 'domain': 'Edge / Cloud', 'skills': ['Python', 'MQTT', 'Cloud'], 'level': 'Student', 'match': 81},
        {'title': 'Junior IoT Engineer', 'type': 'Job', 'domain': 'IoT', 'skills': ['Embedded C', 'Networking', 'Cloud'], 'level': 'Entry level', 'match': 76},
        {'title': 'IoT Solutions Engineer – Graduate', 'type': 'Job', 'domain': 'IoT Solutions', 'skills': ['APIs', 'Linux', 'Networking'], 'level': 'Entry level', 'match': 70},
      ];
    }
    if (c.contains('ai/ml')) {
      return [
        {'title': 'AI/ML Intern', 'type': 'Internship', 'domain': 'Artificial Intelligence', 'skills': ['Python', 'ML', 'NumPy / Pandas'], 'level': 'Student', 'match': 88},
        {'title': 'Machine Learning Intern', 'type': 'Internship', 'domain': 'Machine Learning', 'skills': ['Python', 'Scikit-learn', 'Statistics'], 'level': 'Student', 'match': 82},
        {'title': 'Junior AI Engineer', 'type': 'Job', 'domain': 'AI / ML', 'skills': ['Python', 'ML', 'Git'], 'level': 'Entry level', 'match': 74},
        {'title': 'Data & AI Graduate Intern', 'type': 'Internship', 'domain': 'Data / AI', 'skills': ['SQL', 'Python', 'Visualization'], 'level': 'Student', 'match': 69},
      ];
    }
    if (c.contains('data analyst')) {
      return [
        {'title': 'Data Analyst Intern', 'type': 'Internship', 'domain': 'Data Analytics', 'skills': ['SQL', 'Excel', 'Python'], 'level': 'Student', 'match': 89},
        {'title': 'Business Data Analyst Intern', 'type': 'Internship', 'domain': 'Analytics', 'skills': ['SQL', 'Power BI', 'Statistics'], 'level': 'Student', 'match': 82},
        {'title': 'Junior Data Analyst', 'type': 'Job', 'domain': 'Data Analytics', 'skills': ['SQL', 'Python', 'Power BI'], 'level': 'Entry level', 'match': 76},
        {'title': 'Data & Reporting Intern', 'type': 'Internship', 'domain': 'Business Intelligence', 'skills': ['Excel', 'SQL', 'Dashboards'], 'level': 'Student', 'match': 71},
      ];
    }
    if (c.contains('cyber')) {
      return [
        {'title': 'Cybersecurity Intern', 'type': 'Internship', 'domain': 'Security', 'skills': ['Networking', 'Linux', 'Security Basics'], 'level': 'Student', 'match': 87},
        {'title': 'SOC Analyst Intern', 'type': 'Internship', 'domain': 'Security Operations', 'skills': ['SIEM', 'Networking', 'Linux'], 'level': 'Student', 'match': 80},
        {'title': 'Junior Security Analyst', 'type': 'Job', 'domain': 'Cybersecurity', 'skills': ['Networking', 'SIEM', 'Incident Response'], 'level': 'Entry level', 'match': 73},
        {'title': 'Security Engineering Intern', 'type': 'Internship', 'domain': 'Application Security', 'skills': ['Web Security', 'Python', 'Git'], 'level': 'Student', 'match': 68},
      ];
    }
    return [
      {'title': 'Software Developer Intern', 'type': 'Internship', 'domain': 'Software Development', 'skills': ['Programming', 'Git', 'Data Structures'], 'level': 'Student', 'match': 88},
      {'title': 'Flutter Developer Intern', 'type': 'Internship', 'domain': 'Mobile Development', 'skills': ['Flutter', 'Dart', 'Git'], 'level': 'Student', 'match': 83},
      {'title': 'Junior Software Developer', 'type': 'Job', 'domain': 'Software Engineering', 'skills': ['Programming', 'DSA', 'Git'], 'level': 'Entry level', 'match': 76},
      {'title': 'Full-Stack Developer Intern', 'type': 'Internship', 'domain': 'Web Development', 'skills': ['JavaScript', 'APIs', 'Git'], 'level': 'Student', 'match': 69},
    ];
  }

  Future<void> _openSearch(String query) async {
    final url = Uri.parse('https://www.linkedin.com/jobs/search/?keywords=${Uri.encodeComponent(query)}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final skills = _skills();
    final gaps = _gaps();
    final opportunities = _opportunities();
    final readiness = ((aiData['readiness'] ?? 0) as num).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            title: 'Jobs & Internships',
            subtitle: 'Career opportunities matched to your $career journey.',
          ),
          const SizedBox(height: 18),
          Panel(
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [kPurple, kBlue]),
                  ),
                  child: const Icon(Icons.work_rounded, color: Colors.white, size: 27),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AI Career Match', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 5),
                      Text(
                        'Your current readiness is $readiness%. Opportunities are organized around your target role, current skills and skill gaps.',
                        style: const TextStyle(color: kSoft, fontSize: 11, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Match Signals', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Text('${skills.length} current skills detected', style: const TextStyle(color: kGreen, fontSize: 11)),
                      const SizedBox(height: 5),
                      Text('${gaps.length} skills to strengthen', style: const TextStyle(color: kOrange, fontSize: 11)),
                      const SizedBox(height: 9),
                      Wrap(spacing: 5, runSpacing: 5, children: skills.take(5).map((s) => GlowChip(s, kBlue)).toList()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Top Skill Gaps', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      if (gaps.isEmpty)
                        const Text('No major gaps returned by the analysis.', style: TextStyle(color: kSoft, fontSize: 11))
                      else
                        ...gaps.take(4).map(
                              (g) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.bolt_rounded, color: kOrange, size: 15),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(g, style: const TextStyle(color: kSoft, fontSize: 10.5))),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Recommended Opportunities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const Spacer(),
              Text('${opportunities.length} matches', style: const TextStyle(color: kSoft, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          ...opportunities.map((item) => _OpportunityCard(item: item, onExplore: () => _openSearch(item['title'].toString()))),
          const SizedBox(height: 18),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.travel_explore_rounded, color: kCyan, size: 20),
                    SizedBox(width: 8),
                    Text('Explore Live Opportunities', style: TextStyle(fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 7),
                const Text(
                  'Search current LinkedIn opportunities using your selected career. Live listings can change frequently.',
                  style: TextStyle(color: kSoft, fontSize: 10.5, height: 1.4),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SmallAction(label: 'Search Jobs', icon: Icons.work_outline, color: kPurple, onTap: () => _openSearch(career)),
                    _SmallAction(label: 'Search Internships', icon: Icons.school_outlined, color: kBlue, onTap: () => _openSearch('$career internship')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
      decoration: BoxDecoration(
        color: kPanel,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: kLine),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 18)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (internship ? kBlue : kPurple).withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(internship ? Icons.school_rounded : Icons.work_rounded, color: internship ? kBlue : kPurple),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'].toString(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    const SizedBox(height: 3),
                    Text('${item['type']} • ${item['domain']} • ${item['level']}', style: const TextStyle(color: kSoft, fontSize: 9.5)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kGreen.withOpacity(.3)),
                ),
                child: Text('$match% match', style: const TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (item['skills'] as List).map((s) => GlowChip(s.toString(), kCyan)).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: kOrange, size: 15),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  match >= 80 ? 'Strong alignment with your current career profile.' : 'Build the highlighted skills to improve your opportunity match.',
                  style: const TextStyle(color: kSoft, fontSize: 9.5),
                ),
              ),
              TextButton.icon(
                onPressed: onExplore,
                icon: const Icon(Icons.open_in_new, size: 15),
                label: const Text('Explore', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SmallAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: color),
        label: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withOpacity(.35)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        ),
      );
}
