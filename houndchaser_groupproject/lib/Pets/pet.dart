import 'package:equatable/equatable.dart';

/// Pet
/// Edited By Hashem
/// @author Tristan
/// @description Class for Pet objects


class Pet extends Equatable {
  String key;
  final String name;
  final String breed;
  final double weight;
  final int age;
  final String image;
  final String owner;
  final int walks;
  final double distance;

  Pet({
    this.key = "",
    required this.name,
    required this.breed,
    required this.weight,
    required this.age,
    required this.image,
    this.owner = "",
    this.walks = 0,
    this.distance = 0,
  });

  @override
  List<Object?> get props => [
    key, name, breed, weight, age, image, owner, walks, distance
  ];

  Pet copyWith({
    String? key,
    String? name,
    String? breed,
    double? weight,
    int? age,
    String? image,
    String? owner,
    int? walks,
    double? distance,
  }) {
    return Pet(
      key: key ?? this.key,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      image: image ?? this.image,
      owner: owner ?? this.owner,
      walks: walks ?? this.walks,
      distance: distance ?? this.distance,
    );
  }

  String get ageString => "${(age / 12).floor()} years ${age % 12} months";
}

