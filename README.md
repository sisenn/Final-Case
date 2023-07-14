# Final-Case

Bu kod parçacığı, INP-FILE'dan okunan kayıtları işleyerek OUT-FILE'a yazan bir ana program ile indeks dosyasında veri okuma, yazma, güncelleme ve silme işlemlerini gerçekleştiren bir alt programı içerir.

**PBMAINCB Programı:**

İki dosya tanımlanmıştır: INP-FILE (input dosyası) ve OUT-FILE (output dosyası).

- H100-OPEN-FILES bölümünde INP-FILE ve OUT-FILE dosyaları açılır.
- H110-OPEN-CHECK bölümünde dosyaların başarılı bir şekilde açılıp açılmadığı kontrol edilir. Eğer bir hata oluşursa program sonlandırılır.
- H200-MOVE-PROGRAM bölümünde INP-FILE'dan kayıtlar okunur ve WS-SUB-AREA'ya taşınır.
- Okunan kayıtlar, WS-SUB-AREA üzerinden WS-PBSUBPG0 alt programına gönderilir.
- Alt programın tamamlanmasının ardından OUT-FILE'ya yazma işlemi gerçekleştirilir.
- Son olarak, bir sonraki kaydı okumak için INP-FILE tekrar okunur ve döngü devam eder.
- H999-PROGRAM-EXIT bölümünde INP-FILE ve OUT-FILE dosyaları kapatılır ve program sonlandırılır.
  
**PBSUBPG0 Programı:**

- IDX-FILE adlı indeks dosyası tanımlanır. Bu dosya INDEXED organizasyonunda ve random erişim modunda açılır.
- LS-SUB-AREA üzerinden geçiş parametreleri alır.
- H100-OPEN-FILES bölümünde IDX-FILE açılır ve başarılı bir şekilde açılıp açılmadığı kontrol edilir.
- H150-KEY-CONTROL bölümünde LS-SUB-ID ve LS-SUB-DVZ değerleriyle indeks dosyasında kayıt aranır.
- H200-READ-FUNC bölümünde indeks dosyasından kayıt okunur ve LS-SUB-AREA'ya taşınır.
- H300-WRITE-FUNC bölümünde indeks dosyasına yeni bir kayıt eklenir veya mevcut bir kayıt güncellenir. İşlem sonucu LS-EXP değişkenine yazılır.
- H400-UPDATE-FUNC bölümünde indeks dosyasındaki veriler üzerinde değişiklik yapılır. Örneğin, karakter değişiklikleri yapılır veya veriler taşınır. Sonrasında güncellenen veriler indeks dosyasına geri yazılır.
- H500-DELETE-FUNC bölümünde indeks dosyasından kayıt silinir.
- H900-CLOSE-FUNC bölümünde indeks dosyası kapatılır.
- PBSUBPG0 programı tamamlandığında kontrol PBMAINCB programına geri döner.
  
**Programı Çalıştırma İşlemleri:**

- İlk olarak "MAININPJ" JCL dosyası çalıştırılarak QSAM.CHK, QSAM.INP, QSAM.COMP ve VSAM.SUB dosyaları oluşturulur.
- İkinci olarak cobol programlarını derleyip çalıştırması için "MAINSUB" JCL dosyası çalıştırılarak programın işleyişi ve çıktısı görüntülenebilir.
