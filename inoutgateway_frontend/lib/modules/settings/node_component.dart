import 'package:flutter/material.dart';
import 'package:inoutgateway_frontend/modules/settings/edit_node_component.dart';

class NodeComponent extends StatefulWidget {
  const NodeComponent({super.key});

  @override
  State<NodeComponent> createState() => _NodeComponentState();
}

class _NodeComponentState extends State<NodeComponent> {
  bool isEditing = false;
  void startEditing() {
    setState(() {
      isEditing = true;
    });
  }

  void closeEditing() {
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isEditing)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(onPressed: () {}, child: Text("ADD")),
                        SizedBox(width: 8),
                        ElevatedButton(onPressed: () {}, child: Text("DELETE")),
                      ],
                    ),
                    Text("10 items / page"),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Checkbox(value: false, onChanged: (bool? value) {})),
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Uptime")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: List.generate(
                        10,
                        (index) => DataRow(
                          cells: [
                            DataCell(Checkbox(value: false, onChanged: (bool? value) {})),
                            DataCell(Text("Item \$index")),
                            DataCell(Text("Up for \$index hours")),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(icon: Icon(Icons.edit), onPressed: () => startEditing()),
                                  IconButton(icon: Icon(Icons.delete), onPressed: () {}),
                                  IconButton(icon: Icon(Icons.info), onPressed: () {}),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          EditNodeComponent(onClose: closeEditing),
      ],
    );
  }
}
