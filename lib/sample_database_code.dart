import 'dart:async';
import "package:aquedart/aquedart.dart"; // for working with api
import "package:mysql1/mysql1.dart" ; //mysql1

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
                    pass varchar(15),
                    CONSTRAINT ck_roll check (roll in (regexp_like (roll,'^(2-4){2}[a-z]{1}(0-9){3}')),((regexp_like (roll,'^(2-4){2}[a-z]{2}(0-9){2}'))),
                    constraint cou_chk check (course in (
                                                            'Automobile Engineering',
                                                            'Biomedical Engineering',
                                                            'Civil Engineering',
                                                            'Computer Science and Engineering (AI and ML)',
                                                            'Computer Science Engineering',
                                                            'Electrical and Electronics Engineering',
                                                            'Instrumentation and Control Engineering',
                                                            'Mechanical Engineering',
                                                            'Metallurgical Engineering',
                                                            'Production Engineering',
                                                            'Robotics Engineering',
                                                            'Bio Technology',
                                                            'Fashion Technology',
                                                            'Information Technology',
                                                            'Textile Technology',
                                                            'Electrical and Electronics Engineering(Sandwich)',
                                                            'Mechanical Engineering(Sandwich)',
                                                            'Production Engineering(Sandwich)',
                                                            'Applied Science',
                                                            'Computer Systems and Design',
                                                            'Applied Electronics',
                                                            'Automobile Electronics',
                                                            'Biometrics and Cybersecurity',
                                                            'Communication Systems',
                                                            'Compiuter Integrated and Manufacturing',
                                                            'Msc Software Systems',
                                                            'Msc Cyber Security',
                                                            'Msc Data Science',
                                                            'Msc Theoretical Computer Science',
                                                            'Msc Applied Mathematics',
                                                            'MBA', 
                                                        )),
                    constraint chk_date  check(yoj<=DATE_SUB(NOW(),INTERVAL 5 YEAR) or yoj<=DATE_SUB(NOW(),INTERVAL 3 YEAR))
                    )"""
    );

    await conn.query("""
        CREATE TABLE token (
                  roll varchar(15) ,
                  dat date,
                  veg int,
                  non int,
                  CONSTRAINT p_key PRIMARY KEY (roll,dat),   
                  CONSTRAINT f_key FOREIGN KEY (roll) REFERENCES login(roll)
                  )"""
    );
    await conn.query("""
      CREATE TABLE employee(
                    empid varchar(5) PRIMARY KEY ,
                    ename varchar(15),
                    dob date,
                    doj date,
                    pass varchar(15),
                    CONSTRAINT chk_id check (regexp_like(empid,'^C(1-9){4}'))
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

    await conn.query("""
      create table tot_counts(
                  Date date,
                  used_veg int,
                  not_used_veg int,
                  used_non_veg int,
                  not_used_non_veg int,
                  egg int
    )"""
    );
  }



  //LOGIN PAGE CHECKING

  void login(String num,String password) {
   if(num[0] == '2' && num[1]== '2'){
     chk_student(num, password);
   }
   else if(num[0]=='E'){
     chk_employee(num,password);
   }
   else if(num[0]=='M'){
     chk_manage(num,password);
   }
  }

  //CHECKING THE STUDENT DATA

   Future<dynamic> chk_student(String num,String password) async {
      final conn=await start();
      final res=await conn.query('SELECT * FROM student where roll=?',[num]);

      if (res.isEmpty){
        return 0;
      }

      else {
        return 1;
      }
   }

  //CHECKING THE EMPLOYEE DATA

  Future<dynamic> chk_employee(String num,String password) async{
    final conn=await start();

    final res=await conn.query('SELECT * FROM employee where empid=?',[num]);

    if (res.isEmpty){
      return 0;
    }

    else {
      return 1;
    }

  }

  Future <dynamic> chk_manage(String num,String pass) async{
    final conn=await start();
    await conn.query('insert into management (id,pass) values(?,?)',[num,pass]);
  }

  //INSERTING DATA TO TOTAL_COUNTS TABLE

  Future<dynamic> ins_tot_counts(String dat,int tot_veg,int tot_non,) async {
    final conn=await start();
    await conn.query('''INSERT INTO tot_count (used_veg)
        SELECT SUM(veg)
    FROM token where date=?''',[dat]);

    await conn.query('''INSERT INTO tot_count (used_non_veg)
        SELECT SUM(non)
    FROM token where date=?''',[dat]);

    await conn.query('''insert into tot_count (not_used_veg) select sum(used_veg)
                        from token where date=?''',[dat]);

    await conn.query('''update tot_count set(not_used_veg)=tot_veg-not_used_veg
                        where date=?''',[dat]);

    await conn.query('''insert into tot_count (not_used_non_veg) select sum(used_not_veg)
                        from token where date=?''',[dat]);

    await conn.query('''update tot_count set(not_used_non_veg)=tot_non-not_used_non_veg
                        where date=?''',[dat]);

  }

   //INSERT THE DATA IN EGG TABLE

   Future<dynamic> ins_egg(String num,int e) async{
     final conn=await start();
     final res=await conn.query('SELECT * FROM student where roll=?',[num]);

     if (res.isEmpty){
       await conn.query('INSERT INTO student (roll,count) VALUES (?,?)',[num,e]);
     }

     else {
       await conn.query('update eggs set count=? where roll=?',[e,num]);
     }
     return 1;
   }

  //INSERT THE DATA IN TOKEN TABLE

  Future ins_token(String num,int v,int nv,int e,String dat) async{
    final conn=await start();
    final res=await conn.query('select * from token where roll=?',[num]);

    if(res.isEmpty) {
      await conn.querry('insert into token (roll,veg,non,date) values(?,?,?,?)', [num, v, nv,dat]);
    }

    else{
      await conn.query('update token set non=? , veg=? , date=? where roll=?',[nv,v,dat,num]);
    }


    if (e!=0){
      ins_egg(num,e);
    }
    check(num);
    return 1;
  }

  //FUNCTION TO CHECK IF THE STUDENT HAS EMPTY RECORDS

  Future<dynamic> check(String num) async{
    final conn=await start();
    await conn.query('delete from token where veg=0 and non=0 and roll=?',[num]);
  }

  //INSERT BASIC DETAILS OF THE STUDENT

  Future<dynamic> ins_MtoS(String num,String course,String name,String dob,String doj) async{
    final conn=await start();

    final res=await conn.query('select * from student where roll=?',[num]);

    if(res.isEmpty) {
      await conn.querry('insert into student (roll,sname,course,dob,yoj) values(?,?,?,?,?)', [num,name,course,dob,doj]);
      return 1;
    }

    else{
        return 0;
     }
  }

  //INSERTING THE BASIC DETAILS OF EMPLOYEE

  Future ins_MtoE(String id,String name,String dob,String doj) async{
    final conn=await start();

    final res=await conn.query('select * from employee where empid=?',[num]);

    if(res.isEmpty) {
      await conn.querry('insert into employee (empid,ename,dob,doj) values(?,?,?,?)', [num,name,dob,doj]);
      return 1;
    }

    else{
      return 0;
    }
  }

  //DISPLAYING THE STUDENT DETAILS

  Future<dynamic> read_stud(String num) async {
    final conn=await start();
    return conn.query('select roll,sname,dob,yoj,extract(year from current_date)-extract(year from doj) as year from student where roll=? and  year<5',[num]);
  }

  //DISPLAYING THE EMPLOYEE DETAILS

  Future<dynamic> read_emp(String num) async {
    final conn=await start();
    var res=await conn.query('select empid,ename,dob,doj,extract(year from current_date)-extract(year from doj) as experience from employee where empid=? ',[num]);
  }

  //DELETING THE STUDENT DETAILS

  Future<dynamic> del_MtoS(String num) async {
    final conn=await start();
    final res=await conn.query('select * from student where roll=?',[num]);

    if(res.isEmpty){
        return 0;
    }
    else{
      await conn.query('delete from student where roll=?',[num]);
      return 1;
    }
  }

  //DELETING THE EMPLOYEE DATA

  Future<dynamic> del_MtoE(String num) async {
    final conn = await start();
    final res=await conn.query('select * from employee where empid=?',[num]);

    if(res.isEmpty){
      return 0;
    }

    else{
      await conn.query('delete from employee where empid=?',[num]);
      return 1;
    }
  }