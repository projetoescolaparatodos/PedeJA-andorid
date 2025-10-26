import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint;

/// 💳 Serviço de pagamentos com Mercado Pago (Split Payment)
class PaymentService {
  static const String apiUrl = 'https://api-pedeja.vercel.app';

  /// Criar pagamento com split (divide valor entre plataforma e restaurante)
  Future<Map<String, dynamic>> createPaymentWithSplit({
    required String orderId,
    String paymentMethod = 'mercadopago',
    int installments = 1,
  }) async {
    try {
      debugPrint('💳 [PaymentService] Criando pagamento...');
      debugPrint('   Order ID: $orderId');
      debugPrint('   Método: $paymentMethod');
      
      final response = await http.post(
        Uri.parse('$apiUrl/api/payment/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'orderId': orderId,
          'paymentMethod': paymentMethod,
          'installments': installments,
        }),
      );

      debugPrint('📡 [PaymentService] Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          debugPrint('✅ [PaymentService] Pagamento criado com sucesso');
          debugPrint('   Init Point: ${data['payment']?['initPoint']}');
          
          return {
            'success': true,
            'payment': data['payment'],
          };
        } else {
          final error = data['error'] ?? 'Erro desconhecido';
          debugPrint('❌ [PaymentService] Erro na API: $error');
          
          return {
            'success': false,
            'error': error,
          };
        }
      } else {
        debugPrint('❌ [PaymentService] Erro HTTP: ${response.statusCode}');
        debugPrint('   Body: ${response.body}');
        
        return {
          'success': false,
          'error': 'Erro ao criar pagamento (${response.statusCode})',
        };
      }
    } catch (e) {
      debugPrint('❌ [PaymentService] Exceção: $e');
      
      return {
        'success': false,
        'error': 'Erro ao conectar com servidor: $e',
      };
    }
  }

  /// Verificar se restaurante está configurado para receber pagamentos
  Future<bool> isRestaurantConfigured(String restaurantId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/payment/restaurant/$restaurantId/status'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['configured'] == true;
      }
      
      return false;
    } catch (e) {
      debugPrint('❌ [PaymentService] Erro ao verificar configuração: $e');
      return false;
    }
  }

  /// Buscar status do pagamento
  Future<Map<String, dynamic>> getPaymentStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/payment/status/$orderId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      
      return {'status': 'unknown'};
    } catch (e) {
      debugPrint('❌ [PaymentService] Erro ao buscar status: $e');
      return {'status': 'error', 'error': e.toString()};
    }
  }
}
