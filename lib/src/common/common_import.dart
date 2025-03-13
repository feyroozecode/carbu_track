import 'common_import.dart';

export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/foundation.dart';

// State Management here
// ... getx, river.., providers

// Network and API
export 'package:cached_network_image/cached_network_image.dart';

// Constants and Theme
import 'constants/app_size.dart';
import 'constants/app_colors.dart';

// Utilities

// Common Widgets

// Extensions
extension ContextExtension on BuildContext {
  // Theme extensions
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // context to ctx
  BuildContext get ctx => this;

  // Media Query extensions
  MediaQueryData get mq => MediaQuery.of(this);
  double get screenHeight => mq.size.height;
  double get screenWidth => mq.size.width;

  // Padding and spacing
  double get defaultSpacing => AppSizes.s16;
  EdgeInsets get defaultPadding => const EdgeInsets.all(AppSizes.s16);

  // Navigation helpers
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
        MaterialPageRoute(builder: (context) => page),
      );
  Future<T?> pushNamed<T>(String route, {Object? arguments}) =>
      Navigator.of(this).pushNamed<T>(route, arguments: arguments);

  // Snackbar helper
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSizes.s16),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s16,
          vertical: AppSizes.s12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.s8),
        ),
      ),
    );
  }
}

// Common type definitions
typedef JSON = Map<String, dynamic>;
typedef QueryParams = Map<String, String>;
typedef HeaderParams = Map<String, String>;

// Common constants
const kDefaultAnimationDuration = Duration(milliseconds: 300);

// Common styles
const kHeadlineStyle = TextStyle(
  fontSize: AppSizes.s24,
  fontWeight: FontWeight.bold,
  color: AppColors.textPrimary,
);

const kTitleStyle = TextStyle(
  fontSize: AppSizes.s18,
  fontWeight: FontWeight.w600,
  color: AppColors.textPrimary,
);

const kSubtitleStyle = TextStyle(
  fontSize: AppSizes.s16,
  fontWeight: FontWeight.w500,
  color: AppColors.textSecondary,
);

const kBodyStyle = TextStyle(
  fontSize: AppSizes.s14,
  color: AppColors.textPrimary,
);

const kBodyStyleBold = TextStyle(
  fontSize: AppSizes.s14,
  fontWeight: FontWeight.bold,
  color: AppColors.textPrimary,
);

const kCaptionStyle = TextStyle(
  fontSize: AppSizes.s12,
  color: AppColors.textSecondary,
);

// Common decorations
final kDefaultInputDecoration = InputDecoration(
  filled: true,
  fillColor: AppColors.surface,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSizes.s8),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSizes.s8),
    borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSizes.s8),
    borderSide: const BorderSide(color: AppColors.primary, width: 2),
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: AppSizes.s16,
    vertical: AppSizes.s12,
  ),
);

// Common button styles
final kDefaultButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppColors.primary,
  foregroundColor: AppColors.textPrimary,
  padding: const EdgeInsets.symmetric(
    horizontal: AppSizes.s24,
    vertical: AppSizes.s12,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSizes.s8),
  ),
);

final kSecondaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppColors.surface,
  foregroundColor: AppColors.textPrimary,
  padding: const EdgeInsets.symmetric(
    horizontal: AppSizes.s24,
    vertical: AppSizes.s12,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSizes.s8),
    side: BorderSide(color: AppColors.primary, width: 1),
  ),
);
