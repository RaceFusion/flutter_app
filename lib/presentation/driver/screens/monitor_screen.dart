import 'package:flutter/material.dart';
import 'package:karting_app/utils/page_animation.dart';
import 'dart:math';
import 'analysis_screen.dart';
import '../widgets/info_card.dart';

class MonitorScreen extends StatelessWidget {
  final String kartName;
  const MonitorScreen({super.key, required this.kartName});

  @override
  Widget build(BuildContext context) {
    PageAnimation pageAnimation = PageAnimation();

    Random random = Random();
    return Scaffold(
      appBar: AppBar(
        title: Text('$kartName Monitor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gokart1.jpg',
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Estado: Activo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(
                    icon: Icons.speed, value: '${random.nextInt(100)} km/h'),
                InfoCard(
                    icon: Icons.thermostat, value: '${random.nextInt(40)}°C'),
                InfoCard(
                    icon: Icons.air, value: '${random.nextInt(35) + 20} PSI'),
                InfoCard(
                    icon: Icons.gas_meter_outlined,
                    value: '${random.nextInt(100)}%'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Análisis',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
                context,
                pageAnimation.createPageRoute(
                  AnalysisScreen(kartName: kartName),
                ));
          }
        },
      ),
    );
  }
}
