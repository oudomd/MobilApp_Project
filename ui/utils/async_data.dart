enum AsyncStatus { notStarted, loading, success, error }

class AsyncData<T> {
  final AsyncStatus status;
  final T? value;
  final String? error;

  AsyncData.notStarted()
    : status = AsyncStatus.notStarted,
      value = null,
      error = null;
  AsyncData.loading()
    : status = AsyncStatus.loading,
      value = null,
      error = null;
  AsyncData.success(this.value) : status = AsyncStatus.success, error = null;
  AsyncData.error(this.error) : status = AsyncStatus.error, value = null;
}
