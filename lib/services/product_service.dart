import '../core/supabase_client.dart';

class ProductService {
  Future<List> getAll() async => await supabase
      .from('products')
      .select('id, name, price, categories(name)')
      .order('id');

  Future<void> add(String name, int price, int categoryId) async {
    await supabase.from('products').insert({
      'name': name,
      'price': price,
      'category_id': categoryId,
    });
  }
}
