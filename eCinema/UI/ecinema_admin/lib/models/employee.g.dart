// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
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
      json['cinemaId'] as int?,
      json['cinema'] == null
          ? null
          : Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
      'role': instance.role,
      'isActive': instance.isActive,
      'profilePhoto': instance.profilePhoto,
      'cinemaId': instance.cinemaId,
      'cinema': instance.cinema,
    };
