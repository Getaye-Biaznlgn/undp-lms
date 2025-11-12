import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/constants/app_strings.dart';
import 'package:lms/core/services/api_service.dart';
import 'package:lms/core/services/network_response.dart';

abstract class MeetingDataSource {
  Future<NetworkResponse> getAllMeetings({int? page});
}

class MeetingDataSourceImpl implements MeetingDataSource {
  @override
  Future<NetworkResponse> getAllMeetings({int? page}) async {
    String endPoint = ApiRoutes.allMeetings;
    if (page != null) {
      endPoint = '$endPoint?page=$page';
    }
    return await ApiService().apiCall(
      endPoint: endPoint,
      requestType: RequestType.get,
    );
  }
}

