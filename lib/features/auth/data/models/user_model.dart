import 'package:json_annotation/json_annotation.dart';
import 'package:lavaloon_ecommerce_app/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });
  factory UserModel.fromJson(Map<dynamic, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<dynamic, dynamic> toJson() => _$UserModelToJson(this);
}
