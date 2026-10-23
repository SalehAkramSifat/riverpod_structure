import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';
import 'package:riverpod_structure/core/extensions/build_context_extensions.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String asset;
  final bool isSelected;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.title,
    required this.asset,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          dense: true,
          leading: SvgPicture.asset(
            asset,
            height: 20,
            width: 20,
            color: context.theme.primaryColor,
          ),
          title: Text(
            title,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: AppColors.ratingIconColor)
              : null,
        ),
      ),
    );
  }
}
