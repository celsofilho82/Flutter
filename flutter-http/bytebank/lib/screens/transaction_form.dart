import 'dart:async';

import 'package:bytebank2/components/progress.dart';
import 'package:bytebank2/components/response_dialog.dart';
import 'package:bytebank2/components/transaction_auth_dialog.dart';
import 'package:bytebank2/http/webclients/transaction_webclient.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = Uuid().v4();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(
                    message: 'Sending...',
                  ),
                ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(value, widget.contact, transactionId);
                      showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return TransactionAuthDialog(
                              onConfirm: (String password) {
                                _save(transactionCreated, password, context,
                                    dialogContext);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password,
      BuildContext context, BuildContext dialogContext) async {
    setState(() {
      _sending = true;
    });
    await _webClient.save(transactionCreated, password, context).then((transaction) {
      if (transaction != null) {
        showDialog(
            context: context,
            builder: (dialogContext) {
              return SuccessDialog('successful transacion');
            }).then((value) => Navigator.pop(context));
      }
      setState(() {
        _sending = false;
      });
    }).catchError((e) {
      showDialog(
          context: context,
          builder: (dialogContext) {
            return FailureDialog('timeout submitting the transaction');
          });
    }, test: (e) => e is TimeoutException).catchError((e) {
      showDialog(
          context: context,
          builder: (dialogContext) {
            return FailureDialog(e.message);
          });
    }, test: (e) => e is HttpException).catchError((e) {
      showDialog(
          context: context,
          builder: (dialogContext) {
            return FailureDialog('Unknown error');
          });
    }, test: (e) => e is Exception);
  }
}
