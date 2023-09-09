import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:token_system/register_item.dart';
class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listItems=<int>[0,0,0];
  int veg=0;
  Color vegcolor=Colors.white;
  double vegElevate=10;
  bool? vegable;

  int nonVeg=0;
  Color nonvegcolor=Colors.white;
  double nonvegElevate=10;
  bool? nonvegable;

  int egg=0;
  Color eggcolor=Colors.white;
  int getegg=0;

  double eggElevate=10;

  @override
  Widget build(BuildContext context) {
    nonvegable=(listItems[0]==0)? true:false;
    vegable=(listItems[0]==0)? true:false;

    var register=context.watch<Register>();
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xff000428),Color(0xff004e92)]),
        ),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            const Divider(
              color: Colors.blueGrey,
            ),
            Card(
              color: Colors.transparent,
              elevation: nonvegElevate,
              child: ListTile(
                leading: const Icon(Icons.kebab_dining,color: Colors.white,),
                title: const Text('Non-veg',style: TextStyle(color: Colors.white),),
                subtitle: const Text('Chicken \n Date: \n Day:',style: TextStyle(color: Colors.white),),
                trailing: Ink(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    //enableFeedback: nonvegable,
                    icon: const Icon(Icons.add),
                    color: nonvegcolor,
                    onPressed: () {setState(() {
                      if(nonVeg==1){
                        nonVeg=0;
                        nonvegElevate=10;
                        nonvegcolor=Colors.white;
                        listItems[0]=0;
                      }else{
                        nonVeg=1;
                        nonvegElevate=30;
                        nonvegcolor=Colors.green;
                        listItems[0]=1;
                      }
                    });
                    },
                  ),
                ),
              ),
            ),
            const Divider(
              height: 30,
              color: Colors.blueGrey,
            ),
            Card(
              color: Colors.transparent,
              elevation: vegElevate,
              child: ListTile(
                leading: const Icon(Icons.soup_kitchen,color: Colors.white,),
                title: const Text('Veg',style: TextStyle(color: Colors.white),),
                subtitle: const Text('Califlower \n Date: \n Day:',style: TextStyle(color: Colors.white),),
                trailing: Ink(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: vegcolor,
                    onPressed: () {
                      setState(() {
                        if(veg==1){
                          veg=0;
                          vegElevate=10;
                          vegcolor=Colors.white;
                          listItems[1]=0;
                        }else{
                          veg=1;
                          vegElevate=30;
                          vegcolor=Colors.green;
                          listItems[1]=1;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            const Divider(
              height: 30,
              color: Colors.blueGrey,
            ),
            Card(
              color: Colors.transparent,
              elevation: eggElevate,
              child: ListTile(
                leading: const Icon(Icons.egg,color: Colors.white,),
                title: const Text('Egg',style: TextStyle(color: Colors.white),),
                subtitle: Row(
                  children:[
                    TextButton(onPressed: (){setState(() {
                      egg+=15;
                    });
                    }, child: const Icon(Icons.add,color: Colors.white,),
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Text('$egg',style: TextStyle(color: Colors.white),),
                    ),
                    TextButton(onPressed: (){setState(() {
                      egg-=(egg!=0)?15:0;
                    });
                    }, child: const Icon(Icons.remove,color: Colors.white,)),
                  ],
                ),
                trailing: Ink(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: eggcolor,
                    onPressed: () {
                      setState(() {
                        if(getegg==1) {
                          getegg=0;
                          eggElevate = 10;
                          eggcolor=Colors.white;
                          listItems[2]=0;
                        }else{
                          getegg=1;
                          eggElevate=30;
                          eggcolor=Colors.green;
                          listItems[2]=egg;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            const Divider(
              height: 30,
              color: Colors.blueGrey,
            ),
            Card(
              color: Colors.transparent,
              child: Column(
                children: [
                  Text("\nYour token can be altered only before\n",style: TextStyle(color: Colors.white),),
                  Text("00/00/0000",style: TextStyle(color: Colors.white),),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: (){setState(() {
                      register.updateList(listItems[0],listItems[1],listItems[2]);
                    });
                    },
                    child: const Text("Purchase"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}