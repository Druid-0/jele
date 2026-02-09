sealed class Result<T> {
  const Result();

  const factory Result.loading() = Loading<T>;
  const factory Result.success(T data) = Success<T>;
  const factory Result.error(String message) = Failure<T>;

  R when<R>({
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message) error,
  }) {
    return switch (this) {
      Loading<T>() => loading(),
      Success<T>(:final data) => success(data),
      Failure<T>(:final message) => error(message),
    };
  }
}

class Loading<T> extends Result<T> {
  const Loading();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
