import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first/features/home/domain/news_service.dart';
import 'package:offline_first/features/home/data/news_repository.dart';

// 1. Membuat Stuntman (Pemeran Pengganti) untuk Repository
class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late NewsService newsService;
  late MockNewsRepository mockRepository;

  setUp(() {
    mockRepository = MockNewsRepository();
    // Kita berikan stuntman ke Service
    newsService = NewsService(mockRepository);
  });

  group('Pengujian Logika NewsService -', () {
    
    // Robot Penguji 1
    test('1. syncLatestNews harus menyuruh repository menarik data dari API', () async {
      // ARRANGE: Ajari stuntman untuk pura-pura sukses
      when(() => mockRepository.fetchAndSaveTopHeadlines()).thenAnswer((_) async => {});
      
      // ACT: Eksekusi fungsi utama
      await newsService.syncLatestNews();
      
      // ASSERT: Buktikan bahwa fungsi repository benar-benar dipanggil 1 kali
      verify(() => mockRepository.fetchAndSaveTopHeadlines()).called(1);
    });

    // Robot Penguji 2
    test('2. toggleBookmark harus meneruskan status yang benar ke database', () async {
      // ARRANGE
      when(() => mockRepository.toggleBookmark(1, true)).thenAnswer((_) async => {});
      
      // ACT
      await newsService.toggleBookmark(1, true);
      
      // ASSERT: Buktikan ID 1 dengan status True benar-benar diteruskan
      verify(() => mockRepository.toggleBookmark(1, true)).called(1);
    });

  });
}