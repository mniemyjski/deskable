part of 'selected_date_cubit.dart';

enum ESelectedDateStatus { loading, succeed }

class SelectedDateState extends Equatable {
  final DateTime dateTime;
  final String name;
  final ESelectedDateStatus status;

  SelectedDateState(
      {required this.dateTime, required this.status, required this.name});

  factory SelectedDateState.init() {
    return SelectedDateState(
      dateTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      name: Strings.today(),
      status: ESelectedDateStatus.succeed,
    );
  }

  factory SelectedDateState.loading(DateTime dateTime, String name) {
    return SelectedDateState(
        dateTime: dateTime, name: name, status: ESelectedDateStatus.loading);
  }

  factory SelectedDateState.succeed(DateTime dateTime, String name) {
    return SelectedDateState(
        dateTime: dateTime, name: name, status: ESelectedDateStatus.succeed);
  }

  @override
  List<Object?> get props => [dateTime, name, status];
}
