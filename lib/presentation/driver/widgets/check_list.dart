import 'package:flutter/material.dart';

Widget buildChecklist() {
  final List<String> recommendations = [
    'Revisar presión de neumáticos',
    'Verificar nivel de aceite',
    'Ajustar cinturones de seguridad',
    'Comprobar frenos',
    'Revisar nivel de combustible',
  ];

  return Column(
    children: recommendations.map((recommendation) {
      return CheckboxListTile(
        value: false,
        onChanged: (bool? newValue) {},
        title: Text(recommendation),
        controlAffinity: ListTileControlAffinity.leading,
      );
    }).toList(),
  );
}
