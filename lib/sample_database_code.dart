/*class DatabaseHelper extends ChangeNotifier{
  static const _databaseName = "token.db";
  static const _databaseVersion = 1;
  static const table='token';
  int eggState=0;
  int vegState=0;
  int nonVegState=0;

  late Database _db;

  Future<void> init()async{
    final documentsDirectory = await  getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path , _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async{
    await db.execute("""CREATE TABLE $table (
        ROLL VARCHAR(7) PRIMARY KEY,
        VEG INTEGER,
        NONVEG INTEGER,
        EGG INTEGER
        )""");
  }

  Future<void> insert(String roll,int veg,int nonveg, int egg)async{
    _db.execute("INSERT INTO TABLE VALUES ?,?,?,?",[roll,veg,nonveg,egg]);
  }

  Future<void> updateVeg(String roll,int veg)async{
    _db.execute("UPDATE TOKEN SET VEG=? WHERE ROLL=?",[veg,roll]);
    vegState=veg;
    notifyListeners();
  }

  Future<void> updateNonVeg(String roll,int nonVeg)async{
    _db.execute("UPDATE TOKEN SET NONVEG=? WHERE ROLL=?",[nonVeg,roll]);
    nonVegState=nonVeg;
    notifyListeners();
  }

  Future<void> updateEgg(String roll, int egg)async{
    _db.execute("UPDATE TOKEN SET egg=(SELECT EGG FROM TOKEN WHERE ROLL=?)+? WHERE ROLL=?",[roll,egg,roll]);
    eggState=egg;
    notifyListeners();
  }

  Future<void>? getVeg(String roll){
    vegState=_db.execute("SELECT VEG FROM TOKEN WHERE ROLL=?",[roll]) as int;

  }
}*/