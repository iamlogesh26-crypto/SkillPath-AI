import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PageHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  const PageHeading({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kWhite)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: kSoft, fontSize: 13, height: 1.5)),
        ],
      );
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Panel({super.key, required this.child, this.padding = const EdgeInsets.all(18)});

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: kPanel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kLine),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.18), blurRadius: 24, offset: const Offset(0, 12))
          ],
        ),
        child: child,
      );
}

class GlowChip extends StatelessWidget {
  final String text;
  final Color color;
  const GlowChip(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(.13),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(.42)),
        ),
        child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
      );
}

class ActionPanel extends StatelessWidget {
  final String title, text, button;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionPanel({
    super.key,
    required this.title,
    required this.text,
    required this.button,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
            ]),
            const SizedBox(height: 9),
            Text(text, style: const TextStyle(color: kSoft, fontSize: 10.5, height: 1.4)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color.withOpacity(.45)),
                  foregroundColor: color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                ),
                child: Text(button),
              ),
            ),
          ],
        ),
      );
}
