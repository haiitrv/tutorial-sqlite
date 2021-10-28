import 'package:flutter/material.dart';
import 'package:sqlite_tutorial/sqlite/data_card.dart';
import 'package:sqlite_tutorial/sqlite/data_model.dart';
import 'package:sqlite_tutorial/sqlite/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  List<DataModel> datas = [];
  bool fetching = true;
  int currentIndex = 0;

  late DB db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DB();
    getData();
  }

  // getData() -> local function
  void getData() async {
    // getData() -> from database.dart
    datas = await db.getData();
    setState(() {
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SQLite Tutorial'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMyDilogue();
        },
        child: Icon(Icons.add),
      ),
      body: fetching
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: datas.length,
              itemBuilder: (context, index) => DataCard(
                data: datas[index],
                edit: edit,
                index: index,
                delete: delete,
              ),
            ),
    );
  }

  void showMyDilogue() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: subtitleController,
                    decoration: InputDecoration(labelText: 'Subtitle'),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    DataModel dataLocal = DataModel(
                        title: titleController.text,
                        subtitle: subtitleController.text);
                    db.insertData(dataLocal);
                    dataLocal.id = datas[datas.length - 1].id! + 1;
                    setState(() {
                      datas.add(dataLocal);
                    });
                    titleController.clear();
                    subtitleController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Save')),
            ],
          );
        });
  }

  // Update Dilogue
  void showMyDilogueUpdate() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: subtitleController,
                    decoration: InputDecoration(labelText: 'Subtitle'),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    DataModel newData = datas[currentIndex];
                    newData.subtitle = subtitleController.text;
                    newData.title = titleController.text;
                    db.update(newData, newData.id!);
                    setState(() {

                    });
                    Navigator.pop(context);
                  },
                  child: Text('Update')),
            ],
          );
        });
  }

  // Edit method
  void edit(index) {
    // Display the previous value -> Easier to edit
    currentIndex = index;
    titleController.text = datas[index].title;
    subtitleController.text = datas[index].subtitle;
    showMyDilogueUpdate();
  }

  // Delete method
  void delete(int index) {
    db.delete(datas[index].id!);
    setState(() {
      datas.removeAt(index);
    });
  }
}
