import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Data/controller.dart';
import 'dart:io' show Platform;
import 'notification_service.dart' if (Platform.isAndroid) "";
import 'Data/file.dart';
import 'package:flutter/services.dart';

// Initialises the needed classes for notifications
Future<void> notif() async{
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationService().init();
  }
}

// Copies the stored data to the clipboard
void toClip() async{
  final Controller c = Get.find();
  ClipboardData data = ClipboardData(text: c.getJson());
  await Clipboard.setData(data);  
}

// copies the data from clipboard to the saved data
void fromClip() async {
  final Controller c = Get.find();
  Clipboard.getData("text/plain").then((value) => {
    c.fromJson(value?.text)
  });
}


void main() async {
  notif();
  String data = await readFile("data.json"); //read previous stored data
  String settingsData = await readFile("settings.json");
  runApp(TodoInfinite(data: data, settingsData: settingsData,)); //use the stored data
}

// In charge of displaying the App
class TodoInfinite extends StatelessWidget {
  final String data;
  final String settingsData;
  const TodoInfinite({ Key? key, required  this.data, required this.settingsData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller(data, settingsData));
    return GetMaterialApp(
      title: 'Todo infinite',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: c.getColors()[c.getColor()],
        ),
      ),
      themeMode: ThemeMode.light,
      home: TodoHome(arr:[]),
    );
  }
}

// Displays a todo chosen by the arr variable
class TodoHome extends StatelessWidget {
  final List<int> arr;
  const TodoHome({ Key? key, required this.arr }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return  WillPopScope(
      onWillPop: () async {
        if (arr.isEmpty) {return true;}
        List<int> a = List<int>.from(arr);
        a.removeLast();
        Get.offAll(() => TodoHome(arr: a));
        return false;
      },
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Color.fromRGBO(33, 33, 33, 1),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title:GetBuilder<Controller>(
            builder: (todo) => Text('${c.getText(arr)}'),
          ),
          leading: GetBuilder<Controller>( //display a back button when the chosen todo is not the root
            builder: (todo) => arr.isEmpty? Icon(Icons.home): IconButton(
              onPressed: () {             //display the todo above the current one
                if (arr.isEmpty) {return;}
                List<int> a = List<int>.from(arr);
                a.removeLast();
                Get.offAll(() => TodoHome(arr: a));
              }, 
              icon: Icon(Icons.keyboard_arrow_left_rounded,),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => Notifications());
              }, 
              icon: Icon(Icons.notifications_none_rounded,),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => Settings());
              }, 
              icon: Icon(Icons.settings,),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<Controller>(
                builder: (todo) => ReorderableListView(
                  buildDefaultDragHandles: false,
                  padding: EdgeInsets.all(10),
                  children: [ //display a todo element for every item in the sub array
                    for (int i=0; i<todo.getTodo(arr).sub.length; i++) 
                      ReorderableDelayedDragStartListener(
                        index: i,
                        key: Key('$i'),
                        child:Todo(arr: arr + [i]),
                      ) 
                  ],
                  onReorder: (oldIndex, newIndex) {
                    c.reorder(arr, oldIndex, newIndex);
                  },
                ),
              ),
            ),
            MakeTodo(arr: arr),
          ],
        ),
      ),
    );
  }
}

class Notifications extends StatefulWidget {
  const Notifications({ Key? key }) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}
// Provides the notification window
class _NotificationsState extends State<Notifications> {
  final _formkey = GlobalKey<FormState>();
  final fieldText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Notifications'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: fieldText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Displayed text',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: (){
                  if (_formkey.currentState!.validate()) {
                    if (Platform.isAndroid){ //notifications dont work on versions other then android
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sending notification...')));
                      c.incCnt();
                      NotificationService().send(fieldText.text, "", c.getCnt());
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notifications are not possible on this device.')));
                    }
                    fieldText.clear();
                  }
                }, 
                child: Text("Send notification"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Displays the settings tab
class Settings extends StatelessWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 33, 33, 1),
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Accent Color"),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        runSpacing: 5,
                        direction: Axis.horizontal,
                        spacing: 5,
                        children: [
                          for (int i=0; i<c.getColors().length; i++)
                            ColorPick(color: i,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Export to clipboard as json"),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                      onPressed: () => toClip(), 
                      child: Icon(Icons.upload),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Import json from clipboard"),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                      onPressed: () => fromClip(), 
                      child: Icon(Icons.download),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Used to create color selector buttons
class ColorPick extends StatelessWidget {
  const ColorPick({Key? key, required this.color,}) : super(key: key);
  final int color;
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(2),
          primary: c.getColors()[color],
        ),
        onPressed: () {
          c.setColor(color);
        },
        child: Container(),
      ),
    );
  }
}

// displays the button and textfield for adding new todos
class MakeTodo extends StatelessWidget {
  final fieldText = TextEditingController();
  final List<int> arr;
  MakeTodo({ Key? key, required this.arr}) : super(key: key);

