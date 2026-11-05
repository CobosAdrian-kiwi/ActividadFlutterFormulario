/*
Crear formulario:
  - Nombre
  - Desc
  - Duracion

Poner StatefulWidget para la nueva pantalla

Boton de validar y guardar: Validar los datos (no letras en duracion)
Guardar los datos (Añadir card) -> List actividades (map() tarjeta)

Investigar sobre las KEY -> global.key

*/

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MiAplicacion())
  );
}

class MiAplicacion extends StatefulWidget {
  const MiAplicacion({super.key});

  @override
  State <MiAplicacion> createState() => _MiAplicacionState();
}

class _MiAplicacionState extends State<MiAplicacion> {

// Lista de actividades
    final List<Actividad> actividades = [
      Actividad(
        nombre: 'Leer',
        descripcion: 'Leer durante 20 minutos',
        icono: Icons.menu_book,
        colorFondo: Colors.blue.shade100,
        duracionMinutos: 20,
      ),
      Actividad(
        nombre: 'Hacer ejercicio',
        descripcion: 'Caminar durante 30 minutos',
        icono: Icons.directions_walk,
        colorFondo: Colors.green.shade100,
        duracionMinutos: 30,
      ),
      Actividad(
        nombre: 'Estudiar Flutter',
        descripcion: 'Practicar programación durante una hora',
        icono: Icons.code,
        colorFondo: Colors.orange.shade100,
        duracionMinutos: 60,
      ),
      Actividad(
        nombre: 'Prueba',
        descripcion: 'Prueba de que funciona o no',
        icono: Icons.sunny,
        colorFondo: const Color.fromARGB(255, 85, 133, 36),
        duracionMinutos: 20,
      ),
    ];

  void agregarActividad() {
    setState(() {
      actividades.add(
        Actividad(
          nombre: 'Nueva act ${actividades.length + 1}',
          descripcion: 'Desde el boton',
          icono: Icons.add_circle_outline,
          colorFondo: Colors.teal,
          duracionMinutos: 15,
          ),
        );
      });
    }

  @override
  Widget build(BuildContext context) {
    String titulo = 'Mis actividades';
    final String grupo = '2.º DAM';
    const String subtitulo = 'Organiza tus actividades';

    // Cantidad de actividades
    int cantidadActividades = actividades.length;

    // Duración total
    int minutosTotales = 0;

    for (final actividad in actividades) {
      minutosTotales += actividad.duracionMinutos;
    }

    double horasTotales = minutosTotales / 60;

    // Comprobamos si existen actividades
    bool hayActividades = actividades.isNotEmpty;

    // Obtenemos el resumen de la primera actividad
    var aviso = hayActividades
        ? actividades.first.obtenerResumen()
        : 'No hay actividades';

    return Scaffold(
        appBar: AppBar(
          title: Text(titulo),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaNuevaActividad(),
                  )
                );
              }, 
              icon: const Icon(Icons.arrow_forward),
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: agregarActividad,
          tooltip: 'Añadir nueva actividad',
          child: const Icon(Icons.plus_one),),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text('Grupo: $grupo'),
                Text('Actividades disponibles: $cantidadActividades'),
                Text('Duración total: $minutosTotales minutos'),
                Text(
                  'Tiempo total previsto: ${horasTotales.toStringAsFixed(2)} horas',
                ),
                Text(
                  hayActividades
                      ? 'Hay actividades disponibles'
                      : 'No hay actividades disponibles',
                ),

                const SizedBox(height: 16),
                Text(aviso),
                const SizedBox(height: 24),

                const Text(
                  'Actividades',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Mostramos las tarjetas individualmente
                ...actividades.map((actividad){
                  return crearTarjeta(actividad);
                }),
              ],
            ),
          ),
        ),
      );
  }
}





// Función que construye una tarjeta
Widget crearTarjeta(Actividad actividad) {
  return Card(
    margin: const EdgeInsets.only(top: 12),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: actividad.colorFondo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(actividad.icono, size: 28),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actividad.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(actividad.descripcion),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Clase que representa una actividad
class Actividad {
  final String nombre;
  final String descripcion;
  final IconData icono;
  final Color colorFondo;
  final int duracionMinutos;

  // Constructor
  Actividad({
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.colorFondo,
    required this.duracionMinutos,
  });

  // Método que devuelve un resumen
  String obtenerResumen() {
    return '$nombre: $duracionMinutos minutos';
  }
}

class PantallaNuevaActividad extends StatefulWidget {
  const PantallaNuevaActividad({super.key});
  
  @override
  State <PantallaNuevaActividad> createState() => _PantallaNuevaEstado();
}

class _PantallaNuevaEstado extends State<PantallaNuevaActividad> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva actividad'),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aqui introduciremos los datos de una nueva actividad.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text('Volver a mis actividades'),
              )
          ],
        ),
        ),
    );
  }
}