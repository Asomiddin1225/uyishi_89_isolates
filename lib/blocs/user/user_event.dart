sealed class UserEvent {}

final class GetUsersCount extends UserEvent {
  final int count;

  GetUsersCount(this.count);
}

final class GetUsersCountWithIsolate extends UserEvent {
  final int count;

  GetUsersCountWithIsolate(this.count);
}

final class GetPhotos extends UserEvent {}

final class GetPhotosWithIsolate extends UserEvent {}
