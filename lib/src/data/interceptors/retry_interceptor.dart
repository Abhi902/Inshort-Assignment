import 'package:dio/dio.dart';
import 'dart:developer';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  int maxRetries = 3;
  Duration retryDelay = const Duration(seconds: 2);

  RetryInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log('🔄 Retry attempt for: ${err.requestOptions.uri}');

    if (_shouldRetry(err) &&
        err.requestOptions.extra['retry_count'] < maxRetries) {
      final retryCount = (err.requestOptions.extra['retry_count'] ?? 0) + 1;

      log('🔄 Retrying ${retryCount}/$maxRetries after ${retryDelay.inSeconds}s...');

      await Future.delayed(retryDelay);

      try {
        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            extra: {
              ...err.requestOptions.extra,
              'retry_count': retryCount,
            },
          ),
        );
        handler.resolve(response);
      } catch (retryError) {
        log('❌ Retry $retryCount failed: $retryError');
        if (retryCount >= maxRetries) {
          handler.next(err);
        }
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.message?.contains('Connection reset') == true ||
        err.response?.statusCode == 429; // Rate limit
  }
}
