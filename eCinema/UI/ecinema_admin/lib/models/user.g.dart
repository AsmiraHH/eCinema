// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['username'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['birthDate'] as String?,
      json['gender'] as int?,
      json['role'] as int?,
      json['isActive'] as bool?,
      json['profilePhoto'] as String?,
      json['isVerified'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
      'role': instance.role,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'profilePhoto': instance.profilePhoto,
    };
