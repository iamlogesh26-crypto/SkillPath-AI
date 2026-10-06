import '../../models/course_recommendation.dart';

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
