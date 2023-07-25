import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infinite/data/Tags.dart';
import 'package:todo_infinite/data/controllers/SettingsController.dart';
import '../data/controllers/TagsController.dart';
import '../data/controllers/WorkSpaceController.dart';


class TagSettings extends StatelessWidget {
  const TagSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TagList(),
              SizedBox.fromSize(size: Size.fromHeight(8)),
              MakeTag(),
            ],
          )
        )
    );
  }
}

class TagList extends StatelessWidget {
  const TagList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TagsController>(
      builder: (tags) {
        return Column(
          children: [
            Text("Tags", textScaleFactor: 1.3,),
            SizedBox.fromSize(size: Size.fromHeight(8),),
            for (var tag in tags.list())
              TagItem(tag: tag)
          ],
        );
      }
    );
  }
}

class TagItem extends StatelessWidget {
  const TagItem({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(tag.id),
        direction: DismissDirection.endToStart,
        background: Container(color: Colors.red, alignment: AlignmentDirectional.centerEnd, child: Icon(Icons.delete)),
        onDismissed: (direction) => removeTag(),
        child: Container(
            width: double.infinity,
            child: TagItemInfo(tag: tag))
    );
  }

  removeTag() {
    final c = Get.find<TagsController>();
    c.remove(tag.id);
  }
}

class TagItemInfo extends StatelessWidget {
  const TagItemInfo({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    var colors = settings.getColors();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: PopupMenuButton<int>(
        tooltip: "",
        constraints: BoxConstraints(maxHeight: 200),
        child: TagButton(tag: tag),
        onSelected: (value){handleSelect(value);},
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        itemBuilder: (context) => [
          for (var i=0; i<colors.length; i++)
            PopupMenuItem(
                value: i,
                child: Container(
                    width: 80,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: colors[i],
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                ),
        ],),
    );
  }

  void handleSelect(int value) {
    final c = Get.find<TagsController>();
    c.setColor(tag.id, value);
  }
}

class TagButton extends StatelessWidget {
  const TagButton({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Container(
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: settings.colorOf(tag.color),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(tag.label, textScaleFactor: 1.1,));
  }
}


class MakeTag extends StatefulWidget {
  const MakeTag({Key? key}) : super(key: key);
  @override
  State<MakeTag> createState() => _MakeTag();
}

class _MakeTag extends State<MakeTag> {
  final _formkey = GlobalKey<FormState>();
  final fieldText = TextEditingController();

  void addTag() async {
    if (fieldText.text.isEmpty) return;

    final c = Get.find<TagsController>();
    c.addTag(fieldText.text);
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Row(children: [
          Expanded(
            child: TextFormField(
              controller: fieldText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'tag name',
              ),
            ),
          ),
          SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(padding: EdgeInsets.all(2)),
            onPressed: () => addTag(),
            child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.add)
            ),
          ),
        ]));
  }
}
