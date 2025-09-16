import 'package:book_finder/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final int itemCount;
  const ShimmerList({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerStyle = theme.extension<AppShimmerStyle>()!;

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        child: Shimmer.fromColors(
          baseColor: shimmerStyle.baseColor,
          highlightColor: shimmerStyle.highlightColor,
          period: shimmerStyle.period,
          child: Row(
            children: [
              Container(
                width: 64, // Aligned with theme.md thumbnail size
                height: 96, // Aligned with theme.md thumbnail size
                color: shimmerStyle.baseColor, // Use shimmer base color
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: double.infinity,
                      color: shimmerStyle.baseColor, // Use shimmer base color
                    ),
                    const SizedBox(height: AppTheme.spaceSm),
                    Container(
                      height: 12,
                      width: 100,
                      color: shimmerStyle.baseColor, // Use shimmer base color
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
