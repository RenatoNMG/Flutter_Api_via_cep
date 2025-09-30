import 'package:http/http.dart' as http;

class ViaCepService {
  buscarendereco(String cep){
    String endpoint = "viacep.com.br/ws/$cep/json/";
    Uri uri = Uri.parse(endpoint);


    http.get(uri);

  }
}