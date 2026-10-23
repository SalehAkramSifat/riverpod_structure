import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_structure/core/utils/app_urls.dart';
import 'package:riverpod_structure/core/utils/app_dimens.dart';

import 'package:riverpod_structure/features/home/data/models/movie.dart';

import 'package:riverpod_structure/core/common/rating_bar.dart';

class NowShowingMovieCard extends StatelessWidget {
  final Movie movie;

  const NowShowingMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.nowShowingCardWidth,
      child: Padding(
        padding: EdgeInsets.only(left: AppDimens.p6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.sp,
                ), // Adjust the radius as needed
              ),
              elevation: 8.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.sp),
                child: CachedNetworkImage(
                  imageUrl: AppUrls.moviePoster(movie.posterPath),
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                  width: AppDimens.nowShowingPosterWidth,
                  height: AppDimens.nowShowingPosterHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: AppDimens.p6, left: AppDimens.p8),
              child: Text(
                movie.title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: AppDimens.p2, left: AppDimens.p8),
              child: RatingBar(rating: movie.voteAverage),
            ),
          ],
        ),
      ),
    );
  }
}
