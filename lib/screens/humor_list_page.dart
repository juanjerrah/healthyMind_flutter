import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:hm/screens/forms/humor_form_page.dart';
import 'package:http/http.dart' as http;

import '../utils/handlers.dart';

class HumorListPage extends StatefulWidget {
  const HumorListPage({super.key});

  @override
  State<HumorListPage> createState() => _HumorListPageState();
}

class _HumorListPageState extends State<HumorListPage> {
  List humores = [];
  bool isLoading = true;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      replacement: RefreshIndicator(
        onRefresh: FetchAll,
        child: Visibility(
          //false para mostrar o svg
          visible: humores.isNotEmpty,
          replacement: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Minha caixinha de pensamentos",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(55, 73, 87, 1)),
                    textAlign: TextAlign.center,
                  ),
                  SvgPicture.asset("lib/assets/Chakras-bro.svg"),
                ],
              ),
            ),
          ),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int humorIndex) {
              final item = humores[humorIndex] as Map;
              final id = item['id'] as String;
              final tipoHumor = item["tipoDoHumor"] as int;
              return ListTile(
                onTap: () => NavigateToEditPage(item),
                title: Text(
                  tiposHumor[tipoHumor - 1]["mensagem"],
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  humores[humorIndex]['tituloHumor'],
                  maxLines: 1,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                  ),
                ),
                leading: SizedBox(
                  width: 40,
                  child: SvgPicture.asset(tiposHumor[tipoHumor - 1]["emoji"]),
                ),
                trailing: CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.delete_rounded),
                    onPressed: () {
                      AlertDialog(
                        title: const Text("Excluir Humor"),
                        content: const Text("Certeza que deseja excluir o registro"),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Apagar'),
                            onPressed: () {
                              deleteById(id);
                            },
                          ),
                        ],
                      );
                    },
                    color: Colors.redAccent,
                  ),
                ),
              );
            },
            itemCount: humores.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> FetchAll() async {
    const urlBase = 'https://10.0.2.2:7053/api/Humor';
    const header = {'accept': 'text/plain'};

    final response = await http.get(Uri.parse(urlBase), headers: header);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json as List;
      setState(() {
        humores = result;
      });
    }

    print(humores);

    setState(() {
      isLoading = false;
    });

    print(response.body);
  }

  Future<void> deleteById(String id) async {
    final baseUrl = 'https://10.0.2.2:7053/api/Humor?id=$id';
    const header = {"accept": "*/*"};

    var response = await http.delete(Uri.parse(baseUrl), headers: header);

    if (response.statusCode == 200) {
      final filtered = humores.where((element) => element['id'] != id).toList();

      setState(() {
        humores = filtered;
      });

      showSuccessMessage(context, "Excluído com sucesso");
    } else {
      showErroMessage(context, "Falha ao tentar excluir");
    }

    print(response.statusCode);
  }

  Future<void> NavigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => HumorForm(item: item),
    );
    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });
    FetchAll();
  }

  String formatarTexto(String texto) {
    if (texto.length > 19) {
      return "${texto.substring(0, 19)}...";
    } else {
      return texto;
    }
  }
}
