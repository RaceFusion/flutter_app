import 'package:flutter/material.dart';
import 'package:karting_app/models/race_record.dart';

Widget buildRaceTile(RaceRecord race) {
    return ExpansionTile(
      title: Text(
        'Fecha: ${race.raceDate}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        _buildInfoRow('Nombre de Carrera', race.raceName),
        _buildInfoRow('Tiempo de Carrera', race.raceTime),
        _buildInfoRow('Ubicación', race.raceLocation),
        _buildInfoRow('Vueltas', race.raceLaps),
        _buildInfoRow('Velocidad Promedio', race.averageSpeed),
        _buildInfoRow('Alertas', race.warnings),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }