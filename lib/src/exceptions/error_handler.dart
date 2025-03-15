import 'dart:io';
import 'dart:ui';

import 'package:carbu_track/src/exceptions/error_logger.dart';
import 'package:carbu_track/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/constants/app_spacing.dart';

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Builder(builder: (ctx) {
          return Center(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  )),
              height: MediaQuery.of(ctx).size.height / 2,
              margin: screenPadding,
              padding: screenPadding,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    details.toString(),
                    maxLines: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            String email = "feyroozecode@gmail.com";
                            // send email to feyroozecode
                            launchUrl(Uri.parse(
                                'mailto:$email?subject=Erreur de l\ application, CarbuTrack &body=${details.toString()}'));
                            Navigator.pushNamedAndRemoveUntil(
                                ctx, '/', (_) => false);
                          },
                          child: const Text(
                              "Cliquer ici pour signaler l'erreur  ")),
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: ctx,
                                builder: (ctx) {
                                  return const Column(
                                    children: [
                                      Text("Leaving the app..."),
                                      CircularProgressIndicator(),
                                    ],
                                  );
                                });
                            Future.delayed(const Duration(seconds: 3), () {
                              // restart the app here
                              Navigator.pushNamedAndRemoveUntil(
                                  ctx, '/', (_) => false);
                            });
                          },
                          child: const Text("Relancer"))
                    ],
                  )
                ],
              )),
            ),
          );
        }));
  };
}
