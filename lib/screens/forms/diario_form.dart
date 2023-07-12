import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hm/globals/color.dart';
import 'package:hm/screens/home.dart';
import 'package:http/http.dart' as http;

import '../../utils/handlers.dart';

class DiarioForm extends StatefulWidget {
  const DiarioForm({super.key, this.item});
  final Map? item;

  @override
  State<DiarioForm> createState() => _DiarioFormState();
}

class _DiarioFormState extends State<DiarioForm> {
  bool isEdit = false;
  TextEditingController diarioController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final item = widget.item;
    if (item != null) {
      isEdit = true;
      final diario = item['descricao'];
      diarioController.text = diario;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          "Meu Diário",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: cor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              controller: diarioController,
              style: const TextStyle(fontSize: 20, color: Color(0xff374957)),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xffd9d9d9),
                hintText: "Fique a vontade para escrever aqui...",
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              maxLines: 18,
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(100, 5, 100, 5))),
              onPressed: isEdit ? update : submit,
              child: Text(
                isEdit ? "Atualizar" : "Salvar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submit() async {
    const header = {'accept': 'text/plain', 'Content-Type': 'application/json'};
    final diario = diarioController.text;
    final body = {
      "Descricao": diario,
    };
    const urlBase = 'https://10.0.2.2:7275/api/Diario';

    final json = jsonEncode(body);

    final response =
        await http.post(Uri.parse(urlBase), headers: header, body: json);

    if (response.statusCode == 200) {
      diarioController.text = '';
      showSuccessMessage(context, "Creation Success");
      NavigateToDiaryListPage;
      print("Success");
    } else {
      //showErroMessage("Creation Failed");
      print("Failed");
    }

    print(response.body);
  }

  Future<void> update() async {
    final item = widget.item;
    if (item == null) {
      print("Todo can not be updated without data");
      return;
    }
    final id = item["id"];
    final diario = diarioController.text;

    const baseUrl = 'https://10.0.2.2:7275/api/Diario';

    final body = {
      "id": id,
      "Descricao": diario,
    };

    final response = await http.put(
      Uri.parse(baseUrl),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json', "accept": "*/*"},
    );

    if (response.statusCode == 200) {
      showSuccessMessage(context, "Diário atualizado com sucesso");
    } else {
      showErroMessage(context, "Updation Failed");
    }
  }

  Future<void> NavigateToDiaryListPage() async {
    final route = MaterialPageRoute(
      builder: (context) => HomePage(),
    );
    await Navigator.push(context, route);
  }
}
