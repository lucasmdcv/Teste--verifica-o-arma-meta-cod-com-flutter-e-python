import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
      ),
      home: const MetaCodPage(),
    );
  }
}

class MetaCodPage extends StatefulWidget {
  const MetaCodPage({super.key});

  @override
  State<MetaCodPage> createState() => _MetaCodPageState();
}

class _MetaCodPageState extends State<MetaCodPage> {
  // Função para buscar os dados do seu Kali Linux
  Future<List<dynamic>> fetchMeta() async {
    // SEU IP DO KALI: 172.30.73.150
    final response = await http.get(Uri.parse('http://172.30.73.150:8000/meta'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; 
    } else {
      throw Exception('Falha ao conectar ao servidor do Kali');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COD Meta - Kali Backend'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchMeta(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final armas = snapshot.data!;
            return ListView.builder(
              itemCount: armas.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesArmaPage(arma: armas[index]),
                        ),
                      );
                    },
                    // EXIBIÇÃO DA IMAGEM DA ARMA
                    leading: SizedBox(
                      width: 80,
                      child: Image.network(
                        armas[index]['url_imagem'] ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.videogame_asset, color: Colors.orange),
                      ),
                    ),
                    title: Text(
                      armas[index]['nome'], 
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text('Status: ${armas[index]['status']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
class DetalhesArmaPage extends StatelessWidget {
  final dynamic arma;
  const DetalhesArmaPage({super.key, required this.arma});

  @override
  Widget build(BuildContext context) {
    List<dynamic> build = arma['build'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(arma['nome'])),
      body: Column(
        children: [
          // IMAGEM GRANDE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.black26,
            child: Image.network(
              arma['url_imagem'] ?? '',
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.image_not_supported, size: 80),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "BUILD / ACESSÓRIOS", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)
            ),
          ),
          // LISTA DE ACESSÓRIOS
          Expanded(
            child: ListView.builder(
              itemCount: build.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: const Icon(Icons.tune, color: Colors.orange),
                  title: Text(build[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
