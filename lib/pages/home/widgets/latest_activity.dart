import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:toptalents/pages/invoice/invoice_screen.dart';
import 'package:toptalents/pages/invoice/pdf_page.dart';

class LatestActivity extends StatelessWidget {
  const LatestActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(
          height: defaultPadding * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Invoices',
              style: textTheme.titleLarge!.copyWith(color: Colors.black54),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceScreen(),
                ),
              ),
              // child: Container(
              //   padding: EdgeInsets.symmetric(
              //     vertical: defaultPadding / 4,
              //   ),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(defaultPadding),
              //       color: colorScheme.tertiary),
              //   child: Center(
              child: Text(
                'View More',
                style: textTheme.titleMedium!
                    .copyWith(color: colorScheme.secondary),
              ),
              //   ),
              // ),
            )
          ],
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('pdffiles')
              .orderBy('timestamp', descending: true)
              .limit(5)
              //.where('isShared', isEqualTo: true) // Filter for shared PDFs
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No shared PDFs found.'));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var pdfData = snapshot.data!.docs[index];

                return ListTile(
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: pdfData['isShared']
                        ? colorScheme.primary
                        : colorScheme.secondary,
                    child: Text(pdfData['isShared'] ? 'Sent' : ' Not\nSent',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.surface)),
                  ),

                  title:
                      Text(pdfData['Vendor Name'], style: textTheme.titleLarge),
                  subtitle: Text(
                    pdfData['invoiceId'].toString(),
                    style: textTheme.bodyMedium,
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(left: defaultPadding / 2),
                    child: IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultPadding / 3),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.tertiary, // Shadow color
                              spreadRadius: 3, // How much the shadow spreads
                              blurRadius: 5, // How blurry the shadow is
                              offset:
                                  const Offset(2, 3), // Shadow offset (x, y)
                            ),
                          ],
                        ),
                        child: const Icon(
                          //shadows: [colorScheme.tertiary],
                          Icons.picture_as_pdf,
                          size: 30,
                          //color: Colors.grey,
                        ),
                      ),
                      onPressed: () async {
                        var pdfUrl =
                            pdfData['pdfUrl']; // The URL to the PDF file
                        print(
                            '.........................${pdfData['isShared']}................');
                        if (pdfData['isShared']) {
                          print(
                              '.........................goint to PDFViewerScreen................');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PDFViewerScreen(pdfUrl: pdfUrl),
                            ),
                          );
                          print(
                              '.........................reached PDFViewerScreen................');
                        } else {
                          print(
                              '.........................goint to PDFPage................');
                          print(
                              '.........................${pdfData['invoiceId']}................');
                          print('.........................................');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PDFPage(
                                      invoiceID: pdfData.id,
                                      fromRecent: true,
                                    )
                                //PDFViewerScreen(pdfUrl: pdfUrl),
                                ),
                          );
                        }
                      },
                    ),
                  ), // Displaying PDF file info
                );
              },
            );
          },
        )
      ],
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfUrl;

  PDFViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(),
      body: SfPdfViewer.network(
          pdfUrl), // Load and display the PDF from a network URL
    );
  }
}
