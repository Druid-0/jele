enum ViewStatus { idle, loading, success, error }

class ViewState {
  final ViewStatus status;
  final String? message;

  const ViewState({this.status = ViewStatus.idle, this.message});

  ViewState copyWith({ViewStatus? status, String? message}) {
    return ViewState(
      status: status ?? this.status,
      message: message,
    );
  }
}
