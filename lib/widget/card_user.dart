import 'package:flutter/material.dart';

class CardUser extends StatelessWidget {

  String? nome;
  String? email;
  String? telefone;
  String? cpf;

   CardUser({this.nome, this.email, this.telefone, this.cpf, super.key});


  @override
  Widget build(BuildContext context) {
    return Card(
                        child: ListTile(
                          subtitle: Column(
                            children: [
                              Row(
                                spacing: 40,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.teal,
                                    child: Text(
                                      nome[0],
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Nome: ${nome}"),
                                      Text("Email: ${email}"),
                                      Text("Telefone: ${telefone}"),
                                      Text("CPF: ${cpf}"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );;
  }
}