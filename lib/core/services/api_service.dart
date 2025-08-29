import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/network_response.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiService {
  Dio dio;

  ApiService._internal() : dio = Dio();

  static final ApiService _singleton = ApiService._internal();

  factory ApiService() => _singleton;

  final String baseUrl = ApiRoutes.apiUrl;
  final Map<String, String> headers = {
    // 'Content-type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer token',
  };

  Future<void> init() async {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: const Duration(milliseconds: 300000),
      connectTimeout: const Duration(milliseconds: 300000),
      sendTimeout: const Duration(milliseconds: 300000),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          //  var token =  AppPreferences().getToken();
          //  Logger().e("Token = $token");
          // if(token != null){
          //    options.headers['Authorization'] = 'Token $token';
          // }
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<NetworkResponse> apiCall({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    String? params,
    required RequestType requestType,
    String? baseUrl,
  }) async {
    late Response result;

    String url = (baseUrl ?? ApiRoutes.apiUrl) + endPoint;
    if (params != null && params.isNotEmpty) {
      url += params;
    }

    try {
      Options options = Options(headers: headers);
      // if (!await sl<NetworkInfo>().isConnected) {
      //   return NetworkResponse.error(noInternetMessage);
      // }
      switch (requestType) {
        case RequestType.get:
          result = await dio.get(url,
              queryParameters: queryParameters, options: options);
          break;
        case RequestType.post:
          result = await dio.post(url, data: body, options: options);
          break;
        case RequestType.delete:
          result =
              await dio.delete(url, data: body, queryParameters: queryParameters, options: options);
          break;
        case RequestType.put:
          result = await dio.put(url, data: body, queryParameters: queryParameters, options: options);
          break;
        case RequestType.patch:
          result =
              await dio.patch(url, data: body, queryParameters: queryParameters, options: options);
          break;
      }

      switch (result.statusCode) {
        case 200:
          return NetworkResponse.success(result.data);
        case 201:
          return NetworkResponse.success(result.data);  
        case 204:
          return NetworkResponse.success(null);
      
      }
      return NetworkResponse.error(errorMessage);
    } on DioException catch (e, stackTrace) {
      Logger().e("DioException is HereR: $e", stackTrace: stackTrace);

      switch (e.response?.statusCode) {
      
        case 403:
          return NetworkResponse.error(e.response?.data['message']);
        case 401:
          return NetworkResponse.error(e.response?.data['message']);
        case 431:
          return NetworkResponse.error("Reconnecting");
        case 404:
          return NetworkResponse.error(e.response?.data['message']);
          
        case 400:
          Logger().e(e.response?.data['message']);
          return NetworkResponse.error(e.response?.data['message']);
        case 500:
          // Logger().e(e.response?.data['message']);
          return NetworkResponse.error( e.response?.data['message'] ?? errorMessage);
        
      }
    
      Logger().e(e, stackTrace: stackTrace);
//  Sentry.captureException(e, stackTrace: stackTrace);
      return NetworkResponse.error(errorMessage);
    } catch (e, stackTrace) {
     
Logger().e(e, stackTrace: stackTrace);
      return NetworkResponse.error(errorMessage);
    }
  }
}
