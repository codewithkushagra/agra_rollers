import 'package:gsheets/gsheets.dart';
import 'package:agra_rollers/model/hall.dart';


class GSheetAPI {
  static final _spreadsheetId = '1rqJTf49vdymRV6ZitASvlW9_vO0LYKcnVBz7v3xR6Ng';
  static final _cerdentails = r'''
  {
  "type": "service_account",
  "project_id": "agrarollers",
  "private_key_id": "c8fc43f9d2ca295f88bb3354fab7678dedd98374",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDjjl/DYIWvmuJk\ni9oQQIfjn70vF3Ynll5Me4ywR6TRWGn5EbdJrSzJPrAzghxDT3404MZJMp5A/6yg\nHLOQZUia1i7mMd5FRuJlxxQEqx3saz3Ixtb+Dd1THR6s4q1ya5nnnedpGDP2i1HJ\n2nO7tOaGGUQI8wR4u9HORjzEUbFkjNHRJNXxmoYb+GRnZyUBwfaXqbEZMPsB5fib\nRXdieF9Kq6e65do9IPbGM6UY4JKx3NOpWqmIvwuYizD5Mg8242rVjhJ2Btct/G+9\nZUm1oIoZ423JpFL0/90ENq33pyusmtFWmZV2hhp4J0zWtszpqzQxxF28GrjkHnOi\nEEIq/TkhAgMBAAECggEAMbNlAx1P1Zz0mZVaGXaet36qKWDsc5UKH5ZUkiPzwa2X\n58iQyczDHWlNvtJKLgFsxUvawx4FJpkxMP9T0NPuWbMyJyD5NRRYWnZyzto4/Own\nYHTdfDu2/XI8wvH3hCgwQ0BfzLp2jwC66mWGJZdLSjq2e2Xosh4DoxQALbjSD+2w\nbc72zXj6YrofGD+ZJbWrjnoUWhLacOlZrybhdB8ZM5yPUtvnB7BQa57J+ofYchMf\nePBc3fLYiiHD9Ow6rLMxaaublMUdjZGSMhLZzhVKGF9i+bFZmQFaMy0XSuxvza9m\nnxdX0bDDtgwJEvEBNdhUIMOtbRSeq4cZynKJyC8kKQKBgQDz35c0lpzpwrxRDqIp\nlckOvhPqErZwjA95ht8MQ2NILYELdZYgbcynVoV7YwGkjGuHUnpcvBKM99fJeeYa\nsaiYx1Y9ZFfif8tO7WKXV8JOuxTA/b1FR9fNUQbcK4Y0bPLTPqCf+PV35Bl0BCRq\nUXX989RQP0curpjoswJg5mKQ7wKBgQDu3xJJiMd1b94Tzh2hAnlv/Bvce+xQO3dg\nIV/KUi/JRHslWT+q3ZzrdmtIIFvawsNcXONqVtrzN7+iwST5VSiKW9GnNMvZ/AFq\nky8o9ec+GEefSs5HL9cO8HjaD07hZDn/MZV39Tz7TqFyQT2Ajc6pgab5DMK7mom0\nQVpsAPK27wKBgQDyvQrz/TYSNxLaW4ZtffmyAuAvjJCrVb3RaL16p1ia7zATB+d2\nP9QEe8pBFjr8XghpmV7SDyEnz0mp8Ptodo0qBL+CO+5+NFVZKk+H9IIje3Mc5XMP\nEoNqicwaOfhLFmZcfWnD0ToDK7dqEvVsHckkDR63AUUI4iCw/fzQFoDlYQKBgQCD\nvwDlEc2A1gxUPBBXZ3f27cOoHak+ry2uFXoxqpa0mVKaTNkysjwEGjIde8ttopIB\ndTHwyqrEDnFhoMl1wyQy+2VspU/xkG5vi3ItU0MRGm8WSjnvRVGF6ded3WeSJKdg\nOsbHfLj/mmStEZKMPqpHDz06i3Ez644bnxfyDavQfQKBgQDFlTXbXqG5ttfB0JeF\nDWArReu3P16pmCffyYdmCH/bOQ+zOUsQXt+6N0GXxyuXfaem5jSOMi+RI1nVxRkN\nLA8VD5de2QUOpl9kITB3IOaUt4jRgxlSajFy8Ysiv4FYGkxwnDLEf7wSnPVkSFFn\nQ5ISIbOfoWw0Z61xL66ir5saAw==\n-----END PRIVATE KEY-----\n",
  "client_email": "agrarollers@agrarollers.iam.gserviceaccount.com",
  "client_id": "104704959989211397202",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/agrarollers%40agrarollers.iam.gserviceaccount.com"
}
''';

