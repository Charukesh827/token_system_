import 'dart:async';
import 'package:sqflite/sqflite.dart' as sql; //sqflite package
class TOK {
  Future<sql.Database> start() async{
    return sql.openDatabase(
      "tokkens.db",
      version:1,
      onCreate : (sql.Database db,int version) async{
        await create(db);
      });
  }

  Future create(sql.Database db) async {
    await db.execute("""
      CREATE TABLE student(
                    roll TEXT PRIMARY KEY ,
                    sname TEXT,
                    course TEXT,
                    dob TEXT,
                    yoj TEXT,
                    pass TEXT
                    )"""
    );

    await db.execute("""
        CREATE TABLE token (
                  roll TEXT ,
                  date TEXT,
                  veg INTEGER,
                  non INTEGER,
                  egg INTEGER,
                  CONSTRAINT p_key PRIMARY KEY (roll,date),   
                  CONSTRAINT f_key FOREIGN KEY (roll) REFERENCES login(roll)
                  )"""
    );
    await db.execute("""
      CREATE TABLE employee(
                    empid TEXT PRIMARY KEY ,
                    ename TEXT,
                    dob TEXT,
                    doj TEXT,
                    password TEXT
                    )"""
    );

    await db.execute("""
      create table eggs(
                  roll TEXT PRIMARY KEY,
                  count INTEGER
      )"""
    );

    await db.execute("""
      create table management(
                  id TEXT PRIMARY KEY,
                  pass TEXT
    )"""
    );
  }

   Future<void> ins_student(String num,String password) async {                                 //insert into student table
     final db = await start();
     var data = { 'roll': num, 'pass': password};
     await db.insert('student', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
   }

   Future<void> egg(String num,int e) async{                                                    //insert into egg table
      final db=await start();
      var data={'roll' : num,'count' : e};
      await db.insert('eggs',data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
   }


  Future<void> instoken(String num,int v,int nv,int e) async{                                  //insert into tokken table
    final db = await start();
    var datas = { 'roll': num,'veg' : v , 'non' : nv};
    await db.insert('token', datas,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    if (e!=0){
      egg(num,e);
    }
  }

  Future<void> insemployee(String num,String password) async{                                  //insert into employee table
    final db = await start();
    var data = { 'empid' : num , 'pass' : password };
    await db.insert('employee', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<void> ins_manage(String num,String pass) async{                                       //insert into management table
    final db=await start();
    var data={'id' : num , 'pass' : pass};
    await db.insert('management',data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<void> ins_MtoS(String num,String course,String name,String dob,String doj) async{          //inserting the student basic details by management
    final db=await start();
    var data={'roll' : num , 'sname' : name , 'course' : course , 'dob' : dob,'yoj': doj};
    await db.insert('student',data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<void> ins_MtoE(String id,String name,String dob,String doj) async{          //inserting the employee basic details by management
    final db=await start();
    var data={'empid' : id , 'ename' : name , 'dob' : dob,'doj': doj};
    await db.insert('student',data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<void> update_token(String num , int v, int nv,int e) async{                          //updating the token table
    final db = await start();
    var data={'veg' : v , 'non' : nv };
    await db.update('token',data,where:"num=?",whereArgs:[num]);
    if (e!=0){
      egg(num,e);
    }
  }

  Future<List<Map<String,dynamic>>> read_stud(String num) async {                                   //displaying the student
    final db=await start();
    return db.query('student',where:"num=?",whereArgs:[num]);
  }

  Future<List<Map<String,dynamic>>> read_emp(String num) async {                                   //displaying the employee
    final db=await start();
    return db.query('employee',where:"empid=?",whereArgs:[num]);
  }

  Future<List<Map<String,dynamic>>> read_manage(String num) async {                                //displaying the management
    final db=await start();
    return db.query('management',where:"id=?",whereArgs:[num]);
  }

  Future<void> del_MtoS(String num) async {                                                   //deleting student data by management
    final db=await start();
    await db.delete('student',where : "roll=?",whereArgs: [num]);
  }

  Future<void> del_MtoE(String num) async {                                                  //deleting student data by management
    final db=await start();
    await db.delete('employee',where : "empid=?",whereArgs: [num]);
  }

  /*Future<void> check_stud() async{
    final db=await start();

  }*/
}

