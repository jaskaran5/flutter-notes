import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_source/home_data_source.dart';
import '../../data/models/preferance_model.dart';
import '../../data/repositories/home_repo_implementation.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home.dart';


// Define a Provider for HomeDataSource
final homeDataProvider = Provider.autoDispose<HomeDataSource>((ref) => HomeDataSourceImpl());

// Define a Provider for HomeRepository
final homeRepoProvider = Provider.autoDispose<HomeRepository>((ref) {
  final dataSource = ref.watch(homeDataProvider);
  return HomeRepoImpl(dataSource: dataSource);
});

// Define a Provider for HomeUseCase
final homeUseCaseProvider = Provider.autoDispose<HomeUseCase>((ref) {
  final repository = ref.watch(homeRepoProvider);
  return HomeUseCaseImpl(repository: repository);
});

final getPreferenceProvider = FutureProvider.autoDispose<List<PreferencesModel>>((ref) async {
  final getUserHomeCase = ref.watch(homeUseCaseProvider);
  final res = await getUserHomeCase.callGetPreference();
  return res.fold((error) {print("Error: ${error.message}");
  throw Exception(error.toString());
  }, (data) {
      return data?.preferences??[];
    },
  );

});
