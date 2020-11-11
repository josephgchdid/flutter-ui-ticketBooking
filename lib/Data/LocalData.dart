import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flight/Classes/City.dart';

class LocalData {
  String _dbName = "flight.db";
  String _table = 'countries';
  String _columnCityCode = 'code';
  String _columnCountryCode = 'country_code';
  String _columnCityName = 'name';
  String path;
  Database _db;

  LocalData();

  Future  _open() async {
    path = join(await getDatabasesPath(), _dbName); 
   _db = await openDatabase(path, version: 1,
    onCreate: (Database db, int version)  async{
      await db.execute("CREATE TABLE $_table ($_columnCityCode TEXT, $_columnCityName TEXT, $_columnCountryCode TEXT);");
    }
   );
 }

 Future insertBatch(List<City> rows) async {
   try {
      int i = 0;
     await _open();
     await _db.transaction((txn) async {
       Batch batch =  txn.batch();
       for(var data in rows) {
         Map<String,dynamic> row = {
           _columnCityCode : data.cityCode,
           _columnCityName : data.cityName,
           _columnCountryCode : data.countryCode
         };
         batch.insert(_table, row);
         i++;
       }
       await batch.commit(noResult: true);
     });
    print("Inserted $i");
    await _db.close();
   }catch(Exception){}
 }
 
 Future<List<Map>> getRecords() async {
   await _open();
   var result = await _db.rawQuery("SELECT * FROM $_table ORDER BY $_columnCityName;");
   await _db.close();
   return result;
 }
}