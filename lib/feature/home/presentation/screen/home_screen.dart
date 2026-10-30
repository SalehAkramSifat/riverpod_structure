import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_riverpod/core/common/app_snackbar.dart';
import 'package:practice_riverpod/core/common/custom_text.dart';
import 'package:practice_riverpod/core/common/custom_textformfield.dart';
import 'package:practice_riverpod/core/services/auth_service.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';
import 'package:practice_riverpod/feature/home/model/job_model.dart';
import 'package:practice_riverpod/feature/home/presentation/widget/job_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  // 🏷️ Category Filter List
  final List<String> categories = [
    'All',
    'Remote',
    'Full-time',
    'Technology',
    'Design',
    'Marketing',
  ];
  String selectedCategory = 'All';

  // 📦 Dummy Jobs List (Stateful for local UI testing)
  late List<JobModel> jobsList;

  @override
  void initState() {
    super.initState();
    // Parse dummy JSON to JobModel list
    jobsList = dummyJobsJson.map((e) => JobModel.fromJson(e)).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // 🔍 Filtered List getter based on Search & Category
  List<JobModel> get filteredJobs {
    final query = searchController.text.trim().toLowerCase();
    return jobsList.where((job) {
      final matchesQuery =
          query.isEmpty ||
          job.title.toLowerCase().contains(query) ||
          job.companyName.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'All' ||
          job.jobType.toLowerCase() == selectedCategory.toLowerCase() ||
          job.category.toLowerCase() == selectedCategory.toLowerCase();

      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            // Simulated pull-to-refresh
            await Future.delayed(const Duration(milliseconds: 800));
            setState(() {
              jobsList = dummyJobsJson
                  .map((e) => JobModel.fromJson(e))
                  .toList();
            });
            AppSnackBar.showSuccess('Job feed refreshed');
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // 1. Top Header (User Greeting & Actions)
                Row(
                  children: [
                    // User Avatar
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        'S',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Greeting
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Hello, Sifat 👋',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: 'Find your dream opportunity',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),

                    // Notification Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.textFormFieldBorder,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none_rounded),
                        color: AppColors.textPrimary,
                        onPressed: () {
                          AppSnackBar.showSuccess('No new notifications');
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Profile Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.textFormFieldBorder,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.person_outline_rounded),
                        color: AppColors.textPrimary,
                        onPressed: () {
                          // TODO: Navigate to Profile Screen
                          AppSnackBar.showSuccess('Navigating to Profile...');
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // 2. Search Field
                CustomTextFormField(
                  hintText: 'Search by job title, company...',
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: (val) {
                    setState(() {});
                  },
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 22.sp,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18.sp,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),

                SizedBox(height: 16.h),

                // 3. Category Filter Chips (Horizontal)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = cat;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textFormFieldBorder,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 20.h),

                // 4. Promotional Opportunity Banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6BAFB2), Color(0xFF4C8D90)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6BAFB2).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'PRO TIP',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Complete your resume',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Get 2x higher response from recruiters.',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.white,
                          size: 28.r,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // 5. Section Title & Results Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Recent Opportunities',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '${filteredJobs.length} available',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // 6. Job Cards List
                if (filteredJobs.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48.r,
                            color: AppColors.textTertiary,
                          ),
                          SizedBox(height: 12.h),
                          CustomText(
                            text: 'No matching opportunities found',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: 'Try adjusting your search or filters.',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return JobCard(
                        job: job,
                        onTap: () {
                          AppSnackBar.showSuccess('Selected: ${job.title}');
                        },
                        onBookmarkTap: () {
                          setState(() {
                            // Toggle bookmark locally
                            final originalIndex = jobsList.indexWhere(
                              (element) => element.id == job.id,
                            );
                            if (originalIndex != -1) {
                              jobsList[originalIndex] = jobsList[originalIndex]
                                  .copyWith(
                                    isBookmarked:
                                        !jobsList[originalIndex].isBookmarked,
                                  );
                            }
                          });
                        },
                      );
                    },
                  ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
