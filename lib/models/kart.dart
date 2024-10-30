import 'dart:math';

class Kart {
  final String id;
  final String name;
  final String model;
  final String imagePath;

  Kart(this.id, {required this.name, required this.model, required this.imagePath});

  factory Kart.fromJson(Map<String, dynamic> json) {
    return Kart(
      json['id'],
      name: json['name'],
      model: json['model'],
      imagePath: json['imagePath'],
    );
  }

  // constructor
  Kart copyWith({String? name, String? model, String? imagePath}) {
    // random id generator
    final id = Random().nextInt(100).toString();    
    return Kart(
      id,
      name: name ?? this.name,
      model: model ?? this.model,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}