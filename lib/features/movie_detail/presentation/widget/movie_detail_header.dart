import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';
import 'package:riverpod_structure/core/utils/app_urls.dart';
import 'package:riverpod_structure/core/utils/app_dimens.dart';
import 'package:riverpod_structure/features/movie_detail/data/models/movie_detail.dart';

class MovieDetailHeader extends StatelessWidget {
  final MovieDetail movieDetail;

  const MovieDetailHeader({super.key, required this.movieDetail});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: AppDimens.movieDetailBackdropHeight,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios, color: AppColors.primaryLight),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // context.router
          },
          icon: const Icon(Icons.more_horiz),
          color: AppColors.primaryLight,
        ),
      ],
      stretch: true,
      pinned: false,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: CachedNetworkImage(
          imageUrl: AppUrls.movieBackdrop(movieDetail.backdropPath),
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
