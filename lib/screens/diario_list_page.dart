import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hm/screens/forms/diario_form.dart';
import 'package:http/http.dart' as http;

import '../utils/handlers.dart';

class DiarioListPage extends StatefulWidget {
  DiarioListPage({super.key});

  @override
  State<DiarioListPage> createState() => _DiarioListPageState();
}

class _DiarioListPageState extends State<DiarioListPage> {
  List diarios = [];
  bool isLoading = true;
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
          visible: diarios.isNotEmpty,
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
                  SvgPicture.asset("lib/assets/Diary-bro.svg"),
                ],
              ),
            ),
          ),
          child: ListView.builder(
            itemCount: diarios.length,
            itemBuilder: (context, index) {
              final item = diarios[index] as Map;
              final id = item['id'] as String;
              final formatDate = formatarData(item["dataInclusao"]);
              final diaDaSemana = obterNomeDia(item["dataInclusao"]);
              return InkWell(
                onTap: () => NavigateToEditPage(item),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  color: const Color(0xffd9d9d9),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(diaDaSemana),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                    subtitle: Text(
                      formatDate,
                      style: const TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      onPressed: () => deleteById(id),
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> FetchAll() async {
    const urlBase = 'https://10.0.2.2:7275/api/Diario';
    const header = {'accept': 'text/plain'};

    final response = await http.get(Uri.parse(urlBase), headers: header);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json as List;
      setState(() {
        diarios = result;
      });
    }

    print(diarios);

    setState(() {
      isLoading = false;
    });

    print(response.body);
  }

  String formatarData(String dataStr) {
    DateTime data = DateTime.parse(dataStr);
    String dia = data.day.toString().padLeft(2, '0');
    String mes = data.month.toString().padLeft(2, '0');
    String ano = data.year.toString();
    return '$dia/$mes/$ano';
  }

  String obterNomeDia(String data) {
    final dataFormat = DateTime.parse(data);

    List<String> nomesDias = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    return nomesDias[dataFormat.weekday - 1];
  }

  Future<void> NavigateToDiaryFormPage() async {
    final route = MaterialPageRoute(
      builder: (context) => DiarioForm(),
    );
    await Navigator.push(context, route);
  }

  Future<void> NavigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => DiarioForm(item: item),
    );
    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });
    FetchAll();
  }

  Future<void> deleteById(String id) async {
    final baseUrl = 'https://10.0.2.2:7275/api/Diario?id=$id';
    const header = {"accept": "*/*"};

    var response = await http.delete(Uri.parse(baseUrl), headers: header);

    if (response.statusCode == 200) {
      final filtered = diarios.where((element) => element['id'] != id).toList();

      setState(() {
        diarios = filtered;
      });

      showSuccessMessage(context, "Deletion Succeded");
    } else {
      showErroMessage(context, "Deletion Failed");
    }

    print(response.statusCode);
  }
}
