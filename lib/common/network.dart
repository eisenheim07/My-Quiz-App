sealed class NetworkState<T> {}

class Initial<T> extends NetworkState<T> {}

class Loading<T> extends NetworkState<T> {}

class Success<T> extends NetworkState<T> {
  final T data;

  Success(this.data);
}

class Error<T> extends NetworkState<T> {
  final String message;

  Error(this.message);
}
