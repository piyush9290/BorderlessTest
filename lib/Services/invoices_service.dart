import 'dart:convert';
import 'package:borderless_test/Extensions/datetime_extension.dart';
import 'package:borderless_test/Services/services_helper.dart';
import 'package:borderless_test/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InvoiceModel {
  final num amount;
  final String currency;
  final String id;
  final String invoiceNumber;
  final String status;
  final String submittedByUserId;
  final DateTime submittedDate;
  final String type;

  const InvoiceModel({
    required this.amount,
    required this.currency,
    required this.id,
    required this.invoiceNumber,
    required this.status,
    required this.submittedByUserId,
    required this.submittedDate,
    required this.type
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      amount: json['amount'] as num, 
      currency: json['currency'] as String, 
      id: json['id'] as String, 
      invoiceNumber: json['invoiceNumber'] as String, 
      status: json['status'] as String, 
      submittedByUserId: json['submittedByUserId'] as String, 
      submittedDate: (json['submittedDate'] as String).toDateTime(), 
      type: json['type'] as String
    );
  }
}

abstract class InvoicesService {
  Future<List<InvoiceModel>> getInvoices() async {
    throw ImplementationException();
  }
} 

class InvoicesServiceImp implements InvoicesService {
  @override
  Future<List<InvoiceModel>> getInvoices() async {
    final url = Uri.parse(ServicePath.invoices.urlString());
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dataBody = response.body;
      final json = jsonDecode(dataBody).cast<Map<String, dynamic>>();
      final list = json.map<InvoiceModel>((json) => InvoiceModel.fromJson(json)).toList();
      return list;
    } else {
      throw ServiceException();
    }
  }
}

class Formatter {
  ListTileUIModel getUIModelFrom(InvoiceModel invoiceModel) {
    final leftModel = DetailColumnUIModel(
      title: invoiceModel.submittedDate.toString(), 
      description: invoiceModel.invoiceNumber,
      alignment: CrossAxisAlignment.start
    );

    final rightModel = DetailColumnUIModel(
      title: '${invoiceModel.currency} ${invoiceModel.amount}', 
      description: invoiceModel.status,
      alignment: CrossAxisAlignment.start
    );
    return ListTileUIModel(
      leftColumnModel: leftModel, 
      rightColumnModel: rightModel);
  }
}



