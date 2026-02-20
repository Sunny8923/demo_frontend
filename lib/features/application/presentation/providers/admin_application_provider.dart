import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/application/presentation/providers/appliaction_provider.dart';
import '../../data/models/application_model.dart';
import '../../data/repository/application_repository.dart';

final adminApplicationProvider =
    AsyncNotifierProvider<AdminApplicationNotifier, List<ApplicationModel>>(
      AdminApplicationNotifier.new,
    );

class AdminApplicationNotifier extends AsyncNotifier<List<ApplicationModel>> {
  late final ApplicationRepository _repository;

  @override
  Future<List<ApplicationModel>> build() async {
    _repository = ref.read(applicationRepositoryProvider);

    return await _repository.getAllApplications();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await _repository.getAllApplications();
    });
  }
}
