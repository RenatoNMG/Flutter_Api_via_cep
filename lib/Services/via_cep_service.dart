import 'dart:convert';

import 'package:cosumodeapi/Models/endereco.dart';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Endereco?> buscarEndereco(String cep) async {
    String endpoint = "http://viacep.com.br/ws/$cep/json/";
    Uri uri = Uri.parse(endpoint);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Endereco.fromjson(json);
    }
    return null;
  }
}
