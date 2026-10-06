import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/catalogs/project_catalog.dart';
import '../../../../models/project_recommendation.dart';
import '../widgets/common_widgets.dart';

class ProjectsPage extends StatefulWidget {
  final String career;
  final Map<String, dynamic> aiData;

  const ProjectsPage({
    super.key,
    required this.career,
    required this.aiData,
  });

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  Set<String> completed = {};

  String get keyName => 'skillpath_projects_${Uri.encodeComponent(widget.career)}';

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
      setState(() => completed = (p.getStringList(keyName) ?? []).toSet());
    }
  }

  Future<void> _toggle(String title) async {
    final p = await SharedPreferences.getInstance();
    setState(() => completed.contains(title) ? completed.remove(title) : completed.add(title));
    await p.setStringList(keyName, completed.toList());
  }

  @override
  Widget build(BuildContext context) {
    final projects = ProjectCatalog.forSkills(skills);
    final progress = projects.isEmpty ? 0 : completed.where(projects.map((e) => e.title).contains).length / projects.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            title: 'Project Lab',
            subtitle: 'Turn your missing skills into portfolio evidence with guided builds.',
          ),
          const SizedBox(height: 18),
          Panel(
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: kOrange.withOpacity(.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.code_rounded, color: kOrange, size: 28),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Build real proof',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${completed.length} completed • ${projects.length} matched projects',
                        style: const TextStyle(color: kSoft, fontSize: 11),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress.toDouble(),
                          minHeight: 6,
                          color: kOrange,
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
          if (projects.isEmpty)
            const Panel(
              child: Text(
                'No project match yet. Run an AI analysis with more detailed skill gaps.',
                style: TextStyle(color: kSoft),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width >= 1000 ? 2 : 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.1,
              ),
              itemCount: projects.length,
              itemBuilder: (_, i) => _ProjectCard(
                project: projects[i],
                done: completed.contains(projects[i].title),
                onToggle: () => _toggle(projects[i].title),
              ),
            ),
        ],
      ),
    );
  }
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
              if (done) const Icon(Icons.check_circle, color: kGreen, size: 20),
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
              GlowChip(project.level, kPurple),
              GlowChip(project.duration, kBlue),
              GlowChip(project.tech, kCyan),
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
