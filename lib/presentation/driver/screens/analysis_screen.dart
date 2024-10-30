import 'package:flutter/material.dart';
import 'package:karting_app/models/race_record.dart';
import 'dart:math';
import 'package:karting_app/presentation/driver/widgets/check_list.dart';
import 'package:karting_app/presentation/driver/widgets/race_tile.dart';

class AnalysisScreen extends StatelessWidget {
  final String kartName;
  const AnalysisScreen({super.key, required this.kartName});

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    // Lista de registros de carreras usando RaceRecord
    final List<RaceRecord> races = [
      RaceRecord(
        'Ninguna',
        '${random.nextInt(80) + 20} km/h',
        raceId: '1',
        raceName: 'Gran Premio Local',
        raceDate: '12/05/2025',
        raceTime: '${random.nextInt(60) + 50} min',
        raceLocation: 'Circuito Central',
        raceLaps: '15',
      ),
      RaceRecord(
        'Problemas en frenos',
        '${random.nextInt(80) + 20} km/h',
        raceId: '2',
        raceName: 'Competencia Regional',
        raceDate: '11/04/2025',
        raceTime: '${random.nextInt(60) + 50} min',
        raceLocation: 'Circuito Regional',
        raceLaps: '12',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Análisis - $kartName'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historial de Carreras:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...races.map((race) => buildRaceTile(race)),
              const SizedBox(height: 15),
              const Text(
                'Recomendaciones:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              buildChecklist(),
            ],
          ),
        ),
      ),
      
    );
  }

  
}
