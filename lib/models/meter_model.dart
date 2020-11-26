class Sayac {
  String sayacNo;
  bool ceza;
  bool uyari;
  String toplamTuketim;
  bool cezaManyetikEtki;
  bool cezaKapak;
  bool uyariDonma;
  bool uyariSizintiveyaPatlak;
  bool hataPilAz;
  bool hataKristal;
  bool hataPals;
  bool rfDinlemeAktif;
  String sayacTipi;
  bool vanaliMi;
  bool krediliMi;
  bool readoutMu;
  int rssi;
  bool lqiCrc;
  String lqi;
  int rxConter;

  String krediMiktari;

  bool cezaOptik;
  bool cezaPilKapak;
  bool cezaRakor;
  bool cezaUstKapak;
  bool uyariSizinti;
  bool uyariPatlak;
  bool uyariTersAkis;
  bool uyariMaxDebi;

  bool bilgiVanaAktif;
  bool bilgiVanaAcik;
  bool uyariVanaAriza;
  bool bilgiVanaIslemiKart;
  bool bilgiVanaIslemiRf;
  bool bilgiVanaIslemiOptik;
  bool bilgiYedekKrediKullanim;
  bool bilgiSayacBorcaGecti;

  Sayac.withoutParameter() {
    this.ceza = false;
    this.uyari = false;
  }
  Sayac.withParameter(String sayacNo, bool ceza) {
    this.sayacNo = sayacNo;
    this.ceza = ceza;
  }
}
