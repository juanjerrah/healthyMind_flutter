import 'dart:convert';

import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hm/globals/color.dart';
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

  List<Map> tiposHumores = [
    {"nome": "Feliz", "emoji": AnimatedEmoji(AnimatedEmojis.smile)},
    {"nome": "Entediado", "emoji": AnimatedEmoji(AnimatedEmojis.neutralFace)},
    {"nome": "Triste", "emoji": AnimatedEmoji(AnimatedEmojis.cry)},
    {"nome": "Confuso", "emoji": AnimatedEmoji(AnimatedEmojis.thinkingFace)},
    {"nome": "Bravo", "emoji": AnimatedEmoji(AnimatedEmojis.angry)},
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
          child: ListView.builder(
            itemCount: humores.length,
            itemBuilder: ((context, index) {
              final item = humores[index] as Map;
              final id = item['id'] as String;

              final titulo = item["tituloHumor"] as String;
              final tipoHumor = item["tipoDoHumor"] as int;

              return InkWell(
                onTap: () => NavigateToEditPage(item),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xffd9d9d9),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 9, 8, 9),
                    title: Row(
                      children: [
                        Text(
                          "Me sentindo ${tiposHumores[tipoHumor - 1]["nome"]}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff374957)),
                        ),
                        tiposHumores[tipoHumor - 1]["nome"] == "Feliz"
                            ? const AnimatedEmoji(AnimatedEmojis.smile)
                            : tiposHumores[tipoHumor - 1]["nome"] == "Entediado"
                                ? const AnimatedEmoji(
                                    AnimatedEmojis.neutralFace)
                                : tiposHumores[tipoHumor - 1]["nome"] ==
                                        "Triste"
                                    ? const AnimatedEmoji(AnimatedEmojis.cry)
                                    : tiposHumores[tipoHumor - 1]["nome"] ==
                                            "Confuso"
                                        ? const AnimatedEmoji(
                                            AnimatedEmojis.thinkingFace)
                                        : tiposHumores[tipoHumor - 1]["nome"] ==
                                                "Bravo"
                                            ? const AnimatedEmoji(
                                                AnimatedEmojis.angry)
                                            : const AnimatedEmoji(
                                                AnimatedEmojis.kissingHeart),
                      ],
                    ),
                    subtitle: Text(
                      formatarTexto(titulo),
                      style: const TextStyle(
                          fontSize: 25,
                          color: Color(0xff374957),
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: IconButton(
                      onPressed: () => deleteById(id),
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ),
              );
            }),
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

      showSuccessMessage(context, "Deletion Succeded");
    } else {
      showErroMessage(context, "Deletion Failed");
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
