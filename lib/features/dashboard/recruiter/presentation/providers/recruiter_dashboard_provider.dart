import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/dashboard/recruiter/data/model/recruiter_dashboard_model.dart';
import '../../data/repository/recruiter_dashboard_repository.dart';

final recruiterDashboardRepositoryProvider = Provider(
  (ref) => RecruiterDashboardRepository(),
);

final recruiterDashboardProvider =
    AsyncNotifierProvider.autoDispose<
      RecruiterDashboardNotifier,
      RecruiterDashboardModel
    >(RecruiterDashboardNotifier.new);

class RecruiterDashboardNotifier
    extends AsyncNotifier<RecruiterDashboardModel> {
  late final RecruiterDashboardRepository _repository;

  @override
  Future<RecruiterDashboardModel> build() async {
    _repository = ref.read(recruiterDashboardRepositoryProvider);

    return await _repository.getDashboard();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() async {
      return await _repository.getDashboard();
    });
  }
}
