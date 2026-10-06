import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/common_widgets.dart';

class RoadmapPage extends StatefulWidget {
  final String career;
  final Map<String, dynamic> aiData;

  const RoadmapPage({
    super.key,
    required this.career,
    required this.aiData,
  });

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  Map<String, bool> skillDone = {};
  Map<String, bool> taskDone = {};

  String get keyName => 'skillpath_progress_${Uri.encodeComponent(widget.career)}';

  List<Map<String, dynamic>> get skills {
    final raw = widget.aiData['missing_skills'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => {
              'skill': e['skill']?.toString() ?? 'Skill',
              'priority': e['priority']?.toString() ?? 'Medium',
              'reason': e['reason']?.toString() ?? ''
            })
        .toList();
  }

  List<String> get tasks {
    final raw = widget.aiData['plan_30_days'];
    if (raw is! List) return [];
    return raw.map((e) => e.toString()).toList();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(keyName);
    if (raw != null) {
      final m = jsonDecode(raw);
      if (mounted) {
        setState(() {
          skillDone = Map<String, bool>.from((m['skills'] ?? {}).map((k, v) => MapEntry(k.toString(), v == true)));
          taskDone = Map<String, bool>.from((m['tasks'] ?? {}).map((k, v) => MapEntry(k.toString(), v == true)));
        });
      }
    }
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(keyName, jsonEncode({'skills': skillDone, 'tasks': taskDone, 'savedAt': DateTime.now().toIso8601String()}));
  }

  double get progress {
    final total = skills.length + tasks.length;
    if (total == 0) return 0;
    final done = skills.where((e) => skillDone[e['skill']] == true).length + tasks.where((e) => taskDone[e] == true).length;
    return done / total;
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeading(
              title: 'Personalized Skill Roadmap',
              subtitle: 'A visual path from skill gaps to your ${widget.career} goal.',
            ),
            const SizedBox(height: 18),
            Panel(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.route_rounded, color: kPurple),
                      const SizedBox(width: 8),
                      const Text('Your Journey', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                      const Spacer(),
                      Text('${(progress * 100).round()}% complete', style: const TextStyle(color: kSoft, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _RoadmapFlow(skills: skills, progress: progress),
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
                        const Text('Priority Skills', style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        ...skills.map(
                          (s) => CheckboxListTile(
                            value: skillDone[s['skill']] ?? false,
                            onChanged: (v) {
                              setState(() => skillDone[s['skill']] = v == true);
                              _save();
                            },
                            activeColor: kPurple,
                            contentPadding: EdgeInsets.zero,
                            title: Text(s['skill'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                            subtitle: Text('${s['priority']} priority • ${s['reason']}', style: const TextStyle(color: kSoft, fontSize: 9)),
                            secondary: Icon(Icons.bolt_rounded, color: _priorityColor(s['priority'])),
                          ),
                        ),
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
                        const Text('30-Day Action Plan', style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        ...tasks.map(
                          (task) => CheckboxListTile(
                            value: taskDone[task] ?? false,
                            onChanged: (v) {
                              setState(() => taskDone[task] = v == true);
                              _save();
                            },
                            activeColor: kBlue,
                            contentPadding: EdgeInsets.zero,
                            title: Text(task, style: const TextStyle(fontSize: 10.5, color: kSoft)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Color _priorityColor(String p) {
    final x = p.toLowerCase();
    return x == 'high'
        ? kPink
        : x == 'low'
            ? kCyan
            : kOrange;
  }
}

class _RoadmapFlow extends StatelessWidget {
  final List<Map<String, dynamic>> skills;
  final double progress;

  const _RoadmapFlow({required this.skills, required this.progress});

  @override
  Widget build(BuildContext context) {
    final nodes = skills.take(5).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const _FlowNode(icon: Icons.upload_file_rounded, title: 'Resume', color: kBlue),
          _arrow(),
          const _FlowNode(icon: Icons.psychology_rounded, title: 'AI Gap Analysis', color: kOrange),
          _arrow(),
          ...nodes.asMap().entries.expand(
                (entry) => [
                  _FlowNode(
                    icon: Icons.auto_awesome_rounded,
                    title: entry.value['skill'].toString(),
                    color: entry.key == 0 ? kPink : kPurple,
                  ),
                  _arrow(),
                ],
              ),
          const _FlowNode(icon: Icons.workspace_premium_rounded, title: 'Target Role', color: kOrange),
        ],
      ),
    );
  }

  Widget _arrow() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Icon(Icons.arrow_forward_rounded, color: kSoft, size: 18),
      );
}

class _FlowNode extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _FlowNode({required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 145,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: color.withOpacity(.45)),
          boxShadow: [BoxShadow(color: color.withOpacity(.07), blurRadius: 18)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: kWhite),
            ),
          ],
        ),
      );
}
