import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class NotesViewer extends StatefulWidget {
  File pdf;
  NotesViewer(this.pdf);
  @override
  State<StatefulWidget> createState() {
    return _NotesViewer(pdf);
  }
}

class _NotesViewer extends State<NotesViewer> {
  File pdf;
  _NotesViewer(this.pdf);
  @override
  Widget build(BuildContext context) {
    print('pdf path ${pdf.path.toString()}');
    return PDFViewerScaffold(
      path: pdf.path,
    );
  }
}
