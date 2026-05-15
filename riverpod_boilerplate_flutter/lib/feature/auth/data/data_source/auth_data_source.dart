import '../../../../core/helpers/all_getter.dart';
import '../../../../core/network/http_service.dart';
import '../../../../core/response_wrapper/data_response.dart';
import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<ResponseWrapper?> logInUser({required Map<String,dynamic> body});
}
class AuthDataSourceImpl extends AuthDataSource{

  @override
  Future<ResponseWrapper<UserModel>?> logInUser({required Map<String,dynamic> body}) async{
    try {
      final dataResponse = await Getters.getHttpService.request<UserModel>(
        body: body,
        url: ApiConstants.login,
        fromJson: (json) => UserModel.fromJson(json),
      );
      if (dataResponse.status == true) {
          UserModel model = dataResponse.data!;
          await Getters.getLocalStorage.saveLoginUser(model.user!);
          await Getters.getLocalStorage.saveToken(model.token ?? "");
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