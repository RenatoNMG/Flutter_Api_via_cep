import 'package:cosumodeapi/Models/endereco.dart';
import 'package:cosumodeapi/Services/via_cep_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controllerCep = TextEditingController();
  TextEditingController controllerLogradouro = TextEditingController();
  TextEditingController controllerLocalidade = TextEditingController();
  TextEditingController controllerComplemento = TextEditingController();
  TextEditingController controllerUf = TextEditingController();
  TextEditingController controllerEstado = TextEditingController();
  Endereco? endereco; // variavel pode sreceber null;

  ViaCepService viaCepService = ViaCepService();

  Future<void> buscarCep(String cep) async {
    Endereco? response = await viaCepService.buscarEndereco(cep);

    if (response?.localidade == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.warning),
            title: Text("Atenção"),
            content: Text("Cep Não Encontrado"),
          );
        },
      );
      return;
    }
    setState(() {
      endereco = response;
    });
  }

  void setControllersCep(Endereco endereco) {
    controllerLogradouro.text = endereco.logradouro!;
    controllerLocalidade.text = endereco.localidade!;
    controllerComplemento.text = endereco.complemento!;
    controllerUf.text = endereco.uf!;
    controllerEstado.text = endereco.estado!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextField(
                controller: controllerCep,
                maxLength: 8,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      buscarCep(controllerCep.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(),
                  labelText: "CEP",
                ),
              ),
            ),
            Center(
              child: TextField(
                controller: controllerLogradouro,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Logradouro",
                ),
              ),
            ),
            Center(
              child: TextField(
                controller: controllerLocalidade,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Localidade",
                ),
              ),
            ),
            TextField(
              controller: controllerComplemento,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "complemento",
              ),
            ),

            TextField(
              controller: controllerUf,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "uf",
              ),
            ),
            TextField(
              controller: controllerEstado,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "estado",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
