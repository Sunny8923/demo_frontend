import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/application/presentation/providers/appliaction_provider.dart';
import '../../data/repository/application_repository.dart';

final updateApplicationStageProvider =
    AsyncNotifierProvider<UpdateApplicationStageNotifier, void>(
      UpdateApplicationStageNotifier.new,
    );

class UpdateApplicationStageNotifier extends AsyncNotifier<void> {
  late ApplicationRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.read(applicationRepositoryProvider);
  }

  Future<void> updateStage({
    required String applicationId,
    required String pipelineStage,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.updateApplicationStage(
        applicationId: applicationId,
        pipelineStage: pipelineStage,
      );
    });
  }
}
