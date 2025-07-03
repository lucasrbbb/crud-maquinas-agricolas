import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tipo.dart';

class TipoService {
  static const String baseUrl = 'https://argo.td.utfpr.edu.br/maquinas/ws/tipo';

  Future<List<Tipo>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Tipo.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar tipos');
    }
  }

  Future<Tipo> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Tipo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Tipo não encontrada');
    }
  }

  Future<void> create(Tipo tipo) async {
    final jsonBody = json.encode(tipo.toJson());
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
      throw Exception('Erro ao criar tipo: ${response.statusCode}');
    }
  }

  Future<void> update(Tipo tipo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${tipo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tipo.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao atualizar tipo');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar tipo');
    }
  }
}