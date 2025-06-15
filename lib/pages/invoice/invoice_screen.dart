import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/custom_container.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/no_data_found.dart';
import 'package:toptalents/pages/invoice/invoice_detail_screen.dart';
import 'package:toptalents/pages/side_menu/side_menu_drawer.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  bool showNotSent = true;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const SideMenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: getPadding(all: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText('Invoices'),
                IconButton(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.addInvoiceScreen, arguments: {
                          'argument1': false,
                          'argument2': null,
                        }),
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Search by Invoice ID or Vendor Name',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                            searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showNotSent = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 4,
                        horizontal: defaultPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultPadding),
                      color: showNotSent ? colorScheme.secondary : Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        'Not Sent',
                        style: textTheme.titleMedium!
                            .copyWith(color: colorScheme.surface),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showNotSent = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 4,
                        horizontal: defaultPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultPadding),
                      color: !showNotSent ? colorScheme.primary : Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        'Sent',
                        style: textTheme.titleMedium!
                            .copyWith(color: colorScheme.surface),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: showNotSent
                ? _buildInvoiceList(false)
                : _buildInvoiceList(true),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(bool isShared) {
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('invoice_collection')
          .where('isShared', isEqualTo: isShared)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: const NoDataFound()
              // Text(isShared ? 'No Sent Invoices' : 'No Not Sent Invoices')
              );
        }

        var documents = snapshot.data!.docs.where((doc) {
          String invoiceId = doc['invoiceId'].toString().toLowerCase();
          String vendorName = doc['Vendor Name'].toString().toLowerCase();

          return invoiceId.contains(searchQuery) ||
              vendorName.contains(searchQuery);
        }).toList();

        if (documents.isEmpty) {
          return const Center(child: Text('No matching invoices found.'));
        }

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var document = documents[index];
            var isSent = document['isShared'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvoiceDetailScreen(
                      docId: document.id,
                      isSent: isSent,
                    ),
                  ),
                );
              },
              child: Padding(
                padding:
                    getPadding(left: defaultPadding, right: defaultPadding),
                child: CustomContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              document['Vendor Name'],
                                              style: textTheme.titleLarge,
                                            ),
                                            const SizedBox(
                                              height: defaultPadding / 8,
                                            ),
                                            Text(
                                              document['invoiceId'],
                                              style: textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InvoiceDetailScreen(
                                    docId: document.id, isSent: isSent),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
