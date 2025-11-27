import 'package:dio/dio.dart';
import 'dart:developer';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('📡 REQUEST: ${options.method} ${options.uri}');
    log('🔍 Params: ${options.queryParameters}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('❌ ERROR: ${err.message}');
    log('📍 URL: ${err.requestOptions?.uri}');

    // Retry once after 2 seconds for connection reset
    if (err.type == DioExceptionType.connectionTimeout ||
        err.message?.contains('Connection reset') == true) {
      log('🔄 Retrying after 2s...');
      Future.delayed(const Duration(seconds: 2), () {
        handler.resolve(err.response ??
            Response(
              requestOptions: err.requestOptions,
              statusCode: 503,
            ));
      });
    } else {
      handler.next(err);
    }
  }
}
