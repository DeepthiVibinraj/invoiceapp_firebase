import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/custom_container.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/no_data_found.dart';
import 'package:toptalents/pages/invoice/pdf_page.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final String docId;
  final bool isSent;

  InvoiceDetailScreen({required this.docId, required this.isSent});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  bool isEdit = false;
  // bool? isSent;
  Map<String, dynamic>? vendorDetails;
  String? documentId;
  Map<String, dynamic>? documentData;

  String numberToWords(int number) {
    final units = [
      "",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen"
    ];

    final tens = [
      "",
      "",
      "Twenty",
      "Thirty",
      "Forty",
      "Fifty",
      "Sixty",
      "Seventy",
      "Eighty",
      "Ninety"
    ];

    if (number == 0) return "Zero";

    if (number < 0) return "Minus ${numberToWords(-number)}";

    String words = "";

    // Process the Crore part
    if (number >= 10000000) {
      words += "${_convertChunk(number ~/ 10000000, units, tens)} Crore ";
      number = number % 10000000;
    }

    // Process the Lakh part
    if (number >= 100000) {
      words += "${_convertChunk(number ~/ 100000, units, tens)} Lakh ";
      number = number % 100000;
    }

    // Process the Thousand part
    if (number >= 1000) {
      words += "${_convertChunk(number ~/ 1000, units, tens)} Thousand ";
      number = number % 1000;
    }

    // Process the Hundred part
    if (number >= 100) {
      words += "${units[number ~/ 100]} Hundred ";
      number = number % 100;
    }

    if (number > 0) {
      if (number < 20) {
        words += units[number];
      } else {
        words += tens[number ~/ 10];
        if ((number % 10) > 0) {
          words += " ${units[number % 10]}";
        }
      }
    }

    return words.trim();
  }

  String _convertChunk(int chunk, List<String> units, List<String> tens) {
    String chunkWords = "";
    if (chunk > 19) {
      chunkWords = tens[chunk ~/ 10];
      chunk = chunk % 10;
      if (chunk > 0) {
        chunkWords += " ${units[chunk]}";
      }
    } else if (chunk > 0) {
      chunkWords = units[chunk];
    }
    return chunkWords;
  }

  String? vendorName;

  @override
  void initState() {
    // TODO: implement initState
    _fetchData();

    super.initState();
  }

  Future<void> _fetchData() async {
    Map<String, dynamic> invoiceData = await fetchInvoiceData(widget.docId);

    print('invoice data@@@@@@@@@$invoiceData');
    vendorName = invoiceData['Vendor Name'];
    print(vendorName);

    QuerySnapshot vendorSnapshot = await FirebaseFirestore.instance
        .collection('vendor_collection')
        .where('Vendor Name', isEqualTo: vendorName)
        .get();
    documentId = vendorSnapshot.docs.first.id;
    print('documentid##########$documentId');
    if (documentId != null) {
      Map<String, dynamic>? documentData =
          await getDocumentDataById(documentId!);

      if (documentData != null) {
        print('Document Data: $documentData');

        print('Vendor phone: ${documentData['City']}');
      } else {
        print('No data found for document ID: $documentId');
      }
    } else {
      print('No document found for vendor name: $vendorName');
    }
    vendorDetails = vendorSnapshot.docs.first.data() as Map<String, dynamic>;
    print('VendorDetail${vendorDetails}');
  }

  Future<Map<String, dynamic>?> getDocumentDataById(String documentId) async {
    try {
      // Get the document snapshot by document ID
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('vendor_collection')
          .doc(documentId)
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Return the document data as a map
        return documentSnapshot.data() as Map<String, dynamic>?;
      } else {
        // Document does not exist
        return null;
      }
    } catch (e) {
      print('Error getting document data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchInvoiceData(String invoiceId) async {
    print('***********invoiceId $invoiceId');
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('invoice_collection')
        .doc(invoiceId)
        .get();
    return snapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        appBar: CustomAppBar(
            detailScreen: true,
            deleteFunction: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Confirm Deletion',
                    ),
                    content: const Text(
                      'Are you sure you want to delete the invoice?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes
                              .invoiceScreen); // Return false to not delete;
                        },
                        child: Text(
                          'Cancel',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.secondary),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('invoice_collection')
                              .doc(widget.docId)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Invoice deleted successfully')));
                          Navigator.of(context)
                              .pop(true); // Return true to delete
                          Get.offAllNamed(AppRoutes.invoiceScreen);
                        },
                        child: Text('Delete',
                            style: TextStyle(color: colorScheme.secondary)),
                      ),
                    ],
                  );
                },
              );
            }),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('invoice_collection')
              .doc(widget.docId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No data found'));
            }

            // Get document data
            final invoice = snapshot.data!.data() as Map<String, dynamic>;

            List<String> selectedCourses =
                List<String>.from(invoice['selectedCourses'] ?? []);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeaderText('Invoice Details'),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding / 4,
                              horizontal: defaultPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultPadding),
                            color: widget.isSent
                                ? colorScheme.primary
                                : colorScheme.secondary,
                          ),
                          child: Center(
                            child: Text(
                              widget.isSent ? 'Sent' : 'Not Sent',
                              style: textTheme.titleMedium!
                                  .copyWith(color: colorScheme.surface),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    CustomContainer(
                        child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Row(children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Invoice#: ',
                                style: textTheme.titleMedium!
                                    .copyWith(color: Colors.black54),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: Text(invoice['invoiceId'] ?? 'N/A'))
                          ]),
                          const SizedBox(height: defaultPadding / 2),
                          Row(children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Invoice Date',
                                style: textTheme.titleMedium!
                                    .copyWith(color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(invoice['invoiceDate']),
                              //  Text(invoice['invoiceId'] ?? 'N/A')
                            )
                          ]),
                          const SizedBox(height: defaultPadding / 2),
                          Row(children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Due Date',
                                style: textTheme.titleMedium!
                                    .copyWith(color: Colors.black54),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(invoice['invoiceDueDate']),
                              //  Text(invoice['invoiceId'] ?? 'N/A')
                            )
                          ]),
                        ],
                      ),
                    )),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      'Vendor Details',
                      style:
                          textTheme.titleMedium?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Row(children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Name: ',
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        ),
                      ),
                      Expanded(
                          flex: 3, child: Text(invoice['Vendor Name'] ?? 'N/A'))
                    ]),
                    const SizedBox(height: defaultPadding),
                    Row(children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Address: ',
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('vendor_collection')
                                .where('Vendor Name',
                                    isEqualTo: invoice['Vendor Name'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const NoDataFound();
                              }
                              final vendorData = snapshot.data!.docs.first
                                  .data() as Map<String, dynamic>;

                              return Text(vendorData['Address Line1'] +
                                  ", " +
                                  vendorData['Address Line2'] +
                                  "\n" +
                                  vendorData['City']);
                            }),
                      ),
                    ]),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    const Divider(),
                    const SizedBox(height: defaultPadding / 2),
                    Text(
                      'Selected Courses:',
                      style:
                          textTheme.titleMedium?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchCourseDetails(selectedCourses),
                      builder: (context, courseSnapshot) {
                        if (courseSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (courseSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${courseSnapshot.error}'));
                        }
                        if (!courseSnapshot.hasData ||
                            courseSnapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No course data found'));
                        }

                        List<Map<String, dynamic>> courses =
                            courseSnapshot.data!;
                        double totalAmount =
                            courses.fold(0.0, (sum, courseData) {
                          return sum +
                              calculateTotalPrice(
                                courseData['Course Price'],
                                invoice['gstRate'],
                              );
                        });

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Table(
                              //border: TableBorder.all(color: Colors.black54),
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: defaultPadding / 2,
                                          top: defaultPadding / 2,
                                          bottom: defaultPadding / 2),
                                      child: Text('Name',
                                          style: textTheme.titleMedium),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Price',
                                          style: textTheme.titleMedium),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('GST',
                                          style: textTheme.titleMedium),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: defaultPadding / 2,
                                          top: defaultPadding / 2,
                                          bottom: defaultPadding / 2),
                                      child: Text(
                                        'Amount',
                                        style: textTheme.titleMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final courseData = courses[index];

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: CourseDetailRow(
                                      courseData: courseData,
                                      invoiceData: invoice),
                                );
                              },
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            const Divider(),
                            const SizedBox(height: defaultPadding / 2),
                            Text(
                              'Notes:',
                              style: textTheme.titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              invoice['notes'] ?? 'N/A',
                              style: textTheme.titleMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            const Divider(),
                            const SizedBox(height: defaultPadding / 2),
                            // const SizedBox(
                            //   height: defaultPadding,
                            // ),
                            Text(
                              'Total Amount',
                              style: textTheme.titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${numberToWords(totalAmount.toInt())} only',
                                        style: textTheme.titleMedium!
                                            .copyWith(color: Colors.black54),
                                      ),
                                      const SizedBox(
                                        height: defaultPadding / 2,
                                      ),
                                      Text(
                                        'Rs.${totalAmount.toStringAsFixed(2)}/-',
                                        style: textTheme.titleLarge!
                                            .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: defaultPadding * 2,
                            ),
                            if (widget.isSent == false)
                              Container(
                                width: width,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PDFPage(
                                                  invoiceID: widget.docId,
                                                  fromRecent: false,
                                                )),
                                      );
                                    },
                                    child: const Text('Generate PDF')),
                              )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: widget.isSent == false
            ? Card(
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.edit,
                      size: 25, color: Color.fromARGB(250, 253, 180, 27)),
                  onPressed: () {
                    setState(() {
                      isEdit = true;
                    });
                    Get.toNamed(AppRoutes.addInvoiceScreen, arguments: {
                      'argument1': isEdit,
                      'argument2': widget.docId,
                      'argument3': vendorName,
                    });
                  },
                ),
              )
            : null);
  }

  Future<List<Map<String, dynamic>>> fetchCourseDetails(
      List<String> courseNames) async {
    List<Map<String, dynamic>> courseDetails = [];

    for (String courseName in courseNames) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('courses_collection')
          .where('Course Name', isEqualTo: courseName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot courseDoc = querySnapshot.docs.first;
        courseDetails.add(courseDoc.data() as Map<String, dynamic>);
      } else {
        print('Course not found for name: $courseName');
      }
    }

    return courseDetails;
  }

  double calculateTotalPrice(String? price, String? gstRate) {
    if (price == null || gstRate == null) {
      return 0.0;
    }
    double priceValue = double.tryParse(price) ?? 0.0;
    double gstValue = double.tryParse(gstRate) ?? 0.0;
    double total = priceValue + (priceValue * gstValue / 100);
    return total;
  }
}

