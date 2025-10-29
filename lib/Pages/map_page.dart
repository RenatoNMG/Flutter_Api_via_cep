import 'package:cosumodeapi/Services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final LocationService locationService = LocationService();
  final MapController _mapController =
      MapController(); // MapController adicionado
  LatLng posicaoInicial = LatLng(-23.5505, -46.6333);
  LatLng posicaoSenac = LatLng(-23.5280859, -46.6917602);
  LatLng posicaoParque = LatLng(-23.5306847, -46.678802);
  LatLng posicaoLuz = LatLng(23.5503099, -46.6342009);
  LatLng posicaoPraia = LatLng(23.790409, -46.0504455);
  String locationText = "Obtendo localização...";

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    Position? position = await locationService.getCurrentLocation();
    if (position != null) {
      LatLng novaPosicao = LatLng(position.latitude, position.longitude);

      setState(() {
        posicaoInicial = novaPosicao;
        print(
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}",
        );
      });

      _mapController.move(novaPosicao, 15.0);
    } else {
      setState(() {
        locationText = "Localização não permitida";
      });
    }
  }

  senacLocation() {
    posicaoInicial = LatLng(-23.5280859, -46.6917602);
    _mapController.move(posicaoInicial, 13);
  }

  parqueLocation() {
    posicaoInicial = LatLng(-23.5306847, -46.678802);
    _mapController.move(posicaoInicial, 15.0);
  }

  luzLocation() {
    posicaoInicial = LatLng(23.5503099, -46.6342009);
    _mapController.move(posicaoInicial, 15.0);
  }

  praiaLocation() {
    posicaoInicial = LatLng(23.790409, -46.0504455);
    _mapController.move(posicaoInicial, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa Interativo")),
      body: FlutterMap(
        mapController: _mapController, // Passa o controller
        options: MapOptions(
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.cosumodeapi',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: posicaoInicial,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              Marker(
                point: posicaoSenac,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              Marker(
                point: posicaoParque,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              Marker(
                point: posicaoLuz,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              Marker(
                point: posicaoPraia,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min, // Para não ocupar toda a tela
        children: [
          FloatingActionButton(
            onPressed: getLocation,
            heroTag: 'btn1', // tag única para cada botão
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: senacLocation,
            heroTag: 'btn2',
            child: const Icon(Icons.school),
          ),
          FloatingActionButton(
            onPressed: parqueLocation,
            heroTag: 'btn2',
            child: const Icon(Icons.park),
          ),
          FloatingActionButton(
            onPressed: luzLocation,
            heroTag: 'btn2',
            child: const Icon(Icons.school),
          ),
          FloatingActionButton(
            onPressed: praiaLocation,
            heroTag: 'btn2',
            child: const Icon(Icons.park),
          ),
        ],
      ),
    );
  }
}
