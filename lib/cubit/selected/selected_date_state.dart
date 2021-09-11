part of 'selected_date_cubit.dart';

enum ESelectedDateStatus { loading, succeed }

class SelectedDateState extends Equatable {
  final DateTime dateTime;
  final ESelectedDateStatus status;

  SelectedDateState({required this.dateTime, required this.status});

  factory SelectedDateState.init() {
    return SelectedDateState(
      dateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      status: ESelectedDateStatus.succeed,
    );
  }

  factory SelectedDateState.loading(DateTime dateTime) {
    return SelectedDateState(dateTime: dateTime, status: ESelectedDateStatus.loading);
  }

  factory SelectedDateState.succeed(DateTime dateTime) {
    return SelectedDateState(dateTime: dateTime, status: ESelectedDateStatus.succeed);
  }

  @override
  List<Object?> get props => [dateTime, status];
}
