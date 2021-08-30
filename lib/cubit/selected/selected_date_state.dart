part of 'selected_date_cubit.dart';

class SelectedDateState extends Equatable {
  final DateTime dateTime;
  final EStatus status;

  SelectedDateState({required this.dateTime, required this.status});

  factory SelectedDateState.unknown() {
    return SelectedDateState(status: EStatus.unknown, dateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  factory SelectedDateState.succeed(DateTime dateTime) {
    return SelectedDateState(status: EStatus.succeed, dateTime: dateTime);
  }

  @override
  List<Object?> get props => [dateTime, status];
}
