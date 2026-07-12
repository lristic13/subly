import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Subscription categories with associated icons and colors
enum SubscriptionCategory {
  streaming,
  music,
  gaming,
  software,
  cloud,
  news,
  fitness,
  food,
  education,
  finance,
  shopping,
  productivity,
  social,
  vpn,
  other;

  /// Display name for the category
  String get displayName => switch (this) {
        streaming => 'Streaming',
        music => 'Music',
        gaming => 'Gaming',
        software => 'Software',
        cloud => 'Cloud Storage',
        news => 'News & Media',
        fitness => 'Fitness & Health',
        food => 'Food & Delivery',
        education => 'Education',
        finance => 'Finance',
        shopping => 'Shopping',
        productivity => 'Productivity',
        social => 'Social',
        vpn => 'VPN & Security',
        other => 'Other',
      };

  /// Icon for the category
  IconData get icon => switch (this) {
        streaming => Icons.movie_outlined,
        music => Icons.music_note_outlined,
        gaming => Icons.sports_esports_outlined,
        software => Icons.code_outlined,
        cloud => Icons.cloud_outlined,
        news => Icons.article_outlined,
        fitness => Icons.fitness_center_outlined,
        food => Icons.restaurant_outlined,
        education => Icons.school_outlined,
        finance => Icons.account_balance_outlined,
        shopping => Icons.shopping_bag_outlined,
        productivity => Icons.task_alt_outlined,
        social => Icons.people_outlined,
        vpn => Icons.vpn_key_outlined,
        other => Icons.more_horiz_outlined,
      };

  /// Color associated with the category (for charts and icons)
  Color get color => switch (this) {
        streaming => AppColors.categoryStreaming,
        music => AppColors.categoryMusic,
        gaming => AppColors.categoryGaming,
        software => AppColors.categorySoftware,
        cloud => AppColors.categoryCloud,
        news => AppColors.categoryNews,
        fitness => AppColors.categoryFitness,
        food => AppColors.categoryFood,
        education => AppColors.categoryEducation,
        finance => AppColors.categoryFinance,
        shopping => AppColors.categoryShopping,
        productivity => AppColors.categoryProductivity,
        social => AppColors.categorySocial,
        vpn => AppColors.categoryVpn,
        other => AppColors.categoryOther,
      };
}