  // used when the add button is pressed
  void submitText(String str, Controller c) {
    c.addTodo(arr, str);
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Container(
      padding:EdgeInsets.all(5.0),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines:3,
                  minLines: 1,
                  controller: fieldText,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    labelText: 'New Todo',
                  ),
                  onSubmitted: (String val) => submitText(val, c),
                ),
              ),
              SizedBox(width: 5,),
              SizedBox(
                height: 40,
                width: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(2)),
                  onPressed: () => submitText(fieldText.text, c), 
                  child: Icon(Icons.add)
                ), 
              ),
            ],
          ),
        )
      )
    );
  }
}

// Used by TodoHome to display a todo element on screen
class Todo extends StatelessWidget {
  final List<int> arr;
  const Todo({ Key? key, required this.arr }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();

    return  Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd){
          return showMoveDialog(context, arr);
        }
        return Future<bool>.value(true);
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart){
          c.delTodo(arr);
        }
      },
      background: MoveBox(),
      secondaryBackground: RedBox(),
      direction: DismissDirection.horizontal,
      child: Column(
        children: [
          Center(
            child: TodoCard(arr:arr),
          ),
          GetBuilder<Controller>( //display the sub todo's when the todo is open and there are sub todo's
            builder: (todo) => todo.getOpen(arr) && todo.getTodo(arr).sub.isNotEmpty? ListTodo(arr: arr): SizedBox(),
          ),
        ],
      ),
    );
  }
}

Future<bool> showMoveDialog(BuildContext context, List<int> arr) async {
  final Controller c = Get.find();
  List<int> parr = [...arr];
  int? res = await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      parr.removeLast();
      return SimpleDialog(
        title: Column(
          children: [
            Text('Where do you want to move the item?'),
            Divider()
          ],
        ),
        children: <Widget>[
          if (parr.length > 0)
          SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context,-1); 
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_upward, color: c.getColors()[c.getColor()],),
                  SizedBox(width: 10,),
                  Text("..", 
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          for (int i=0; i<c.getTodo(parr).sub.length; i++)
            if (i != arr[arr.length-1])
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context,i); 
                },
                child: Row(
                  children: [
                    Icon(Icons.chevron_right_rounded, color: c.getColors()[c.getColor()],),
                    SizedBox(width: 10,),
                    Flexible(
                      child: Text(c.getText([...parr, i]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      );
    }
  );
  if (res == null) {
    return Future<bool>.value(false);
  }
  else if (res == -1) {
    if (parr.length > 0){
      parr.removeLast();
      c.moveTodo(arr, parr);
      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  }
  else {
    parr.add(res);
    c.moveTodo(arr, parr);
    return Future<bool>.value(true);
  }
}

// used by Todo to display a red box when being dismissed 
class RedBox extends StatelessWidget {
  const RedBox({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            Expanded(child: Container(),),
            Icon(Icons.delete)
          ],
        )
      ),
    );
  }
}
// used by Todo to display a box when being dismissed to the right
class MoveBox extends StatelessWidget {
  const MoveBox({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>( //display the sub todo's when the todo is open and there are sub todo's
      builder: (todo) => Card(
        color: todo.getColors()[todo.getColor()],
        child: Container(
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          height: 60,
          child: Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.black,),
              Expanded(child: Container(),),
            ],
          )
        ),
      ),
    );
  }
}

// used by Todo to display a card with the text and needed buttons of the todo
class TodoCard extends StatelessWidget {
  const TodoCard({ Key? key,required this.arr, }) : super(key: key);
  final List<int> arr;

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        //height: 60,
        child: Row(
          children: [
            SizedBox(
              height: 40,
              child: GetBuilder<Controller>(
                builder: (todo) => IconButton(
                  onPressed: () => c.toggleDone(arr), 
                  icon: Icon(todo.getDone(arr)? Icons.check_circle_outline: Icons.radio_button_unchecked),
                )
              )
            ),
            Expanded(
              child:
              GetBuilder<Controller>(
                builder: (todo) {
                  return Text("${todo.getText(arr)}",
                    style: TextStyle(
                      fontSize: 18,
                      decoration: todo.getDone(arr)? TextDecoration.lineThrough: TextDecoration.none,
                    ),
                  );
                }
              ),
            ),
            SizedBox(
              height: 40,
              child: GetBuilder<Controller>(
                builder: (todo) => todo.getTodo(arr).sub.isNotEmpty? SizedBox(
                  width: 30,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
                    onPressed: () => c.toggleOpen(arr), 
                    child: Icon(todo.getOpen(arr)?  Icons.expand_less_rounded: Icons.notes),
                  ),
                ): Container(), 
              )
            ),
            SizedBox(width:5),
            SizedBox(
              height: 40,
              child: SizedBox(
                width: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(2)),
                  onPressed: () { 
                    Get.offAll(() => TodoHome(arr: arr));
                  }, 
                  child: Icon(Icons.navigate_next_rounded ),
                ), 
              ),
            )
          ],
        ),
      ),
    );
  }
}

// used by Todo to display its sub elements
class ListTodo extends StatelessWidget {
  final List<int> arr;
  const ListTodo({ Key? key, required this.arr }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25),
      child: GetBuilder<Controller>(
        builder: (todo) => Column(
          children: [
            for (int i=0; i<todo.getTodo(arr).sub.length; i++) Todo(arr: arr + [i],),
          ],
        ),
      ) 
    );
  }
}


