import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  Responsive(this.context);

  bool get isTablet => MediaQuery.of(context).size.width > 600;
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  // Font Sizes
  double get fontSmall => isTablet ? 20 : 12;
  double get fontM => isTablet ? 20 : 14;

  double get fontBase => isTablet ? 25 : 16;
  double get fontLarge => isTablet ? 28 : 20;
  double get fontXL => isTablet ? 32 : 24;

  // Padding / Spacing
  double get paddingHorizontal => isTablet ? 64 : 32;
  double get appbarHorizontal => isTablet ? 80 : 32;
  double get sectionSpacing => isTablet ? 24 : 16;
  double get itemSpacing => isTablet ? 20 : 10;
  double get cardSpacing => isTablet ? 24 : 12;
  double get checkSpacing => isTablet ? 24 : 5;

  // Sizes
  double get imageSize => isTablet ? 70 : 50;
  double get iconSize => isTablet ? 45 : 32;
  double get cardWidth => isTablet ? 240 : screenWidth * 0.4;
  double get buttonHeight => isTablet ? 56 : 48;
  double get modifyButton => isTablet ? 56 : 30;

  // Layout Decisions
  bool get isWide => screenWidth >= 800;
  bool get isNarrow => screenWidth < 350;

  double get imageReportSize =>
      (screenWidth - (paddingHorizontal * 2) - (itemSpacing * 2)) / 3;
}
