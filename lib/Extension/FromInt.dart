extension FromInt on int{
  /// Ubah int jadi string dengan x digit sesuai parameternya.
  ///
  /// **Parameter**
  /// * [digit]: Jumlah digit yang mau ditambahkan. Defaultnya adalah 2. Penjelasan lihat [Contoh] dibawah
  ///
  /// **Ketentuan**
  ///  * Kalau jumlah digit [nilai asli] lebih besar dari parameter [digit], misalnya angka "100" dan parameter digit "2", Fungsi ini akan mereturn angka asli "100" tidak menambah nol lagi di belakang
  ///
  /// **Contoh**
  /// * 7 dengan digit = 2, akan diconvert jadi "07"
  /// * 12 dengan digit = 2, akan diconvert jadi "12"
  ///
  /// **WARNING**
  /// * kalau [nilai asli]nya minus, fungsi ini akan mengembalikan error
  /// * kalau parameter [digit] nilainya kurang dari 1, fungsi ini akan error
  String koiDisplayXDigit({int digit = 2}){
    if(this < 0){
      throw AssertionError("Nilai int tidak boleh minus");
    }
    if(digit < 1){
      throw AssertionError("Nilai parameter [digit] tidak boleh kurang dari 1");
    }

    String thisInt = this.toString();

    if(thisInt.length < digit){
      var ret = "";
      for(int x=0; x< digit - thisInt.length; x++){
        ret +="0";
      }
      return ret+thisInt;
    }
    else{
      return thisInt;
    }
  }
}