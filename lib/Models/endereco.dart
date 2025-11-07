class Endereco {
  String? cep;
  String? logradouro;
  String? localidade;
  String? complemento;
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

  // Já existente
  factory Endereco.fromjson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'],
      logradouro: json['logradouro'],
      localidade: json['localidade'],
      complemento: json['complemento'],
      uf: json['uf'],
      estado: json['estado'],
    );
  }

  // 🔹 Adicione este método:
  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'localidade': localidade,
      'complemento': complemento,
      'uf': uf,
      'estado': estado,
    };
  }
}
