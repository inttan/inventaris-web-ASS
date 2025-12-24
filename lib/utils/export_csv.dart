import 'dart:html';

void exportCsv(String content) {
  final blob = Blob([content]);
  final url = Url.createObjectUrlFromBlob(blob);
  AnchorElement(href: url)
    ..setAttribute("download", "products.csv")
    ..click();
  Url.revokeObjectUrl(url);
}
