import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fortune/Src/Leave/LeaveRequest.dart';

/// ---------------- MODEL ----------------
class LeaveModel {
  final String type;
  final String subType;
  final DateTime from;
  final DateTime to;
  final String reason;
  final String status;

  LeaveModel({
    required this.type,
    required this.subType,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
  });
}

class LeaveManagementPage extends StatefulWidget {
  const LeaveManagementPage({super.key});

  @override
  State<LeaveManagementPage> createState() => _LeaveManagementPageState();
}

class _LeaveManagementPageState extends State<LeaveManagementPage> {
  /// DATA
  List<LeaveModel> leaveList = [];

  int selectedYear = DateTime.now().year;

  /// APPLY FORM
  String? applyType;
  String? leaveType;
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController reasonController = TextEditingController();

  /// FILTER
  String? filterType;
  String? filterStatus;

  List<LeaveModel> get filteredLeaveList {
    return leaveList.where((e) {
      if (filterType != null && e.type != filterType) return false;
      if (filterStatus != null && e.status != filterStatus) return false;
      return true;
    }).toList();
  }

  //time
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  @override
  Widget build(BuildContext context) {
    final list = filteredLeaveList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Management"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// TOP BAR
            Row(
              children: [
                _box(
                  child: InkWell(
                    onTap: _pickYear,
                    child: Text("Select Month/Year"),
                  ),
                ),
                SizedBox(width: 5),
                Row(
                  children: [
                    Material(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: _openFilterSheet,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.filter_list, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to ViewDetailsPage and wait for result
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewDetailsPage(
                          leaveList: leaveList, // pass current list if needed
                        ),
                      ),
                    );

                    if (result != null && result is LeaveModel) {
                      // Add new leave
                      setState(() {
                        leaveList.add(result);
                      });
                    }
                  },
                  child: const Text("Apply Leave"),
                ),
              ],
            ),

            const SizedBox(height: 15),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("No Records Found"),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (_, i) => _leaveRow(list[i], i),
              ),
          ],
        ),
      ),
    );
  }

  Widget _leaveRow(LeaveModel item, int index) {
    final actualIndex = leaveList.indexOf(item);
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Type",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _cell(item.subType),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Remarks",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _cell(item.status),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _cell(item.from.toString()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "To Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _cell(item.to.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Reason",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _cell(item.reason),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _cell(item.status),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editLeave(actualIndex),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _deleteLeave(actualIndex),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editLeave(int index) async {
    final item = leaveList[index];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewDetailsPage(leaveList: leaveList, editLeave: item),
      ),
    );

    if (result != null && result is LeaveModel) {
      setState(() {
        leaveList[index] = result; // update the leave
      });
    }
  }

  void _deleteLeave(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Leave"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => leaveList.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField2(
                value: filterType,
                hint: const Text("Type"),
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
                onChanged: (v) => setState(() => filterType = v),
                buttonStyleData: const ButtonStyleData(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 1),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField2(
                value: filterStatus,
                hint: const Text("Status"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 1,
                    vertical: 1,
                  ),
                ),
                items: ["Pending", "Approved", "Rejected"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => filterStatus = v),
                buttonStyleData: const ButtonStyleData(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 1),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          filterType = null;
                          filterStatus = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Clear"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickYear() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(selectedYear),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (d != null) setState(() => selectedYear = d.year);
  }

  Widget _box({required Widget child}) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );

  Widget _cell(String text) {
    return SizedBox(
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