  static final _gsheets = GSheets(_cerdentails);
  static Worksheet? _hallDataSheet;
  static Worksheet? _filterDataSheet;
  static Worksheet? _infilterDataSheet;
  static Worksheet? _smallpackDataSheet;
  static Worksheet? _loadingDataSheet;
  static Worksheet? _materialreturnedDataSheet;
  static Worksheet? _usersDataSheet;
  static Worksheet? _runningbalanceDataSheet;

  Future<String> setit() async {
    try {
       final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
       _hallDataSheet = await _getWorkSheet(spreadsheet, title: 'hall');
       _filterDataSheet = await _getWorkSheet(spreadsheet, title: 'filter');
       _smallpackDataSheet = await _getWorkSheet(spreadsheet, title: 'smallpack');
       _loadingDataSheet = await _getWorkSheet(spreadsheet, title: 'loading');
       _materialreturnedDataSheet = await _getWorkSheet(spreadsheet, title: 'materialreturned');
       _usersDataSheet = await _getWorkSheet(spreadsheet, title: 'users');
       _runningbalanceDataSheet = await _getWorkSheet(spreadsheet, title: 'runningbalance');
       _infilterDataSheet = await _getWorkSheet(spreadsheet, title: 'filterin');
//      final firstRow = HallFields.getFields();
    return "done";
    }catch(e){
//      print('Init Error: $e');
      return "$e";
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet, {required String title,}) async {
    try{
    return await spreadsheet.addWorksheet(title);
  } catch(e){
      return spreadsheet.worksheetByTitle(title)!;
    }
  }
//MAKE CHANCE HERE....
  Future<List<List<dynamic>>> getDatabyName(String name,String place,String date)async{
    try {
      var then=(DateTime.now().millisecondsSinceEpoch/1000).toInt();
      var dateinstancenow = DateTime.fromMillisecondsSinceEpoch(then*1000);
      String datenow=dateinstancenow.day.toString()+"-"+dateinstancenow.month.toString();
//      print(datenow);
      if (place == 'hall') {
        List<List<String>> m = await _hallDataSheet!.values.allRows(fromRow: 5);
        List<List<dynamic>> data = [];

        for (List i in m) {
//          print(double.parse(i[20]));
          int mnn=double.parse(i[20]).toInt();
          var dateinstancethen = DateTime.fromMillisecondsSinceEpoch(mnn*1000);
          var datethen=dateinstancethen.day.toString()+"-"+dateinstancethen.month.toString();
//          print(datethen+"  "+datenow);
          if (i[19] == name &&  datenow == datethen && i[22]!='error') {
            data.add(i.sublist(0, 19));
          }
        }
        return data;
      }
      if (place == 'loading') {
        List<List<String>> m = await _loadingDataSheet!.values.allRows(fromRow: 5);
        List<List<dynamic>> data = [];
//        print(m);
        for (List i in m) {
          int mnn=double.parse(i[21]).toInt();
          var dateinstancethen = DateTime.fromMillisecondsSinceEpoch(mnn*1000);
          var datethen=dateinstancethen.day.toString()+"-"+dateinstancethen.month.toString();
          if (i[20] == name && datenow == datethen && i[23]!='error') {
            data.add(i.sublist(0, 20));
          }
        }
        return data;
      }
      else if (place == 'filter') {
        List<List<String>> m = await _filterDataSheet!.values.allRows(fromRow: 5);
        List<List<dynamic>> data = [];
//        print(m);
        for (List i in m) {
          int mnn=double.parse(i[20]).toInt();
          var dateinstancethen = DateTime.fromMillisecondsSinceEpoch(mnn*1000);
          var datethen=dateinstancethen.day.toString()+"-"+dateinstancethen.month.toString();
          if (i[19] == name && datethen == datenow && i[22]!='error') {
            data.add(i.sublist(0, 19));
          }
        }
        return data;
      }
      else if (place == 'infilter') {
        List<List<String>> m = await _infilterDataSheet!.values.allRows(fromRow: 5);
        List<List<dynamic>> data = [];
//        print(m);
        for (List i in m) {
          int mnn=double.parse(i[4]).toInt();
          var dateinstancethen = DateTime.fromMillisecondsSinceEpoch(mnn*1000);
          var datethen=dateinstancethen.day.toString()+"-"+dateinstancethen.month.toString();
          if (i[3] == name && datethen == datenow && i[6]!='error') {
            data.add(i.sublist(0, 3));
          }
        }
        return data;
      }
      else if (place == 'material returned') {
        List<List<String>> m = await _materialreturnedDataSheet!.values.allRows(fromRow: 5);
        List<List<dynamic>> data = [];
//        print(m);
        for (List i in m) {
          int mnn=double.parse(i[20]).toInt();
          var dateinstancethen = DateTime.fromMillisecondsSinceEpoch(mnn*1000);
          var datethen=dateinstancethen.day.toString()+"-"+dateinstancethen.month.toString();
          if (i[19] == name && datethen == datenow && i[22]!='error') {
            data.add(i.sublist(0, 19));
          }
        }
        return data;
      }
      else if (place == 'small pack') {
        List<List<String>> m = await _smallpackDataSheet!.values.allRows(fromRow: 5);
        List<List<dynamic>> data = [];
//        print(m);
        for (List i in m) {
          int mnn=double.parse(i[10]).toInt();
          var dateinstancethen = DateTime.fromMillisecondsSinceEpoch(mnn*1000);
          var datethen=dateinstancethen.day.toString()+"-"+dateinstancethen.month.toString();
          if (i[9] == name && datethen == datenow && i[12]!='error') {
            data.add(i.sublist(0, 9));
          }
        }
        return data;
      }
      return [['Not Found']];
    }catch(e) {
     return [['Error']];
    }
  }

  Future<dynamic> getUsers()async
  {
    try {
      if (_usersDataSheet == null) {
        return 'Not Found';
      }
      final userData=await _usersDataSheet!.values.columnByKey('Employee');
      return userData;
    }
    catch(e)
    {
      return "Error in connection";
    }
  }

  Future<dynamic> getRunningBalance()async
  {
    try {
      if (_runningbalanceDataSheet == null) {
        return 'Not Found';
      }
      final balanceData=await _runningbalanceDataSheet!.values.columnByKey('Running Balance');
      return balanceData;
    }
    catch(e)
    {
      return "Error in connection";
    }
  }

  Future setStatus(String sheetName,String INOUT,String sno)async{
    int rowc;
    rowc=int.parse(sno);
    rowc=rowc+4;
    if(sheetName=='Hall'){
      await _hallDataSheet!.values.insertValue('error', column: 23, row: rowc);
    }
    else if(sheetName=='Filter' && INOUT=='OUT'){
      await _filterDataSheet!.values.insertValue('error', column: 23, row: rowc);
    }
    else if(sheetName=='Filter' && INOUT=='IN'){
      await _infilterDataSheet!.values.insertValue('error', column: 7, row: rowc);
    }
    else if(sheetName=='Material Returned'){
      await _materialreturnedDataSheet!.values.insertValue('error', column: 23, row: rowc);
    }
    else if(sheetName=='Small Pack'){
      await _smallpackDataSheet!.values.insertValue('error', column: 13, row: rowc);
    }
    else if(sheetName=='Loading'){
      await _loadingDataSheet!.values.insertValue('error', column: 24, row: rowc);
    }
  }

  Future<String> insert(List<String> list,String materialselected,String currentwidget,String tempselectedit,List<String> templist) async{
    try {
      if(materialselected=='Hall'){
        if(_hallDataSheet==null){return 'Not Found';}
        var userCount=await _hallDataSheet!.values.lastColumn();
        var count=userCount!.length-3;
        list.insert(0,count.toString());
        await _hallDataSheet!.values.appendRow(list);
        list.removeAt(0);
        List<String>? runningbalance = await _runningbalanceDataSheet!.values.columnByKey('Running Balance');
//        print(runningbalance);
        List<String> updatedRow=[];
        for(var i=0;i<runningbalance!.length;i++){
          int a=int.parse(runningbalance[i])+int.parse(list[i]);
          if(tempselectedit!='None')
          {
            a=a-int.parse(templist[i]);
          }
          updatedRow.add(a.toString());
        }
//        print(templist);
        await _runningbalanceDataSheet!.values.insertColumn(4, updatedRow, fromRow: 2);
      }
      else if(materialselected=='Filter'&&currentwidget=="OUT")
        {
          if(_filterDataSheet==null){return 'Not Found';}
          var userCount=await _filterDataSheet!.values.lastColumn();
          var count=userCount!.length-3;
          list.insert(0,count.toString());
          await _filterDataSheet!.values.appendRow(list);
          list.removeAt(0);
          List<String>? runningbalance = await _runningbalanceDataSheet!.values.columnByKey('Running Balance');
//          print(runningbalance);
          List<String> updatedRow=[];
          for(var i=0;i<runningbalance!.length;i++){
            int a=int.parse(runningbalance[i])-int.parse(list[i]);
            if(tempselectedit!='None')
            {
              a=a+int.parse(templist[i]);
            }
            updatedRow.add(a.toString());
          }
//          print(updatedRow);
          await _runningbalanceDataSheet!.values.insertColumn(4, updatedRow, fromRow: 2);
        }

      else if(materialselected=='Filter'&&currentwidget=="IN")
      {
        if(_infilterDataSheet==null){return 'Not Found';}
        var userCount=await _infilterDataSheet!.values.lastColumn();
        var count=userCount!.length-3;
        list.insert(0,count.toString());
        await _infilterDataSheet!.values.appendRow(list);
        list.removeAt(0);
        List<String>? runningbalance = await _runningbalanceDataSheet!.values.columnByKey('Running Balance');
//        print(runningbalance);
        if(runningbalance!=null)
        {
          int a=int.parse(runningbalance[12])+int.parse(list[0]);
          if(tempselectedit!='None')
          {
            a=a-int.parse(templist[0]);
          }
          runningbalance[12]=a.toString();
          a=int.parse(runningbalance[13])+int.parse(list[1]);
          if(tempselectedit!='None')
          {
            a=a-int.parse(templist[1]);
          }
          runningbalance[13]=a.toString();
        }
        await _runningbalanceDataSheet!.values.insertColumn(4, runningbalance!, fromRow: 2);
      }

      else if(materialselected=='Loading')
      {
        if(_loadingDataSheet==null){return 'Not Found';}
        var userCount=await _loadingDataSheet!.values.lastColumn();
        var count=userCount!.length-3;
        list.insert(0,count.toString());
        await _loadingDataSheet!.values.appendRow(list);
        list.removeAt(0);
        List<String>? runningbalance = await _runningbalanceDataSheet!.values.columnByKey('Running Balance');
//        print(runningbalance);
        List<String> updatedRow=[];
        for(var i=0;i<runningbalance!.length;i++){
          int a=int.parse(runningbalance[i])-int.parse(list[i]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[i]);
          }
          updatedRow.add(a.toString());
        }
//        print(updatedRow);
        await _runningbalanceDataSheet!.values.insertColumn(4, updatedRow, fromRow: 2);
      }
      else if(materialselected=='Small Pack')
      {
        if(_smallpackDataSheet==null){return 'Not Found';}
        var userCount=await _smallpackDataSheet!.values.lastColumn();
        var count=userCount!.length-3;
        list.insert(0,count.toString());
        await _smallpackDataSheet!.values.appendRow(list);
        list.removeAt(0);
        List<String>? runningbalance = await _runningbalanceDataSheet!.values.columnByKey('Running Balance');
//        print(runningbalance);
        if(runningbalance!=null)
        {
          int a=int.parse(runningbalance[0])-int.parse(list[0]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[0]);
          }
          runningbalance[0]=a.toString();
          a=int.parse(runningbalance[1])-int.parse(list[1]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[1]);
          }
          runningbalance[1]=a.toString();
          a=int.parse(runningbalance[2])-int.parse(list[2]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[2]);
          }
          runningbalance[2]=a.toString();
          a=int.parse(runningbalance[3])-int.parse(list[3]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[3]);
          }
          runningbalance[3]=a.toString();
          a=int.parse(runningbalance[6])-int.parse(list[4]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[4]);
          }
          runningbalance[6]=a.toString();
          a=int.parse(runningbalance[7])-int.parse(list[5]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[5]);
          }
          runningbalance[7]=a.toString();
          a=int.parse(runningbalance[8])-int.parse(list[6]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[6]);
          }
          runningbalance[8]=a.toString();
          a=int.parse(runningbalance[9])-int.parse(list[7]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[7]);
          }
          runningbalance[9]=a.toString();
        }
        await _runningbalanceDataSheet!.values.insertColumn(4, runningbalance!, fromRow: 2);
      }
      else if(materialselected=='Material Returned')
      {
        if(_materialreturnedDataSheet==null){return 'Not Found';}
        var userCount=await _materialreturnedDataSheet!.values.lastColumn();
        var count=userCount!.length-3;
        list.insert(0,count.toString());
        await _materialreturnedDataSheet!.values.appendRow(list);
        list.removeAt(0);
        List<String>? runningbalance = await _runningbalanceDataSheet!.values.columnByKey('Running Balance');
//        print(runningbalance);
        List<String> updatedRow=[];
        for(var i=0;i<runningbalance!.length;i++){
          int a=int.parse(runningbalance[i])+int.parse(list[i]);
          if(tempselectedit!='None')
          {
            a=a+int.parse(templist[i]);
          }
          updatedRow.add(a.toString());
        }
//        print(updatedRow);
        await _runningbalanceDataSheet!.values.insertColumn(4, updatedRow, fromRow: 2);
      }
      return 'Data added';
    }catch(e){
      return "Error in connection";
    }
  }
}