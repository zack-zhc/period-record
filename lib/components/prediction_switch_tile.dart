import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:period_record/period_provider.dart';

class PredictionSwitchTile extends StatelessWidget {
  const PredictionSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PeriodProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.loadShowPredictionPreference(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // 加载中时显示占位
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(height: 24, child: LinearProgressIndicator()),
          );
        }
        return Consumer<PeriodProvider>(
          builder:
              (context, provider, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '显示生理期预测',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Switch(
                      value: provider.showPrediction,
                      onChanged:
                          (v) async => await provider.setShowPrediction(v),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }
}
