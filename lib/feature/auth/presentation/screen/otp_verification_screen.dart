import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:practice_riverpod/core/common/app_snackbar.dart';
import 'package:practice_riverpod/core/common/custom_appbar.dart';
import 'package:practice_riverpod/core/common/custom_button.dart';
import 'package:practice_riverpod/core/common/custom_text.dart';
import 'package:practice_riverpod/core/logging/logger.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';
import 'package:practice_riverpod/feature/auth/controller/verification/otp_verification_controller.dart';
import 'package:practice_riverpod/routes/app_router.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String? email;
  final bool? isFromRegister;

  const OtpVerificationScreen({super.key, this.email, this.isFromRegister});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    otpController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(otpVerificationProvider, (previous, next) {
      if (next.isSuccess == true) {
        if (widget.isFromRegister == true) {
          AppSnackBar.showSuccess("Your account create is successfull. ");
          AppLogger.info("Now you can go to home");
        } else {
          AppSnackBar.showSuccess("Now you can reset your password.");
          context.push(AppRoute.resetPasswordScreen);
        }
      } else if (next.errorMessage?.isNotEmpty ?? false) {
        AppSnackBar.showError("${next.errorMessage}");
      }
    });

    final otpState = ref.watch(otpVerificationProvider);
    final otpVerificationController = ref.read(
      otpVerificationProvider.notifier,
    );
    final defaultPinTheme = PinTheme(
      width: 46.w,
      height: 52.h,
      textStyle: GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.textFormFieldBorder, width: 1.2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 1.8),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.error, width: 1.2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Header Banner Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/thumbnails/060/199/333/small/minimalist-abstract-3d-curve-in-glowing-green-tone-on-dark-background-elegant-and-modern-visual-for-tech-presentations-ai-projects-website-headers-and-futuristic-graphic-design-templates-vector.jpg',
                    width: double.infinity,
                    height: 120.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.mark_email_read_outlined,
                        size: 48.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // Title and Subtitle
              CustomText(
                text: 'OTP Verification',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: widget.email != null && widget.email!.isNotEmpty
                    ? 'Enter the 6-digit verification code sent to\n${widget.email}'
                    : 'Enter the 6-digit verification code sent to your email address.',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.4,
              ),

              SizedBox(height: 32.h),

              // OTP Pin Input Field
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: Pinput(
                    length: 6,
                    controller: otpController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    errorPinTheme: errorPinTheme,
                    separatorBuilder: (index) => SizedBox(width: 8.w),
                    mainAxisAlignment: MainAxisAlignment.center,
                    keyboardType: TextInputType.number,
                    showCursor: true,
                    cursor: Container(
                      width: 2.w,
                      height: 20.h,
                      color: AppColors.primary,
                    ),
                    onCompleted: (pin) {
                      debugPrint('Completed OTP: $pin');
                    },
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Verify Button
              CustomButton(
                text: 'Verify Code',
                isLoading: otpState.isLoading ?? false,
                onTap: () {
                  final otp = otpController.text.trim();
                  if (otp.length < 6) {
                    AppSnackBar.showError('Please enter a 6-digit OTP code');
                    return;
                  }
                  otpVerificationController.verification(
                    email: widget.email ?? "",
                    otp: otp,
                  );
                },
              ),

              SizedBox(height: 32.h),

              // Resend Code Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    AppSnackBar.showSuccess(
                      'Verification code resent successfully.',
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: "Didn't receive code? "),
                        TextSpan(
                          text: 'Resend Code',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
