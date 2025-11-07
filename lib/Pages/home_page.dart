import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cosumodeapi/Models/endereco.dart';
import 'package:cosumodeapi/Services/connectivity_service.dart';
import 'package:cosumodeapi/Services/shered_preferences_services.dart';
import 'package:cosumodeapi/Services/via_cep_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controllerCep = TextEditingController();
  final TextEditingController controllerLogradouro = TextEditingController();
  final TextEditingController controllerLocalidade = TextEditingController();
  final TextEditingController controllerComplemento = TextEditingController();
  final TextEditingController controllerUf = TextEditingController();
  final TextEditingController controllerEstado = TextEditingController();

  final ViaCepService viaCepService = ViaCepService();
  final ConnectivityService cs = ConnectivityService();
  final SheredPreferencesServices prefs = SheredPreferencesServices();

  bool isLoading = false;
  bool isOnline = true;
  List<Endereco> cepsSalvos = [];

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  Future<void> inicializar() async {
    await prefs.init();
    await carregarCepsSalvos();

    // Monitora conexão
    cs.connectivityStream.listen((statusConnect) {
      setState(() => isOnline = statusConnect);
    });
  }

  Future<void> carregarCepsSalvos() async {
    final jsonList = prefs.getString('ceps_salvos');
    if (jsonList != null) {
      final List decoded = json.decode(jsonList);
      cepsSalvos = decoded.map((e) => Endereco.fromjson(e)).toList();
      setState(() {});
    }
  }

  Future<void> salvarCep(Endereco endereco) async {
    final cepLimpo = endereco.cep?.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    endereco.cep = cepLimpo;

    if (!cepsSalvos.any(
      (e) => e.cep?.replaceAll(RegExp(r'[^0-9]'), '') == cepLimpo,
    )) {
      cepsSalvos.add(endereco);
      final jsonEncoded = json.encode(
        cepsSalvos.map((e) => e.toJson()).toList(),
      );
      await prefs.saveString('ceps_salvos', jsonEncoded);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("CEP salvo localmente")));
      setState(() {});
    }
  }

  Future<void> buscarCep(String cep) async {
    cep = cep.replaceAll(RegExp(r'[^0-9]'), ''); // 🔹 remove traços e espaços
    clearControllers();
    setState(() => isLoading = true);

    try {
      Endereco? resultado;

      if (isOnline) {
        resultado = await viaCepService.buscarEndereco(cep);
        if (resultado != null && resultado.localidade != null) {
          resultado.cep = resultado.cep?.replaceAll(
            RegExp(r'[^0-9]'),
            '',
          ); // padroniza
          await salvarCep(resultado);
        }
      } else {
        resultado = cepsSalvos.firstWhere(
          (e) => e.cep?.replaceAll(RegExp(r'[^0-9]'), '') == cep,
          orElse: () => Endereco(),
        );
        if (resultado.cep == null || resultado.cep!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sem conexão e CEP não encontrado localmente"),
            ),
          );
        }
      }

      if (resultado != null && resultado.localidade != null) {
        setControllersCep(resultado);
      } else {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Atenção"),
            content: Text("CEP não encontrado"),
          ),
        );
      }
    } catch (e) {
      debugPrint("Erro ao buscar CEP: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void setControllersCep(Endereco e) {
    controllerCep.text = e.cep ?? '';
    controllerLogradouro.text = e.logradouro ?? '';
    controllerLocalidade.text = e.localidade ?? '';
    controllerComplemento.text = e.complemento ?? '';
    controllerUf.text = e.uf ?? '';
    controllerEstado.text = e.estado ?? '';
  }

  void clearControllers() {
    controllerLogradouro.clear();
    controllerLocalidade.clear();
    controllerComplemento.clear();
    controllerUf.clear();
    controllerEstado.clear();
  }

  Future<void> limparHistorico() async {
    await prefs.clearALL();
    cepsSalvos.clear();
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Histórico limpo")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            color: isOnline ? Colors.green : Colors.red,
          ),
          IconButton(
            onPressed: limparHistorico,
            icon: const Icon(Icons.delete_forever),
            tooltip: "Limpar histórico",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controllerCep,
              maxLength: 8,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CEP",
                border: const OutlineInputBorder(),
                suffixIcon: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => buscarCep(controllerCep.text),
                      ),
              ),
            ),
            const SizedBox(height: 10),

            // Exibe resultado
            if (controllerLogradouro.text.isNotEmpty)
              Column(
                children: [
                  campoTexto("Logradouro", controllerLogradouro),
                  campoTexto("Localidade", controllerLocalidade),
                  campoTexto("Complemento", controllerComplemento),
                  campoTexto("UF", controllerUf),
                  campoTexto("Estado", controllerEstado),
                ],
              ),

            const SizedBox(height: 20),
            const Divider(),
            const Text(
              "📋 CEPs Salvos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: cepsSalvos.isEmpty
                  ? const Center(child: Text("Nenhum CEP salvo"))
                  : ListView.builder(
                      itemCount: cepsSalvos.length,
                      itemBuilder: (context, index) {
                        final e = cepsSalvos[index];
                        return ListTile(
                          title: Text(e.cep ?? ''),
                          subtitle: Text(e.localidade ?? ''),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                          onTap: () => setControllersCep(e),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campoTexto(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
