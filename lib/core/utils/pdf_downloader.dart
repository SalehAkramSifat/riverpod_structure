import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_structure/core/extensions/build_context_extensions.dart';
import 'package:riverpod_structure/core/logging/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfDownloader {
  PdfDownloader._();

  static Future<File?> downloadPdf(
    String url, {
    String? title,
    BuildContext? context,
  }) async {
    if (url.trim().isEmpty) {
      if (context != null && context.mounted) {
        context.showSnackBar('Invalid PDF URL', isError: true);
      }
      return null;
    }

    if (kIsWeb) {
      return await _openExternal(url, context: context);
    }

    try {
      final cleanTitle = (title ?? 'document')
          .replaceAll(RegExp(r'[^\w\s\.-]'), '_')
          .trim();
      final fileName = cleanTitle.endsWith('.pdf')
          ? cleanTitle
          : '$cleanTitle.pdf';

      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      } else if (Platform.isIOS || Platform.isMacOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$fileName';
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      await dio.download(url, filePath);
      final file = File(filePath);

      if (context != null && context.mounted) {
        context.showSnackBar('PDF downloaded successfully: $fileName');
      }
      return file;
    } catch (e) {
      AppLogger.error('Failed to download PDF: $e');
      if (context != null && context.mounted) {
        return await _openExternal(url, context: context);
      }
      return null;
    }
  }

  static Future<File?> _openExternal(
    String url, {
    BuildContext? context,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (context != null && context.mounted) {
        context.showSnackBar('Opening PDF download in browser...');
      }
    } else if (context != null && context.mounted) {
      context.showSnackBar('Could not download or open PDF', isError: true);
    }
    return null;
  }
}
