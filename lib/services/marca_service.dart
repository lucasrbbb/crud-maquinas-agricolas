import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/marca.dart';

class MarcaService {
  static const String baseUrl = 'https://argo.td.utfpr.edu.br/maquinas/ws/marca';

  Future<List<Marca>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Marca.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar marcas');
    }
  }

  Future<Marca> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Marca.fromJson(json.decode(response.body));
    } else {
      throw Exception('Marca não encontrada');
    }
  }

  Future<void> create(Marca marca) async {
    final jsonBody = json.encode(marca.toJson());
    print('JSON enviado: $jsonBody');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 201) {
      print('Resposta sucesso');
    } else {
      print('Erro na resposta: ${response.statusCode} - ${response.body}');
      throw Exception('Erro ao criar marca: ${response.statusCode}');
    }
  }


  Future<void> update(Marca marca) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${marca.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(marca.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao atualizar marca');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar marca');
    }
  }
}