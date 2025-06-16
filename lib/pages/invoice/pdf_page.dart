import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';

class PDFPage extends StatefulWidget {
  final String invoiceID;
  final bool fromRecent;
  const PDFPage({super.key, required this.invoiceID, required this.fromRecent});
  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  File? _pdfFile;
  double totalAmount = 0.0;
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
  // Map<String, dynamic> invoiceDataNew = await fetchInvoiceData(invoiceID);

  @override
  void initState() {
    super.initState();
    print('.**********************.$isShared..**********************..');
    print(
        '........................reached PDFPage.${widget.invoiceID}................');
    print(
        '........................from invoice details page.....${widget.invoiceID}................');
    _generatePdfNew(widget.invoiceID);
  }

  late Map<String, dynamic> invoiceData;
  late Map<String, dynamic> vendorData;
  Future<void> _generatePdfNew(String invoiceID) async {
    try {
      invoiceData = await fetchInvoiceData(invoiceID);
      vendorData = await fetchVendorData(invoiceData['Vendor Name']);
      List<Map<String, dynamic>> courseDetails = await fetchSelectedCourses(
          List<String>.from(invoiceData['selectedCourses']));

      // Generate and preview PDF
      await generateInvoicePdf(
        invoiceData: invoiceData,
        vendorData: vendorData,
        courseDetails: courseDetails,
      );
    } catch (e) {
      print('Error: $e');
    }
    if (_pdfFile != null) {
      await sharePdf(_pdfFile!);
    }
  }

  Future<Map<String, dynamic>> fetchInvoiceData(String invoiceId) async {
    // Fetch invoice document
    DocumentSnapshot invoiceSnapshot = await FirebaseFirestore.instance
        .collection('invoice_collection')
        .doc(invoiceId)
        .get();

    if (invoiceSnapshot.exists) {
      return invoiceSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Invoice not found');
    }
  }

