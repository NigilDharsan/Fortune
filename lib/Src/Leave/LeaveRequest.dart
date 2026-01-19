import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Model/LeaveRequestListModel.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Generic.dart';
import 'package:intl/intl.dart';

class ViewDetailsPage extends ConsumerStatefulWidget {
  final RequestListData? editLeave;

  const ViewDetailsPage({super.key, this.editLeave});

  @override
  ConsumerState<ViewDetailsPage> createState() => _ViewDetailsPageState();
}

class _ViewDetailsPageState extends ConsumerState<ViewDetailsPage> {
  String? applyType;
  String? leaveType;
  int? leaveTypeID;

  DateTime? fromDate;
  DateTime? toDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  TextEditingController reasonController = TextEditingController();

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
          //"03-01-2026"
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
      applyType = e.recordType ?? "";
      leaveType = "PERMISSION"; //e.subType != "Permission" ? e.subType : null;
      fromDate =
          e.fromDate != null ? getFormattedDateTime(e.fromDate ?? "") : null;
      toDate = e.toDate != null ? getFormattedDateTime(e.toDate!) : null;
      reasonController.text = e.reason ?? "";
      if (e.fromTime != null && e.fromTime!.isNotEmpty) {
        final fromParts = e.fromTime!.split(":");
        fromTime = TimeOfDay(
            hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1]));
      }
      if (e.toTime != null && e.toTime!.isNotEmpty) {
        final toParts = e.toTime!.split(":");
        toTime = TimeOfDay(
            hour: int.parse(toParts[0]), minute: int.parse(toParts[1]));
      }
    }
  }

  Future<void> _submit() async {
    if (applyType == null) return;

    if (applyType == "LEAVE" &&
        (leaveType == null || fromDate == null || toDate == null)) {
      return;
    }
    if (applyType == "PERMISSION" &&
        (fromDate == null || fromTime == null || toTime == null)) {
      return;
    }

    var formdata = FormData();

    if (applyType == "LEAVE") {
      formdata = FormData.fromMap({
        "type": applyType == "LEAVE" ? "1" : "2",
        "leave_type": leaveTypeID ?? "",
        "from_date": fromDate != null
            ? convertDateFormat("${fromDate!.toLocal()}".split(' ')[0])
            : "",
        "to_date": toDate != null
            ? convertDateFormat("${toDate!.toLocal()}".split(' ')[0])
            : "",
        "from_time": fromTime != null ? fromTime!.format(context) : "",
        "to_time": toTime != null ? toTime!.format(context) : "",
        "reason": reasonController.text,
      });
    } else {
      formdata = FormData.fromMap({
        "type": applyType == "LEAVE" ? "1" : "2",
        "from_date": fromDate != null
            ? convertDateFormat("${fromDate!.toLocal()}".split(' ')[0])
            : "",
        "to_date": toDate != null
            ? convertDateFormat("${toDate!.toLocal()}".split(' ')[0])
            : "",
        "from_time": fromTime != null ? fromTime!.format(context) : "",
        "to_time": toTime != null ? toTime!.format(context) : "",
        "reason": reasonController.text,
      });
    }

    if (widget.editLeave != null) {
      SingleTon singleTon = SingleTon();

      singleTon.formData = formdata;

      final results =
          await ref.read(leaveRequestUpdate(widget.editLeave?.id ?? "").future);
      if (results == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(results!.message ?? 'Leave request submitted.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit leave request.')),
        );
      }
    } else {
      final results = await ref.read(leaveRequestPost(formdata).future);
      if (results == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(results!.message ?? 'Leave request submitted.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit leave request.')),
        );
      }
    }

    Navigator.pop(context);
  }

  String convertDateFormat(String dateStr) {
    // 1. Parse the input string (yyyy-MM-dd)
    DateTime tempDate = DateFormat('yyyy-MM-dd').parse(dateStr);

    // 2. Format it to the output string (dd-MM-yyyy)
    String formattedDate = DateFormat('dd-MM-yyyy').format(tempDate);

    return formattedDate;
  }

  DateTime? getFormattedDateTime(String input) {
    try {
      // 1. Parse the ISO string (2026-01-19) into a DateTime object
      DateTime initialDate = DateTime.parse(input);

      // 2. Format it to the European style string (19-01-2026)
      String formattedStr = DateFormat('dd-MM-yyyy').format(initialDate);

      // 3. Parse it back into a DateTime object
      // This confirms the DateTime is valid for the 'dd-MM-yyyy' format
      DateTime finalDateTime = DateFormat('dd-MM-yyyy').parse(formattedStr);

      return finalDateTime;
    } catch (e) {
      print("Error parsing date: $e");
      return null; // Returns null if the input string is invalid
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveTypeData = ref.watch(leaveTypeProvider);

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
                items: ["LEAVE", "PERMISSION"]
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
              if (applyType == "LEAVE") ...[
                leaveTypeData.when(
                  data: (data) {
                    return DropdownButtonFormField2<String>(
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
                      items: data!.data!
                          .map((e) => DropdownMenuItem(
                                value: e.name,
                                child: Text(e.name ?? ""),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          leaveType = v;
                          final selectedType = data.data!
                              .firstWhere((element) => element.name == v);
                          leaveTypeID = selectedType.id;
                        });
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 20,
                        padding: EdgeInsets.symmetric(horizontal: 1),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text('Error: $e'),
                ),
                if (leaveType != null) ...[
                  const SizedBox(height: 12),
                  ref.watch(leaveBalance(leaveTypeID ?? 0)).when(
                        data: (data) {
                          return Row(
                            children: [
                              _CountBox(
                                  title: "Available",
                                  value:
                                      "${data?.data?.availableBalance ?? 0}"),
                              const SizedBox(width: 8),
                              _CountBox(
                                  title: "Yearly Used",
                                  value: "${data?.data?.yearlyUsed ?? 0}"),
                              const SizedBox(width: 8),
                              _CountBox(
                                  title: "Monthly Used",
                                  value: "${data?.data?.monthlyLimit ?? 0}"),
                            ],
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (e, st) => Text('Error: $e'),
                      ),
                  // Row(
                  //   children: const [
                  //     _CountBox(title: "Available", value: "12"),
                  //     SizedBox(width: 8),
                  //     _CountBox(title: "Yearly Used", value: "6"),
                  //     SizedBox(width: 8),
                  //     _CountBox(title: "Monthly Used", value: "1"),
                  //   ],
                  // ),
                  const SizedBox(height: 12),
                  _datePicker("From Date", fromDate, () => _pickDate(true)),
                  const SizedBox(height: 12),
                  _datePicker("To Date", toDate, () => _pickDate(false)),
                ],
              ],

              if (applyType == "PERMISSION") ...[
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
