import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
        useMaterial3: true,
      ),
      home: const TelaLista(),
    );
  }
}

// =======================================================
// TODO 1 - Classe/modelo Item
// =======================================================

class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

// =======================================================
// Tela principal
// =======================================================

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {

  // =====================================================
  // TODO 2 - Lista de itens
  // =====================================================

  List<Item> itens = [];

  // =====================================================
  // TODO 3 - Abrir tela para adicionar
  // =====================================================

  Future<void> abrirTelaAdicionar() async {
    final Item? novoItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAdicionarItem(),
      ),
    );

    if (novoItem != null) {
      setState(() {
        itens.add(novoItem);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${novoItem.nome} adicionado à lista'),
        ),
      );
    }
  }

  // =====================================================
  // TODO 4 - Remover item
  // =====================================================

  void removerItem(int indice) {
    final itemRemovido = itens[indice];

    setState(() {
      itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${itemRemovido.nome} removido da lista'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // Conta quantos itens foram comprados
    final int quantidadeComprados =
        itens.where((item) => item.comprado).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),

        // =================================================
        // TODO 5 - Contador
        // =================================================

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$quantidadeComprados de ${itens.length} comprados',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),

      // ===================================================
      // TODO 6 - ListView.builder
      // ===================================================

      body: itens.isEmpty
          ? const Center(
              child: Text(
                'Nenhum item na lista.\nClique no + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, indice) {

                final item = itens[indice];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.comprado,
                      onChanged: (valor) {
                        setState(() {
                          item.comprado = valor!;
                        });
                      },
                    ),

                    title: Text(
                      item.nome,
                      style: TextStyle(
                        fontSize: 18,
                        decoration: item.comprado
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),

                    subtitle: Text(
                      'Quantidade: ${item.quantidade}',
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        removerItem(indice);
                      },
                    ),
                  ),
                );
              },
            ),

      // ===================================================
      // TODO 7 - Botão adicionar
      // ===================================================

      floatingActionButton: FloatingActionButton(
        onPressed: abrirTelaAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// =======================================================
// Tela de adicionar item
// =======================================================

class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {

  // =====================================================
  // TODO 8 - Controllers
  // =====================================================

  final TextEditingController nomeController =
      TextEditingController();

  final TextEditingController quantidadeController =
      TextEditingController();

  // =====================================================
  // TODO 9 - Função salvar
  // =====================================================

  void salvar() {

    final String nome = nomeController.text.trim();

    final int quantidade =
        int.tryParse(quantidadeController.text) ?? 1;

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome do item'),
        ),
      );

      return;
    }

    final novoItem = Item(
      nome: nome,
      quantidade: quantidade,
    );

    Navigator.pop(context, novoItem);
  }

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Item'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // =============================================
            // TODO 10 - Nome
            // =============================================

            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do item',
                hintText: 'Ex: Arroz',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // =============================================
            // TODO 11 - Quantidade
            // =============================================

            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                hintText: 'Ex: 2',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // =============================================
            // TODO 12 - Salvar
            // =============================================

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}