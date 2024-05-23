-- Menghitung selisih hari antara tanggal transaksi terakhir dan tanggal sekarang --
DELIMITER //
CREATE PROCEDURE Transaksi (
    IN idanggota INT, 
    OUT TransaksiTerakhir INT
)
BEGIN
    DECLARE tglTransaksiTerakhir DATE;

    SELECT MAX(tanggal_kembali) INTO tglTransaksiTerakhir
    FROM peminjaman
    WHERE id_anggota = idanggota;

    SET TransaksiTerakhir = DATEDIFF(CURDATE(), tglTransaksiTerakhir);
END //
DELIMITER ;

SET @idanggota = 5;
CALL Transaksi(@idanggota, @TransaksiTerakhir);
SELECT @TransaksiTerakhir AS HariSejakTransaksiTerakhir;


-- Menghitung jumlah transaksi pada bulan tertentu --
DELIMITER //
CREATE PROCEDURE HitungTransaksiBulanan (
    IN IdB INT,  
    IN bulan INT, 
    OUT jumlahTransaksi INT
)
BEGIN
    SELECT COUNT(*) INTO jumlahTransaksi
    FROM peminjaman
    WHERE id_buku = IdB
      AND MONTH(tanggal_pinjam) = bulan;
END //
DELIMITER ;
 
SET @IdB = 4;
SET @bulan = 4;
CALL HitungTransaksiBulanan(@IdB, @bulan, @jumlahTransaksi);
SELECT @jumlahTransaksi;



-- Menambahkan data baru ke tabel peminjaman dengan Tanggal_Masuk diisi otomatis
DELIMITER //
CREATE PROCEDURE TambahPeminjaman (
    IN IdPeminjaman INT,
    IN IdAnggota INT, 
    IN IdBuku INT, 
    IN IdPenulis INT,
    IN tanggalKembali DATE,
    IN StatusP VARCHAR(20)
)
BEGIN
    INSERT INTO peminjaman (id_peminjaman, id_anggota, id_buku, id_penulis, tanggal_pinjam, tanggal_kembali, status_pengembalian)
    VALUES (IdPeminjaman, IdAnggota, IdBuku, IdPenulis, CURDATE(), tanggalKembali, StatusP);
END //
DELIMITER ;


SET @IdPeminjaman = 28;
SET @IdAnggota = 8;
SET @IdBuku = 3;
SET @IdPenulis = 5;
SET @tanggalKembali = '2024-06-03';
SET @StatusP = "belum kembali";
CALL TambahPeminjaman(@IdPeminjaman, @IdAnggota, @IdBuku, @IdPenulis, @tanggalKembali, @StatusP);

SELECT * FROM peminjaman WHERE id_peminjaman = @IdPeminjaman AND id_anggota = @IdAnggota
AND id_buku = @IdBuku AND id_penulis = @IdPenulis AND tanggal_kembali = @tanggalKembali
AND status_pengembalian = @StatusP;