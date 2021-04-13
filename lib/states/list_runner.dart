import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungrunner/models/runner_model.dart';
import 'package:ungrunner/states/show_runner.dart';
import 'package:ungrunner/utility/my_constant.dart';
import 'package:ungrunner/utility/my_serivce.dart';
import 'package:ungrunner/widgets/show_progress.dart';
import 'package:ungrunner/widgets/show_title_h1.dart';

class ListRunner extends StatefulWidget {
  @override
  _ListRunnerState createState() => _ListRunnerState();
}

class _ListRunnerState extends State<ListRunner> {
  List<RunnerModel> runnerModels = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    String path = '${MyConstant().domain}/ungtravel/getAllRunner.php';
    await Dio().get(path).then((value) {
      print('###### value = $value #######');
      for (var item in json.decode(value.data)) {
        RunnerModel model = RunnerModel.fromMap(item);
        setState(() {
          runnerModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/runner').then((value) {
          if (runnerModels.length != 0) {
            runnerModels.clear();
          }
          readData();
        }),
        child: Text('Add'),
      ),
      appBar: AppBar(
        title: Text('List Runner'),
      ),
      body: runnerModels.length == 0
          ? ShowProgress()
          : ListView.builder(
              itemCount: runnerModels.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowRunner(
                      runnerModel: runnerModels[index],
                    ),
                  ),
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowTitleH1(title: runnerModels[index].dateRunner),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Distance = ${MyService().myNumberFormat(double.parse(runnerModels[index].distance))} Km'),
                            Text(MyService().showClock(
                                int.parse(runnerModels[index].timeRunner))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