Future<List<Map<String, dynamic>>> fetchInvoiceCourses(String invoiceId) async {
  List<Map<String, dynamic>> courseDetails = [];

  // Fetch invoice details
  var invoiceSnapshot = await FirebaseFirestore.instance
      .collection('invoices')
      .doc(invoiceId)
      .get();

  if (invoiceSnapshot.exists) {
    var invoiceData = invoiceSnapshot.data();
    List<dynamic> selectedCourses = invoiceData?['selectedCourses'] ?? [];
    double gstRate = invoiceData?['gstRate'] ?? 0;

    // Fetch course details for each selected course ID
    for (var courseId in selectedCourses) {
      var courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();

      if (courseSnapshot.exists) {
        var courseData = courseSnapshot.data();
        courseDetails.add({
          'courseName': courseData?['courseName'],
          'courseDescription': courseData?['courseDescription'],
          'price': courseData?['price'],
          'gstRate': gstRate, // Adding GST rate from the invoice
        });
      }
    }
  }

  return courseDetails;
}

class CourseDetailRow extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final Map<String, dynamic> invoiceData;

  CourseDetailRow({required this.courseData, required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Table(
      //border: TableBorder.all(color: Colors.black54),
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: defaultPadding / 2,
                  top: defaultPadding / 2,
                  bottom: defaultPadding / 2),
              child: Text(courseData['Course Name'] ?? 'N/A',
                  style:
                      textTheme.titleMedium!.copyWith(color: Colors.black54)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(courseData['Course Price']?.toString() ?? 'N/A',
                  style:
                      textTheme.titleMedium!.copyWith(color: Colors.black54)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${invoiceData['gstRate']?.toString()}%' ?? 'N/A',
                  style:
                      textTheme.titleMedium!.copyWith(color: Colors.black54)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: defaultPadding / 2,
                  top: defaultPadding / 2,
                  bottom: defaultPadding / 2),
              child: Text(
                (calculateTotalPrice(
                  courseData['Course Price'],
                  invoiceData['gstRate'],
                )).toStringAsFixed(2),
                style: textTheme.titleMedium!.copyWith(color: Colors.black54),
              ),
            ),
          ],
        ),
      ],
    );
  }

  double calculateTotalPrice(String? price, String? gstRate) {
    if (price == null || gstRate == null) {
      return 0.0;
    }
    double priceValue = double.tryParse(price) ?? 0.0;
    double gstValue = double.tryParse(gstRate) ?? 0.0;
    double total = priceValue + (priceValue * gstValue / 100);
    return total;
  }
}
