import 'package:flutter/material.dart';
import 'package:period_record/theme/app_colors.dart';

/// A reusable single setting group used in settings pages.
class SingleSettingGroup extends StatelessWidget {
  const SingleSettingGroup({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final Widget child;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Card(
          elevation: 1,
          shadowColor: Theme.of(context).colorScheme.shadow,
          surfaceTintColor: AppColors.of(context).onSurface,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(children: [child]),
        ),

        if (subtitle != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
