import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;
  final Color? color;

  const SettingsCard({
    super.key,
    required this.title,
    required this.children,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (color ?? Theme.of(context).colorScheme.primary)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: color ?? Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color ?? Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
