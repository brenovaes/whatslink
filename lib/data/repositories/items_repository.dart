import 'package:whatslink/data/models/Data.dart';
import 'package:whatslink/data/provider/database_helper.dart';

class ItemsRepository {
  getAllItems() async =>
      DatabaseHelper.instance.queryAllRows().then((value) => {value});

  void addData(Data item) async {
    print('aqui no repo');
    await DatabaseHelper.instance.insert(item);
  }
}
