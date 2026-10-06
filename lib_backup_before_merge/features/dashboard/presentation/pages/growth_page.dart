import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class GrowthPage extends StatelessWidget {
  final String career;
  final Map<String, dynamic> currentData;
  final Map<String, dynamic>? previousData;
  final VoidCallback onReanalyze;

  const GrowthPage({
    super.key,
    required this.career,
    required this.currentData,
    required this.previousData,
    required this.onReanalyze,
  });

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
    final added = newSkills.where((e) => !oldSet.contains(e.toLowerCase())).toList();
    final retained = newSkills.where((e) => oldSet.contains(e.toLowerCase())).toList();
    final levelsBefore = _levels(previousData);
    final levelsNow = _levels(currentData);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            title: 'Career Growth',
            subtitle: 'Track how your resume and skills change over time for $career.',
          ),
          const SizedBox(height: 18),
          if (previousData == null)
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.insights_rounded, color: kGreen, size: 34),
                  const SizedBox(height: 12),
                  const Text('Growth tracking is ready', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  const Text(
                    'Run another resume analysis after completing courses, projects or roadmap tasks. SkillPath AI will compare the two analyses here.',
                    style: TextStyle(color: kSoft, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onReanalyze,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Upload Updated Resume'),
                  ),
                ],
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(child: _GrowthMetric(title: 'Previous Readiness', value: '$before%', color: kSoft)),
                const SizedBox(width: 10),
                Expanded(child: _GrowthMetric(title: 'Current Readiness', value: '$now%', color: kGreen)),
                const SizedBox(width: 10),
                Expanded(
                  child: _GrowthMetric(
                    title: 'Change',
                    value: '${delta >= 0 ? '+' : ''}$delta%',
                    color: delta >= 0 ? kGreen : kOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.show_chart_rounded, color: kGreen),
                      const SizedBox(width: 8),
                      const Text('Readiness Growth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      const Spacer(),
                      Text('$before% → $now%', style: const TextStyle(color: kSoft, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(value: now / 100, minHeight: 12, color: kGreen, backgroundColor: kLine),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    delta > 0
                        ? 'Your latest analysis shows measurable progress.'
                        : delta == 0
                            ? 'Your readiness score is unchanged in the latest analysis.'
                            : 'The latest analysis shows a lower readiness score; review the new skill gaps below.',
                    style: const TextStyle(color: kSoft, fontSize: 11),
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
                        const Text('New Skills Detected', style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        if (added.isEmpty)
                          const Text('No new skills detected yet.', style: TextStyle(color: kSoft, fontSize: 11))
                        else
                          Wrap(spacing: 7, runSpacing: 7, children: added.map((s) => GlowChip(s, kGreen)).toList()),
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
                        const Text('Skills Retained', style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        if (retained.isEmpty)
                          const Text('No matching skills found.', style: TextStyle(color: kSoft, fontSize: 11))
                        else
                          Wrap(spacing: 7, runSpacing: 7, children: retained.take(12).map((s) => GlowChip(s, kCyan)).toList()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (levelsNow.isNotEmpty) ...[
              const SizedBox(height: 16),
              Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Skill Level Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    ...levelsNow.entries.map((entry) {
                      final old = levelsBefore[entry.key];
                      final current = entry.value;
                      final change = old == null ? null : current - old;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(entry.key, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
                                Text('${old?.round() ?? 0}% → ${current.round()}%', style: const TextStyle(color: kSoft, fontSize: 10)),
                                if (change != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Text(
                                      '${change >= 0 ? '+' : ''}${change.round()}%',
                                      style: TextStyle(color: change >= 0 ? kGreen : kOrange, fontSize: 10, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(value: current.clamp(0, 100) / 100, minHeight: 7, color: kPurple, backgroundColor: kLine),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Panel(
              child: Row(
                children: [
                  const Icon(Icons.refresh_rounded, color: kPurple),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Keep learning, building projects and re-upload your resume to update this growth view.',
                      style: TextStyle(color: kSoft, fontSize: 11, height: 1.4),
                    ),
                  ),
                  ElevatedButton(onPressed: onReanalyze, child: const Text('Re-analyze')),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GrowthMetric extends StatelessWidget {
  final String title, value;
  final Color color;

  const _GrowthMetric({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(color: kSoft, fontSize: 9)),
          ],
        ),
      );
}
