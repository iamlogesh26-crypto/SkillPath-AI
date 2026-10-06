import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/common_widgets.dart';

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

  const DashboardPage({
    super.key,
    required this.career,
    required this.careers,
    required this.resumeName,
    required this.resumeStatus,
    required this.isExtracting,
    required this.isAnalyzing,
    required this.aiData,
    required this.onUpload,
    required this.onAnalyze,
    required this.onCareerChanged,
    required this.onAnalysis,
    required this.onRoadmap,
    required this.onCourses,
    required this.onProjects,
  });

  List<dynamic> _list(String key) => aiData?[key] is List ? aiData![key] as List : [];

  @override
  Widget build(BuildContext context) {
    final readiness = ((aiData?['readiness'] ?? 0) as num).round();
    final current = _list('current_skills');
    final gaps = _list('missing_skills');
    final wide = MediaQuery.of(context).size.width >= 1120;
    final medium = MediaQuery.of(context).size.width >= 800;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(wide ? 28 : 16, 22, wide ? 28 : 16, 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Good Morning, Logesh 👋', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: kWhite)),
        const SizedBox(height: 4),
        const Text('Your skills today build your tomorrow', style: TextStyle(fontSize: 10.5, color: kSoft)),
        const SizedBox(height: 18),

        if (wide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 7, child: _DashboardJourney(career: career, readiness: readiness, current: current.length, gaps: gaps.length, onAnalysis: onAnalysis, onRoadmap: onRoadmap)),
            const SizedBox(width: 13),
            SizedBox(width: 245, child: _DashboardReadiness(readiness: readiness, career: career)),
          ])
        else
          Column(children: [
            _DashboardJourney(career: career, readiness: readiness, current: current.length, gaps: gaps.length, onAnalysis: onAnalysis, onRoadmap: onRoadmap),
            const SizedBox(height: 13),
            _DashboardReadiness(readiness: readiness, career: career),
          ]),

        const SizedBox(height: 13),
        if (medium)
          Row(children: [
            Expanded(child: _DashboardStat(icon: Icons.auto_awesome_rounded, value: '${current.length}', label: 'Current Skills', change: current.isEmpty ? 'Upload resume' : 'Analyzed', color: kCyan)),
            const SizedBox(width: 10),
            Expanded(child: _DashboardStat(icon: Icons.warning_amber_rounded, value: '${gaps.length}', label: 'Skill Gaps', change: gaps.isEmpty ? 'Run analysis' : 'To improve', color: kOrange)),
            const SizedBox(width: 10),
            Expanded(child: _DashboardStat(icon: Icons.school_rounded, value: '3', label: 'Courses', change: 'Recommended', color: kPurple)),
            const SizedBox(width: 10),
            Expanded(child: _DashboardStat(icon: Icons.code_rounded, value: '2', label: 'Projects', change: 'Portfolio', color: kBlue)),
          ])
        else
          Column(children: [
            Row(children: [
              Expanded(child: _DashboardStat(icon: Icons.auto_awesome_rounded, value: '${current.length}', label: 'Current Skills', change: 'Analyzed', color: kCyan)),
              const SizedBox(width: 8),
              Expanded(child: _DashboardStat(icon: Icons.warning_amber_rounded, value: '${gaps.length}', label: 'Skill Gaps', change: 'To improve', color: kOrange)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _DashboardStat(icon: Icons.school_rounded, value: '3', label: 'Courses', change: 'Recommended', color: kPurple)),
              const SizedBox(width: 8),
              Expanded(child: _DashboardStat(icon: Icons.code_rounded, value: '2', label: 'Projects', change: 'Portfolio', color: kBlue)),
            ]),
          ]),

        const SizedBox(height: 13),
        if (wide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _DashboardActivity(resumeName: resumeName, hasAnalysis: aiData != null)),
            const SizedBox(width: 13),
            Expanded(child: _DashboardQuickActions(onUpload: onUpload, onAnalysis: onAnalysis, onRoadmap: onRoadmap, onCourses: onCourses, onProjects: onProjects)),
            const SizedBox(width: 13),
            SizedBox(width: 255, child: _DashboardInsights(career: career, readiness: readiness, gaps: gaps)),
          ])
        else ...[
          _DashboardActivity(resumeName: resumeName, hasAnalysis: aiData != null),
          const SizedBox(height: 13),
          _DashboardQuickActions(onUpload: onUpload, onAnalysis: onAnalysis, onRoadmap: onRoadmap, onCourses: onCourses, onProjects: onProjects),
          const SizedBox(height: 13),
          _DashboardInsights(career: career, readiness: readiness, gaps: gaps),
        ],

        const SizedBox(height: 13),
        Panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.track_changes_rounded, color: kPurple, size: 19), SizedBox(width: 8), Text('Career Goal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900))]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: career,
                isExpanded: true,
                dropdownColor: kPanel2,
                style: const TextStyle(color: kWhite, fontSize: 11),
                decoration: InputDecoration(
                  labelText: 'Target career',
                  labelStyle: const TextStyle(color: kSoft, fontSize: 10),
                  filled: true,
                  fillColor: const Color(0xFF07102A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kLine)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kLine)),
                ),
                items: careers.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onCareerChanged,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isAnalyzing ? null : onAnalyze,
                icon: isAnalyzing ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.auto_awesome_rounded, size: 17),
                label: Text(isAnalyzing ? 'Analyzing...' : 'Analyze Resume'),
                style: ElevatedButton.styleFrom(backgroundColor: kPurple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Icon(resumeName == null ? Icons.upload_file_outlined : Icons.check_circle_rounded, color: resumeName == null ? kSoft : kGreen, size: 15),
            const SizedBox(width: 6),
            Expanded(child: Text(resumeName == null ? resumeStatus : '$resumeName • $resumeStatus', style: const TextStyle(fontSize: 9.5, color: kSoft))),
            TextButton.icon(onPressed: onUpload, icon: const Icon(Icons.upload_rounded, size: 15), label: const Text('Upload Resume', style: TextStyle(fontSize: 9.5))),
          ]),
        ])),
      ]),
    );
  }
}

