
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginaPrincipal extends StatefulWidget {
  PaginaPrincipal({Key key, this.titulo}) : super(key: key);

  final String titulo;

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}


class _PaginaPrincipalState extends State<PaginaPrincipal> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _pesoControle = TextEditingController();
  TextEditingController _alturaControle = TextEditingController();
  String _result;

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _pesoControle.text = '';
    _alturaControle.text = '';
    setState(() {
      _result = 'Informe seu peso e altura';
    });
  }

  void calcularIMC() {
    double peso = double.parse(_pesoControle.text);
    double altura = double.parse(_alturaControle.text) / 100.0;
    double imc = peso / (altura * altura);

    setState(() {
      _result = "IMC = ${imc.toStringAsPrecision(2)}\n";
      if (imc < 18.5)
        _result += "Abaixo do peso";
      else if (imc >18.5 && imc <=24.9)
        _result += "Peso normal";
      else if (imc >= 25 && imc <= 29.9)
        _result += "Sobrepeso";
      else if (imc > 30 && imc <= 34.9)
        _result += "Obesidade Grau I";
      else if (imc > 35 && imc <= 39.9)
        _result += "Obesidade Grau II";
      else
        _result += "Obesidade Grau III";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0), child: buildForm()));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calculadora de IMC'),
      backgroundColor: Colors.purple,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            resetFields();
          },
        )
      ],
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Peso (kg). Dica: Não insira pontos ou vírgulas.",
              error: "Informe um peso!.",
              controller: _pesoControle),
          buildTextFormField(
              label: "Altura (cm). Dica: Não insira pontos ou vírgulas.",
              error: "Informe uma altura!",
              controller: _alturaControle),
          buildTextResult(),
          buildCalculateButton(),
        ],
      ),
    );
  }

  Padding buildCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            calcularIMC();
          }
        },
        child: Text('CALCULAR', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  Padding buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: Text(
        _result,
        textAlign: TextAlign.center,
      ),
    );
  }

  TextFormField buildTextFormField(
      {TextEditingController controller, String error, String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text.isEmpty ? error : null;
      },
    );
  }
}