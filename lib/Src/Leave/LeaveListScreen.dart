import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortune/Common_Widgets/Custom_App_Bar.dart';
import 'package:fortune/Model/LeaveRequestListModel.dart';
import 'package:fortune/Src/Leave/LeaveRequest.dart';
import 'package:fortune/utilits/ApiProvider.dart';
import 'package:fortune/utilits/Generic.dart';

class LeaveManagementPage extends ConsumerStatefulWidget {
  const LeaveManagementPage({super.key});

  @override
  ConsumerState<LeaveManagementPage> createState() =>
      _LeaveManagementPageState();
}

class _LeaveManagementPageState extends ConsumerState<LeaveManagementPage> {
  /// DATA
  List<RequestListData> leaveList = [];

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

  List<RequestListData> get filteredLeaveList {
    return leaveList.where((e) {
      if (filterType != null && e.recordType != filterType) return false;
      if (filterStatus != null && e.status != filterStatus) return false;
      return true;
    }).toList();
  }

  //time
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  @override
  Widget build(BuildContext context) {
    final leaveRequestData = ref.watch(leaveRequestListProvider);

    return Scaffold(
      appBar: Custom_AppBar(
          title: "Leave Management", actions: [], isGreen: false, isNav: true),
      // AppBar(
      //   title: const Text("Leave Management"),
      //   backgroundColor: Colors.blue,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to ViewDetailsPage and wait for result
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewDetailsPage(),
            ),
          ).then((onValue) {
            ref.refresh(leaveRequestListProvider);
          });
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// TOP BAR
            // Row(
            //   children: [
            //     _box(
            //       child: InkWell(
            //         onTap: _pickYear,
            //         child: Text("Select Month/Year"),
            //       ),
            //     ),
            //     SizedBox(width: 5),
            //     Row(
            //       children: [
            //         Material(
            //           color: Colors.blue,
            //           borderRadius: BorderRadius.circular(10),
            //           child: InkWell(
            //             borderRadius: BorderRadius.circular(10),
            //             onTap: _openFilterSheet,
            //             child: Padding(
            //               padding: EdgeInsets.all(8),
            //               child: Icon(Icons.filter_list, color: Colors.white),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     const Spacer(),
            //     ElevatedButton(
            //       onPressed: () async {
            //         // Navigate to ViewDetailsPage and wait for result
            //         final result = await Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (_) => ViewDetailsPage(),
            //           ),
            //         );

            //         if (result != null && result is RequestListData) {
            //           // Add new leave
            //           setState(() {
            //             leaveList.add(result);
            //           });
            //         }
            //       },
            //       child: const Text("Apply Leave"),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 15),
            leaveRequestData.when(data: (data) {
              // Process data and populate leaveList
              if (data?.data?.isEmpty ?? true) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No Records Found"),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data?.data?.length ?? 0,
                  itemBuilder: (_, i) => _leaveRow(data!.data![i], i),
                );
              }
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            }, error: (err, stack) {
              return Center(child: Text('Error: $err'));
            }),
          ],
        ),
      ),
    );
  }

  Widget _leaveRow(RequestListData item, int index) {
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
                          _cell(item.recordType ?? ""),
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
                          _cell(item.status ?? ""),
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
                          _cell(item.fromDate.toString()),
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
                          _cell(item.toDate.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reason",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _cell(item.reason ?? ""),
                  ],
                ),
              ],
            ),
          ),
          item.status == "PENDING"
              ? Positioned(
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _editLeave(item, index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.red),
                        onPressed: () => _deleteLeave(
                            item.recordType ?? "", item.id ?? "", ref),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void _editLeave(RequestListData item, int index) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ViewDetailsPage(editLeave: item),
      ),
    ).then((onValue) {
      ref.refresh(leaveRequestListProvider);
    });
  }

  void _deleteLeave(String type, String index, WidgetRef ref) {
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
            onPressed: () async {
              Navigator.pop(context);

              SingleTon singleTon = SingleTon();
              singleTon.formData1 = {"type": type == "PERMISSION" ? 2 : 1};

              await ref.read(leaveRequestDelete(index).future);
              ref.refresh(leaveRequestListProvider);
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
      child: Text(
        text,
      ),
    );
  }
}
