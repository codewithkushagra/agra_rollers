import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agra_rollers/fetch_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

GSheetAPI instance=GSheetAPI();

void main(){

  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //one order details
  String currentwidget = "IN";  //In or Out
  String INOUT="IN";
  List<String> loadunload=[];  //Hall, Filter, Small pack, Loading list
  String materialselected="None"; //Which one is selected from loadunload list
  List<String> employeenames= ['None']; //List of Employee name
  String selectedemployeename='None'; //Selected employee name
  List<Item> itemList = []; //list of items
  Map<String, String> quantities = {}; //what item is done in or out
  String tempselectedit='None';
  Map<String, String> textcontrol = {};
  Map<String, String> login={'password':'','username':''};
  List<DataColumn> tablecolumndata=[];
  String SNo='None';
  Map<String, String> tempquantities={};
  List<List<dynamic>> tablerowdata=[];
  DateTime now = DateTime.now();
  String todaysdate = (DateTime.now().millisecondsSinceEpoch/1000).toString();
  Map<String, List<String>> tabledata={'Product':['Maida NB 50Kg','Maida NB 20Kg','Maida DT 50Kg','Maida DT 20Kg','Maida Special 50Kg',
    'Maida Biscuit 50Kg',
    'Suji DT 50Kg',
    'Suji DT 20Kg',
    'Suji NB 50Kg',
    'Suji NB 20Kg',
    'Fine Suji NB 50Kg',
    'Atta Fine DT 50Kg',
    'Bran Blod 50Kg',
    'Bran F/SF 50Kg',
    'Bran Chakki 50Kg',
    'Chakki Atta DT 50Kg',
    'Chakki Atta NB 50Kg',
    'Chakki Atta NB 20Kg',
  ],'br':[]};
  String state="loading";

  void takeNumber(String text, String itemId) {
    try {
      int number = int.parse(text);
      quantities[itemId] = text;
      textcontrol[itemId]=text;
    } on FormatException {}
  }

  Widget singleItemList(int index) {
    Item item = itemList[index];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(

        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            child: Container(child: Text("${index + 1}")),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 50.0, 10.0),
            child: Text(item.name,style: TextStyle(fontSize: 20),),
          ),
          Container(
            child: SizedBox(
              width: 85,
              height: 30,
              child: TextField(
                controller: TextEditingController(text: textcontrol[item.id]),
                keyboardType: TextInputType.number,
                onChanged: (text) {
//                  print(text);
                  takeNumber(text, item.id);
                },
                decoration: const InputDecoration(
                  hintText: "0",

                  contentPadding:
                  EdgeInsets.only(left: 4.0, bottom: 0.0, top: 0.0, right: 0.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget singleRow(int index){
    String product=tabledata['Product']![index];
    String br=tabledata['br']![index];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            child: Container(child: Text("${index + 1}")),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            child: Container(child: Text(product)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            child: Container(child: Text(br)),
          ),
        ],
      ),
    );
  }

  void setup() async{

//    print('loading...');
    String response = await instance.setit();
    List<String> newList=await instance.getUsers();
    setState(() {
      employeenames.addAll(newList);
      state=response;
//      print(response);
    });
  }

  @override
  void initState(){
    super.initState();
//    print(todaysdate);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: getMainWidget()
      ),
    );
  }

  Widget getMainWidget() {
    if(state=='loading' && currentwidget=="IN")
    {

      return getLoadingW();
    }
    else if(state=='loading'&&currentwidget=='LIST')
      {
        return getLoadingDataTable();
      }
    else if(state=="loading")
      {
//        print(currentwidget);
        return getLoadingDataW();
      }
    else if(state=='done')
    {
      return getMain();
    }
    return getErrorW();
  }

  Widget getLoadingDataTable(){
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
          child: Text(
            'Loading Table',
            style: TextStyle(
                fontSize: 35,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w900
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 30),
          child: Text(
            'Getting your Data safely to from sheets...',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600
            ),
          ),
        ),

        SpinKitFadingCircle(

          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.blue : Colors.blueAccent,
              ),
            );
          },
        ),
      ],
    )

    );
  }

  Widget getErrorW(){
    return const Center(child: Text('error'));
  }

  Widget getMain(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.black87,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentwidget = "IN";
                          loadunload=[];
                          tablecolumndata=[];
                          selectedemployeename='None';
                          materialselected="None";
                          itemList = [];
                          textcontrol={};
                          tempselectedit='None';
                          INOUT="IN";
                          quantities = {};
                        });
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 40),
                        padding: const EdgeInsets.all(5.0),
                        primary: (currentwidget == "IN")? Colors.white : Colors.grey,
                      ),
                      child: const Text('IN'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentwidget = "OUT";
                          loadunload=[];
                          INOUT="OUT";
                          textcontrol={};
                          tablecolumndata=[];
                          tempselectedit='None';
                          selectedemployeename='None';
                          materialselected="None";
                          itemList = [];
                          quantities = {};
                        });
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 40),
                        padding: const EdgeInsets.all(5.0),
                        primary: (currentwidget == "OUT") ? Colors.white : Colors.grey,
                      ),
                      child: const Text('OUT'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentwidget = "ENTRY";
                          loadunload=[];
                          INOUT="";
                          selectedemployeename='None';
                          materialselected="None";
                          tempselectedit='None';
                          itemList = [];
                          tablecolumndata=[];
                          textcontrol={};
                          quantities = {};
                        });
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 40),
                        padding: const EdgeInsets.all(5.0),
                        primary: (currentwidget == "ENTRY")? Colors.white : Colors.grey,
                      ),
                      child: const Text('ENTRY'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentwidget = "LIST";
                          loadunload=[];
                          textcontrol={};
                          tablecolumndata=[];
                          selectedemployeename='None';
                          tempselectedit='None';
                          materialselected="None";
                          INOUT="";
                          itemList = [];
                          quantities = {};
                        });
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 40),
                        padding: const EdgeInsets.all(5.0),
                        primary: (currentwidget == "LIST")
                            ? Colors.white
                            : Colors.grey,
                      ),
                      child: const Text('LIST'),
                    ),
                  ]
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Container(
              color: Colors.white,
              child: getWidget()
          ),
        ),
      ],
    );
  }

  Widget getWidget() {

    if ((currentwidget == "IN" || currentwidget == "OUT"||currentwidget=="ENTRY")&& materialselected=="None") {
      return getName();
    }
    else if(currentwidget=="LIST"&& materialselected=="None")
    {
      return getLIST();
    }
    else if(currentwidget=="table")
    {
      return getTABLE();
    }
    else if(currentwidget=="edittable")
      {
        return getEditTable();
      }
    else if(currentwidget=='entrytableloading' && materialselected=='None')
      {
        return getEntryTABLELoading();
      }
    else if(currentwidget=='entrytable' && materialselected=='None'){
      return getEntryTABLE();
    }
    else if(currentwidget=='entrytablesmallpack' && materialselected=='None'){
    return getEntryTABLESmallPack();
    }
    else if(currentwidget=='entrytablefilterin' && materialselected=='None'){
      return getEntryTABLEFilterin();
    }
    else if((currentwidget=="Load Material" || currentwidget=="Unload Material")&& materialselected=="None")
    {
      return getLOADUNLOAD();
    }
    else if(materialselected=="Hall"||materialselected=="Filter"||materialselected=="Material Returned"|| materialselected=="Small Pack")
    {
      return getHALLFILMA();
    }
    else if(materialselected=="Loading")
    {
      return getLOADING();
    }
    return getName();
  }

  Widget getEditTable(){
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/select.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: IconButton(onPressed: (){
                loadunload=[];
                materialselected='None';
                selectedemployeename='None';
                currentwidget="ENTRY";
                textcontrol={};
                quantities={};
                setState((){});
                }, icon: const Icon(Icons.arrow_back_outlined,color: Colors.blue,size:40,)),
            ),
            Expanded(
              flex: 20,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 250, 10, 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:const [
                            Text(
                                'IN',
                                style: TextStyle(fontSize: 60),
                            ),
                            Text(
                                'OUT',
                                style: TextStyle(fontSize: 60),
                            )
                          ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: SizedBox(
                                width: 300.0,
                                height: 55.0,
                                child: ElevatedButton(
                                    onPressed: ()async{
                                      state='loading';
                                      setState((){});
                                      tablecolumndata=[
                                        const DataColumn(label:Text('Edit')),
                                        const DataColumn(
                                            label: Text('Maida NB 50Kg')),
                                        const DataColumn(
                                            label: Text('Maida NB 20Kg')),
                                        const DataColumn(
                                            label: Text('Maida DT 50Kg')),
                                        const DataColumn(
                                            label: Text('Maida DT 20Kg')),
                                        const DataColumn(
                                            label: Text('Maida Special 50Kg')),
                                        const DataColumn(
                                            label: Text('Maida Biscuit 50Kg')),
                                        const DataColumn(
                                            label: Text('Suji DT 50Kg')),
                                        const DataColumn(
                                            label: Text('Suji DT 20Kg')),
                                        const DataColumn(
                                            label: Text('Suji NB 50Kg')),
                                        const DataColumn(
                                            label: Text('Suji NB 20Kg')),
                                        const DataColumn(
                                            label: Text('Fine Suji NB 50Kg')),
                                        const DataColumn(
                                            label: Text('Atta Fine DT 50Kg')),
                                        const DataColumn(
                                            label: Text('Bran Blod 50Kg')),
                                        const DataColumn(
                                            label: Text('Bran F/SF 50Kg')),
                                        const DataColumn(
                                            label: Text('Bran Chakki 50Kg')),
                                        const DataColumn(
                                            label: Text('Chakki Atta DT 50Kg')),
                                        const DataColumn(
                                            label: Text('Chakki Atta NB 50Kg')),
                                        const DataColumn(
                                            label: Text('Chakki Atta NB 20Kg'))
                                      ];
                                      tablerowdata = await instance.getDatabyName(selectedemployeename,'hall',todaysdate);
//                                    print(tablerowdata);
                                      state='done';
                                      tempselectedit='hall';
                                      currentwidget='entrytable';
                                      setState((){});

                                    },
                                    child: const Text(
                                      'Hall',
                                      style: TextStyle(fontSize: 30),
                                    ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: SizedBox(
                                width: 300.0,
                                height: 55.0,
                                child: ElevatedButton(
                                  onPressed: ()async{
                                    state='loading';
                                    setState((){});
                                    tablecolumndata=[
                                      const DataColumn(label:Text('Edit')),
                                      const DataColumn(
                                          label: Text('Maida NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida NB 20Kg')),
                                      const DataColumn(
                                          label: Text('Maida DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida DT 20Kg')),
                                      const DataColumn(
                                          label: Text('Maida Special 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida Biscuit 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji DT 20Kg')),
                                      const DataColumn(
                                          label: Text('Suji NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji NB 20Kg')),
                                      const DataColumn(
                                          label: Text('Fine Suji NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Atta Fine DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran Blod 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran F/SF 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran Chakki 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta NB 20Kg')),
                                      const DataColumn(
                                          label: Text('Bill Number'))
                                    ];
                                    tablerowdata = await instance.getDatabyName(selectedemployeename,'loading',todaysdate);
//                                  print(tablerowdata);
                                    state='done';
                                    tempselectedit='loading';
                                    currentwidget='entrytableloading';
                                    setState((){});

                                  },
                                  child: const Text(
                                    'Loading',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: SizedBox(
                                width: 300.0,
                                height: 55.0,
                                child: ElevatedButton(
                                  onPressed: ()async{
                                    state='loading';
                                    setState((){});
                                    tablecolumndata=[
                                      const DataColumn(label:Text('Edit')),
                                      const DataColumn(
                                          label: Text('Bran Blod 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran F/SF 50Kg')),
                                    ];
                                    tablerowdata = await instance.getDatabyName(selectedemployeename,'infilter',todaysdate);
//                                  print(tablerowdata);
                                    state='done';
                                    tempselectedit='infilter';
                                    currentwidget='entrytablefilterin';
                                    setState((){});

                                  },
                                  child: const Text(
                                    'Filter',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: SizedBox(
                                width: 300.0,
                                height: 55.0,
                                child: ElevatedButton(
                                  onPressed: ()async{
                                    state='loading';
                                    setState((){});
                                    tablecolumndata=[
                                      const DataColumn(label:Text('Edit')),
                                      const DataColumn(
                                          label: Text('Maida NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida NB 20Kg')),
                                      const DataColumn(
                                          label: Text('Maida DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida DT 20Kg')),
                                      const DataColumn(
                                          label: Text('Maida Special 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida Biscuit 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji DT 20Kg')),
                                      const DataColumn(
                                          label: Text('Suji NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji NB 20Kg')),
                                      const DataColumn(
                                          label: Text('Fine Suji NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Atta Fine DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran Blod 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran F/SF 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran Chakki 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta NB 20Kg'))

                                    ];
                                    tablerowdata = await instance.getDatabyName(selectedemployeename,'filter',todaysdate);
//                                  print(tablerowdata);
                                    state='done';
                                    tempselectedit='filter';
                                    currentwidget='entrytable';
                                    setState((){});

                                  },
                                  child: const Text(
                                    'Filter',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: SizedBox(
                                width: 300.0,
                                height: 55.0,
                                child: ElevatedButton(
                                  onPressed: ()async{
                                    state='loading';
                                    setState((){});
                                    tablecolumndata=[
                                      const DataColumn(label:Text('Edit')),
                                      const DataColumn(
                                          label: Text('Maida NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida NB 20Kg')),
                                      const DataColumn(
                                          label: Text('Maida DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida DT 20Kg')),
                                      const DataColumn(
                                          label: Text('Maida Special 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida Biscuit 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji DT 20Kg')),
                                      const DataColumn(
                                          label: Text('Suji NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji NB 20Kg')),
                                      const DataColumn(
                                          label: Text('Fine Suji NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Atta Fine DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran Blod 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran F/SF 50Kg')),
                                      const DataColumn(
                                          label: Text('Bran Chakki 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Chakki Atta NB 20Kg')),

                                    ];
                                    tablerowdata = await instance.getDatabyName(selectedemployeename,'material returned',todaysdate);
//                                  print(tablerowdata);
                                    state='done';
                                    tempselectedit='material returned';
                                    currentwidget='entrytable';
                                    setState((){});

                                  },
                                  child: const Text(
                                    'Material Returned',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: SizedBox(
                                width: 300.0,
                                height: 55.0,
                                child: ElevatedButton(
                                  onPressed: ()async{
                                    state='loading';
                                    setState((){});
                                    tablecolumndata=[
                                      const DataColumn(label:Text('Edit')),
                                      const DataColumn(
                                          label: Text('Maida NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida NB 20Kg')),
                                      const DataColumn(
                                          label: Text('Maida DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Maida DT 20Kg')),
                                      const DataColumn(
                                          label: Text('Suji DT 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji DT 20Kg')),
                                      const DataColumn(
                                          label: Text('Suji NB 50Kg')),
                                      const DataColumn(
                                          label: Text('Suji NB 20Kg')),
                                    ];
                                    tablerowdata = await instance.getDatabyName(selectedemployeename,'small pack',todaysdate);
//                                  print(tablerowdata);
                                    state='done';
                                    tempselectedit='small pack';
                                    currentwidget='entrytablesmallpack';
                                    setState((){});

                                  },
                                  child: const Text(
                                    'Small Pack',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
    );
  }

  Widget getLoadingDataW(){
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
          child: Text(
            'Making Entry',
            style: TextStyle(
                fontSize: 55,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w900
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 30),
          child: Text(
            'Sending your Data safely to your sheets...',
            style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w600
            ),
          ),
        ),

        SpinKitFadingCircle(

          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.blue : Colors.blueAccent,
              ),
            );
          },
        ),
      ],
    )

    );
  }

  Widget getLoadingW(){
    return
      Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
            child: Text(
                'AGRA ROLLER FLOUR MILL',
              style: TextStyle(
                fontSize: 55,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w900
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 30),
            child: Text(
              'Getting your sheets ready...',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),

          SpinKitFadingCircle(

            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.blue : Colors.blueAccent,
                ),
              );
            },
          ),
        ],
      )

    );
  }

  Widget getName(){
    return
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/plan.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 180.0),
                child: Text(
                     currentwidget,
                  style: const TextStyle(
//                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 5.0),
                child: Text(
                  'Select Your Name',
                  style: TextStyle(
//                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              DropdownButton<String>(

                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 65,
                  elevation: 35,
                  style: const TextStyle(color: Colors.blue),
                  underline: Container(
                    height: 5,
                    color: Colors.blueAccent,
                  ),
                  value: selectedemployeename,
                  items: employeenames.map((name) {
                    return DropdownMenuItem(
                      value: name,
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 30),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      selectedemployeename = val!;
                      if(selectedemployeename!='None') {
                        materialselected="None";
                        if (currentwidget == "IN") {
                          currentwidget = "Load Material";
                          loadunload=["Hall", "Filter", "Material Returned"];
                        }
                        else if(currentwidget=="OUT")
                          {
                            currentwidget="Unload Material";
                            loadunload=["Loading","Filter","Small Pack"];
                          }
                        else if(currentwidget=="ENTRY")
                          {
                            currentwidget="edittable";
                          }
                      }
                    });
                  }
              ),
            ],
          ),
        ),
      );
  }

  Widget getLOADUNLOAD() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/select.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: IconButton(onPressed: (){
              loadunload=[];
              selectedemployeename='None';
              currentwidget=INOUT;
              textcontrol={};
              quantities={};
              setState((){});
              }, icon: const Icon(Icons.arrow_back_outlined,color: Colors.blue,size: 40,)),
          ),
          Expanded(     //change in this
            flex: 30,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 140.0, 0.0, 0.0),
                        child: Text(
                          INOUT,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
                        child: Text(
                          'Select one the below options',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300.0,
                          height: 55.0,
                          child: ElevatedButton(
                              onPressed: () async{
                                materialselected=loadunload[0];
                                textcontrol={'MN50':'','MN20':'','MD50':'','MD20':'','MS50':'','MB50':'','SD50':'','SD20':'','SN50':'','SN20':'','FSN50':'','AFD50':'','BB50':'','BF50':'','BC50':'','CAD50':'','CAN50':'','CAN20':''};
                                quantities={'MN50':'0','MN20':'0','MD50':'0','MD20':'0','MS50':'0','MB50':'0','SD50':'0','SD20':'0','SN50':'0','SN20':'0','FSN50':'0','AFD50':'0','BB50':'0','BF50':'0','BC50':'0','CAD50':'0','CAN50':'0','CAN20':'0'};
                                itemList=[
                                  Item("MN50","Maida NB 50Kg            "),
                                  Item("MN20","Maida NB 20Kg            "),
                                  Item("MD50","Maida DT 50Kg            "),
                                  Item("MD20","Maida DT 20Kg            "),
                                  Item("MS50","Maida Special 50Kg    "),
                                  Item("MB50","Maida Biscuit 50Kg     "),
                                  Item("SD50","Suji DT 50Kg                 "),
                                  Item("SD20","Suji DT 20Kg                 "),
                                  Item("SN50","Suji NB 50Kg                 "),
                                  Item("SN20","Suji NB 20Kg                "),
                                  Item("FSN50","Fine Suji NB 50Kg       "),
                                  Item("AFD50","Atta Fine DT 50Kg      "),
                                  Item("BB50","Bran Blod 50Kg           "),
                                  Item("BF50","Bran F/SF 50Kg          "),
                                  Item("BC50","Bran Chakki 50Kg       "),
                                  Item("CAD50","Chakki Atta DT 50Kg "),
                                  Item("CAN50","Chakki Atta NB 50Kg "),
                                  Item("CAN20","Chakki Atta NB 20Kg "),
                                ];
                                setState(() {

                                });
                              },
                              child: Text(
                                loadunload[0],
                                style: const TextStyle(fontSize: 30),
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300.0,
                          height: 55.0,
                          child: ElevatedButton(
                              onPressed: (){
                                materialselected=loadunload[1];
                                if(loadunload[1]=="Filter"&&INOUT=="IN")
                                {
                                  textcontrol={'Bold Bran':'', 'Bran F/SF': ''};
                                  quantities={'Bold Bran':'0', 'Bran F/SF': '0'};
                                  itemList=[
                                    Item("Bold Bran",       "Bold Bran            "),
                                    Item("Bran F/SF",       "Bran F/SF            "),
                                  ];
                                }
                                else if(loadunload[1]=="Filter"&&INOUT=="OUT"){
                                  textcontrol={'MN50':'','MN20':'','MD50':'','MD20':'','MS50':'','MB50':'','SD50':'','SD20':'','SN50':'','SN20':'','FSN50':'','AFD50':'','BB50':'','BF50':'','BC50':'','CAD50':'','CAN50':'','CAN20':''};
                                  quantities={'MN50':'0','MN20':'0','MD50':'0','MD20':'0','MS50':'0','MB50':'0','SD50':'0','SD20':'0','SN50':'0','SN20':'0','FSN50':'0','AFD50':'0','BB50':'0','BF50':'0','BC50':'0','CAD50':'0','CAN50':'0','CAN20':'0'};
                                  itemList=[
                                    Item("MN50","Maida NB 50Kg           "),
                                    Item("MN20","Maida NB 20Kg           "),
                                    Item("MD50","Maida DT 50Kg           "),
                                    Item("MD20","Maida DT 20Kg           "),
                                    Item("MS50","Maida Special 50Kg   "),
                                    Item("MB50","Maida Biscuit 50Kg   "),
                                    Item("SD50","Suji DT 50Kg               "),
                                    Item("SD20","Suji DT 20Kg               "),
                                    Item("SN50","Suji NB 50Kg               "),
                                    Item("SN20","Suji NB 20Kg             "),
                                    Item("FSN50","Fine Suji NB 50Kg     "),
                                    Item("AFD50","Atta Fine DT 50Kg    "),
                                    Item("BB50","Bran Blod 50Kg         "),
                                    Item("BF50","Bran F/SF 50Kg         "),
                                    Item("BC50","Bran Chakki 50Kg     "),
                                    Item("CAD50","Chakki Atta DT 50Kg"),
                                    Item("CAN50","Chakki Atta NB 50Kg"),
                                    Item("CAN20","Chakki Atta NB 20Kg"),
                                  ];
                                }
                                setState(() {
                                });
                              },
                              child: Text(
                                loadunload[1],
                                style: TextStyle(fontSize: 30),
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300.0,
                          height: 55.0,
                          child: ElevatedButton(
                              onPressed: (){
                                materialselected=loadunload[2];
                                if(loadunload[2]=="Small Pack")
                                {
                                  textcontrol={'MN50':'','MN20':'','MD50':'','MD20':'','SD50':'','SD20':'','SN50':'','SN20':''};
                                  quantities={'MN50':'0','MN20':'0','MD50':'0','MD20':'0','SD50':'0','SD20':'0','SN50':'0','SN20':'0'};
                                  itemList=[
                                    Item("MN50","Maida NB 50Kg            "),
                                    Item("MN20","Maida NB 20Kg           "),
                                    Item("MD50","Maida DT 50Kg            "),
                                    Item("MD20","Maida DT 20Kg            "),
                                    Item("SD50","Suji DT 50Kg                "),
                                    Item("SD20","Suji DT 20Kg                "),
                                    Item("SN50","Suji NB 50Kg                "),
                                    Item("SN20","Suji NB 20Kg                "),
                                  ];
                                }
                                else if(loadunload[2]=='Material Returned'){
                                  textcontrol={'MN50':'','MN20':'','MD50':'','MD20':'','MS50':'','MB50':'','SD50':'','SD20':'','SN50':'','SN20':'','FSN50':'','AFD50':'','BB50':'','BF50':'','BC50':'','CAD50':'','CAN50':'','CAN20':''};
                                  quantities={'MN50':'0','MN20':'0','MD50':'0','MD20':'0','MS50':'0','MB50':'0','SD50':'0','SD20':'0','SN50':'0','SN20':'0','FSN50':'0','AFD50':'0','BB50':'0','BF50':'0','BC50':'0','CAD50':'0','CAN50':'0','CAN20':'0'};
                                  itemList=[
                                    Item("MN50","Maida NB 50Kg          "),
                                    Item("MN20","Maida NB 20Kg          "),
                                    Item("MD50","Maida DT 50Kg           "),
                                    Item("MD20","Maida DT 20Kg           "),
                                    Item("MS50","Maida Special 50Kg  "),
                                    Item("MB50","Maida Biscuit 50Kg   "),
                                    Item("SD50","Suji DT 50Kg               "),
                                    Item("SD20","Suji DT 20Kg               "),
                                    Item("SN50","Suji NB 50Kg               "),
                                    Item("SN20","Suji NB 20Kg             "),
                                    Item("FSN50","Fine Suji NB 50Kg     "),
                                    Item("AFD50","Atta Fine DT 50Kg    "),
                                    Item("BB50","Bran Blod 50Kg         "),
                                    Item("BF50","Bran F/SF 50Kg         "),
                                    Item("BC50","Bran Chakki 50Kg     "),
                                    Item("CAD50","Chakki Atta DT 50Kg"),
                                    Item("CAN50","Chakki Atta NB 50Kg"),
                                    Item("CAN20","Chakki Atta NB 20Kg"),
                                  ];
                                }
                                setState(() {
                                  });
                                },
                              child: Text(
                                loadunload[2],
                                style: const TextStyle(fontSize: 30),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getHALLFILMA(){
    return Container(

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(onPressed: (){
                  materialselected="None";
                  itemList = [];
                  quantities = {};
                  setState(() {});
                  }, icon: Icon(Icons.arrow_back_outlined,color: Colors.blue,size: 40,)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                  child: Text(
                    materialselected,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
                SizedBox(
                  height: 500,
                  width: 1000,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemList.length,
                      itemBuilder: (context, index) {
                        if (itemList.isEmpty) {
                          return CircularProgressIndicator();
                        } else {
                          return singleItemList(index);
                        }
                      }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
              child: ElevatedButton(onPressed: () async {
                  quantities['Employee']=selectedemployeename;
                  quantities['Timestamp']=todaysdate;
                  quantities['IN/OUT']=INOUT;
                  if(tempselectedit=='None'){
                    quantities['status']='original';
                  }
                  else
                    {
                      quantities['status']='corrected';
                    }
//                  print(quantities);
                  List<String> finalpass=[];
                  List<String> finaltemppass=[];
                  quantities.values.forEach((v) => finalpass.add(v));
                  if(tempselectedit!='None')
                    {
                      tempquantities.values.forEach((v) => finaltemppass.add(v));
//                      print(tempquantities);
                    }
//                  print(finalpass);
                  setState(() {
                    state='loading';
                  });
                  String message = await instance.insert(finalpass,materialselected,INOUT,tempselectedit,finaltemppass);

                  if(tempselectedit!='None'){
                    await instance.setStatus(materialselected,INOUT,SNo);

                  }

                  if(message!="null") {
                    setState(() {
                      state="done";
                      if(materialselected=='Hall'||materialselected=='Material Returned'||(materialselected=='Filter'&&INOUT=="OUT"))
                        {
                          textcontrol={'MN50':'','MN20':'','MD50':'','MD20':'','MS50':'','MB50':'','SD50':'','SD20':'','SN50':'','SN20':'','FSN50':'','AFD50':'','BB50':'','BF50':'','BC50':'','CAD50':'','CAN50':'','CAN20':''};
                          quantities={'MN50':'0','MN20':'0','MD50':'0','MD20':'0','MS50':'0','MB50':'0','SD50':'0','SD20':'0','SN50':'0','SN20':'0','FSN50':'0','AFD50':'0','BB50':'0','BF50':'0','BC50':'0','CAD50':'0','CAN50':'0','CAN20':'0'};
                        }
                      else if(materialselected=='Filter'&& INOUT=="IN")
                        {
                          textcontrol={'Bold Bran':'', 'Bran F/SF': ''};
                          quantities={'Bold Bran':'0', 'Bran F/SF': '0'};
                        }
                      else if(materialselected=='Small Pack')
                      {
                        textcontrol={'MN50':'','MN20':'','MD50':'','MD20':'','SD50':'','SD20':'','SN50':'','SN20':''};
                        quantities={'MN50':'0','MN20':'0','MD50':'0','MD20':'0','SD50':'0','SD20':'0','SN50':'0','SN20':'0'};
                      }
                      quantities['Employee']=selectedemployeename;
                      quantities['Timestamp']=todaysdate;
                      quantities['IN/OUT']=INOUT;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Status"),
                          content: Text(message),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      },
                    );
                  }
                },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: Text("Submit",
                        style: TextStyle(fontSize: 20)
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLOADING(){
    return Container(
      child: SingleChildScrollView(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(onPressed: (){
                  materialselected="None";
                  itemList = [];
                  quantities = {};
                  setState(() {});
                }, icon: const Icon(Icons.arrow_back_outlined,color: Colors.blue,size: 40,)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                  child: Text(
                    materialselected,
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                  child: Row(
                    children: [
                      const Text("Bill Number",style: TextStyle(fontSize: 25),),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          width: 150,
                          height: 30,
                          child: Container(
                            child: TextField(
                              controller: TextEditingController(text: tempselectedit!='None'?textcontrol['Bill Number']:''),
                              keyboardType: TextInputType.text,
                              onChanged: (text) {
                                quantities['Bill Number']=text;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 0.0)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 500,
                  width: 600,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemList.length,
                      itemBuilder: (context, index) {
                        if (itemList.isEmpty) {
                          return const CircularProgressIndicator();
                        } else {
                          return singleItemList(index);
                        }
                      }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: ElevatedButton(onPressed: () async {
//                'Maidi':'0', 'Suji': '0', 'Bran': '0', 'Chakki Atta': '0', 'Fine Atta': '0', 'Fine Suji': '0'

                if(quantities['Bill Number']==null||quantities['Bill Number']=="") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Empty Field"),
                        content: Text("Please enter the Bill Number"),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
                else
                  {
                quantities['Employee']=selectedemployeename;
                quantities['Timestamp']=todaysdate;
                quantities['IN/OUT']=INOUT;
                if(tempselectedit=='None'){
                  quantities['status']='original';
                }
                else
                {
                  quantities['status']='corrected';
                }
                List<String> finalpass=[];
                List<String> finaltemppass=[];
                quantities.values.forEach((v) => finalpass.add(v));
                if(tempselectedit!='None')
                {
                  tempquantities.values.forEach((v) => finaltemppass.add(v));
                }
//                print(finalpass);
                setState(() {
                  state='loading';
                });
                String message = await instance.insert(finalpass,materialselected,INOUT,tempselectedit,finaltemppass);
                if(tempselectedit!='None'){
                  await instance.setStatus(materialselected,INOUT,SNo);
                }
                if(message!="null") {
                  setState(() {
                    state = "done";
                    textcontrol = {
                      'MN50': '',
                      'MN20': '',
                      'MD50': '',
                      'MD20': '',
                      'MS50': '',
                      'MB50': '',
                      'SD50': '',
                      'SD20': '',
                      'SN50': '',
                      'SN20': '',
                      'FSN50': '',
                      'AFD50': '',
                      'BB50': '',
                      'BF50': '',
                      'BC50': '',
                      'CAD50': '',
                      'CAN50': '',
                      'CAN20': ''
                    };
                    quantities = {
                      'MN50': '0',
                      'MN20': '0',
                      'MD50': '0',
                      'MD20': '0',
                      'MS50': '0',
                      'MB50': '0',
                      'SD50': '0',
                      'SD20': '0',
                      'SN50': '0',
                      'SN20': '0',
                      'FSN50': '0',
                      'AFD50': '0',
                      'BB50': '0',
                      'BF50': '0',
                      'BC50': '0',
                      'CAD50': '0',
                      'CAN50': '0',
                      'CAN20': '0',
                      'Bill Number': '-'
                    };
                    quantities['Employee'] = selectedemployeename;
                    quantities['Timestamp'] = todaysdate;
                    quantities['IN/OUT'] = INOUT;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Status"),
                        content: Text(message),
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
                }
              }
              , child: const Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Text("Submit",
                  style: TextStyle(fontSize: 20),
                    ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget getLIST() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/loginin.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 75.0, 70.0, 70.0),
                child: Text(
                    "Admin",
                    style: TextStyle(fontSize: 65),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 55.0, 7.0),
                child: SizedBox(
                  width: 300,
                  height: 60,
                  child: Container(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        login['username']=text;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter Your Name',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 12.0, 55.0, 25.0),
                child: SizedBox(
                  width: 300,
                  height: 60,
                      child: TextField(
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (text) {
                          login['password']=text;
                        },
                          decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter Your Name',
                          ),
                      ),
                  ),
              ),
              ElevatedButton(
                child: const Text('LogIn'),
                onPressed: ()async{
                    if(login['password']=='1234'&&login['username']=='admin')
                      {
                        setState(() {
                          state='loading';
                        });
                        tabledata['br'] = await instance.getRunningBalance();
                        setState(() {
                          currentwidget='table';
                          state='done';
                        });
                      }
                    else
                      {
//                      print("wrong");

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text("Please check the credentials"),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed:(){
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                },
              )
            ]
          ),
        ),
      ),
    );
  }

  Widget getEntryTABLEFilterin(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: (){
            materialselected="None";
            tempselectedit='None';
            itemList = [];
            currentwidget="edittable";
            quantities = {};
            setState(() {});
            },
              icon: const Icon(Icons.arrow_back_outlined,color: Colors.blue,size: 40,)
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // Data table widget in not scrollable so we have to wrap it in a scroll view when we have a large data set..
            child: SingleChildScrollView(
              child: DataTable(
                columns: tablecolumndata,
                rows:
                tablerowdata.map((data) =>
                // we return a DataRow every time
                DataRow(
                  // List<DataCell> cells is required in every row
                    cells: [
                      DataCell(IconButton(onPressed: (
                          ){
                        setState((){
                          materialselected='Filter';
                          INOUT='IN';
                          SNo=data[0];
                          textcontrol={'Bold Bran':data[1], 'Bran F/SF':data[2]};
                          quantities={'Bold Bran':data[1], 'Bran F/SF':data[2]};
                          tempquantities={'Bold Bran':data[1], 'Bran F/SF':data[2]};
                          itemList=[
                            Item("Bold Bran",       "Bold Bran            "),
                            Item("Bran F/SF",       "Bran F/SF           "),
                          ];
                        });
                      },
                          icon: const Icon(Icons.edit,color: Colors.blue,))),
                      DataCell(Text(data[1])),
                      DataCell(Text(data[2])),
                    ]))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget getEntryTABLELoading(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: (){
            materialselected="None";
            tempselectedit='None';
            itemList = [];
            currentwidget="edittable";
            quantities = {};
            setState(() {});
            }, icon: Icon(Icons.arrow_back_outlined,color: Colors.blue,size: 40,)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // Data table widget in not scrollable so we have to wrap it in a scroll view when we have a large data set..
            child: SingleChildScrollView(
              child: DataTable(
                columns: tablecolumndata,
                rows:
                    tablerowdata.map((data) =>
                // we return a DataRow every time
                DataRow(
                  // List<DataCell> cells is required in every row
                    cells: [
                      DataCell(IconButton(onPressed: (

                          ){
                        setState((){
                          materialselected='Loading';
                          INOUT='OUT';
                          SNo=data[0];
                          textcontrol={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'MS50':data[5],'MB50':data[6],'SD50':data[7],'SD20':data[8],'SN50':data[9],'SN20':data[10],'FSN50':data[11],'AFD50':data[12],'BB50':data[13],'BF50':data[14],'BC50':data[15],'CAD50':data[16],'CAN50':data[17],'CAN20':data[18],'Bill Number':data[19]};
                          quantities={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'MS50':data[5],'MB50':data[6],'SD50':data[7],'SD20':data[8],'SN50':data[9],'SN20':data[10],'FSN50':data[11],'AFD50':data[12],'BB50':data[13],'BF50':data[14],'BC50':data[15],'CAD50':data[16],'CAN50':data[17],'CAN20':data[18],'Bill Number':data[19]};
                          tempquantities={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'MS50':data[5],'MB50':data[6],'SD50':data[7],'SD20':data[8],'SN50':data[9],'SN20':data[10],'FSN50':data[11],'AFD50':data[12],'BB50':data[13],'BF50':data[14],'BC50':data[15],'CAD50':data[16],'CAN50':data[17],'CAN20':data[18],'Bill Number':data[19]};
                          itemList=[
                            Item("MN50","Maida NB 50Kg             "),
                            Item("MN20","Maida NB 20Kg            "),
                            Item("MD50","Maida DT 50Kg            "),
                            Item("MD20","Maida DT 20Kg            "),
                            Item("MS50","Maida Special 50Kg   "),
                            Item("MB50","Maida Biscuit 50Kg    "),
                            Item("SD50","Suji DT 50Kg                "),
                            Item("SD20","Suji DT 20Kg               "),
                            Item("SN50","Suji NB 50Kg               "),
                            Item("SN20","Suji NB 20Kg             "),
                            Item("FSN50","Fine Suji NB 50Kg     "),
                            Item("AFD50","Atta Fine DT 50Kg    "),
                            Item("BB50","Bran Blod 50Kg         "),
                            Item("BF50","Bran F/SF 50Kg         "),
                            Item("BC50","Bran Chakki 50Kg     "),
                            Item("CAD50","Chakki Atta DT 50Kg"),
                            Item("CAN50","Chakki Atta NB 50Kg"),
                            Item("CAN20","Chakki Atta NB 20Kg"),
                          ];
                        });
                       },
                          icon: const Icon(Icons.edit,color: Colors.blue,))),
                      DataCell(Text(data[1])),
                      DataCell(Text(data[2])),
                      DataCell(Text(data[3])),
                      DataCell(Text(data[4])),
                      DataCell(Text(data[5])),
                      DataCell(Text(data[6])),
                      DataCell(Text(data[7])),
                      DataCell(Text(data[8])),
                      DataCell(Text(data[9])),
                      DataCell(Text(data[10])),
                      DataCell(Text(data[11])),
                      DataCell(Text(data[12])),
                      DataCell(Text(data[13])),
                      DataCell(Text(data[14])),
                      DataCell(Text(data[15])),
                      DataCell(Text(data[16])),
                      DataCell(Text(data[17])),
                      DataCell(Text(data[18])),
                      DataCell(Text(data[19]))
                    ]))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget getEntryTABLESmallPack(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: (){
            materialselected="None";
            itemList = [];
            tempselectedit='None';
            currentwidget="edittable";
            quantities = {};
            setState(() {});
            }, icon: Icon(Icons.arrow_back_outlined,color: Colors.blue,size: 40,)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // Data table widget in not scrollable so we have to wrap it in a scroll view when we have a large data set..
            child: SingleChildScrollView(
              child: DataTable(
                columns: tablecolumndata,
                rows:
                tablerowdata.map((data) =>
                // we return a DataRow every time
                DataRow(
                  // List<DataCell> cells is required in every row
                    cells: [
                      DataCell(IconButton(onPressed: (

                          ){
                        setState((){
                          textcontrol={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'SD50':data[5],'SD20':data[6],'SN50':data[7],'SN20':data[8]};
                          quantities={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'SD50':data[5],'SD20':data[6],'SN50':data[7],'SN20':data[8]};
                          tempquantities={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'SD50':data[5],'SD20':data[6],'SN50':data[7],'SN20':data[8]};
                          itemList=[
                            Item("MN50","Maida NB 50Kg             "),
                            Item("MN20","Maida NB 20Kg            "),
                            Item("MD50","Maida DT 50Kg            "),
                            Item("MD20","Maida DT 20Kg            "),
                            Item("SD50","Suji DT 50Kg                "),
                            Item("SD20","Suji DT 20Kg                "),
                            Item("SN50","Suji NB 50Kg                "),
                            Item("SN20","Suji NB 20Kg                "),
                          ];
                          materialselected='Small Pack';
                          INOUT='OUT';
                          SNo=data[0];
                        });
                        },
                          icon: const Icon(Icons.edit,color: Colors.blue,))),
                      DataCell(Text(data[1])),
                      DataCell(Text(data[2])),
                      DataCell(Text(data[3])),
                      DataCell(Text(data[4])),
                      DataCell(Text(data[5])),
                      DataCell(Text(data[6])),
                      DataCell(Text(data[7])),
                      DataCell(Text(data[8])),
                    ]))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //Hall, Filter out, Material Returned
  Widget getEntryTABLE(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: (){
            materialselected="None";
            itemList = [];
            tempselectedit='None';
            SNo='None';
            currentwidget="edittable";
            quantities = {};
            setState(() {});
            }, icon: const Icon(Icons.arrow_back_outlined,color: Colors.blue,size: 40,)),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // Data table widget in not scrollable so we have to wrap it in a scroll view when we have a large data set..
            child: SingleChildScrollView(
              child: DataTable(
                columns: tablecolumndata,
                rows:
                tablerowdata.map((data) =>
                // we return a DataRow every time
                DataRow(
                  // List<DataCell> cells is required in every row
                    cells: [
                      DataCell(IconButton(onPressed: (){
                        setState((){
                          if(tempselectedit=='hall'){
                            materialselected='Hall';
                            INOUT='IN';
                          }
                          else if(tempselectedit=='filter'){
                            materialselected='Filter';
                            INOUT='OUT';
                          }
                          else if(tempselectedit=='material returned'){
                            materialselected='Material Returned';
                            INOUT='IN';
                          }
                          SNo=data[0];
                          textcontrol={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'MS50':data[5],'MB50':data[6],'SD50':data[7],'SD20':data[8],'SN50':data[9],'SN20':data[10],'FSN50':data[11],'AFD50':data[12],'BB50':data[13],'BF50':data[14],'BC50':data[15],'CAD50':data[16],'CAN50':data[17],'CAN20':data[18]};
                          quantities={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'MS50':data[5],'MB50':data[6],'SD50':data[7],'SD20':data[8],'SN50':data[9],'SN20':data[10],'FSN50':data[11],'AFD50':data[12],'BB50':data[13],'BF50':data[14],'BC50':data[15],'CAD50':data[16],'CAN50':data[17],'CAN20':data[18]};
                          tempquantities={'MN50':data[1],'MN20':data[2],'MD50':data[3],'MD20':data[4],'MS50':data[5],'MB50':data[6],'SD50':data[7],'SD20':data[8],'SN50':data[9],'SN20':data[10],'FSN50':data[11],'AFD50':data[12],'BB50':data[13],'BF50':data[14],'BC50':data[15],'CAD50':data[16],'CAN50':data[17],'CAN20':data[18]};
                          itemList=[
                            Item("MN50","Maida NB 50Kg             "),
                            Item("MN20","Maida NB 20Kg            "),
                            Item("MD50","Maida DT 50Kg            "),
                            Item("MD20","Maida DT 20Kg            "),
                            Item("MS50","Maida Special 50Kg   "),
                            Item("MB50","Maida Biscuit 50Kg    "),
                            Item("SD50","Suji DT 50Kg                "),
                            Item("SD20","Suji DT 20Kg               "),
                            Item("SN50","Suji NB 50Kg               "),
                            Item("SN20","Suji NB 20Kg             "),
                            Item("FSN50","Fine Suji NB 50Kg     "),
                            Item("AFD50","Atta Fine DT 50Kg    "),
                            Item("BB50","Bran Blod 50Kg         "),
                            Item("BF50","Bran F/SF 50Kg         "),
                            Item("BC50","Bran Chakki 50Kg     "),
                            Item("CAD50","Chakki Atta DT 50Kg"),
                            Item("CAN50","Chakki Atta NB 50Kg"),
                            Item("CAN20","Chakki Atta NB 20Kg"),
                          ];
                        });
                      },
                          icon: const Icon(Icons.edit,color: Colors.blue,))),
                      DataCell(Text(data[1])),
                      DataCell(Text(data[2])),
                      DataCell(Text(data[3])),
                      DataCell(Text(data[4])),
                      DataCell(Text(data[5])),
                      DataCell(Text(data[6])),
                      DataCell(Text(data[7])),
                      DataCell(Text(data[8])),
                      DataCell(Text(data[9])),
                      DataCell(Text(data[10])),
                      DataCell(Text(data[11])),
                      DataCell(Text(data[12])),
                      DataCell(Text(data[13])),
                      DataCell(Text(data[14])),
                      DataCell(Text(data[15])),
                      DataCell(Text(data[16])),
                      DataCell(Text(data[17])),
                      DataCell(Text(data[18])),
                    ]))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTABLE() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            IconButton(onPressed: (){
              loadunload=[];
              selectedemployeename='None';
              currentwidget="LIST";
              textcontrol={};
              quantities={};
              setState((){});
            }, icon: const Icon(Icons.arrow_back_outlined,color: Colors.blue,size: 40,)),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Current Stock',style: TextStyle(fontSize: 50),),
            ),
          ],
        ),
        Container(
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                child: Text('Sno',style: TextStyle(fontSize: 30),),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                child: Text('Products',style: TextStyle(fontSize: 30),),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                child: Text('Running Balance',style: TextStyle(fontSize: 30),),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tabledata['Product']!.length,
            itemBuilder: (context, index) {

            if (tabledata['Product']!.isEmpty) {
              return CircularProgressIndicator();
              }
            else {
              return singleRow(index);
              }
          }),
        ),
      ],
    );
  }
}

class Item {
  final String id;
  final String name;
  Item(this.id, this.name);
}
