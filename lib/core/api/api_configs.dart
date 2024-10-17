import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';

import '../../utils/shared_pref.dart';



class ApiProvider {
  Dio dio = Dio();

  ApiProvider() {
    dio = Dio();

    // Add interceptor to handle 401 Unauthorized errors globally
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response != null && error.response!.statusCode == 401) {
          // Clear token and navigate to login
          await clearSavedObject('token');
          await clearSavedObject('type');
          await clearSavedObject('phc');
          // Get.offAll(() => login());
        }
        handler.next(error); // Continue processing the error
      },
    ));
  }


  Future<Response<dynamic>> get(String url,
      {Map<String, dynamic>? queryParams, String? token}) async {
    try {
      print("api url ===========> $url");

      // Set authorization header if token is provided
      dio.options.headers["Authorization"] = "Bearer $token";

      return await dio.get(
        url,
        queryParameters: queryParams,
      );
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<Response<dynamic>> post(String url, dynamic data,
      {String? token}) async {
    try {
      print("api url ===========> $url");

      // Set authorization header if token is provided
      dio.options.headers["Authorization"] = "Bearer $token";

      return await dio.post(url, data: data);
    } on DioException catch (error) {
      throw handleError(error);
    }
  }

  Future<Response<dynamic>> put(String url, dynamic data,
      {Map<String, dynamic>? headers, String? token}) async {
    try {
      print("api url ===========> $url");

      // Set authorization header if token is provided
      dio.options.headers["Authorization"] = "Bearer $token";

      return await dio.put(url, data: data, options: Options(headers: headers));
    } on DioException catch (error) {
      throw handleError(error);
    }
  }




// Common error handler
dynamic handleError(DioException error) {
  String errorDescription = "";
  
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    errorDescription = "Connection timeout. Please try again later.";
  } else if (error.type == DioExceptionType.badResponse) {
    // Handle specific status codes
    if (error.response != null) {
      switch (error.response!.statusCode) {
        case 400:
          errorDescription = "Bad request. Please check your input.";
          break;
        case 401:
          errorDescription = "Unauthorized. Please check your credentials.";
          break;
        case 403:
          errorDescription = "Forbidden. You do not have permission to access this resource.";
          break;
        case 404:
          errorDescription = "Resource not found.";
          break;
        case 408:
          errorDescription = "Request timeout. Please try again.";
          break;
        case 429:
          errorDescription = "Too many requests. Please slow down and try again later.";
          break;
        case 500:
          errorDescription = "Internal server error. Please try again later.";
          break;
        case 502:
          errorDescription = "Bad gateway. There is an issue with the server.";
          break;
        case 503:
          errorDescription = "Service unavailable. The server is temporarily down.";
          break;
        case 504:
          errorDescription = "Gateway timeout. Please try again later.";
          break;
        default:
          errorDescription = "Something went wrong. Please try again.";
      }
    }
  } else if (error.type == DioExceptionType.cancel) {
    errorDescription = "Request to the server was cancelled.";
  } else {
    errorDescription = "Unexpected error occurred.";
  }

  // Log error for debugging
  print("Dio error: $errorDescription");
  return errorDescription;
}

}
