import 'package:flutter/material.dart';
import 'package:flutter_mvvm_core/flutter_mvvm_core.dart';

import '../view_models/{{name_snake}}_view_model.dart';

class {{name}}View extends StatelessWidget {
  const {{name}}View({super.key, required {{name}}ViewModel {{name_camel}}ViewModel})
    : _{{name_camel}}ViewModel = {{name_camel}}ViewModel;

  final {{name}}ViewModel _{{name_camel}}ViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<{{name}}ViewModel>(
      viewModel: _{{name_camel}}ViewModel,
      builder: (BuildContext context, {{name}}ViewModel vm, Widget? child) =>
          const Scaffold(
            appBar: CustomAppBar(title: '{{name}}View'),
            body: Center(child: Text('Welcome to {{name}}View')),
          ),
    );
  }
}
