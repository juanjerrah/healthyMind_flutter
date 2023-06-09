import 'dart:convert';

import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hm/screens/humor_list_page.dart';
import 'package:http/http.dart' as http;

import '../../globals/color.dart';
import '../../utils/handlers.dart';

class HumorForm extends StatefulWidget {
  const HumorForm({super.key, this.item});
  final Map? item;

  @override
  State<HumorForm> createState() => _HumorFormState();
}

class _HumorFormState extends State<HumorForm> {
  bool isEdit = false;
  bool permiteVisualizacao = false;
  int tipoHumor = 0;

  TextEditingController tituloHumorController = TextEditingController();
  TextEditingController descricaoHumorController = TextEditingController();
  TextEditingController tipoHumorController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final item = widget.item;
    if (item != null) {
      isEdit = true;
      final titulo = item["tituloHumor"] as String;
      final tipoDoHumor = item["tipoDoHumor"] as int;
      final descricaoHumor = item["descricaoHumor"] as String;
      final anonimo = item["permiteVisualizacao"] as bool;
      tituloHumorController.text = titulo;
      descricaoHumorController.text = descricaoHumor;
      tipoHumor = tipoDoHumor;
      permiteVisualizacao = !anonimo;
    }
  }

  List<Map<dynamic, dynamic>> tiposHumor = [
    {
      "id": 1,
      "mensagem": "Me sentindo Feliz",
      "emoji": "lib/assets/happy2.svg"
    },
    {
      "id": 2,
      "mensagem": "Me sentindo Entediado",
      "emoji": "lib/assets/bored.svg"
    },
    {"id": 3, "mensagem": "Me sentindo Triste", "emoji": "lib/assets/sad.svg"},
    {
      "id": 4,
      "mensagem": "Me sentindo Confuso",
      "emoji": "lib/assets/confused2.svg"
    },
    {"id": 5, "mensagem": "Me sentindo Bravo", "emoji": "lib/assets/angry.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          "O que estou Sentindo",
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
              controller: tituloHumorController,
              style: const TextStyle(fontSize: 20, color: Color(0xff374957)),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xffd9d9d9),
                hintText: "Titulo do humor",
                hintStyle: TextStyle(color: Color(0xff374957)),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                contentPadding:
                    EdgeInsets.only(left: 16, top: 18, bottom: 18, right: 16),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: descricaoHumorController,
              maxLines: 12,
              style: const TextStyle(fontSize: 20, color: Color(0xff374957)),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xffd9d9d9),
                hintText: "Descreva a situação...",
                hintStyle: TextStyle(color: Color(0xff374957)),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 16, top: 18, bottom: 18),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: tipoHumor == 1 ? Colors.green : Colors.white,
                  child: IconButton(
                    onPressed: () => {
                      setState(() {
                        tipoHumor = 1;
                      })
                    },
                    icon: SvgPicture.asset("lib/assets/happy2.svg"),
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: tipoHumor == 2 ? Colors.green : Colors.white,
                  child: IconButton(
                    onPressed: () => {
                      setState(() {
                        tipoHumor = 2;
                      })
                    },
                    icon: SvgPicture.asset("lib/assets/bored.svg"),
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: tipoHumor == 3 ? Colors.green : Colors.white,
                  child: IconButton(
                    onPressed: () => {
                      setState(() {
                        tipoHumor = 3;
                      })
                    },
                    icon: SvgPicture.asset("lib/assets/sad.svg"),
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: tipoHumor == 4 ? Colors.green : Colors.white,
                  child: IconButton(
                    onPressed: () => {
                      setState(() {
                        tipoHumor = 4;
                      })
                    },
                    icon: SvgPicture.asset("lib/assets/confused2.svg"),
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: tipoHumor == 5 ? Colors.green : Colors.white,
                  child: IconButton(
                    onPressed: () => {
                      setState(() {
                        tipoHumor = 5;
                      })
                    },
                    icon: SvgPicture.asset("lib/assets/angry.svg"),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: permiteVisualizacao,
                    fillColor: MaterialStateProperty.all(cor),
                    onChanged: (bool? value) {
                      setState(() {
                        permiteVisualizacao = value!;
                      });
                    }),
                const Text(
                  "Tornar Anônimo",
                  style: TextStyle(color: Color(0xff374957), fontSize: 16),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(100, 5, 100, 5))),
              onPressed: isEdit ? update : submitHumor,
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

  Future<void> submitHumor() async {
    const header = {'accept': 'text/plain', 'Content-Type': 'application/json'};
    final titulo = tituloHumorController.text;
    final descricao = descricaoHumorController.text;

    final body = {
      "titulo": titulo,
      "descricao": descricao,
      "tipoHumor": tipoHumor,
      "permiteVisualizacao": !permiteVisualizacao
    };
    const urlBase = 'https://10.0.2.2:7053/api/Humor';

    final json = jsonEncode(body);

    final response =
        await http.post(Uri.parse(urlBase), headers: header, body: json);

    if (response.statusCode == 200) {
      tituloHumorController.text = '';
      descricaoHumorController.text = '';
      showSuccessMessage(context, "Creation Success");
      Navigator.pop(context);
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
    final titulo = tituloHumorController.text;
    final descricao = descricaoHumorController.text;

    const baseUrl = 'https://10.0.2.2:7053/api/Humor';

    final body = {
      "id": id,
      "titulo": titulo,
      "descricao": descricao,
      "tipoHumor": tipoHumor,
      "permiteVisualizacao": !permiteVisualizacao
    };

    final response = await http.put(
      Uri.parse(baseUrl),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json', "accept": "*/*"},
    );

    if (response.statusCode == 200) {
      showSuccessMessage(context, "Updation Success");
    } else {
      showErroMessage(context, "Updation Failed");
    }
  }
}
