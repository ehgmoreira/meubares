import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importando Firestore

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  // ignore: prefer_final_fields
  Set<Marker> _markers = {}; // Conjunto de marcadores

  // Coordenadas de Belo Horizonte, MG
  static const LatLng _center = LatLng(-19.9173, -43.9345);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadBars(); // Carregar os bares ao criar o mapa
  }

  // Função para carregar dados do Firestore e adicionar marcadores
  void _loadBars() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Acessando a coleção 'bares' no Firestore
      QuerySnapshot snapshot = await firestore.collection('bares').get();

      for (var doc in snapshot.docs) {
        // Supondo que os documentos têm os campos 'nome', 'latitude', 'longitude', 'endereço', 'jogo'
        String nome = doc['nome']; // Usando 'nome'
        String endereco = doc['endereço']; // Usando 'endereço'
        String jogo = doc['jogo']; // Usando 'jogo'
        double latitude = doc['latitude']; // Usando 'latitude'
        double longitude = doc['longitude']; // Usando 'longitude'

        // Cria uma descrição que pode ser exibida no infoWindow
        String infoWindowContent = '$nome\nEndereço: $endereco\nJogo: $jogo';

        // Adiciona um marcador ao conjunto de marcadores
        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: nome,
              snippet: infoWindowContent,
            ), // Usando 'nome' e 'infoWindowContent'
          ),
        );
      }

      // Atualiza o estado para exibir os marcadores
      setState(() {});
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao carregar os bares: $e"); // Imprime qualquer erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center, // Usando as coordenadas de Belo Horizonte
          zoom: 12.0, // Ajuste o zoom conforme necessário
        ),
        markers: _markers, // Passando o conjunto de marcadores
      ),
    );
  }
}
