part of 'selected_date_cubit.dart';

class SelectedDateState extends Equatable {
  final DateTime dateTime;
  final EStatus status;

  SelectedDateState({required this.dateTime, required this.status});

  factory SelectedDateState.unknown() {
    return SelectedDateState(dateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), status: EStatus.unknown);
  }

  factory SelectedDateState.loading(DateTime dateTime) {
    return SelectedDateState(dateTime: dateTime, status: EStatus.loading);
  }

  factory SelectedDateState.succeed(DateTime dateTime) {
    return SelectedDateState(dateTime: dateTime, status: EStatus.succeed);
  }

  @override
  List<Object?> get props => [dateTime, status];
}
