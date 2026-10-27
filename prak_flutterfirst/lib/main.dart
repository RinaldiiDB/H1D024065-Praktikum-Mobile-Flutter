import 'package:flutter/material.dart';

class Queue<T> {
  final List<T> _elements = [];

  void enqueue(T element) {
    _elements.add(element);
  }

  T? pop() {
    if (isEmpty) {
      return null;
    }
    return _elements.removeAt(0);
  }

  T? get peek => isEmpty ? null : _elements.first;

  bool get isEmpty => _elements.isEmpty;

  bool get isNotEmpty => _elements.isNotEmpty;

  int get size => _elements.length;

  List<T> get elements => List.unmodifiable(_elements);

  void clear() {
    _elements.clear();
  }

  @override
  String toString() => _elements.toString();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulasi Antrian (Queue)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QueueHomePage(),
    );
  }
}

class QueueHomePage extends StatefulWidget {
  const QueueHomePage({super.key});

  @override
  State<QueueHomePage> createState() => _QueueHomePageState();
}

class _QueueHomePageState extends State<QueueHomePage> {
  final Queue<String> _antrian = Queue<String>();
  final namaController = TextEditingController();
  String? _lastPopped;

  @override
  void initState() {
    super.initState();
    _resetAntrian();
  }

  @override
  void dispose() {
    namaController.dispose();
    super.dispose();
  }

  void _resetAntrian() {
    setState(() {
      _antrian.clear();
      _antrian.enqueue("joko");
      _antrian.enqueue("prabo");
      _antrian.enqueue("gibro");
      _lastPopped = null;
    });
  }

  void _handleEnqueue(String nama) {
    if (nama.trim().isEmpty) return;
    setState(() {
      _antrian.enqueue(nama.trim());
    });
    namaController.clear();
  }

  void _handlePop() {
    setState(() {
      _lastPopped = _antrian.pop();
    });

    if (_lastPopped != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Memanggil: $_lastPopped dari antrian'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAntrian = _antrian.elements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Antrian (Queue)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Reset Antrian Awal',
            icon: const Icon(Icons.refresh),
            onPressed: _resetAntrian,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Jumlah Antrian', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              '${_antrian.size}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Antrian Terdepan (Peek)', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              _antrian.peek ?? '-',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _antrian.peek != null ? Colors.deepPurple : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_lastPopped != null) ...[
                      const Divider(height: 24),
                      Text(
                        'Terakhir di-pop (keluar): $_lastPopped',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _antrian.isNotEmpty ? _handlePop : null,
              icon: const Icon(Icons.arrow_upward),
              label: const Text('POP (Panggil Antrian Terdepan)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tambah Cepat (Enqueue):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleEnqueue('joko'),
                    child: const Text('+ joko'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleEnqueue('prabo'),
                    child: const Text('+ prabo'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleEnqueue('gibro'),
                    child: const Text('+ gibro'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama baru...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: _handleEnqueue,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _handleEnqueue(namaController.text),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Enqueue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Visualisasi Antrian (FIFO):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Elemen paling kiri = Terdepan (siap di-pop), Paling kanan = Paling baru masuk',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            if (listAntrian.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text(
                  'Antrian sedang kosong',
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listAntrian.length,
                separatorBuilder: (context, index) => const Icon(
                  Icons.arrow_downward,
                  size: 18,
                  color: Colors.deepPurple,
                ),
                itemBuilder: (context, index) {
                  final nama = listAntrian[index];
                  final isFirst = index == 0;
                  final isLast = index == listAntrian.length - 1;

                  return Card(
                    color: isFirst ? Colors.deepPurple.shade50 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isFirst ? Colors.deepPurple : Colors.grey.shade300,
                        width: isFirst ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isFirst ? Colors.deepPurple : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(
                        nama,
                        style: TextStyle(
                          fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Chip(
                        label: Text(
                          isFirst
                              ? 'Depan (Front)'
                              : isLast
                                  ? 'Belakang (Rear)'
                                  : 'Urutan ${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isFirst ? Colors.deepPurple : Colors.black87,
                          ),
                        ),
                        backgroundColor: isFirst ? Colors.deepPurple.shade100 : Colors.grey.shade200,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
