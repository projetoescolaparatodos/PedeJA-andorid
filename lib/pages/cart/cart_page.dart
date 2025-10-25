import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/cart_state.dart';
import '../../models/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D3B3B), // Verde musgo escuro
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 📌 HEADER
          _buildHeader(context),

          // 📦 CONTEÚDO
          Expanded(
            child: Consumer<CartState>(
              builder: (context, cart, _) {
                // ⏳ LOADING
                if (cart.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFE39110),
                      ),
                    ),
                  );
                }

                // 🛒 CARRINHO VAZIO
                if (cart.items.isEmpty) {
                  return _buildEmptyCart();
                }

                // ✅ LISTA DE ITENS + RESUMO
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length + 1, // +1 para resumo
                  itemBuilder: (context, index) {
                    // 💰 RESUMO (última posição)
                    if (index == cart.items.length) {
                      return _buildCartSummary(context, cart);
                    }

                    // 📦 ITEM DO CARRINHO
                    final item = cart.items[index];
                    return _buildCartItem(context, cart, item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A4747),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFFE39110)),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Meu Carrinho',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE39110),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: const Color(0xFFE39110).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Seu carrinho está vazio',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE39110),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione itens para começar seu pedido',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartState cart, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2F2F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1A4747),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ IMAGEM
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: const Color(0xFF1A4747),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.fastfood,
                          color: Color(0xFFE39110),
                          size: 40,
                        ),
                      )
                    : const Icon(
                        Icons.fastfood,
                        color: Color(0xFFE39110),
                        size: 40,
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // 📝 INFORMAÇÕES
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Adicionais
                  if (item.addonsDescription.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          size: 14,
                          color: Color(0xFFE39110),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.addonsDescription,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE39110),
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 4),

                  // Preço
                  Text(
                    'R\$ ${item.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE39110),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ➕➖ CONTROLES DE QUANTIDADE
                  Row(
                    children: [
                      // Botão -
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFFE39110),
                        iconSize: 28,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          if (item.quantity > 1) {
                            cart.updateItemQuantity(
                              item.id,
                              item.quantity - 1,
                            );
                          } else {
                            cart.removeItem(item.id);
                          }
                        },
                      ),

                      // Quantidade
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A4747),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE39110),
                          ),
                        ),
                      ),

                      // Botão +
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFFE39110),
                        iconSize: 28,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          cart.updateItemQuantity(
                            item.id,
                            item.quantity + 1,
                          );
                        },
                      ),

                      const Spacer(),

                      // Botão excluir
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: const Color(0xFFFF5722),
                        iconSize: 24,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          cart.removeItem(item.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartState cart) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A4747),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE39110),
                    ),
                  ),
                  Text(
                    'R\$ ${cart.total.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE39110),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🚀 BOTÃO FINALIZAR PEDIDO
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implementar checkout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🚀 Checkout em desenvolvimento...'),
                        backgroundColor: Color(0xFF74241F),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF74241F), // Vinho
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Finalizar Pedido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => const CartPage(),
      ),
    );
  }
}
