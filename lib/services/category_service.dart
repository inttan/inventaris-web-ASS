import '../core/supabase_client.dart';

class CategoryService {
  Future<List> getAll() async =>
      await supabase.from('categories').select().order('id');

  Future<void> add(String name) async =>
      await supabase.from('categories').insert({'name': name});
}
