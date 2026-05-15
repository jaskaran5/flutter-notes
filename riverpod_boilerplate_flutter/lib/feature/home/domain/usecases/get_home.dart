import '../../../../core/error/failure.dart';
import '../../../../core/utils/dartz/either.dart';
import '../../data/models/preferance_model.dart';
import '../../data/repositories/home_repo_implementation.dart';

abstract class HomeUseCase {
  Future<Either<Failure, PreferencesModel?>> callGetPreference();
}

class HomeUseCaseImpl implements HomeUseCase{
  final HomeRepository repository;
  HomeUseCaseImpl({required this.repository});
  @override
  Future<Either<Failure, PreferencesModel?>> callGetPreference() async {
    final result = await repository.getPreference();
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
