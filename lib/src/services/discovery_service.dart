import '../models/discovery_item.dart';
import '../models/page.dart';
import '../transport.dart';

final class DiscoveryService {
  const DiscoveryService(this._transport);
  final AldiwanTransport _transport;
  Future<List<DiscoveryItem>> categories() => _list('categories');
  Future<List<DiscoveryItem>> themes() => _list('themes');
  Future<List<DiscoveryItem>> eras() => _list('eras');
  Future<List<DiscoveryItem>> meters() => _list('meters');
  Future<List<DiscoveryItem>> rhymes() => _list('rhymes');
  Future<List<DiscoveryItem>> _list(String path) async =>
      AldiwanPage<DiscoveryItem>.fromJson(
        await _transport.get(path),
        DiscoveryItem.fromJson,
      ).items;
}
