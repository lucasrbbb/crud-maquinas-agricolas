import 'dart:convert';
import 'package:crud_maquinas_agricolas/models/filtro.dart';
import 'package:http/http.dart' as http;
import '../models/maquina.dart';

class MaquinaService {
  static const String baseUrl = 'https://argo.td.utfpr.edu.br/maquinas/ws/maquina';

  Future<List<Maquina>> getAll({Filtro? filtro}) async {
    final queryParameters = <String, String>{};

    if (filtro != null) {
      if (filtro.valorDe > 0) {
        queryParameters['valorDe'] = filtro.valorDe.toString();
      }
      if (filtro.valorAte > 0) {
        queryParameters['valorAte'] = filtro.valorAte.toString();
      }
      if (filtro.status != null) {
        queryParameters['status'] = filtro.status.name;
      }
      if (filtro.idMarca > 0) {
        queryParameters['idMarca'] = filtro.idMarca.toString();
      }
      if (filtro.idTipo > 0) {
        queryParameters['idTipo'] = filtro.idTipo.toString();
      }
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    print('Buscando máquinas na URL: $uri');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Maquina.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar máquinas');
    }
  }

  Future<Maquina> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Maquina.fromJson(json.decode(response.body));
    } else {
      throw Exception('Máquina não encontrada');
    }
  }

  Future<void> create(Maquina maquina) async {
    final jsonBody = json.encode(maquina.toJson());
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
      throw Exception('Erro ao criar máquina: ${response.statusCode}');
    }
  }


  Future<void> update(Maquina maquina) async {
    final jsonBody = json.encode(maquina.toJson());
    print('JSON enviado: $jsonBody');

    final response = await http.put(
      Uri.parse('$baseUrl/${maquina.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(maquina.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao atualizar máquina: ${response.statusCode}');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar máquina');
    }
  }
}