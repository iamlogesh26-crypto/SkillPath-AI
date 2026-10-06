import '../../models/project_recommendation.dart';

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
