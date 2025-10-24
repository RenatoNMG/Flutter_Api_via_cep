import 'package:cosumodeapi/Models/user_model.dart';
import 'package:cosumodeapi/Services/firebase_service.dart';
import 'package:cosumodeapi/widget/card_user.dart';
import 'package:flutter/material.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({super.key});

  @override
  State<ListUsers> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListUsers> {
  final FirebaseService _firebaseService = FirebaseService(
    collectionName: "usuarios",
  );
  List<User> usuarios = [];

  Future<void> carregarUsers() async {
    try {
      List<User> users = [];
      final listaDados = await _firebaseService.readAll();

      for (var dados in listaDados) {
        User user = User.fromap(dados, dados["id"]);
        users.add(user);
      }

      setState(() {
        usuarios = users;
      });
    } catch (erro) {
      print("Erro ao carregar usuarios: $erro");
    }
  }

  @override
  void initState() {
    super.initState();
    carregarUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 3, 165, 89),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Lista de Usuarios",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    ...usuarios.map((usuario) {
                      return CardUser(
                        nome: usuario.nome,
                        email: usuario.email,
                        telefone: usuario.telefone,
                        cpf: usuario.cpf,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