  Future<Map<String, dynamic>> fetchVendorData(String vendorName) async {
    // Query vendor by vendorName
    QuerySnapshot vendorSnapshot = await FirebaseFirestore.instance
        .collection('vendor_collection')
        .where('Vendor Name', isEqualTo: vendorName)
        .get();

    if (vendorSnapshot.docs.isNotEmpty) {
      return vendorSnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      throw Exception('Vendor not found');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSelectedCourses(
      List<String> courseNames) async {
    List<Map<String, dynamic>> courseDetails = [];

    for (String courseName in courseNames) {
      QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('courses_collection')
          .where('Course Name', isEqualTo: courseName)
          .get();

      if (courseSnapshot.docs.isNotEmpty) {
        courseDetails
            .add(courseSnapshot.docs.first.data() as Map<String, dynamic>);
      }
    }

    return courseDetails;
  }

  Future<void> generateInvoicePdf({
    required Map<String, dynamic> invoiceData,
    required Map<String, dynamic> vendorData,
    required List<Map<String, dynamic>> courseDetails,
  }) async {
    var gstRate = invoiceData['gstRate'];
    try {
      final pdf = pw.Document();
      final ByteData bytes =
          await rootBundle.load(ImageConstant.institution_emblem);
      final Uint8List imageData = bytes.buffer.asUint8List();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
          header: (pw.Context context) {
            return pw.Column(children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5),
                color: PdfColors.indigo50,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(children: [
                        pw.Center(
                          child: pw.Image(
                            pw.MemoryImage(
                              imageData,
                            ),
                            height: height * 1.5,
                            width: width * 0.6,
                          ),
                        ),
                      ]),
                      pw.SizedBox(height: defaultPadding / 2),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Center(
                              child: pw.Text('INVOICE',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromHex('#FDB41B'))),
                            ),
                            pw.SizedBox(height: defaultPadding / 2),
                            pw.Text('The Sample Institution',
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#686198'))),
                            pw.SizedBox(
                              height: defaultPadding / 2,
                            ),
                            pw.Text('3/325, Gandhi Nagar',
                                style: const pw.TextStyle(
                                    fontSize: 16, color: PdfColors.black)),
                            pw.SizedBox(
                              height: defaultPadding / 2,
                            ),
                            pw.Text('Saidapet',
                                style: const pw.TextStyle(
                                    fontSize: 16, color: PdfColors.black)),
                            pw.SizedBox(
                              height: defaultPadding / 2,
                            ),
                            pw.Text('Chennai - 600002',
                                style: const pw.TextStyle(
                                    fontSize: 16, color: PdfColors.black)),
                          ],
                        ),
                      ),
                    ]),
              ),
              pw.SizedBox(height: defaultPadding * 1.5)
            ]);
          },
          footer: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(defaultPadding * 1.5),
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Page ${context.pageNumber}',
                style: const pw.TextStyle(
                    fontSize: 12, color: PdfColors.indigo100),
              ),
            );
          },
          build: (pw.Context context) => <pw.Widget>[
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Bill To:',
                              style: const pw.TextStyle(
                                fontSize: 16,
                              )),
                          pw.SizedBox(height: defaultPadding / 4),
                          pw.Text('${vendorData['Vendor Name']}',
                              style: pw.TextStyle(
                                  fontSize: 17,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: defaultPadding / 4),
                          pw.Text('${vendorData['Address Line1']}',
                              style: const pw.TextStyle(
                                fontSize: 16,
                              )),
                          pw.SizedBox(height: defaultPadding / 4),
                          pw.Text('${vendorData['Address Line2']}',
                              style: const pw.TextStyle(
                                fontSize: 16,
                              )),
                          pw.SizedBox(height: defaultPadding / 4),
                          pw.Text('${vendorData['City']}',
                              style: const pw.TextStyle(
                                fontSize: 16,
                              )),
                          pw.SizedBox(height: defaultPadding / 4),
                        ]),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('INVOICE#'),
                        pw.SizedBox(
                          height: defaultPadding / 4,
                        ),
                        pw.Text(invoiceData['invoiceId'],
                            style: pw.TextStyle(
                                fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(
                          height: defaultPadding / 4,
                        ),
                        pw.Text('DATE:'),
                        pw.SizedBox(
                          height: defaultPadding / 4,
                        ),
                        pw.Text(invoiceData['invoiceDate']),
                        pw.SizedBox(
                          height: defaultPadding / 4,
                        ),
                        pw.Text('DUE DATE:'),
                        pw.SizedBox(
                          height: defaultPadding / 4,
                        ),
                        pw.Text(invoiceData['invoiceDate']),
                      ],
                    )
                  ]),
            ),
            pw.SizedBox(height: defaultPadding),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5),
              child: pw.Divider(
                color: PdfColors.indigo100,
                indent: 0,
                endIndent: 0,
              ),
            ),
            pw.SizedBox(height: defaultPadding),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5),
              child: pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Table Header
                  pw.TableRow(
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Courses',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ),
                      ),
                      pw.Expanded(
                        flex: 4,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Description',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Price',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Tax',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              left: 8.0, top: 8.0, bottom: 8.0),
                          child: pw.Text('Amount',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ),
                      ),
                    ],
                  ),

                  // Table Rows for Data
                  ...courseDetails.map((course) {
                    var price = course['Course Price'];
                    double gstAmount =
                        double.parse(price) * (double.parse(gstRate) / 100);

                    double totalPrice = double.parse(price) + gstAmount;
                    totalAmount += totalPrice;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            course['Course Name'],
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            course['Course Description'],
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            price,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            gstRate.toString(),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              left: 8.0, top: 8.0, bottom: 8.0),
                          child: pw.Text(
                            totalPrice.toString(),
                            //textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            pw.Spacer(),
            pw.SizedBox(height: defaultPadding),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5),
              child: pw.Divider(
                color: PdfColors.indigo100,
                indent: 0,
                endIndent: 0,
              ),
            ),
            pw.SizedBox(height: defaultPadding),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                        flex: 1,
                        child: pw.Text('Total',
                            style: const pw.TextStyle(fontSize: 16))),
                    pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text('Rs. ${totalAmount.toString()}'),
                            pw.SizedBox(
                              height: defaultPadding / 4,
                            ),
                            pw.Text(
                                '${numberToWords(totalAmount.toInt())} only')
                          ],
                        ))
                  ]),
            ),
            pw.SizedBox(height: defaultPadding),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5),
              child: pw.Expanded(
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                            padding: const pw.EdgeInsets.all(defaultPadding),
                            height: 100,
                            color: PdfColors.indigo50,
                            child: pw.Row(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Expanded(
                                      child: pw.Text(
                                          'Notes:  ${invoiceData['notes']}',
                                          style: const pw.TextStyle(
                                              fontSize: 16,
                                              color: PdfColors.black)))
                                ]))),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: const pw.EdgeInsets.all(defaultPadding),
                            height: 100,
                            color: PdfColor.fromHex('#686198'),
                            child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text('Total:',
                                      style: const pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 14)),
                                  pw.Text('Rs.${totalAmount.toString()}',
                                      style: const pw.TextStyle(
                                          color: PdfColors.white, fontSize: 18))
                                ])))
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: defaultPadding / 2),
            pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: defaultPadding * 1.5),
                child: pw.Center(
                  child: pw.Text(
                    '***This is a Computer Generated Invoice***',
                  ),
                )),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/example.pdf');
      await file.writeAsBytes(await pdf.save());
      setState(() {
        _pdfFile = file;
      });

      print('PDF created successfully: ${file.path}');
    } catch (e) {
      print('Error creating PDF: $e');
    }
  }

  Future<void> sharePdf(File pdfFile) async {
    try {
      // Attempt to share the PDF file
      print('......................sharing..........');
      //await Share.shareFiles([pdfFile.path], text: 'Here is your invoice.');

      // If no error occurs, upload the PDF to Firebase Storage
      await uploadPdfToStorage(pdfFile, widget.invoiceID);

      print("PDF shared successfully and uploaded.");
    } catch (e) {
      print("Error during PDF sharing: $e");
    }
  }

  Future<void> uploadPdfToStorage(File pdfFile, String invoiceID) async {
    try {
      String fileName = 'invoice_$invoiceID.pdf';
      Reference storageRef =
          FirebaseStorage.instance.ref().child('invoicePdfs/$fileName');

      // Upload the PDF file to Firebase Storage
      //TaskSnapshot uploadTask = await storageRef.putFile(pdfFile);

      // Get the download URL of the uploaded PDF
      String downloadUrl = await storageRef.getDownloadURL();
      print("PDF uploaded. Download URL: $downloadUrl");

      // Now save the download URL to Firestore
      await savePdfUrlToFirestore(invoiceID, downloadUrl);

      print("PDF URL saved to Firestore");
    } catch (e) {
      print("Error uploading PDF to Firebase Storage: $e");
    }
  }

  Future<void> savePdfUrlToFirestore(String invoiceID, String pdfUrl) async {
    try {
      // Reference to Firestore collection and document
      DocumentReference invoiceRef =
          FirebaseFirestore.instance.collection('pdffiles').doc(invoiceID);

      // Update or set the document with the PDF URL
      await invoiceRef.set({
        'Vendor Name': invoiceData['Vendor Name'],
        'invoiceId': invoiceData['invoiceId'],
        'pdfUrl': pdfUrl, // Save the URL
        'timestamp': FieldValue.serverTimestamp(),

        'isShared': isShared,
      }, SetOptions(merge: true)); // Merge with existing document data

      print("PDF URL saved to Firestore");
    } catch (e) {
      print("Error saving PDF URL to Firestore: $e");
    }
  }

  bool isShared = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before leaving the page
        bool shouldLeave = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmation'),
                content: const Text('Did you share the PDF?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // setState(() {
                      //   isShared = !isShared;
                      // });

                      // FirebaseFirestore.instance
                      //     .collection('pdffiles')
                      //     .doc(widget.invoiceID)
                      //     .update({'isShared': isShared});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('PDF Not Sent'),
                        duration: Duration(seconds: 2),
                      ));
                      Navigator.of(context).pop(true); // User cancels leaving
                    },
                    child: Text(
                      'No',
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.secondary),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        // isShared = !isShared;
                        isShared = true;
                      });

                      FirebaseFirestore.instance
                          .collection('pdffiles')
                          .doc(widget.invoiceID)
                          .update({'isShared': isShared});
                      FirebaseFirestore.instance
                          .collection('invoice_collection')
                          .doc(widget.invoiceID)
                          .update({'isShared': isShared});
                      try {
                        // Query the collection for documents where 'invoiceId' equals the provided invoiceID
                        QuerySnapshot querySnapshot = await FirebaseFirestore
                            .instance
                            .collection('invoice_collection')
                            .where('invoiceId', isEqualTo: widget.invoiceID)
                            .get();
                        print('............$querySnapshot.........');

                        // Iterate through the documents and update the field
                        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
                          // Update the 'isShared' field for each matching document
                          await doc.reference.update({
                            'isShared': isShared,
                          });
                        }

                        print("Invoice field updated successfully.");
                      } catch (e) {
                        print("Error updating invoice field: $e");
                      }

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('PDF Sent'),
                        duration: Duration(seconds: 2),
                      ));
                      Navigator.of(context).pop(true); // User confirms leaving
                    },
                    child: Text(
                      'Yes',
                      style: textTheme.titleMedium
                          ?.copyWith(color: colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ) ??
            false;

        return shouldLeave; // Return true if the user confirms, false otherwise
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
        ),
        body: Center(
          child: _pdfFile == null
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Expanded(
                      child: PdfPreview(
                        canDebug: false,
                        build: (format) => _pdfFile!.readAsBytes(),
                        pdfFileName: 'Invoice ${invoiceData['invoiceId']}.pdf',
                        shareActionExtraSubject:
                            'Invoice ${invoiceData['invoiceId']} from The Sample Institution',
                        shareActionExtraEmails: [vendorData['Email']],
                        shareActionExtraBody:
                            'Dear Customer, \n I hope this email finds you well.\n\n\n Please find the Invoice ${invoiceData['invoiceId']}, dated ${invoiceData['invoiceDate']} for the services provided to ${invoiceData['Vendor Name']}. The total amount due is due by ${invoiceData['invoiceDueDate']}.\n\n If you have any questions regarding this invoice or the services rendered, please dont hesitate to reach out to us. We greatly appreciate your prompt payment. \n\n Payment Instructions \n\n You can make the payment via Online. Please include the invoice number in your payment reference for quicker processing. \n Bank Name: abc \n Account Number: 1234\n IFSC Code: IFSCBA232\n\n Thank you for your business! We look forward to working with you again.\n\n Warm regards,\n Name of Authorized Person\n The Sample Institution,\n Ottiyambakkam,\n Chennai - 600130.',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
