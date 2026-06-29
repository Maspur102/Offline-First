import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first/features/home/presentation/cubit/news_cubit.dart';
import 'package:offline_first/features/home/presentation/cubit/news_state.dart';
import 'package:offline_first/features/home/domain/news_service.dart';
import 'dart:async';

// 1. Membuat Stuntman (Mock) untuk NewsService
class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;
  
  setUp(() {
    mockNewsService = MockNewsService();
  });

  group('Pengujian Logika NewsCubit (BLOC) -', () {
    
    // Robot Penguji 3 (Melengkapi syarat minimal 3 Unit Test)
    test('3. Cubit harus memiliki inisial state NewsLoading saat pertama kali dipanggil', () {
      // ARRANGE: Siapkan aliran data (Stream) kosong agar Cubit tidak error saat dijalankan
      when(() => mockNewsService.getArticlesStream()).thenAnswer((_) => const Stream.empty());
      when(() => mockNewsService.syncLatestNews()).thenAnswer((_) async {});
      
      // ACT: Inisialisasi Cubit
      final cubit = NewsCubit(mockNewsService);
      
      // ASSERT: Pastikan state pertama yang muncul adalah status Loading
      expect(cubit.state, isA<NewsLoading>());
      
      // Bersihkan memori setelah pengujian selesai
      cubit.close();
    });

  });
}