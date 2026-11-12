import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para FilteringTextInputFormatter

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MiAplicacion()),
  );
}

class MiAplicacion extends StatefulWidget {
  const MiAplicacion({super.key});

  @override
  State<MiAplicacion> createState() => _MiAplicacionState();
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

  void eliminarActividad(Actividad actividad){
    setState((){
      actividades.remove(actividad);
    });
  }

  // Función asíncrona para ir al formulario y recoger la nueva Actividad
  Future<void> _irAFormulario() async {
    final nuevaActividad = await Navigator.push<Actividad>(
      context,
      MaterialPageRoute(
        builder: (context) => const PantallaNuevaActividad(),
      ),
    );

    // Si el usuario guardó el formulario (no volvió atrás sin guardar)
    if (nuevaActividad != null) {
      setState(() {
        actividades.add(nuevaActividad);
      });
    }
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
            onPressed: _irAFormulario, // Llama a la función que espera el resultado
            tooltip: 'Crear actividad con formulario',
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: agregarActividad,
        tooltip: 'Añadir actividad rápida',
        child: const Icon(Icons.plus_one),
      ),
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

              // Mostramos las tarjetas individualmente usando map()
              ...actividades.map((actividad) {
                return Row(
                  children: [
                  Expanded(child: crearTarjeta(actividad)), 
                  IconButton(
                    onPressed:(){
                       eliminarActividad(actividad);
                    }, 
                    tooltip: 'Eliminar actividad',
                    icon: const Icon(Icons.delete)),
                  ],
                );
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
                const SizedBox(height: 4),
                Text(
                  '${actividad.duracionMinutos} min',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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

// --- PANTALLA DEL FORMULARIO ---
class PantallaNuevaActividad extends StatefulWidget {
  const PantallaNuevaActividad({super.key});

  @override
  State<PantallaNuevaActividad> createState() => _PantallaNuevaEstado();
}

class _PantallaNuevaEstado extends State<PantallaNuevaActividad> {
  // 1. GlobalKey para identificar el Form y poder validarlo
  final _formKey = GlobalKey<FormState>();

  // 2. Controladores para capturar el texto de cada campo
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _duracionController = TextEditingController();

  @override
  void dispose() {
    // Liberamos memoria al cerrar la pantalla
    _nombreController.dispose();
    _descripcionController.dispose();
    _duracionController.dispose();
    super.dispose();
  }

  void _validarYGuardar() {
    // Ejecuta todos los validator() del formulario
    if (_formKey.currentState!.validate()) {
      // Creamos el objeto Actividad con los datos validados
      final nuevaActividad = Actividad(
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        duracionMinutos: int.parse(_duracionController.text.trim()),
        // Valores por defecto para icono y color
        icono: Icons.event_available,
        colorFondo: Colors.purple.shade100,
      );

      // Cerramos la pantalla devolviendo el objeto a MiAplicacion
      Navigator.pop(context, nuevaActividad);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva actividad')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Vinculamos la GlobalKey
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Introduce los datos de la nueva actividad:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // CAMPO NOMBRE
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ej. Repasar acceso a datos',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // CAMPO DESCRIPCIÓN
              TextFormField(
                controller: _descripcionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Detalles de la actividad...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // CAMPO DURACIÓN (Solo números, sin letras)
              TextFormField(
                controller: _duracionController,
                keyboardType: TextInputType.number,
                // Bloquea físicamente que se escriban letras en el teclado
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Duración (minutos)',
                  hintText: 'Ej. 45',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Introduce la duración en minutos';
                  }
                  // Doble validación lógica: intentamos convertir a entero
                  final minutos = int.tryParse(value.trim());
                  if (minutos == null) {
                    return 'No se permiten letras, solo números';
                  }
                  if (minutos <= 0) {
                    return 'La duración debe ser mayor a 0 minutos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // BOTÓN VALIDAR Y GUARDAR
              ElevatedButton.icon(
                onPressed: _validarYGuardar,
                icon: const Icon(Icons.save),
                label: const Text('Validar y guardar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),

              // BOTÓN CANCELAR / VOLVER
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar y volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}