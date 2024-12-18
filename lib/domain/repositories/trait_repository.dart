import '../../data/models/traits/trait_type_model.dart';
import '../../data/models/traits/user_trait_model.dart';

abstract class TraitRepository {
  Future<List<TraitTypeModel>> getTraitTypes();
  
  Future<List<UserTraitModel>> getUserTraits(String userId);
  
  Future<UserTraitModel> addUserTrait({
    required String userId,
    required String traitTypeId,
    required String value,
  });
  
  Future<void> removeUserTrait({
    required String userId,
    required String traitId,
  });
  
  Future<void> updateTraitOrder({
    required String userId,
    required List<String> traitIds,
  });
}
