import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:sistem_informasi_penjualan/models/models.dart';
import 'package:sistem_informasi_penjualan/providers/cart_provider.dart';

// PDF RECEIPT
class PdfServices {
  static Future<Uint8List> gennerateReceipt({
    required String invoiceNumber,
    required String date,
    required List<Map<String, dynamic>> items,
    required int totalPrice,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Column(
            children: [
              pw.Text('WARUNG KITA'),
              pw.Text('Jl. Merdeka No. 123'),
              pw.Divider(),
              pw.Text('No: $invoiceNumber'),
              pw.Text('Tanggal: $date'),
              pw.Divider(),
              // ... items
              pw.Divider(),
              pw.Text('Total: Rp $totalPrice'),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  // PRINT PDF
  static Future<void> printPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }

  // SHARE PDF
  static Future<void> sharePdf(Uint8List pdfBytes, String filename) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: filename);
  }
}

// PDF STOCK ITEMS
class PdfStockService {
  // 1. Parameter dikunci langsung pakai List<ProductModel>
  static Future<void> generateAndPrintPdf(List<ProductModel> items) async {
    final fontData = await rootBundle.load(
      "assets/fonts/Roboto-Italic-VariableFont_wdth,wght.ttf",
    );
    final fontBoldData = await rootBundle.load(
      "assets/fonts/Roboto-VariableFont_wdth,wght.ttf",
    );
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    // SET THEME DENGAN FONT BARU
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
    );

    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(8),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // HEADER
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'LAPORAN STOK BARANG',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Dicetak pada: ${dateFormat.format(DateTime.now())}',
                      ),
                    ],
                  ),
                  pw.Text(
                    'STORE APPS',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // TABEL STOK
              pw.TableHelper.fromTextArray(
                headers: ['No', 'Nama Barang', 'Stok'],
                data: List.generate(items.length, (index) {
                  final item = items[index];

                  // 2. Akses data langsung pakai titik (.), BUKAN kurung siku []
                  return [
                    (index + 1).toString(),
                    item.nameProduct,
                    '${item.stock} pcs',
                  ];
                }),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue700,
                ),
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellAlignments: {
                  0: pw.Alignment.center,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.center,
                },
              ),

              pw.SizedBox(height: 20),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total Jenis Barang: ${items.length} Item',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_Stok_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }
}
