import 'package:flutter/material.dart';

enum ErrorType {
  network,
  server,
  notFound,
  unknown;

  String get message {
    switch (this) {
      case ErrorType.network:
        return ErrorMessages.noInternet;
      case ErrorType.server:
        return ErrorMessages.serverTimeout;
      case ErrorType.notFound:
        return ErrorMessages.noMoviesFound;
      case ErrorType.unknown:
        return ErrorMessages.generalError;
    }
  }

  IconData get icon {
    switch (this) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.server:
        return Icons.cloud_off;
      case ErrorType.notFound:
        return Icons.unpublished_sharp;
      case ErrorType.unknown:
        return Icons.error_outline;
    }
  }

  Color get color {
    switch (this) {
      case ErrorType.network:
        return Colors.red;
      case ErrorType.server:
        return Colors.orange;
      case ErrorType.notFound:
        return Colors.grey;
      case ErrorType.unknown:
        return Colors.red;
    }
  }
}

class ErrorMessages {
  static const String noInternet =
      'No internet connection. Please check your network settings.';
  static const String serverTimeout =
      'Server taking too long to respond. Please try again.';
  static const String noMoviesFound =
      'No movies found. Please try again later.';
  static const String generalError = 'Something went wrong. Please try again.';
}
