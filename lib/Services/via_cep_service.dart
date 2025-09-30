import 'dart:convert';

import 'package:cosumodeapi/models/endereco.dart';
import 'package:http/http.dart' as http;

class ViaCepService {
  Future<Endereco?>  buscarendereco(String cep) async{
    String endpoint = "viacep.com.br/ws/$cep/json/";
    Uri uri = Uri.parse(endpoint);

    var response =  await http.get(uri);
    
    if (response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      return Endereco.fromjson(json);
    }

  }
}