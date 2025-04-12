-- 2. Membuat Database dan Tabel e-commerce

-- CREATE DATABASE IF NOT EXISTS `e-commerce`;
USE `e-commerce`;

CREATE TABLE IF NOT EXISTS `pengguna`(
    id_pengguna INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    nomor_telepon VARCHAR(20) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS `admin`(
id_admin INT PRIMARY KEY AUTO_INCREMENT,
nama VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS `pesanan`(
    id_pesanan INT PRIMARY KEY AUTO_INCREMENT,
    id_pengguna INT NOT NULL,
    total_harga DECIMAL(10, 2) NOT NULL,
    tanggal_transaksi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pembayaran ENUM('Belum Dibayar', 'Sudah Dibayar', 'Dibatalkan') NOT NULL DEFAULT 'Belum Dibayar',
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `detail_transaksi`(
    id_transaksi INT PRIMARY KEY AUTO_INCREMENT,
    id_pesanan INT NOT NULL,
    id_produk INT NOT NULL,
    jumlah INT NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS `produk`(
    id_produk INT PRIMARY KEY AUTO_INCREMENT,
    id_admin INT NOT NULL,
    nama VARCHAR(50) NOT NULL,
    harga DECIMAL NOT NULL,
    stok INT NOT NULL,
    kategori VARCHAR(50) NOT NULL
);

ALTER TABLE `detail_transaksi`
ADD CONSTRAINT fk_detail_transaksi_pesanan
FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `detail_transaksi`
ADD CONSTRAINT fk_detail_transaksi_produk
FOREIGN KEY (id_produk) REFERENCES produk(id_produk) ON DELETE CASCADE ON UPDATE CASCADE;    

ALTER TABLE `produk`
ADD CONSTRAINT fk_produk_admin
FOREIGN KEY (id_admin) REFERENCES admin(id_admin) ON DELETE CASCADE ON UPDATE CASCADE;

-- 3. Mengisi Tabel Dengan Data Sebanyak 5 Baris (Record) 

INSERT INTO admin (nama, email, password) VALUES
('Admin #1', 'admin1@example.com', 'password1'),
('Admin #2', 'admin2@example.com', 'password2'),
('Admin #3', 'admin3@example.com', 'password3'),
('Admin #4', 'admin4@example.com', 'password4'),
('Admin #5', 'admin5@example.com', 'password5');

INSERT INTO pengguna (nama, email, password, alamat, nomor_telepon) VALUES
('User A', 'usera@mail.com', 'password1', 'Alamat A', '0811111111'),
('User B', 'userb@mail.com', 'password2', 'Alamat B', '0812222222'),
('User C', 'userc@mail.com', 'password3', 'Alamat C', '0813333333'),
('User D', 'userd@mail.com', 'password4', 'Alamat D', '0814444444'),
('User E', 'usere@mail.com', 'password5', 'Alamat E', '0815555555');

INSERT INTO produk (id_admin, nama, harga, stok, kategori) VALUES
(1, 'Nasi Goreng', 10000, 50, 'Makanan'),
(2, 'Es Teh', 2000, 40, 'Minuman'),
(3, 'Burger', 15000, 30, 'Makanan'),
(4, 'Kabel USB Type-C', 25000, 20, 'Elektronik'),
(5, 'Baju Pantai', 30000, 10, 'Pakaian');

INSERT INTO pesanan (id_pengguna, total_harga, status_pembayaran) VALUES
(1, 50000, 'Sudah Dibayar'),
(2, 30000, 'Belum Dibayar'),
(3, 25000, 'Sudah Dibayar'),
(4, 40000, 'Dibatalkan'),
(5, 60000, 'Belum Dibayar');

INSERT INTO detail_transaksi (id_pesanan, id_produk, jumlah, subtotal) VALUES
(1, 1, 2, 20000),
(2, 2, 1, 20000),
(3, 3, 1, 15000),
(4, 4, 1, 25000),
(5, 5, 2, 60000);

-- 4. Mengubah 1 Data Pada Setiap Tabel 
UPDATE admin SET nama = 'Admin Satu' WHERE id_admin = 1;
UPDATE pengguna SET alamat = 'Alamat Baru A' WHERE id_pengguna = 1;
UPDATE produk SET harga = 11000 WHERE id_produk = 1;
UPDATE pesanan SET status_pembayaran = 'Sudah Dibayar' WHERE id_pesanan = 2;
UPDATE detail_transaksi SET jumlah = 3, subtotal = 30000 WHERE id_transaksi = 1;

-- 5. Menghapus 1 Data Pada Setiap Tabel
DELETE FROM detail_transaksi WHERE id_transaksi = 5;
DELETE FROM pesanan WHERE id_pesanan = 5;
DELETE FROM produk WHERE id_produk = 5;
DELETE FROM pengguna WHERE id_pengguna = 5;
DELETE FROM admin WHERE id_admin = 5;

-- 6. Melakukan 3 Operasi Query Pada Setiap Tabel Dengan Perintah SELECT Tertentu
Table Pengguna
SELECT alamat, COUNT(*) FROM pengguna GROUP BY alamat;
SELECT alamat, COUNT(*) FROM pengguna GROUP BY alamat HAVING COUNT(*) > 0;
SELECT * FROM pengguna ORDER BY nama ASC;

Table Admin
SELECT COUNT(*) AS total_admin FROM `admin`;
SELECT * FROM `admin` WHERE email LIKE '%admin%';
SELECT nama FROM `admin` UNION SELECT nama FROM pengguna;

-- Table Produk
SELECT kategori, AVG(harga) FROM produk GROUP BY kategori;
SELECT kategori, AVG(harga) FROM produk GROUP BY kategori HAVING AVG(harga) > 10000;
SELECT * FROM produk ORDER BY stok DESC;

-- Table Pesanan
SELECT status_pembayaran, COUNT(*) FROM pesanan GROUP BY status_pembayaran;
SELECT * FROM pesanan ORDER BY total_harga DESC;
SELECT * FROM pesanan WHERE total_harga > 30000;

-- Table Detail Transaksi
SELECT id_produk, SUM(subtotal) AS total FROM detail_transaksi GROUP BY id_produk;
SELECT * FROM detail_transaksi WHERE jumlah > 1;
SELECT * FROM detail_transaksi ORDER BY subtotal DESC;

-- 7. Join dan subquery

-- Join: pengguna dengan pesanan
SELECT p.nama, ps.total_harga, ps.status_pembayaran
FROM pengguna p
JOIN pesanan ps ON p.id_pengguna = ps.id_pengguna;

-- Join: detail_transaksi dengan produk dan pesanan
SELECT dt.id_transaksi, pr.nama AS nama_produk, dt.jumlah, dt.subtotal, ps.tanggal_transaksi
FROM detail_transaksi dt
JOIN produk pr ON dt.id_produk = pr.id_produk
JOIN pesanan ps ON dt.id_pesanan = ps.id_pesanan;

-- Subquery: produk dengan harga di atas rata-rata
SELECT * FROM produk
WHERE harga > (SELECT AVG(harga) FROM produk);

-- Subquery: pengguna yang memiliki pesanan
SELECT * FROM pengguna
WHERE id_pengguna IN (SELECT id_pengguna FROM pesanan);
