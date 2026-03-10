import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/order_recieved_entity.dart';

Future<void> saveOrderPdf(BuildContext context, OrderReceivedEntity order) async {
  try {
    final doc = await _generatePdfDocument(order);
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'Invoice_${order.orderNumber}.pdf',
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF saved successfully'), backgroundColor: AppColors.matGreen),
      );
    }
  } catch (e) {

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving PDF: $e'), backgroundColor: AppColors.matRed),
      );
    }
  }
}

Future<void> printOrderDetail(BuildContext context, OrderReceivedEntity order) async {
  try {
    final doc = await _generatePdfDocument(order);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Invoice_${order.orderNumber}',
    );
     // Note: Printing.layoutPdf doesn't return a "success" status easily, but if we get here, it launched.
  } catch (e) {

     if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error printing PDF: $e'), backgroundColor: AppColors.matRed),
      );
    }
  }
}

Future<pw.Document> _generatePdfDocument(OrderReceivedEntity order) async {
  final doc = pw.Document();
  
  // Load Noto Sans which has full Unicode support (including ₹ Rupee symbol)
  final font = await PdfGoogleFonts.notoSansRegular();
  final fontBold = await PdfGoogleFonts.notoSansBold();

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(
        base: font,
        bold: fontBold,
      ),
      build: (pw.Context context) {
        return [
          _buildModernHeader(order),
          pw.SizedBox(height: 30),
          _buildModernAddressSection(order),
          pw.SizedBox(height: 30),
          _buildModernItemsTable(order),
          pw.SizedBox(height: 20),
          _buildModernTotalSection(order),
          pw.SizedBox(height: 50),
          _buildModernFooter(),
        ];
      },
    ),
  );
  return doc;
}

pw.Widget _buildModernHeader(OrderReceivedEntity order) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'RIZQMART',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text('Your Trusted Shopping Partner', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        ],
      ),
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            'INVOICE',
            style: pw.TextStyle(
              fontSize: 32,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey200,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildHeaderItem('Invoice #', order.orderNumber),
          _buildHeaderItem('Date', DateFormat('dd MMM yyyy').format(order.createdAt)),
          _buildHeaderItem('Status', order.orderStatus.toUpperCase()),
          _buildHeaderItem('Payment', '${order.paymentStatus} (${order.paymentMethod})'),
        ],
      ),
    ],
  );
}

pw.Widget _buildHeaderItem(String label, String value) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 2),
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          '$label: ',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    ),
  );
}

pw.Widget _buildModernAddressSection(OrderReceivedEntity order) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'BILL TO',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey600,
                letterSpacing: 1,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              order.userName,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
            pw.Text(order.userEmail, style: const pw.TextStyle(fontSize: 10)),
            pw.Text(order.userPhone, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ),
      pw.SizedBox(width: 40),
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'SHIP TO',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey600,
                letterSpacing: 1,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              order.deliveryAddress,
              style: const pw.TextStyle(fontSize: 11),
            ),
             if (order.deliveryNotes != null && order.deliveryNotes!.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.Text(
                'Note: ${order.deliveryNotes}',
                style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildModernItemsTable(OrderReceivedEntity order) {
  return pw.TableHelper.fromTextArray(
    border: null,
    headerDecoration: const pw.BoxDecoration(
      color: PdfColors.grey100,
      border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
      )
    ),
    headerHeight: 25,
    cellHeight: 30,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.center,
      2: pw.Alignment.centerRight,
      3: pw.Alignment.centerRight,
    },
    headerStyle: pw.TextStyle(
      color: PdfColors.grey800,
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      color: PdfColors.grey800,
      fontSize: 11,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey100, width: 0.5),
      ),
    ),
    headers: ['ITEM DESCRIPTION', 'QTY', 'MRP', 'AMOUNT'],
    data: order.items.map((item) {
      return [
        '${item.productName}${item.unit != null ? ' (${item.unit})' : ''}',
        item.quantity.toInt().toString(),
        '₹${item.mrp.toStringAsFixed(2)}',
        '₹${(item.mrp * item.quantity).toStringAsFixed(2)}',
      ];
    }).toList(),
  );
}

pw.Widget _buildModernTotalSection(OrderReceivedEntity order) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.end,
    children: [
      pw.Container(
        width: 250,
        child: pw.Column(
          children: [
            _buildTotalRow('Subtotal', '₹${order.subtotal.toStringAsFixed(2)}'),
            pw.SizedBox(height: 4),
            _buildTotalRow('Delivery Fee', '₹${order.deliveryFee.toStringAsFixed(2)}'),
            if (order.discount > 0) ...[
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Discount', style: const pw.TextStyle(fontSize: 11, color: PdfColors.green700)),
                  pw.Text('-₹${order.discount.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 11, color: PdfColors.green700)),
                ],
              ),
            ],
            pw.SizedBox(height: 4),
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'TOTAL',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.Text(
                  '₹${order.totalAmount.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 18,
                    color: PdfColors.green700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildTotalRow(String label, String value) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(label, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
      pw.Text(value, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey900)),
    ],
  );
}

pw.Widget _buildModernFooter() {
  return pw.Column(
    children: [
      pw.Divider(color: PdfColors.grey200),
      pw.SizedBox(height: 20),
      pw.Text(
        'Thank you for your business',
        style: pw.TextStyle(
          color: PdfColors.blue800,
          fontWeight: pw.FontWeight.bold,
          fontSize: 12,
        ),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        'For questions concerning this invoice, please contact support@rizqmart.com',
        style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 9),
      ),
    ],
  );
}
