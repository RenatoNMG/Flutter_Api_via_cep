import 'package:cosumodeapi/Models/endereco.dart';
import 'package:cosumodeapi/Services/via_cep_service.dart';
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

  bool isLoading = false;

  ViaCepService viaCepService = ViaCepService();

  Future<void> buscarCep(String cep) async {
    clearController();
    setState(() {
      isLoading = true;
    });
    try {
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
        controllerCep.clear();
        return;
      }
      setState(() {
        endereco = response;
      });

      setControllersCep(endereco!);
    } catch (erro) {
      throw Exception("Erro ao buscar CEP:  $erro");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setControllersCep(Endereco endereco) {
    controllerCep.text = endereco.cep!;
    controllerLogradouro.text = endereco.logradouro!;
    controllerLocalidade.text = endereco.localidade!;
    controllerComplemento.text = endereco.complemento!;
    controllerUf.text = endereco.uf!;
    controllerEstado.text = endereco.estado!;
  }

  void clearController() {
    controllerCep.clear();
    controllerLogradouro.clear();
    controllerLocalidade.clear();
    controllerComplemento.clear();
    controllerUf.clear();
    controllerEstado.clear();
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
            TextField(
              onChanged: (value) {
                print(value);
                if (value.isEmpty) {
                  clearController();
                }
              },
              controller: controllerCep,
              maxLength: 8,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixIcon: isLoading
                    ? SizedBox(
                        width: 10,
                        height: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          buscarCep(controllerCep.text);
                        },
                        icon: Icon(Icons.search),
                      ),
                border: OutlineInputBorder(),
                labelText: "CEP",
              ),
            ),

            if (controllerLogradouro.text.isNotEmpty)
              Column(
                children: [
                
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerLogradouro,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Logradouro",
                      ),
                    ),
                
                  
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerLocalidade,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Localidade",
                      ),
                    ),
                 

                  
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerComplemento,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "complemento",
                      ),
                    ),
                  

            
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerUf,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "uf",
                      ),
                    ),
                  
                
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerEstado,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "estado",
                      ),
                    ),
                 
                ],
              ),
          ],
        ),
      ),
    );
  }
}
