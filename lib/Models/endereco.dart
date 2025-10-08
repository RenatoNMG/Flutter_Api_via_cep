class Endereco {
  String? cep;
  String? logradouro;
  String? complemento;
  String? localidade;
  String? uf;
  String? estado;

  Endereco({
    this.cep,
    this.logradouro,
    this.localidade,
    this.complemento,
    this.uf,
    this.estado,
});

  factory Endereco.fromjson(Map<String, dynamic> json){
   return Endereco(
    cep: json["cep"],
    logradouro: json["logradouro"],
    localidade: json["localidade"],
    complemento: json["complemento"],
    uf: json["uf"],
    estado: json["estado"]

   );
  }
}

    // {
    //   "cep": "01001-000",
    //   "logradouro": "Praça da Sé",
    //   "complemento": "lado ímpar",
    //   "unidade": "",
    //   "bairro": "Sé",
    //   "localidade": "São Paulo",
    //   "uf": "SP",
    //   "estado": "São Paulo",
    //   "regiao": "Sudeste",
    //   "ibge": "3550308",
    //   "gia": "1004",
    //   "ddd": "11",
    //   "siafi": "7107"
    // }
        