class _DashboardJourney extends StatelessWidget {
  final String? career;
  final int readiness;
  final int current;
  final int gaps;
  final VoidCallback onAnalysis;
  final VoidCallback onRoadmap;

  const _DashboardJourney({
    required this.career,
    required this.readiness,
    required this.current,
    required this.gaps,
    required this.onAnalysis,
    required this.onRoadmap,
  });

  @override
  Widget build(BuildContext context) => Panel(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Your Career Journey', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
            const Spacer(),
            GlowChip(career ?? 'Target career', kBlue),
          ]),
          const SizedBox(height: 15),
          LayoutBuilder(builder: (context, c) {
            final compact = c.maxWidth < 570;
            final nodes = [
              _JourneyStep(icon: Icons.description_rounded, title: 'Current Skills', subtitle: current > 0 ? '$current skills analyzed' : 'Upload resume', color: kCyan, onTap: onAnalysis),
              _JourneyStep(icon: Icons.auto_awesome_rounded, title: 'Gap Analysis', subtitle: gaps > 0 ? '$gaps gaps identified' : 'Run AI analysis', color: kOrange, onTap: onAnalysis),
              _JourneyStep(icon: Icons.school_rounded, title: 'Learning Path', subtitle: 'Personalized', color: kPurple, onTap: onRoadmap),
              _JourneyStep(icon: Icons.flag_rounded, title: 'Target Role', subtitle: career ?? 'Not selected', color: kPink, onTap: onRoadmap),
            ];
            return compact
                ? Column(children: nodes.map((n) => Padding(padding: const EdgeInsets.only(bottom: 8), child: n)).toList())
                : Row(children: [
                    for (int i = 0; i < nodes.length; i++) ...[
                      Expanded(child: nodes[i]),
                      if (i < nodes.length - 1)
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Icon(Icons.arrow_forward_rounded, size: 15, color: kSoft)),
                    ]
                  ]);
          }),
          const SizedBox(height: 13),
          Row(children: [
            const Icon(Icons.bolt_rounded, color: kGreen, size: 15),
            const SizedBox(width: 5),
            Text('$readiness% career readiness', style: const TextStyle(fontSize: 9.5, color: kSoft)),
            const Spacer(),
            TextButton(onPressed: onAnalysis, child: const Text('View analysis', style: TextStyle(fontSize: 9.5, color: kBlue))),
          ]),
        ]),
      );
}

class _JourneyStep extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;

  const _JourneyStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(.055), borderRadius: BorderRadius.circular(11), border: Border.all(color: color.withOpacity(.28))),
          child: Row(children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: color, size: 15)),
            const SizedBox(width: 7),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: kWhite)),
                const SizedBox(height: 2),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 7.5, color: kSoft)),
              ]),
            ),
          ]),
        ),
      );
}

class _DashboardReadiness extends StatelessWidget {
  final int readiness;
  final String? career;

