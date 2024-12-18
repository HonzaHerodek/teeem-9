import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../domain/repositories/trait_repository.dart';
import '../../../bloc/traits/traits_bloc.dart';
import '../../../bloc/traits/traits_event.dart';
import '../../../widgets/user_traits/user_traits.dart';

class ProfileTraitsView extends StatelessWidget {
  final String userId;
  final bool isLoading;

  const ProfileTraitsView({
    Key? key,
    required this.userId,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ProfileTraitsView build - userId: $userId'); // Debug log
    
    if (userId.isEmpty) {
      print('ProfileTraitsView - Warning: Empty user ID'); // Debug log
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        BlocProvider(
          create: (context) {
            print('Creating TraitsBloc for userId: $userId'); // Debug log
            final bloc = TraitsBloc(getIt<TraitRepository>());
            // Immediately load traits
            bloc.add(LoadTraits(userId));
            return bloc;
          },
          child: UserTraits(userId: userId),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ),
          ),
      ],
    );
  }
}
