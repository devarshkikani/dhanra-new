import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const AppAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading,
      title: showLogo
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset(
                //   'assets/images/d_logo.png',
                //   height: 28,
                //   errorBuilder: (_, __, ___) => const Icon(
                //     Icons.account_balance_wallet_rounded,
                //     color: AppColors.primary,
                //   ),
                // ),
                // const SizedBox(width: 8),
                Image.asset(
                  'assets/images/dhanra.png',
                  height: 20,
                  errorBuilder: (_, __, ___) => const Text(
                    'Dhanra',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            )
          : (title != null
              ? Text(
                  title!,
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
