import 'package:flutter/foundation.dart';
import '../../../../data/models/traits/user_trait_model.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileRefreshed extends ProfileEvent {
  const ProfileRefreshed();
}

class ProfilePostsRequested extends ProfileEvent {
  const ProfilePostsRequested();
}

class ProfileTraitAdded extends ProfileEvent {
  final UserTraitModel trait;

  const ProfileTraitAdded(this.trait);
}

class ProfileRatingReceived extends ProfileEvent {
  final double rating;
  final String userId;
  final String raterId;

  const ProfileRatingReceived(this.rating, this.raterId, {required this.userId});
}

class ProfilePostUnsaved extends ProfileEvent {
  final String postId;

  const ProfilePostUnsaved(this.postId);
}
