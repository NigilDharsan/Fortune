import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fortune/Src/Leave/LeaveListScreen.dart';

class ViewDetailsPage extends StatefulWidget {
  final List<LeaveModel>? leaveList;
  final LeaveModel? editLeave;

  const ViewDetailsPage({super.key, this.leaveList, this.editLeave});

  @override
  State<ViewDetailsPage> createState() => _ViewDetailsPageState();
}

class _ViewDetailsPageState extends State<ViewDetailsPage> {
  String? applyType;
  String? leaveType;
  DateTime? fromDate;
  DateTime? toDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  TextEditingController reasonController = TextEditingController();

  List<LeaveModel> leaveList = [];

  int? editIndex;

  void _clearForm() {
    setState(() {
      applyType = null;
      leaveType = null;
      fromDate = null;
      toDate = null;
      fromTime = null;
      toTime = null;
      reasonController.clear();
      editIndex = null;
    });
  }

  Future<void> _pickDate(bool isFrom) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        if (isFrom) {
          fromDate = date;
          toDate ??= date;
        } else {
          toDate = date;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.editLeave != null) {
      final e = widget.editLeave!;
      applyType = e.type;
      leaveType = e.subType != "Permission" ? e.subType : null;
      fromDate = e.from;
      toDate = e.to;
      reasonController.text = e.reason;
    }
  }

  void _submit() {
    if (applyType == null) return;

    final model = LeaveModel(
      type: applyType!,
      subType: leaveType ?? "Permission",
      from: fromDate ?? DateTime.now(),
      to: toDate ?? fromDate ?? DateTime.now(),
      reason: reasonController.text,
      status: "Pending",
    );

    Navigator.pop(context, model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editLeave != null ? "Edit Leave" : "Apply Leave"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Type Dropdown

              DropdownButtonFormField2<String>(
                value: applyType,
                hint: const Text("Select Type"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 1,
                    vertical: 1,
                  ),
                ),
                items: ["Leave", "Permission"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => applyType = v),
                buttonStyleData: const ButtonStyleData(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 1),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                ),
              ),

              const SizedBox(height: 12),

              /// Leave Type + Count boxes
              if (applyType == "Leave") ...[
                DropdownButtonFormField2<String>(
                  value: leaveType,
                  hint: const Text("Leave Type"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 1,
                      vertical: 1,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Casual Leave",
                      child: Text("Casual Leave"),
                    ),
                    DropdownMenuItem(
                      value: "Sick Leave",
                      child: Text("Sick Leave"),
                    ),
                  ],
                  onChanged: (v) => setState(() => leaveType = v),
                  buttonStyleData: const ButtonStyleData(
                    height: 20,
                    padding: EdgeInsets.symmetric(horizontal: 1),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                  ),
                ),
                if (leaveType != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      _CountBox(title: "Available", value: "12"),
                      SizedBox(width: 8),
                      _CountBox(title: "Yearly Used", value: "6"),
                      SizedBox(width: 8),
                      _CountBox(title: "Monthly Used", value: "1"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _datePicker("From Date", fromDate, () => _pickDate(true)),
                  const SizedBox(height: 12),
                  _datePicker("To Date", toDate, () => _pickDate(false)),
                ],
              ],

              if (applyType == "Permission") ...[
                _datePicker("Date", fromDate, () => _pickDate(true)),
                const SizedBox(height: 10),
                _timePicker(
                  context,
                  "From Time",
                  fromTime,
                  (t) => setState(() => fromTime = t),
                ),
                const SizedBox(height: 10),
                _timePicker(
                  context,
                  "To Time",
                  toTime,
                  (t) => setState(() => toTime = t),
                ),
              ],

              /// Reason
              if (applyType != null) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Reason",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(widget.editLeave != null ? "Update" : "Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// CountBox Widget
class _CountBox extends StatelessWidget {
  final String title;
  final String value;

  const _CountBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// Date Picker Widget
Widget _datePicker(String label, DateTime? date, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: Text(
        date != null ? "${date.toLocal()}".split(' ')[0] : "Select Date",
      ),
    ),
  );
}

/// Time Picker Widget
Widget _timePicker(
  BuildContext context,
  String label,
  TimeOfDay? time,
  ValueChanged<TimeOfDay> onChanged,
) {
  return InkWell(
    onTap: () async {
      final t = await showTimePicker(
        context: context,
        initialTime: time ?? TimeOfDay.now(),
      );
      if (t != null) onChanged(t);
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: Text(time != null ? time.format(context) : "Select Time"),
    ),
  );
}
