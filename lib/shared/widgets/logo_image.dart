import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

/// Logo.dev API token - user should provide their own free token
const String _logoDevToken = 'pk_PCdEMN6vRNKorlbUCwpWTQ';

/// Domains with dark logos that need inversion in dark mode
const _darkLogoDomains = {
  'github.com',
  'music.apple.com',
  'tv.apple.com',
  'openai.com',
  'ubisoft.com',
};

/// Widget that displays a service logo from Logo.dev with letter avatar fallback
class LogoImage extends StatelessWidget {
  const LogoImage({
    super.key,
    required this.name,
    this.domain,
    this.brandColor,
    this.size = 48,
    this.radius,
  });

  /// The name of the service (used for letter avatar fallback)
  final String name;

  /// The domain for Logo.dev lookup (e.g., 'netflix.com')
  final String? domain;

  /// Hex color for the letter avatar background
  final String? brandColor;

  /// Size of the logo (width and height)
  final double size;

  /// Corner radius; defaults to size / 4.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final needsInversion = isDark && _darkLogoDomains.contains(domain);

    if (domain != null && domain!.isNotEmpty) {
      final logoUrl =
          'https://img.logo.dev/$domain?token=$_logoDevToken&format=png&size=${size.toInt() * 2}';

      Widget logoWidget = ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? size / 4),
        child: CachedNetworkImage(
          imageUrl: logoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => _LetterAvatar(
            name: name,
            brandColor: brandColor,
            size: size,
            radius: radius,
          ),
          errorWidget: (context, url, error) => _LetterAvatar(
            name: name,
            brandColor: brandColor,
            size: size,
            radius: radius,
          ),
        ),
      );

      if (needsInversion) {
        logoWidget = ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            -1, 0, 0, 0, 255,
            0, -1, 0, 0, 255,
            0, 0, -1, 0, 255,
            0, 0, 0, 1, 0,
          ]),
          child: logoWidget,
        );
      }

      return logoWidget;
    }

    return _LetterAvatar(
      name: name,
      brandColor: brandColor,
      size: size,
      radius: radius,
    );
  }
}

class _LetterAvatar extends StatelessWidget {
  const _LetterAvatar({
    required this.name,
    this.brandColor,
    required this.size,
    this.radius,
  });

  final String name;
  final String? brandColor;
  final double size;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final bgColor = _parseColor(brandColor) ?? AppColors.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius ?? size / 4),
      ),
      child: Center(
        child: Text(
          letter,
          style: AppTypography.headlineMedium.copyWith(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;

    String colorStr = hex.replaceAll('#', '');
    if (colorStr.length == 6) {
      colorStr = 'FF$colorStr';
    }

    try {
      return Color(int.parse(colorStr, radix: 16));
    } catch (e) {
      return null;
    }
  }
}