  const _DashboardReadiness({required this.readiness, required this.career});

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Career Readiness', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 118,
            height: 118,
            child: Stack(alignment: Alignment.center, children: [
              CircularProgressIndicator(value: readiness.clamp(0, 100) / 100, strokeWidth: 10, color: kCyan, backgroundColor: kLine),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$readiness%', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
                const Text('READY', style: TextStyle(fontSize: 7, letterSpacing: 1.2, color: kSoft, fontWeight: FontWeight.w800)),
              ]),
            ]),
          ),
        ),
        const SizedBox(height: 10),
        Center(child: Text(career ?? 'Choose your target career', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: kSoft, fontWeight: FontWeight.w700))),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: kGreen.withOpacity(.07), borderRadius: BorderRadius.circular(9), border: Border.all(color: kGreen.withOpacity(.16))),
          child: const Row(children: [
            Icon(Icons.lightbulb_outline_rounded, color: kGreen, size: 15),
            SizedBox(width: 6),
            Expanded(child: Text('Keep learning and building portfolio evidence.', style: TextStyle(fontSize: 8.5, color: kSoft, height: 1.35))),
          ]),
        ),
      ]),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  final IconData icon;
  final String value, label, change;
  final Color color;

  const _DashboardStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(12), border: Border.all(color: kLine)),
        child: Row(children: [
          Container(width: 31, height: 31, decoration: BoxDecoration(color: color.withOpacity(.1), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: color, size: 16)),
          const SizedBox(width: 9),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: kWhite)),
              Text(label, style: const TextStyle(fontSize: 8, color: kSoft)),
              const SizedBox(height: 2),
              Text(change, style: TextStyle(fontSize: 7.5, color: color, fontWeight: FontWeight.w800)),
            ]),
          ),
        ]),
      );
}

class _DashboardActivity extends StatelessWidget {
  final String? resumeName;
  final bool hasAnalysis;

  const _DashboardActivity({required this.resumeName, required this.hasAnalysis});

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Recent Activity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 11),
          _ActivityRow(icon: Icons.description_rounded, title: resumeName == null ? 'Upload your resume' : 'Resume uploaded', subtitle: resumeName ?? 'Start your AI career journey', color: kBlue),
          const SizedBox(height: 8),
          _ActivityRow(icon: Icons.auto_awesome_rounded, title: hasAnalysis ? 'Career analysis updated' : 'AI analysis pending', subtitle: hasAnalysis ? 'Skills and gaps are ready' : 'Run analysis after selecting a career', color: kPurple),
          const SizedBox(height: 8),
          const _ActivityRow(icon: Icons.route_rounded, title: 'Learning path', subtitle: 'Build skills through roadmap tasks', color: kGreen),
        ]),
      );
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;

  const _ActivityRow({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(color: const Color(0xFF07102A), borderRadius: BorderRadius.circular(9), border: Border.all(color: kLine)),
        child: Row(children: [
          Container(width: 29, height: 29, decoration: BoxDecoration(color: color.withOpacity(.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 14, color: color)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 7.5, color: kSoft)),
            ]),
          ),
        ]),
      );
}

class _DashboardQuickActions extends StatelessWidget {
  final VoidCallback onUpload, onAnalysis, onRoadmap, onCourses, onProjects;

  const _DashboardQuickActions({
    required this.onUpload,
    required this.onAnalysis,
    required this.onRoadmap,
    required this.onCourses,
    required this.onProjects,
  });

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 11),
          Wrap(spacing: 7, runSpacing: 7, children: [
            _QuickAction(icon: Icons.upload_file_rounded, title: 'Upload Resume', color: kBlue, onTap: onUpload),
            _QuickAction(icon: Icons.analytics_rounded, title: 'View Analysis', color: kPurple, onTap: onAnalysis),
            _QuickAction(icon: Icons.route_rounded, title: 'View Roadmap', color: kCyan, onTap: onRoadmap),
            _QuickAction(icon: Icons.school_rounded, title: 'Explore Courses', color: kOrange, onTap: onCourses),
            _QuickAction(icon: Icons.code_rounded, title: 'Find Projects', color: kPink, onTap: onProjects),
          ]),
        ]),
      );
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 108,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: color.withOpacity(.055), borderRadius: BorderRadius.circular(9), border: Border.all(color: color.withOpacity(.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 7),
            Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: kWhite)),
          ]),
        ),
      );
}

class _DashboardInsights extends StatelessWidget {
  final String? career;
  final int readiness;
  final List<dynamic> gaps;

  const _DashboardInsights({required this.career, required this.readiness, required this.gaps});

  @override
  Widget build(BuildContext context) {
    final focus = gaps.isNotEmpty ? (gaps.first is Map ? gaps.first['skill']?.toString() : gaps.first.toString()) : 'Upload your resume';
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.auto_awesome_rounded, color: kCyan, size: 16), SizedBox(width: 6), Text('AI Insights', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900))]),
        const SizedBox(height: 10),
        Text(career == null ? 'Start your career analysis' : 'Your strongest next step', style: const TextStyle(fontSize: 9, color: kSoft)),
        const SizedBox(height: 4),
        Text(career == null ? 'Upload a resume and choose a target role.' : 'Focus on $focus to strengthen your $career readiness.', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, height: 1.35)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _InsightMini(title: 'Readiness', value: '$readiness%', color: kCyan)),
          const SizedBox(width: 7),
          Expanded(child: _InsightMini(title: 'Top Gap', value: focus ?? 'None', color: kOrange)),
        ]),
      ]),
    );
  }
}

class _InsightMini extends StatelessWidget {
  final String title, value;
  final Color color;

  const _InsightMini({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(.06), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(.17))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(title, style: const TextStyle(fontSize: 7, color: kSoft)),
        ]),
      );
}
