
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddRecipeBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddRecipeBookPageState();
}

class _AddRecipeBookPageState extends State<AddRecipeBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Recipe Book"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(

    );
  }
}