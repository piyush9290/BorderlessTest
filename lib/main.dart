import 'package:borderless_test/Services/invoices_service.dart';
import 'package:borderless_test/Services/users_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Invoices', invoicesService: InvoicesServiceImp(), usersService: UsersServiceImp(), formatter: Formatter(),),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final InvoicesService invoicesService;
  final UsersService usersService;
  final Formatter formatter;

  const MyHomePage({
    super.key, 
    required this.title, 
    required this.invoicesService, 
    required this.usersService,
    required this.formatter
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<InvoiceModel>> invoiceList;
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();

    invoiceList = widget.invoicesService.getInvoices();
    users = widget.usersService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title, textAlign: TextAlign.left,),
        centerTitle: false,
      ),
      body: FutureBuilder<List<InvoiceModel>>(
        future: invoiceList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list =  snapshot.data!.map(widget.formatter.getUIModelFrom).map((uiModel) => ListTile(uiModel: uiModel)).toList();
            return ListView(children: list);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ListTileUIModel {
  final DetailColumnUIModel leftColumnModel;
  final DetailColumnUIModel rightColumnModel;

  const ListTileUIModel({
    required this.leftColumnModel,
    required this.rightColumnModel
  });

  factory ListTileUIModel.mockModel() {
    return ListTileUIModel(
      leftColumnModel: DetailColumnUIModel.mockModel(CrossAxisAlignment.start), 
      rightColumnModel: DetailColumnUIModel.mockModel(CrossAxisAlignment.end)
    );
  }
}

class ListTile extends StatelessWidget {
  final ListTileUIModel uiModel;
  const ListTile({required this.uiModel, super.key});

  @override
  Widget build(BuildContext context) {
    final tile = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DetailColumn(uiModel: uiModel.leftColumnModel),
        DetailColumn(uiModel: uiModel.rightColumnModel)
      ],
    );
    final paddedRow = Padding(padding: const EdgeInsets.all(20), child: tile);
    return paddedRow;
  }
}

class DetailColumnUIModel {
  final String title;
  final String description;
  final CrossAxisAlignment alignment;

  const DetailColumnUIModel({
    required this.title,
    required this.description,
    required this.alignment
  });

  factory DetailColumnUIModel.mockModel(CrossAxisAlignment alignment) {
    return DetailColumnUIModel(title: '30-March 2023', description: 'Darlene', alignment: alignment);
  }
}

class DetailColumn extends StatelessWidget {
  final DetailColumnUIModel uiModel;
  const DetailColumn({required this.uiModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: uiModel.alignment,
      children: [
        Text(uiModel.title),
        const SizedBox(height: 2),
        Text(uiModel.description),
      ],
    );
  }
}
