import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_book/domain/repository/journal_repo.dart';

import '../../domain/repository/user_repo.dart';
import 'cubit_state/cubit_state.dart';

class ProfileScreenCubit extends Cubit<Points> {
  JournalRepo journalRepo;

  final UserRepo userRepo;

  ProfileScreenCubit({
    required this.journalRepo,
    required this.userRepo,
  }) : super(Points.initial());

  Future<Points> getStreakAndPoint() async {
    final streak = await journalRepo.streak();
    final point = await journalRepo.point();
    return Points(streak: streak, point: point);
  }

  /// TODO: getUserName Function
  Future<String> getUserName() async {
    emit(const LoadingState() as Points);
    final user = await userRepo.getUserName(userId: '1');
    return user;
  }
}

class Points {
  final int streak;
  final int point;

  const Points({
    required this.streak,
    required this.point,
  });

  factory Points.initial() => const Points(
        streak: 0,
        point: 0,
      );
}
