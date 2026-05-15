import '../../../../core/helpers/all_getter.dart';
import '../../../../core/network/http_service.dart';
import '../../../../core/response_wrapper/data_response.dart';
import '../models/preferance_model.dart';

abstract class HomeDataSource {
  Future<ResponseWrapper?> getPreferences();
}
class HomeDataSourceImpl extends HomeDataSource{

  @override
  Future<ResponseWrapper<PreferencesModel>?> getPreferences() async{
    try {
      final dataResponse = await Getters.getHttpService.request<PreferencesModel>(
        url: ApiConstants.preferences,
        requestType: RequestType.get,
        fromJson: (json) => PreferencesModel.fromJson(json),
      );
      if (dataResponse.status==true) {

        return getSuccessResponseWrapper(dataResponse);
      } else {
        return getFailedResponseWrapper(dataResponse.message, response:dataResponse.data);
      }
    } catch (e) {
      return getFailedResponseWrapper(exceptionHandler(
        e: e,
        functionName: "userLogin",
      ));
    }
  }
}