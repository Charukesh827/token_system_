import 'dart:async';
import "package:mysql1/mysql1.dart" ; //mysql1

class TOK {

  Future start() async{
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host : 'localhost',
      port: 3306,
      user: 'root',
      db: 'token',
      password: 'tokendatabase1.,'
    ));
    return conn;
  }


 Future create(dynamic conn) async {
    conn=await start();
    await conn.query("""
      CREATE TABLE student(
                    roll varchar(15) PRIMARY KEY ,
                    sname varchar(15),
                    course varchar(15),
                    dob date,
                    yoj date,
                    pass varchar(15)
                    )"""
    );

    await conn.query("""
        CREATE TABLE token (
                  roll varchar(15) ,
                  dat date,
                  veg int,
                  non int,
                  egg int,
                  CONSTRAINT p_key PRIMARY KEY (roll,dat),   
                  CONSTRAINT f_key FOREIGN KEY (roll) REFERENCES login(roll)
                  )"""
    );
    await conn.query("""
      CREATE TABLE employee(
                    empid varchar(15) PRIMARY KEY ,
                    ename varchar(15),
                    dob date,
                    doj date,
                    password varchar(15)
                    )"""
    );

    await conn.query("""
      create table eggs(
                  roll varchar(15) PRIMARY KEY,
                  count int
      )"""
    );

    await conn.query("""
      create table management(
                  id varchar(15) PRIMARY KEY,
                  pass varchar(15)
    )"""
    );
  }

   Future ins_student(String num,String password) async {                                 //insert into student table
      final conn=await start();
      await conn.query('insert into values(roll,pass) values (?,?)',[num,password]);
   }

   Future ins_egg(String num,int e) async{                                                    //insert into egg table
     final conn=await start();
      await conn.query('insert into values(roll,count) values (?,?)',[num,e]);
   }


  Future ins_token(String num,int v,int nv,int e) async{                                  //insert into token table
    final conn=await start();
    await conn.querry('insert into token (roll,veg,non) values(?,?,?)',[num,v,nv]);
    if (e!=0){
      ins_egg(num,e);
    }
  }

  Future ins_employee(String num,String password) async{                                  //insert into employee table
    final conn=await start();
    await conn.query('insert into employee (empid,pass) values(?,?)',[num,password]);
  }

  Future ins_manage(String num,String pass) async{                                       //insert into management table
    final conn=await start();
    await conn.query('insert into management (id,pass) values(?,?)',[num,pass]);
  }

  Future ins_MtoS(String num,String course,String name,String dob,String doj) async{          //inserting the student basic details by management
    final conn=await start();
    await conn.query('update student set sname=?,course=?,dob=?,yoj=? where roll=?',[name,course,dob,doj,num]);
  }

  Future ins_MtoE(String id,String name,String dob,String doj) async{          //inserting the employee basic details by management
    final conn=await start();
    await conn.query('update employee set ename=?,dob=?,doj=? where empid=?',[name,dob,doj,id]);
  }

  Future update_token(String num , int v, int nv,int e) async{                          //updating the token table
    final conn = await start();
    await conn.query('update token set veg=?,non=? where roll=?',[v,nv,num]);
    if (e!=0){
      ins_egg(num,e);
    }
  }

  Future read_stud(String num) async {                                   //displaying the student
    final conn=await start();
    return conn.query('select roll,sname,dob,yoj,extract(year from current_date)-extract(year from doj) as year from student where roll=? and  year<5',[num]);
  }

  Future read_emp(String num) async {                                   //displaying the employee
    final conn=await start();
    var res=await conn.query('select empid,ename,dob,doj,extract(year from current_date)-extract(year from doj) as experience from employee where empid=? ',[num]);
  }

  Future read_manage(String num) async {                                //displaying the management
    final conn=await start();
    var res=await conn.query('select id,pass from management',[num]);
  }

  Future<void> del_MtoS(String num) async {                                                   //deleting student data by management
    final conn=await start();
    await conn.query('delete from student where roll=?',[num]);
  }

  Future<void> del_MtoE(String num) async {                                                  //deleting student data by management
    final conn=await start();
    await conn.query('delete from employee where empid=?',[num]);
  }

  /*Future<void> check_stud() async{
    final db=await start();

  }*/
}




