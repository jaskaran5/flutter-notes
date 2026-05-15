import '../../../../core/error/failure.dart';
import '../../../../core/utils/dartz/either.dart';
import '../data_source/home_data_source.dart';
import '../models/preferance_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, PreferencesModel?>> getPreference();
}


class HomeRepoImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, PreferencesModel?>> getPreference() async {
    try {
      final data = await dataSource.getPreferences();
      if(data?.status==true){
        return Right(data?.data);
      }else{
        return Left(ServerFailure(message: data?.message??""));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

}