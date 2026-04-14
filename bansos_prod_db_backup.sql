/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.29-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: bansos_prod_db
-- ------------------------------------------------------
-- Server version	10.5.29-MariaDB-0+deb11u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
INSERT INTO `cache` VALUES ('bansostracker-cache-total_approved_applicants_count','i:11;',1776172491);
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distribusi_bansos`
--

DROP TABLE IF EXISTS `distribusi_bansos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `distribusi_bansos` (
  `id` char(36) NOT NULL,
  `periode_bansos_id` char(36) NOT NULL,
  `profil_masyarakat_id` char(36) NOT NULL,
  `petugas_id` char(36) NOT NULL,
  `penugasan_id` char(36) DEFAULT NULL,
  `token_qr_dipindai` varchar(255) NOT NULL,
  `status` enum('diterima','gagal','duplikat') NOT NULL DEFAULT 'diterima',
  `alasan_gagal` text DEFAULT NULL,
  `latitude_scan` decimal(10,8) DEFAULT NULL,
  `longitude_scan` decimal(11,8) DEFAULT NULL,
  `diterima_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `distribusi_bansos_periode_bansos_id_foreign` (`periode_bansos_id`),
  KEY `distribusi_bansos_profil_masyarakat_id_foreign` (`profil_masyarakat_id`),
  KEY `distribusi_bansos_petugas_id_foreign` (`petugas_id`),
  KEY `distribusi_bansos_penugasan_id_foreign` (`penugasan_id`),
  CONSTRAINT `distribusi_bansos_penugasan_id_foreign` FOREIGN KEY (`penugasan_id`) REFERENCES `penugasan_petugas` (`id`),
  CONSTRAINT `distribusi_bansos_periode_bansos_id_foreign` FOREIGN KEY (`periode_bansos_id`) REFERENCES `periode_bansos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `distribusi_bansos_petugas_id_foreign` FOREIGN KEY (`petugas_id`) REFERENCES `users` (`id`),
  CONSTRAINT `distribusi_bansos_profil_masyarakat_id_foreign` FOREIGN KEY (`profil_masyarakat_id`) REFERENCES `profil_masyarakat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distribusi_bansos`
--

LOCK TABLES `distribusi_bansos` WRITE;
/*!40000 ALTER TABLE `distribusi_bansos` DISABLE KEYS */;
INSERT INTO `distribusi_bansos` VALUES ('2346f265-d60c-4f54-8f71-8cec3e9107ad','05ec2f5a-9d7f-4b23-b6aa-9a993fce6d9a','e7b04126-c840-4d80-85ee-7abf3b40d600','4b2a3472-e542-4f87-9dfa-f15e6b691b7c',NULL,'fac2fe7e-bed3-4e62-a51d-bcb77f6ea3b4','duplikat','Bansos sudah diterima pada periode ini',-7.33278907,108.27258754,'2026-04-14 12:55:09'),('6eaa7bed-4aa4-4915-8dce-5096c1c36f38','05ec2f5a-9d7f-4b23-b6aa-9a993fce6d9a','81f492de-d1dd-4468-83bd-7e1318aa2789','4b2a3472-e542-4f87-9dfa-f15e6b691b7c',NULL,'68c2fdce-e694-422e-9f23-95a2ab8dc439','diterima',NULL,-7.33289396,108.27278847,'2026-04-14 08:18:15'),('c64ce717-1793-4bc9-b864-2281c1063c5a','05ec2f5a-9d7f-4b23-b6aa-9a993fce6d9a','e7b04126-c840-4d80-85ee-7abf3b40d600','4b2a3472-e542-4f87-9dfa-f15e6b691b7c',NULL,'fac2fe7e-bed3-4e62-a51d-bcb77f6ea3b4','diterima',NULL,-7.33278907,108.27258754,'2026-04-14 12:55:06');
/*!40000 ALTER TABLE `distribusi_bansos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foto_rumah`
--

DROP TABLE IF EXISTS `foto_rumah`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `foto_rumah` (
  `id` char(36) NOT NULL,
  `profil_masyarakat_id` char(36) NOT NULL,
  `jenis_foto` enum('tampak_depan','ruang_tamu','kamar_tidur','kamar_mandi','dapur','atap_dinding','sumber_air','jamban') NOT NULL,
  `path_foto` varchar(255) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `diunggah_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `foto_rumah_profil_masyarakat_id_foreign` (`profil_masyarakat_id`),
  CONSTRAINT `foto_rumah_profil_masyarakat_id_foreign` FOREIGN KEY (`profil_masyarakat_id`) REFERENCES `profil_masyarakat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foto_rumah`
--

LOCK TABLES `foto_rumah` WRITE;
/*!40000 ALTER TABLE `foto_rumah` DISABLE KEYS */;
INSERT INTO `foto_rumah` VALUES ('08449769-cf7b-4809-8f1c-a7e819f1e703','b45fbfc1-33c7-49b2-aecf-32e457b7664d','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Linda Kusuma','2026-04-07 21:21:09'),('0997eac1-d64e-4e15-ab98-09146e1a0d23','ba8912fa-fee8-4f64-9494-a45295096518','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Mushawwir Rahman','2026-04-07 21:21:08'),('0a9a6973-9b4c-444c-b811-40d25e0ad43f','e7b04126-c840-4d80-85ee-7abf3b40d600','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Zheka Baila Arkan','2026-04-07 21:21:09'),('0b887a34-dd84-4f63-930b-9f6d6a8b706e','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','dapur','https://simpan-api.coreapps.web.id/storage/foto-rumah/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/dapur_1775658991.jpeg',NULL,'2026-04-08 14:36:31'),('0dd74374-ed4f-4d85-a972-40b77d4bd41a','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Ratna Wijayanti','2026-04-07 21:21:07'),('0f1d9659-2076-4f6c-8ef8-4db83ce5ad21','ba8912fa-fee8-4f64-9494-a45295096518','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Mushawwir Rahman','2026-04-07 21:21:08'),('119e1183-c6b4-4261-b7b7-f6bc7df7750f','a9a31353-748a-4c7b-901a-7025950f7406','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Dewi Lestari','2026-04-07 21:21:06'),('158973b2-42ec-44e4-8a53-f8145450755e','322452f3-d9ca-4298-9651-571cfdaf2119','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari M Fauzan Gumilang','2026-04-07 21:21:10'),('18f58caa-9dc9-45e3-9d04-3035f101d43a','566af246-f871-4fba-843d-d2aa5cc81ef8','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Susi Handayani','2026-04-07 21:21:07'),('1a89199b-add8-4167-a717-15d79bf743e2','b0d9761c-3094-435d-9f60-14f426206a55','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Budi Santoso','2026-04-07 21:21:05'),('1b41c455-8f75-4803-8078-c0bfb1fc3790','e7b04126-c840-4d80-85ee-7abf3b40d600','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Zheka Baila Arkan','2026-04-07 21:21:09'),('1de2c468-e0cb-4451-bbdb-74b152e83ed8','81f492de-d1dd-4468-83bd-7e1318aa2789','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Shafa Rabbani Fityatul Mukarramah','2026-04-07 21:21:09'),('1e82942a-440e-4ace-aa23-badec71c37b7','81f492de-d1dd-4468-83bd-7e1318aa2789','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Shafa Rabbani Fityatul Mukarramah','2026-04-07 21:21:09'),('1ef07c44-a437-4a89-9a5d-8650b54b2bef','b45fbfc1-33c7-49b2-aecf-32e457b7664d','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Linda Kusuma','2026-04-07 21:21:09'),('212206d1-24da-4fb7-a214-91eb53280c83','00afad59-aa32-47bd-aab2-b10f2fd14ae1','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Ahmad Wijaya','2026-04-07 21:21:06'),('2154add7-641b-4006-97e0-a3e9e493481e','322452f3-d9ca-4298-9651-571cfdaf2119','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari M Fauzan Gumilang','2026-04-07 21:21:10'),('24c729d3-efad-46ab-b1c1-b9c743aa23d1','a28a90d6-3c79-447f-81c5-9b38c21ae868','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Siti Nurhaliza','2026-04-07 21:21:05'),('24f75e46-f803-4fae-8e1d-ab1db71db29f','ba8912fa-fee8-4f64-9494-a45295096518','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Mushawwir Rahman','2026-04-07 21:21:08'),('2632dd0f-7847-4b26-95dc-5421d6fb4401','2d3b0860-6498-4a99-9941-32184e6a6c81','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Hendra Gunawan','2026-04-07 21:21:08'),('27417e8f-d293-4add-b6da-f8cecaa45db3','a28a90d6-3c79-447f-81c5-9b38c21ae868','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Siti Nurhaliza','2026-04-07 21:21:05'),('29a675aa-b59b-47ca-b6bc-42853353c6cc','322452f3-d9ca-4298-9651-571cfdaf2119','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari M Fauzan Gumilang','2026-04-07 21:21:10'),('2ae167b5-10ac-433e-9905-640ec01bfeeb','566af246-f871-4fba-843d-d2aa5cc81ef8','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Susi Handayani','2026-04-07 21:21:07'),('2e94a802-9d89-41d6-884b-f37082977328','e2806a75-e656-4c96-9387-c366c4c633f8','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Eka Prasetya','2026-04-07 21:21:07'),('3042a89f-f699-4c43-a1c6-fcfbcc88870a','a28a90d6-3c79-447f-81c5-9b38c21ae868','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Siti Nurhaliza','2026-04-07 21:21:05'),('33fe11f9-6612-484a-be10-23fbd53acfff','e2806a75-e656-4c96-9387-c366c4c633f8','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Eka Prasetya','2026-04-07 21:21:07'),('341694c5-b744-4d53-8f14-9879440f1e11','2d3b0860-6498-4a99-9941-32184e6a6c81','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Hendra Gunawan','2026-04-07 21:21:08'),('356d63bc-a0fc-40b3-b566-598321a4d892','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Ratna Wijayanti','2026-04-07 21:21:07'),('371e50b2-f5c7-44f8-af21-d8d2d42b6126','81f492de-d1dd-4468-83bd-7e1318aa2789','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Shafa Rabbani Fityatul Mukarramah','2026-04-07 21:21:09'),('3a1d58e1-3b75-4ba8-8577-721a14e5f141','81f492de-d1dd-4468-83bd-7e1318aa2789','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Shafa Rabbani Fityatul Mukarramah','2026-04-07 21:21:09'),('3a879c90-36c5-4074-926d-1ed36e3bbbe6','566af246-f871-4fba-843d-d2aa5cc81ef8','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Susi Handayani','2026-04-07 21:21:07'),('3e2cfe29-e11a-4749-a085-6b5dd7ac0553','a9a31353-748a-4c7b-901a-7025950f7406','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Dewi Lestari','2026-04-07 21:21:06'),('42264007-1f12-4e03-957d-9ce62555cf3b','322452f3-d9ca-4298-9651-571cfdaf2119','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari M Fauzan Gumilang','2026-04-07 21:21:10'),('42d04b7d-c040-402f-9065-557c601c17d5','e7b04126-c840-4d80-85ee-7abf3b40d600','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Zheka Baila Arkan','2026-04-07 21:21:09'),('44b7810e-afe3-42c9-ad2b-486949b18af2','b0d9761c-3094-435d-9f60-14f426206a55','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Budi Santoso','2026-04-07 21:21:05'),('482e0398-04d9-4159-b74a-b20d849e8665','ba8912fa-fee8-4f64-9494-a45295096518','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Mushawwir Rahman','2026-04-07 21:21:08'),('485e1444-17a9-44a9-8f77-6f6670cfa00b','b45fbfc1-33c7-49b2-aecf-32e457b7664d','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Linda Kusuma','2026-04-07 21:21:09'),('4966f7da-4bdb-4007-9e52-1f2317d95dfe','b45fbfc1-33c7-49b2-aecf-32e457b7664d','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Linda Kusuma','2026-04-07 21:21:09'),('4967f848-56e8-448d-8b21-7777c813fef3','a9a31353-748a-4c7b-901a-7025950f7406','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Dewi Lestari','2026-04-07 21:21:06'),('4b9d0cdc-286a-48fc-8bcb-9adf49acf632','a28a90d6-3c79-447f-81c5-9b38c21ae868','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Siti Nurhaliza','2026-04-07 21:21:05'),('4c548a85-ba1c-4420-a606-fda8fdbda9ce','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Ratna Wijayanti','2026-04-07 21:21:07'),('4e32b844-b54a-4e8e-b526-33487c1b8c0e','2d3b0860-6498-4a99-9941-32184e6a6c81','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Hendra Gunawan','2026-04-07 21:21:08'),('521dcdbc-3fad-4c95-95d0-409a319686f0','81f492de-d1dd-4468-83bd-7e1318aa2789','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Shafa Rabbani Fityatul Mukarramah','2026-04-07 21:21:09'),('54e3f9c4-6c93-404f-b832-4e9ef865c1dc','566af246-f871-4fba-843d-d2aa5cc81ef8','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Susi Handayani','2026-04-07 21:21:07'),('5804825c-afe0-4e80-934a-e600a9b83578','a9a31353-748a-4c7b-901a-7025950f7406','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Dewi Lestari','2026-04-07 21:21:06'),('586033ee-f740-44fd-9e40-62b4900d6f83','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Ratna Wijayanti','2026-04-07 21:21:07'),('5885afbe-f85d-46ee-9315-88bc4cb62148','81f492de-d1dd-4468-83bd-7e1318aa2789','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Shafa Rabbani Fityatul Mukarramah','2026-04-07 21:21:09'),('59120c76-ba76-4231-be4e-26c92fbe2a6c','2d3b0860-6498-4a99-9941-32184e6a6c81','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Hendra Gunawan','2026-04-07 21:21:08'),('59fe7de1-f05c-4f7f-aaa3-c93f0131dce2','00afad59-aa32-47bd-aab2-b10f2fd14ae1','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Ahmad Wijaya','2026-04-07 21:21:06'),('5aed8b71-11f7-46b5-8fe9-b9e2ce4cbfe3','b0d9761c-3094-435d-9f60-14f426206a55','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Budi Santoso','2026-04-07 21:21:05'),('5c214388-a2f2-4795-9c00-dd665f99696f','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Ratna Wijayanti','2026-04-07 21:21:07'),('5e98554a-0bfb-41d4-82c4-01ca384a8668','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','atap_dinding','https://simpan-api.coreapps.web.id/storage/foto-rumah/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/atap_dinding_1775658992.jpeg',NULL,'2026-04-08 14:36:32'),('5f9ca196-e663-4bb5-9d8c-8b3d9b96dc1e','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','jamban','https://simpan-api.coreapps.web.id/storage/foto-rumah/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/jamban_1775658995.jpeg',NULL,'2026-04-08 14:36:35'),('61e85df0-2e7b-4517-8e37-7b385aa67470','566af246-f871-4fba-843d-d2aa5cc81ef8','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Susi Handayani','2026-04-07 21:21:07'),('64b5f8d2-c370-4bcf-bc7d-e015d0b69a8f','b0d9761c-3094-435d-9f60-14f426206a55','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Budi Santoso','2026-04-07 21:21:05'),('6959e754-24e9-4913-be44-14b6f4b636e3','ba8912fa-fee8-4f64-9494-a45295096518','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Mushawwir Rahman','2026-04-07 21:21:08'),('6fd95dcd-0cf4-4034-95fc-ce5a85031821','322452f3-d9ca-4298-9651-571cfdaf2119','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari M Fauzan Gumilang','2026-04-07 21:21:10'),('71fbaeba-5497-4bb9-917f-46eed71a0956','e7b04126-c840-4d80-85ee-7abf3b40d600','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Zheka Baila Arkan','2026-04-07 21:21:09'),('746e9a8e-c42d-4cbc-81a7-33279cbf9a3a','a28a90d6-3c79-447f-81c5-9b38c21ae868','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Siti Nurhaliza','2026-04-07 21:21:05'),('75b083e3-97c9-4ca1-a4e3-45f32806025e','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','kamar_mandi','https://simpan-api.coreapps.web.id/storage/foto-rumah/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/kamar_mandi_1775658989.jpeg',NULL,'2026-04-08 14:36:29'),('7c7d88a4-ab58-43c9-b226-77b03e83e77d','322452f3-d9ca-4298-9651-571cfdaf2119','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari M Fauzan Gumilang','2026-04-07 21:21:10'),('7cdc24df-6131-43cf-ac19-cbe3b13ece1d','322452f3-d9ca-4298-9651-571cfdaf2119','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari M Fauzan Gumilang','2026-04-07 21:21:10'),('7e741c34-19de-448d-a641-34c27fbc3087','a9a31353-748a-4c7b-901a-7025950f7406','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Dewi Lestari','2026-04-07 21:21:06'),('80fdef19-a5c2-4244-997b-ecb6371b76a0','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','sumber_air','https://simpan-api.coreapps.web.id/storage/foto-rumah/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/sumber_air_1775658994.jpeg',NULL,'2026-04-08 14:36:34'),('81f9acf8-b422-479d-9076-4510306deb6c','2d3b0860-6498-4a99-9941-32184e6a6c81','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Hendra Gunawan','2026-04-07 21:21:08'),('82ed5e8b-2c1e-4913-8e02-2f5dce57173c','566af246-f871-4fba-843d-d2aa5cc81ef8','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Susi Handayani','2026-04-07 21:21:07'),('87bc09c6-b091-440d-84f9-a31eb93db765','00afad59-aa32-47bd-aab2-b10f2fd14ae1','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Ahmad Wijaya','2026-04-07 21:21:06'),('917f505e-4866-492d-aa72-a941084b4ff9','ba8912fa-fee8-4f64-9494-a45295096518','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Mushawwir Rahman','2026-04-07 21:21:08'),('9337333f-2272-4e03-96b8-9c9033cb79ec','322452f3-d9ca-4298-9651-571cfdaf2119','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari M Fauzan Gumilang','2026-04-07 21:21:10'),('9644b5c8-dea0-4391-8175-f5a3010d2266','00afad59-aa32-47bd-aab2-b10f2fd14ae1','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Ahmad Wijaya','2026-04-07 21:21:06'),('97983160-8bc3-492c-a683-5e3e0713b379','a9a31353-748a-4c7b-901a-7025950f7406','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Dewi Lestari','2026-04-07 21:21:06'),('9ae29f65-8f64-40bd-bfee-677e4f6e94e1','e2806a75-e656-4c96-9387-c366c4c633f8','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Eka Prasetya','2026-04-07 21:21:07'),('9e67f72f-dc07-4214-96bd-6ad0a9a78179','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Ratna Wijayanti','2026-04-07 21:21:07'),('9e6c8c40-0f74-46e8-a077-f0b8d7011754','00afad59-aa32-47bd-aab2-b10f2fd14ae1','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Ahmad Wijaya','2026-04-07 21:21:06'),('9f739dff-0901-4025-a0e0-3dbace103091','e2806a75-e656-4c96-9387-c366c4c633f8','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Eka Prasetya','2026-04-07 21:21:07'),('9f7f219a-c23c-41ba-9664-a4639d0ad7f2','a28a90d6-3c79-447f-81c5-9b38c21ae868','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Siti Nurhaliza','2026-04-07 21:21:05'),('9fa9adcd-299e-45a6-b31d-3a1c981ad423','b0d9761c-3094-435d-9f60-14f426206a55','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Budi Santoso','2026-04-07 21:21:05'),('a393fecf-4472-4d13-b723-91ddfb93343a','e7b04126-c840-4d80-85ee-7abf3b40d600','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Zheka Baila Arkan','2026-04-07 21:21:09'),('af60f91f-edb3-423a-8dec-98d4378cb466','a9a31353-748a-4c7b-901a-7025950f7406','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Dewi Lestari','2026-04-07 21:21:06'),('b18293c7-3770-4d6e-bba9-6f9da09f1112','a28a90d6-3c79-447f-81c5-9b38c21ae868','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Siti Nurhaliza','2026-04-07 21:21:05'),('b23e2ca1-dafa-4501-8dca-7bea766b96d6','e2806a75-e656-4c96-9387-c366c4c633f8','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Eka Prasetya','2026-04-07 21:21:07'),('b7424673-df39-474b-adf9-36a7ec7e7789','e2806a75-e656-4c96-9387-c366c4c633f8','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Eka Prasetya','2026-04-07 21:21:07'),('ba3c6e12-487d-4de1-ba6c-93ff74d8b56b','e2806a75-e656-4c96-9387-c366c4c633f8','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Eka Prasetya','2026-04-07 21:21:07'),('bccb8029-45fa-4a94-984b-308182f4a58a','b0d9761c-3094-435d-9f60-14f426206a55','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Budi Santoso','2026-04-07 21:21:05'),('bd08710a-8df5-4b5b-9c29-f9630200a054','b45fbfc1-33c7-49b2-aecf-32e457b7664d','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Linda Kusuma','2026-04-07 21:21:09'),('c15b35a0-817b-4b5a-9051-dd01f294978e','81f492de-d1dd-4468-83bd-7e1318aa2789','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Shafa Rabbani Fityatul Mukarramah','2026-04-07 21:21:09'),('c2e937a9-6b19-459e-b8a7-72ae251eda9b','2d3b0860-6498-4a99-9941-32184e6a6c81','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Hendra Gunawan','2026-04-07 21:21:08'),('c8f51eea-2f00-414e-9728-2012c3b2b075','e7b04126-c840-4d80-85ee-7abf3b40d600','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Zheka Baila Arkan','2026-04-07 21:21:09'),('cb1cfe12-5def-4987-91d2-80d53a3622da','b45fbfc1-33c7-49b2-aecf-32e457b7664d','ruang_tamu','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto ruang_tamu rumah dari Linda Kusuma','2026-04-07 21:21:09'),('cb8183c2-bb48-4ed3-8b6f-2ddf416aee36','a9a31353-748a-4c7b-901a-7025950f7406','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Dewi Lestari','2026-04-07 21:21:06'),('d5321d07-14aa-453b-b49b-bd62eed5836e','566af246-f871-4fba-843d-d2aa5cc81ef8','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Susi Handayani','2026-04-07 21:21:07'),('d5b73c65-6abb-4251-8277-dc1491c85838','81f492de-d1dd-4468-83bd-7e1318aa2789','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Shafa Rabbani Fityatul Mukarramah','2026-04-07 21:21:09'),('d86dd9f7-d910-403e-867c-994b481a0ce6','a28a90d6-3c79-447f-81c5-9b38c21ae868','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Siti Nurhaliza','2026-04-07 21:21:05'),('d98978af-d9af-49e4-a3d4-e688a1eb019a','b0d9761c-3094-435d-9f60-14f426206a55','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Budi Santoso','2026-04-07 21:21:05'),('da318ac8-c173-4b3f-975e-86f8dbf63e4e','e7b04126-c840-4d80-85ee-7abf3b40d600','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Zheka Baila Arkan','2026-04-07 21:21:09'),('df7cadbb-d143-489b-b0c9-394c124f2ca2','b45fbfc1-33c7-49b2-aecf-32e457b7664d','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Linda Kusuma','2026-04-07 21:21:09'),('e48ad8c1-073f-41b1-a85e-b0ecea27ef8e','e2806a75-e656-4c96-9387-c366c4c633f8','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Eka Prasetya','2026-04-07 21:21:07'),('e4d963ff-9b6c-4bb8-a933-bf64ed74738a','b45fbfc1-33c7-49b2-aecf-32e457b7664d','sumber_air','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto sumber_air rumah dari Linda Kusuma','2026-04-07 21:21:09'),('e721ece9-459d-4f29-b736-8f9dea36cba1','2d3b0860-6498-4a99-9941-32184e6a6c81','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Hendra Gunawan','2026-04-07 21:21:08'),('eaf24113-d25c-48c1-9502-ed6e3a8768a4','b0d9761c-3094-435d-9f60-14f426206a55','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Budi Santoso','2026-04-07 21:21:05'),('ec946949-1cb7-4f1f-b45f-e607fd0960d3','566af246-f871-4fba-843d-d2aa5cc81ef8','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Susi Handayani','2026-04-07 21:21:07'),('ecc3e89d-748c-4a07-ba97-3016d5c0b8e8','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Ratna Wijayanti','2026-04-07 21:21:07'),('ed37f488-8b3e-4b1f-9b3d-cb5343434339','2d3b0860-6498-4a99-9941-32184e6a6c81','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Hendra Gunawan','2026-04-07 21:21:08'),('ee7b8141-9998-4830-9b79-ff8c89096a38','e7b04126-c840-4d80-85ee-7abf3b40d600','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Zheka Baila Arkan','2026-04-07 21:21:09'),('efee9bb8-73c6-4b59-a34b-42cc109c2507','00afad59-aa32-47bd-aab2-b10f2fd14ae1','kamar_mandi','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_mandi rumah dari Ahmad Wijaya','2026-04-07 21:21:06'),('f6bf95d2-e331-457f-8b2c-b63768782957','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','ruang_tamu','https://simpan-api.coreapps.web.id/storage/foto-rumah/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/ruang_tamu_1775658986.jpeg',NULL,'2026-04-08 14:36:26'),('f83c8185-4c10-42e7-a979-0669f74f4a84','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','dapur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto dapur rumah dari Ratna Wijayanti','2026-04-07 21:21:07'),('f8efcee8-c920-4cba-a149-a71ea7e3bce9','00afad59-aa32-47bd-aab2-b10f2fd14ae1','kamar_tidur','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto kamar_tidur rumah dari Ahmad Wijaya','2026-04-07 21:21:06'),('fc487734-4fa7-4205-8e5e-b598bae01d37','ba8912fa-fee8-4f64-9494-a45295096518','jamban','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto jamban rumah dari Mushawwir Rahman','2026-04-07 21:21:08'),('fc97238c-8805-4be8-a721-7aa52700af59','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','kamar_tidur','https://simpan-api.coreapps.web.id/storage/foto-rumah/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/kamar_tidur_1775658988.jpeg',NULL,'2026-04-08 14:36:28'),('fcff8e95-1135-4236-82d3-e7f396006a9c','ba8912fa-fee8-4f64-9494-a45295096518','tampak_depan','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto tampak_depan rumah dari Mushawwir Rahman','2026-04-07 21:21:08'),('fe65dc4b-7fad-4049-91a2-9386bacd796d','00afad59-aa32-47bd-aab2-b10f2fd14ae1','atap_dinding','https://images.unsplash.com/photo-1761839257658-23502c67f6d5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D','Foto atap_dinding rumah dari Ahmad Wijaya','2026-04-07 21:21:06'),('fed82515-5abd-4205-ac55-1d0eb888292a','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','tampak_depan','https://simpan-api.coreapps.web.id/storage/foto-rumah/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/tampak_depan_1775658983.jpeg','bNsbdjd jndjsbdjsn','2026-04-08 14:36:23');
/*!40000 ALTER TABLE `foto_rumah` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2025_03_16_000100_create_profil_masyarakat_table',1),(5,'2025_03_16_000200_create_foto_rumah_table',1),(6,'2025_03_16_000300_create_pengajuan_bansos_table',1),(7,'2025_03_16_000400_create_qrcode_penerima_table',1),(8,'2025_03_16_000500_create_periode_bansos_table',1),(9,'2025_03_16_000600_create_penugasan_petugas_table',1),(10,'2025_03_16_000700_create_distribusi_bansos_table',1),(11,'2025_03_16_000800_create_notifikasi_table',1),(12,'2025_03_16_000910_add_role_to_users_table',1),(13,'2025_03_22_000001_remove_tanggal_from_periode_bansos',1),(14,'2025_03_16_000910_create_profil_petugas_table',2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifikasi`
--

DROP TABLE IF EXISTS `notifikasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifikasi` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `pesan` text NOT NULL,
  `jenis` enum('status_pengajuan','jadwal_distribusi','qr_siap','umum') NOT NULL,
  `referensi_id` char(36) DEFAULT NULL,
  `jenis_referensi` varchar(255) DEFAULT NULL,
  `sudah_dibaca` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `dibaca_pada` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifikasi_user_id_foreign` (`user_id`),
  CONSTRAINT `notifikasi_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifikasi`
--

LOCK TABLES `notifikasi` WRITE;
/*!40000 ALTER TABLE `notifikasi` DISABLE KEYS */;
INSERT INTO `notifikasi` VALUES ('105fecd0-fdd0-4bbd-8a10-b61491893427','93f42258-377a-46e2-8a9b-5adb0f20f242','Pengajuan Bansos Sedang Ditinjau','Pengajuan bansos Anda dengan nomor PNG-2026-00014 sedang dalam proses tinjauan.\n\nCek status aplikasi Anda di:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard\n\nAmi akan segera memberikan keputusan.','status_pengajuan','30f0be69-8c61-4c83-a38a-1fed069ae2f7','pengajuan_bansos',0,'2026-04-08 14:48:41',NULL),('13ad70c5-ca10-47de-b0b4-f27f31690e6d','ad5ad01d-01f7-4af7-ba2f-95e0f7fee947','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','0db3b7ec-47f3-4806-a6c1-c177226387da','pengajuan_bansos',0,'2026-04-10 07:20:49',NULL),('145b08ea-c407-4867-acda-08cfb418e391','9752e736-3dc3-40d5-b60c-36c931c86158','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','d2e6a776-d6fc-4b81-b33c-83cc95768855','pengajuan_bansos',0,'2026-04-07 21:22:40',NULL),('1ccfbfe0-a514-4fa5-a250-755ff04e90d1','93f42258-377a-46e2-8a9b-5adb0f20f242','Pengajuan Bansos Sedang Ditinjau','Pengajuan bansos Anda dengan nomor PNG-2026-00014 sedang dalam proses tinjauan.\n\nCek status aplikasi Anda di:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard\n\nAmi akan segera memberikan keputusan.','status_pengajuan','30f0be69-8c61-4c83-a38a-1fed069ae2f7','pengajuan_bansos',0,'2026-04-08 14:48:42',NULL),('2079c5e5-fa22-4674-83a8-1b77d06fb057','2b4311b5-4b50-4d3f-90e1-74a91780e7d1','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00005 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','706bccc9-9aa0-4269-8967-7463434baa08','pengajuan_bansos',0,'2026-04-14 08:22:49',NULL),('28b342fd-6723-41c3-a701-7d004656b0e7','e491f487-2765-4f81-95dc-9982aefb3fc7','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','68860192-d749-41b1-81b5-ad4bc92f954f','pengajuan_bansos',0,'2026-04-14 07:29:01',NULL),('382a02ce-b1a2-465e-be09-8bf3a6c5e00e','3f7ef7a5-2d7d-4fbc-b088-70ff0d6f9cdc','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00007 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','03e2233d-8b16-4b94-a06f-cf8622e3b3db','pengajuan_bansos',0,'2026-04-10 07:12:37',NULL),('52df78ba-7606-46f7-b657-6f63831fe912','2b4311b5-4b50-4d3f-90e1-74a91780e7d1','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','706bccc9-9aa0-4269-8967-7463434baa08','pengajuan_bansos',0,'2026-04-14 08:22:49',NULL),('5458349f-494f-47d3-b05d-d420ccd20305','96a3da0d-8504-40b8-bdfa-6f7189000dbb','Penugasan Distribusi Baru','Penugasan Distribusi Baru\n\nAnda mendapat penugasan distribusi bansos untuk periode bansos di wilayah _wilayah yang ditentukan_.\n\nSilakan cek detail penugasan di aplikasi.','jadwal_distribusi','308f88b8-d7cc-4dde-8862-5f92dbf2b78e','penugasan_petugas',0,'2026-04-08 14:50:50',NULL),('639cd593-bd90-4ab3-80f6-58473a738db6','ad5ad01d-01f7-4af7-ba2f-95e0f7fee947','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00003 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','0db3b7ec-47f3-4806-a6c1-c177226387da','pengajuan_bansos',0,'2026-04-10 07:20:49',NULL),('6d26b09f-e9cc-4574-b510-58a2ef41b9a2','01384c43-fc4c-40f2-8726-5f27f356feb2','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','9107dbfc-80e2-4036-bdfe-8c9761eba926','pengajuan_bansos',0,'2026-04-08 15:16:39',NULL),('70143df8-2203-43eb-858f-c997a862ec1d','86241c1e-36db-4b6a-bfd4-f2ed2e5e801d','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','26a7d61a-84c2-4696-ab65-1e417050f707','pengajuan_bansos',0,'2026-04-10 07:12:50',NULL),('7b616ad6-5e26-4ce7-b247-67cdb92fb2e4','9752e736-3dc3-40d5-b60c-36c931c86158','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00012 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','d2e6a776-d6fc-4b81-b33c-83cc95768855','pengajuan_bansos',0,'2026-04-07 21:22:40',NULL),('7dd5e7a2-eea2-4504-8b90-641ec1af4f99','f5b5c922-6b15-4024-abb2-336d527f8c3e','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00008 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','9fed81d0-9741-4077-8178-9f0a99666587','pengajuan_bansos',0,'2026-04-08 15:16:32',NULL),('80d06165-0674-4e6c-a569-38567a228003','01384c43-fc4c-40f2-8726-5f27f356feb2','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00009 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','9107dbfc-80e2-4036-bdfe-8c9761eba926','pengajuan_bansos',0,'2026-04-08 15:16:39',NULL),('86513615-3d25-4f9b-8fa3-8f5c4820b20a','4b2a3472-e542-4f87-9dfa-f15e6b691b7c','Penugasan Distribusi Baru','Penugasan Distribusi Baru\n\nAnda mendapat penugasan distribusi bansos untuk periode Bansos Pangan Periode April 2026 di wilayah _wilayah yang ditentukan_.\n\nSilakan cek detail penugasan di aplikasi.','jadwal_distribusi','7fe94692-578b-4252-b7f7-f4d62407f750','penugasan_petugas',0,'2026-04-10 07:14:49',NULL),('8e579eac-160c-4f00-b60a-53b8477ce377','f5b5c922-6b15-4024-abb2-336d527f8c3e','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','9fed81d0-9741-4077-8178-9f0a99666587','pengajuan_bansos',0,'2026-04-08 15:16:32',NULL),('9558b6dc-dc1e-49ca-8248-302f09ff6c8d','3f7ef7a5-2d7d-4fbc-b088-70ff0d6f9cdc','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','03e2233d-8b16-4b94-a06f-cf8622e3b3db','pengajuan_bansos',0,'2026-04-10 07:12:37',NULL),('96987243-b402-4a49-ba37-45fece7a3f38','f4195244-68fb-4817-a85f-97e735ebe6a5','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00010 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','c349371f-0013-4bc8-a132-93e4aaa2f482','pengajuan_bansos',0,'2026-04-10 07:12:43',NULL),('98572a37-a5d4-4d39-a9f4-fd7ddc63d93d','c7974aa9-2822-40df-ae4b-e33fe410ce39','Akun Petugas Anda Telah Dibuat','Selamat! Akun petugas Anda telah berhasil dibuat oleh admin.\n\nInformasi Login:\n📧 Email: petugas.sapa.dari.admin@simpan.id\n🔐 Password: 12345678\n📱 Nomor WhatsApp: 628996324041\n\nAnda sekarang dapat login dan mengakses aplikasi SIMPAN untuk melihat penugasan distribusi.\n\n⚠️ Kami sarankan Anda mengubah password dan nomor WhatsApp ini setelah login pertama kali di halaman profil.\n\nUntuk login, kunjungi: https://simpan.coreapps.web.id','umum','c7974aa9-2822-40df-ae4b-e33fe410ce39','pengguna',0,'2026-04-08 11:56:22',NULL),('9c8e9ab5-abae-4279-9621-ca2a9ebccbe1','93f42258-377a-46e2-8a9b-5adb0f20f242','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','30f0be69-8c61-4c83-a38a-1fed069ae2f7','pengajuan_bansos',0,'2026-04-08 14:48:47',NULL),('a74f5538-c1ad-4a39-bad1-a65d04e460db','54e23f9e-43b2-4ecf-a2c0-ce8675c0cb74','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00013 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','f72a17d7-eb69-4e17-908a-fde5370fc679','pengajuan_bansos',0,'2026-04-14 07:40:46',NULL),('adcf2d48-f937-4041-a742-0bdbff473521','f4195244-68fb-4817-a85f-97e735ebe6a5','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','c349371f-0013-4bc8-a132-93e4aaa2f482','pengajuan_bansos',0,'2026-04-10 07:12:43',NULL),('bc637504-eb6c-40dd-94e2-c4099683ac4a','4b2a3472-e542-4f87-9dfa-f15e6b691b7c','Penugasan Distribusi Baru','Penugasan Distribusi Baru\n\nAnda mendapat penugasan distribusi bansos untuk periode Bansos Pangan Periode April 2026 di wilayah _wilayah yang ditentukan_.\n\nSilakan cek detail penugasan di aplikasi.','jadwal_distribusi','df2f6519-856e-4b62-80d0-c65dc80f76b9','penugasan_petugas',0,'2026-04-14 08:15:44',NULL),('bd6fe54c-c7ed-4d1d-a634-7ef4ba76b227','93f42258-377a-46e2-8a9b-5adb0f20f242','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00014 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','30f0be69-8c61-4c83-a38a-1fed069ae2f7','pengajuan_bansos',0,'2026-04-08 14:48:47',NULL),('c15da3e7-edd1-4617-aaad-a420fa3e357b','86241c1e-36db-4b6a-bfd4-f2ed2e5e801d','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00011 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','26a7d61a-84c2-4696-ab65-1e417050f707','pengajuan_bansos',0,'2026-04-10 07:12:50',NULL),('c7d0cd33-31c8-4bca-baf1-2ad4e9d84bea','4b2a3472-e542-4f87-9dfa-f15e6b691b7c','Akun Petugas Anda Telah Dibuat','Selamat! Akun petugas Anda telah berhasil dibuat oleh admin.\n\nInformasi Login:\n📧 Email: petugas.zheka@simpan.id\n🔐 Password: 12345678\n📱 Nomor WhatsApp: 6281313747177\n\nAnda sekarang dapat login dan mengakses aplikasi SIMPAN untuk melihat penugasan distribusi.\n\n⚠️ Kami sarankan Anda mengubah password dan nomor WhatsApp ini setelah login pertama kali di halaman profil.\n\nUntuk login, kunjungi: https://simpan.coreapps.web.id','umum','4b2a3472-e542-4f87-9dfa-f15e6b691b7c','pengguna',0,'2026-04-10 07:14:33',NULL),('e631e1fb-11d2-4606-9d7e-b232ea65fa4b','54e23f9e-43b2-4ecf-a2c0-ce8675c0cb74','QR Code Anda Sudah Siap','QR Code Anda Sudah Siap\n\nQR Code penerima bansos Anda sudah siap untuk digunakan saat distribusi. Buka link berikut untuk menampilkan QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','qr_siap','f72a17d7-eb69-4e17-908a-fde5370fc679','pengajuan_bansos',0,'2026-04-14 07:40:46',NULL),('e6ed6ba5-b163-4c61-a4c4-dafe9006108d','e491f487-2765-4f81-95dc-9982aefb3fc7','Pengajuan Bansos Disetujui','Selamat! Pengajuan bansos Anda dengan nomor PNG-2026-00006 telah DISETUJUI\n\nQR Code Anda sudah siap. Buka aplikasi berikut untuk melihat QR Code:\nhttps://simpan.coreapps.web.id/masyarakat/dashboard','status_pengajuan','68860192-d749-41b1-81b5-ad4bc92f954f','pengajuan_bansos',0,'2026-04-14 07:29:01',NULL);
/*!40000 ALTER TABLE `notifikasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pengajuan_bansos`
--

DROP TABLE IF EXISTS `pengajuan_bansos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pengajuan_bansos` (
  `id` char(36) NOT NULL,
  `profil_masyarakat_id` char(36) NOT NULL,
  `nomor_pengajuan` varchar(255) NOT NULL,
  `status` enum('menunggu','ditinjau','disetujui','ditolak') NOT NULL DEFAULT 'menunggu',
  `catatan_admin` text DEFAULT NULL,
  `ditinjau_oleh` char(36) DEFAULT NULL,
  `ditinjau_pada` timestamp NULL DEFAULT NULL,
  `diajukan_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pengajuan_bansos_nomor_pengajuan_unique` (`nomor_pengajuan`),
  KEY `pengajuan_bansos_profil_masyarakat_id_foreign` (`profil_masyarakat_id`),
  KEY `pengajuan_bansos_ditinjau_oleh_foreign` (`ditinjau_oleh`),
  CONSTRAINT `pengajuan_bansos_ditinjau_oleh_foreign` FOREIGN KEY (`ditinjau_oleh`) REFERENCES `users` (`id`),
  CONSTRAINT `pengajuan_bansos_profil_masyarakat_id_foreign` FOREIGN KEY (`profil_masyarakat_id`) REFERENCES `profil_masyarakat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pengajuan_bansos`
--

LOCK TABLES `pengajuan_bansos` WRITE;
/*!40000 ALTER TABLE `pengajuan_bansos` DISABLE KEYS */;
INSERT INTO `pengajuan_bansos` VALUES ('03e2233d-8b16-4b94-a06f-cf8622e3b3db','566af246-f871-4fba-843d-d2aa5cc81ef8','PNG-2026-00007','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-10 07:12:37','2026-04-02 21:21:07','2026-04-07 21:21:07','2026-04-10 07:12:37'),('0db3b7ec-47f3-4806-a6c1-c177226387da','a9a31353-748a-4c7b-901a-7025950f7406','PNG-2026-00003','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-10 07:20:49','2026-04-02 21:21:06','2026-04-07 21:21:06','2026-04-10 07:20:49'),('26a7d61a-84c2-4696-ab65-1e417050f707','81f492de-d1dd-4468-83bd-7e1318aa2789','PNG-2026-00011','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-10 07:12:50','2026-04-02 21:21:09','2026-04-07 21:21:09','2026-04-10 07:12:50'),('2d2ca964-4f90-42b3-acc0-102e37866286','00afad59-aa32-47bd-aab2-b10f2fd14ae1','PNG-2026-00004','ditinjau',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-07 21:21:06','2026-04-02 21:21:06','2026-04-07 21:21:06','2026-04-07 21:21:06'),('30f0be69-8c61-4c83-a38a-1fed069ae2f7','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','PNG-2026-00014','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-08 14:48:47','2026-04-08 14:36:48','2026-04-08 14:36:48','2026-04-08 14:48:47'),('68860192-d749-41b1-81b5-ad4bc92f954f','e2806a75-e656-4c96-9387-c366c4c633f8','PNG-2026-00006','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-14 07:29:00','2026-04-02 21:21:07','2026-04-07 21:21:07','2026-04-14 07:29:00'),('706bccc9-9aa0-4269-8967-7463434baa08','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','PNG-2026-00005','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-14 08:22:49','2026-04-02 21:21:07','2026-04-07 21:21:07','2026-04-14 08:22:49'),('9107dbfc-80e2-4036-bdfe-8c9761eba926','ba8912fa-fee8-4f64-9494-a45295096518','PNG-2026-00009','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-08 15:16:39','2026-04-02 21:21:08','2026-04-07 21:21:08','2026-04-08 15:16:39'),('9fed81d0-9741-4077-8178-9f0a99666587','2d3b0860-6498-4a99-9941-32184e6a6c81','PNG-2026-00008','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-08 15:16:32','2026-04-02 21:21:08','2026-04-07 21:21:08','2026-04-08 15:16:32'),('c349371f-0013-4bc8-a132-93e4aaa2f482','b45fbfc1-33c7-49b2-aecf-32e457b7664d','PNG-2026-00010','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-10 07:12:43','2026-04-02 21:21:09','2026-04-07 21:21:09','2026-04-10 07:12:43'),('d2e6a776-d6fc-4b81-b33c-83cc95768855','e7b04126-c840-4d80-85ee-7abf3b40d600','PNG-2026-00012','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-07 21:22:40','2026-04-02 21:21:09','2026-04-07 21:21:09','2026-04-07 21:22:40'),('e1d222a7-a7bc-4a03-9745-f44737d13f75','b0d9761c-3094-435d-9f60-14f426206a55','PNG-2026-00002','ditinjau',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-07 21:21:05','2026-04-02 21:21:05','2026-04-07 21:21:05','2026-04-07 21:21:05'),('f72a17d7-eb69-4e17-908a-fde5370fc679','322452f3-d9ca-4298-9651-571cfdaf2119','PNG-2026-00013','disetujui',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-14 07:40:46','2026-04-02 21:21:10','2026-04-07 21:21:10','2026-04-14 07:40:46'),('fa1595c0-5695-4dba-ba1e-0c25248096cb','a28a90d6-3c79-447f-81c5-9b38c21ae868','PNG-2026-00001','ditinjau',NULL,'27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-07 21:21:05','2026-04-02 21:21:05','2026-04-07 21:21:05','2026-04-07 21:21:05');
/*!40000 ALTER TABLE `pengajuan_bansos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `penugasan_petugas`
--

DROP TABLE IF EXISTS `penugasan_petugas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `penugasan_petugas` (
  `id` char(36) NOT NULL,
  `periode_bansos_id` char(36) NOT NULL,
  `petugas_id` char(36) NOT NULL,
  `ditugaskan_oleh` char(36) NOT NULL,
  `catatan` text DEFAULT NULL,
  `ditugaskan_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `penugasan_petugas_periode_bansos_id_foreign` (`periode_bansos_id`),
  KEY `penugasan_petugas_petugas_id_foreign` (`petugas_id`),
  KEY `penugasan_petugas_ditugaskan_oleh_foreign` (`ditugaskan_oleh`),
  CONSTRAINT `penugasan_petugas_ditugaskan_oleh_foreign` FOREIGN KEY (`ditugaskan_oleh`) REFERENCES `users` (`id`),
  CONSTRAINT `penugasan_petugas_periode_bansos_id_foreign` FOREIGN KEY (`periode_bansos_id`) REFERENCES `periode_bansos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `penugasan_petugas_petugas_id_foreign` FOREIGN KEY (`petugas_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `penugasan_petugas`
--

LOCK TABLES `penugasan_petugas` WRITE;
/*!40000 ALTER TABLE `penugasan_petugas` DISABLE KEYS */;
INSERT INTO `penugasan_petugas` VALUES ('308f88b8-d7cc-4dde-8862-5f92dbf2b78e','ae2165ef-651d-4a92-b7f7-b42f8e0eee01','96a3da0d-8504-40b8-bdfa-6f7189000dbb','27117cb7-92fb-49ef-850f-0bba447237b6',NULL,'2026-04-08 14:50:50',NULL),('df2f6519-856e-4b62-80d0-c65dc80f76b9','05ec2f5a-9d7f-4b23-b6aa-9a993fce6d9a','4b2a3472-e542-4f87-9dfa-f15e6b691b7c','27117cb7-92fb-49ef-850f-0bba447237b6',NULL,'2026-04-14 08:15:44',NULL);
/*!40000 ALTER TABLE `penugasan_petugas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `periode_bansos`
--

DROP TABLE IF EXISTS `periode_bansos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `periode_bansos` (
  `id` char(36) NOT NULL,
  `nama_periode` varchar(255) NOT NULL,
  `jenis_bantuan` enum('sembako','tunai','bpnt','pkh','lainnya') NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `status` enum('akan_datang','aktif','selesai') NOT NULL DEFAULT 'akan_datang',
  `dibuat_oleh` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `periode_bansos_dibuat_oleh_foreign` (`dibuat_oleh`),
  CONSTRAINT `periode_bansos_dibuat_oleh_foreign` FOREIGN KEY (`dibuat_oleh`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `periode_bansos`
--

LOCK TABLES `periode_bansos` WRITE;
/*!40000 ALTER TABLE `periode_bansos` DISABLE KEYS */;
INSERT INTO `periode_bansos` VALUES ('05ec2f5a-9d7f-4b23-b6aa-9a993fce6d9a','Bansos Pangan Periode April 2026','sembako',NULL,'aktif','27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-14 08:15:31','2026-04-14 08:15:52'),('ae2165ef-651d-4a92-b7f7-b42f8e0eee01','bansos','sembako',NULL,'selesai','27117cb7-92fb-49ef-850f-0bba447237b6','2026-04-08 14:50:39','2026-04-10 07:13:49');
/*!40000 ALTER TABLE `periode_bansos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profil_masyarakat`
--

DROP TABLE IF EXISTS `profil_masyarakat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `profil_masyarakat` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `nik` varchar(16) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `nomor_telepon` varchar(15) NOT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `jenis_kelamin` enum('L','P') DEFAULT NULL,
  `alamat` text NOT NULL,
  `rt` varchar(5) DEFAULT NULL,
  `rw` varchar(5) DEFAULT NULL,
  `kelurahan` varchar(255) DEFAULT NULL,
  `kecamatan` varchar(255) DEFAULT NULL,
  `kota` varchar(255) DEFAULT NULL,
  `provinsi` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `status_pernikahan` enum('belum_menikah','menikah','cerai_hidup','cerai_mati') DEFAULT NULL,
  `jumlah_tanggungan` int(11) NOT NULL DEFAULT 0,
  `status_pekerjaan` enum('bekerja','tidak_bekerja','wiraswasta','pensiun') DEFAULT NULL,
  `penghasilan_bulanan` bigint(20) NOT NULL DEFAULT 0,
  `status_kepemilikan_rumah` enum('milik_sendiri','kontrak','numpang','lainnya') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profil_masyarakat_user_id_unique` (`user_id`),
  UNIQUE KEY `profil_masyarakat_nik_unique` (`nik`),
  CONSTRAINT `profil_masyarakat_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profil_masyarakat`
--

LOCK TABLES `profil_masyarakat` WRITE;
/*!40000 ALTER TABLE `profil_masyarakat` DISABLE KEYS */;
INSERT INTO `profil_masyarakat` VALUES ('00afad59-aa32-47bd-aab2-b10f2fd14ae1','0697ddc7-3697-4dfc-b6f3-abd0e2f24a13','3206451992080004','Ahmad Wijaya','6281313747177','1992-08-25','L','Jl. Flamboyan No. 67','02','03','Cipete Utara','Kebayoran Lama','Jakarta Selatan','DKI Jakarta',-6.25980000,106.76340000,'belum_menikah',1,'bekerja',2500000,'kontrak','2026-04-07 21:21:06','2026-04-07 21:21:06'),('2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','93f42258-377a-46e2-8a9b-5adb0f20f242','3278076778985519','Muhammad Fauzan Gemilang','6285520787634','2003-04-07','L','Tasikmalaya, Jawa Barat, Jawa, Indonesia','002','001','Tamanjaya','Tamansari','Kota Tasikmalaya','Jawa barat',-7.32624840,108.22011540,'belum_menikah',5,'wiraswasta',700000000,'milik_sendiri','2026-04-08 14:33:09','2026-04-08 14:36:48'),('2d3b0860-6498-4a99-9941-32184e6a6c81','f5b5c922-6b15-4024-abb2-336d527f8c3e','3206451993120008','Hendra Gunawan','6281313747177','1993-12-05','L','Jl. Bangka No. 78','02','01','Kemang','Kemang','Jakarta Selatan','DKI Jakarta',-6.28230000,106.82010000,'belum_menikah',0,'bekerja',3000000,'kontrak','2026-04-07 21:21:08','2026-04-07 21:21:08'),('322452f3-d9ca-4298-9651-571cfdaf2119','54e23f9e-43b2-4ecf-a2c0-ce8675c0cb74','3206451994020122','M Fauzan Gumilang','6281313747177','1994-02-08','L','Jl. Teuku Umar No. 92','05','02','Cilandak Kota','Cilandak','Jakarta Selatan','DKI Jakarta',-6.32420000,106.79430000,'menikah',1,'wiraswasta',1200000,'numpang','2026-04-07 21:21:10','2026-04-07 21:21:10'),('566af246-f871-4fba-843d-d2aa5cc81ef8','3f7ef7a5-2d7d-4fbc-b088-70ff0d6f9cdc','3206451989110007','Susi Handayani','6281313747177','1989-11-18','P','Jl. Sudirman No. 156','03','04','Pondok Indah','Pondok Indah','Jakarta Selatan','DKI Jakarta',-6.28900000,106.79340000,'cerai_mati',3,'tidak_bekerja',0,'milik_sendiri','2026-04-07 21:21:07','2026-04-07 21:21:07'),('81f492de-d1dd-4468-83bd-7e1318aa2789','86241c1e-36db-4b6a-bfd4-f2ed2e5e801d','3206451994020021','Shafa Rabbani Fityatul Mukarramah','628996324041','1994-02-08','P','Jl. Teuku Umar No. 92','05','02','Cilandak Kota','Cilandak','Jakarta Selatan','DKI Jakarta',-6.30480000,106.79420000,'menikah',1,'wiraswasta',1200000,'numpang','2026-04-07 21:21:09','2026-04-07 21:21:09'),('a28a90d6-3c79-447f-81c5-9b38c21ae868','c6446680-002a-4c8b-8806-24ed63591ccf','3206451987050001','Siti Nurhaliza','6281313747177','1987-05-15','P','Jl. Merdeka No. 45','01','02','Cipete','Cilandak','Jakarta Selatan','DKI Jakarta',-6.29480000,106.79990000,'menikah',2,'tidak_bekerja',0,'numpang','2026-04-07 21:21:05','2026-04-07 21:21:05'),('a9a31353-748a-4c7b-901a-7025950f7406','ad5ad01d-01f7-4af7-ba2f-95e0f7fee947','3206451990070003','Dewi Lestari','6281313747177','1990-07-11','P','Jl. Anggrek No. 28','05','01','Pesanggrahan','Pesanggrahan','Jakarta Selatan','DKI Jakarta',-6.27050000,106.75120000,'menikah',3,'wiraswasta',1500000,'milik_sendiri','2026-04-07 21:21:06','2026-04-07 21:21:06'),('b0d9761c-3094-435d-9f60-14f426206a55','59e05f13-7d2a-4994-8c89-48942ce5b62c','3206451988060002','Budi Santoso','6281313747177','1988-06-20','L','Jl. Garuda No. 12','03','04','Gandaria','Cilandak','Jakarta Selatan','DKI Jakarta',-6.28560000,106.78560000,'cerai_hidup',1,'tidak_bekerja',0,'kontrak','2026-04-07 21:21:05','2026-04-07 21:21:05'),('b45fbfc1-33c7-49b2-aecf-32e457b7664d','f4195244-68fb-4817-a85f-97e735ebe6a5','3206451994020010','Linda Kusuma','6281313747177','1994-02-08','P','Jl. Teuku Umar No. 92','05','02','Cilandak Kota','Cilandak','Jakarta Selatan','DKI Jakarta',-6.31420000,106.79480000,'menikah',1,'wiraswasta',1200000,'numpang','2026-04-07 21:21:09','2026-04-07 21:21:09'),('ba8912fa-fee8-4f64-9494-a45295096518','01384c43-fc4c-40f2-8726-5f27f356feb2','3206451986010009','Mushawwir Rahman','6281313747177','1986-01-22','L','Jl. Kebo Iwa No. 45','04','03','Cilandak Barat','Cilandak','Jakarta Selatan','DKI Jakarta',-6.30120000,106.78760000,'menikah',2,'pensiun',2000000,'milik_sendiri','2026-04-07 21:21:08','2026-04-07 21:21:08'),('e2806a75-e656-4c96-9387-c366c4c633f8','e491f487-2765-4f81-95dc-9982aefb3fc7','3206451991100006','Eka Prasetya','6281313747177','1991-10-30','L','Jl. Bunga Raya No. 34','01','02','Kemang','Kemang','Jakarta Selatan','DKI Jakarta',-6.27560000,106.81520000,'menikah',1,'wiraswasta',1800000,'kontrak','2026-04-07 21:21:07','2026-04-07 21:21:07'),('e7b04126-c840-4d80-85ee-7abf3b40d600','9752e736-3dc3-40d5-b60c-36c931c86158','3206451994020121','Zheka Baila Arkan','6281313747177','1994-02-08','L','Jl. Teuku Umar No. 92','05','02','Cilandak Kota','Cilandak','Jakarta Selatan','DKI Jakarta',-6.32480000,106.79470000,'menikah',1,'wiraswasta',1200000,'numpang','2026-04-07 21:21:09','2026-04-07 21:21:09'),('f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','2b4311b5-4b50-4d3f-90e1-74a91780e7d1','3206451985090005','Ratna Wijayanti','6281313747177','1985-09-14','P','Jl. Melati No. 89','04','05','Lebak Bulus','Cilandak','Jakarta Selatan','DKI Jakarta',-6.30890000,106.80450000,'menikah',2,'tidak_bekerja',0,'numpang','2026-04-07 21:21:07','2026-04-07 21:21:07');
/*!40000 ALTER TABLE `profil_masyarakat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profil_petugas`
--

DROP TABLE IF EXISTS `profil_petugas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `profil_petugas` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `nomor_telepon` varchar(15) NOT NULL,
  `alamat` text DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `profil_petugas_user_id_unique` (`user_id`),
  CONSTRAINT `profil_petugas_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profil_petugas`
--

LOCK TABLES `profil_petugas` WRITE;
/*!40000 ALTER TABLE `profil_petugas` DISABLE KEYS */;
INSERT INTO `profil_petugas` VALUES ('0f4661ca-b8fd-4282-8497-934450537b2b','4b2a3472-e542-4f87-9dfa-f15e6b691b7c','6281313747177','Sukajaya, Purbaratu, Tasikmalaya, Java, 46196, Indonesia',-7.33289396,108.27278847,'2026-04-10 07:14:33','2026-04-10 07:14:33'),('9c083721-dcc7-4a2a-a63d-66a8cb14b72d','c7974aa9-2822-40df-ae4b-e33fe410ce39','628996324041','Manggungsari, Tasikmalaya, Java, 46262, Indonesia',-7.21574233,108.18273783,'2026-04-08 11:56:22','2026-04-08 11:56:22');
/*!40000 ALTER TABLE `profil_petugas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qrcode_penerima`
--

DROP TABLE IF EXISTS `qrcode_penerima`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `qrcode_penerima` (
  `id` char(36) NOT NULL,
  `profil_masyarakat_id` char(36) NOT NULL,
  `token_qr` varchar(255) NOT NULL,
  `path_gambar_qr` varchar(255) DEFAULT NULL,
  `aktif` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `kedaluwarsa_pada` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `qrcode_penerima_profil_masyarakat_id_unique` (`profil_masyarakat_id`),
  UNIQUE KEY `qrcode_penerima_token_qr_unique` (`token_qr`),
  CONSTRAINT `qrcode_penerima_profil_masyarakat_id_foreign` FOREIGN KEY (`profil_masyarakat_id`) REFERENCES `profil_masyarakat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qrcode_penerima`
--

LOCK TABLES `qrcode_penerima` WRITE;
/*!40000 ALTER TABLE `qrcode_penerima` DISABLE KEYS */;
INSERT INTO `qrcode_penerima` VALUES ('187c25e1-26f3-4995-8761-8b24d3b62337','e2806a75-e656-4c96-9387-c366c4c633f8','48924071-d440-4de4-984e-9acab462c74d','qrcode/e2806a75-e656-4c96-9387-c366c4c633f8/qr_48924071-d440-4de4-984e-9acab462c74d.svg',1,'2026-04-14 07:29:01',NULL),('4c6e0129-be50-46cc-8703-d38756d1662f','322452f3-d9ca-4298-9651-571cfdaf2119','6ba8ed32-1d58-4de3-8605-9f3980b40cce','qrcode/322452f3-d9ca-4298-9651-571cfdaf2119/qr_6ba8ed32-1d58-4de3-8605-9f3980b40cce.svg',1,'2026-04-14 07:40:46',NULL),('72bb0603-4ac9-42a1-b669-212b60e8db22','81f492de-d1dd-4468-83bd-7e1318aa2789','68c2fdce-e694-422e-9f23-95a2ab8dc439','qrcode/81f492de-d1dd-4468-83bd-7e1318aa2789/qr_68c2fdce-e694-422e-9f23-95a2ab8dc439.svg',1,'2026-04-10 07:12:50',NULL),('9cee69aa-bc65-40b7-abf5-9fd9a87d26de','a9a31353-748a-4c7b-901a-7025950f7406','f29e980c-5660-4330-bf40-e3c1a54048aa','qrcode/a9a31353-748a-4c7b-901a-7025950f7406/qr_f29e980c-5660-4330-bf40-e3c1a54048aa.svg',1,'2026-04-10 07:20:49',NULL),('acfeace5-ea94-4875-b1a2-368e2150d857','e7b04126-c840-4d80-85ee-7abf3b40d600','fac2fe7e-bed3-4e62-a51d-bcb77f6ea3b4','qrcode/e7b04126-c840-4d80-85ee-7abf3b40d600/qr_fac2fe7e-bed3-4e62-a51d-bcb77f6ea3b4.svg',1,'2026-04-07 21:22:40',NULL),('c1121cc6-1bf8-4a71-b716-61760b61e9a6','566af246-f871-4fba-843d-d2aa5cc81ef8','92b11b51-a588-4211-b676-7d295ee6f019','qrcode/566af246-f871-4fba-843d-d2aa5cc81ef8/qr_92b11b51-a588-4211-b676-7d295ee6f019.svg',1,'2026-04-10 07:12:37',NULL),('cbf54479-774e-4aeb-8f01-213f2c7bf6d8','ba8912fa-fee8-4f64-9494-a45295096518','611898db-761b-4e13-b0bd-a897681b87a7','qrcode/ba8912fa-fee8-4f64-9494-a45295096518/qr_611898db-761b-4e13-b0bd-a897681b87a7.svg',1,'2026-04-08 15:16:39',NULL),('d617cc9d-d610-4c63-9ace-6114fb53a38c','b45fbfc1-33c7-49b2-aecf-32e457b7664d','f7038599-4865-422c-b3de-28b3bb1677e0','qrcode/b45fbfc1-33c7-49b2-aecf-32e457b7664d/qr_f7038599-4865-422c-b3de-28b3bb1677e0.svg',1,'2026-04-10 07:12:43',NULL),('e1f276a9-822f-4b6d-bb3d-59fdf0ccdb9c','f388cd67-6ab1-4478-b6ee-1a4e4f928d3d','00a289c0-d4d1-4478-ad91-d4091cb04381','qrcode/f388cd67-6ab1-4478-b6ee-1a4e4f928d3d/qr_00a289c0-d4d1-4478-ad91-d4091cb04381.svg',1,'2026-04-14 08:22:49',NULL),('edc64c34-3bd7-4df1-8384-c66dd7d34d0c','2b9ecd29-785b-40ca-aa4c-41f6c7eef77c','460609ea-7402-4265-a6fb-25998ec9168f','qrcode/2b9ecd29-785b-40ca-aa4c-41f6c7eef77c/qr_460609ea-7402-4265-a6fb-25998ec9168f.svg',1,'2026-04-08 14:48:47',NULL),('fd7867b4-9e03-45db-910e-277640867fea','2d3b0860-6498-4a99-9941-32184e6a6c81','8a3b247b-dcf8-4799-a868-fd50a752ad9f','qrcode/2d3b0860-6498-4a99-9941-32184e6a6c81/qr_8a3b247b-dcf8-4799-a868-fd50a752ad9f.svg',1,'2026-04-08 15:16:32',NULL);
/*!40000 ALTER TABLE `qrcode_penerima` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('4Dhauo4aFLbpAjo9iiVKP7LMg8wRglePtFncDeTF',NULL,'155.2.194.53','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTGpJQjJMdjlpTExTSGlDY01uMkhqRmF4OEhGTTcwM1FGT3FrY29HaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775923769),('4NBCBQGE9NtWiEIoG2oLDq1TMTCKmF3AnDFifJhF',NULL,'15.222.36.42','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoidDd6djlVQ2VpcHB5YUlHYnZDRFJaRzQ5TmdLYWZPN29IYzh6Uk1ZdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776080309),('5xXqkT1MpwSXQKwone81bCmBREUk2pzRtkTZVYUb',NULL,'204.76.203.25','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.3','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVUlnQ3lpRk1ySWszWUg2d1QzRnVzY3Z2cXI1U01ianhwdGdDVmpUbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775819993),('98hTV5H06t9GqnBBmRQjytosAkBelwNta0ofE9wN',NULL,'185.177.72.60','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoidGVqbW16V1hFeEFabHRaOVU0Y1hVSW82bVJXVDBYV21lRDJ6MnVmZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775804560),('9Zvbm2OLoJA59D2nejZfE9oxZynKAH6cud4rkzu5',NULL,'45.148.10.174','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUc3dXVVTEhESm5nYk9ySkhIWXJncFdWRmVETlpQdXViTmZDVkxOSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775982160),('B5ERNsEuflohiDBcCFr44HHSYNsIfVDIUSDaPNs0',NULL,'178.22.106.230','Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiQzBCSjJ5TE9iZHhLTTBidkVKY3ZjeEFoT2ZaaUx5c0FESzdTVmpzOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775880089),('BBzITAWmwaqH9kRg5bZMv0mJ8tzdiaz1wN3NfCah',NULL,'185.177.72.60','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZUI3RVRSMWM1UU10a0h6NXlqZFNJSk1rQThMRE41a0V6eHBWWTEyUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776009391),('D1dBhhyjmdwDQkTG9yuLFJcqK5ZJMR0ZWM7sHBqr',NULL,'45.148.10.231','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoielBwVnZiMzdHYjVQQVZLa3pqNE1rWklwTXhyMHhSeGxSWEdMdE5tWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776098263),('dBcrS70O4zHAGPnjI5EJhPTcdQ8jDppzyXfn7nNi',NULL,'66.132.172.184','Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)','YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVp0cTFaeHRoZlh6RjluTjVNS1lRU09ydHFhcFF3aXpaMmdCRElJciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775887374),('dssTjO3HJNIDxYb0CJqxnZYRkPbeUNH1Fikgxqfo',NULL,'34.79.222.226','Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)','YTozOntzOjY6Il90b2tlbiI7czo0MDoiOTFBeGR0U0xmMXRjeWRRQUFXZ2IwQzJtbFdLMXpJOFd6WFBiR3BCcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776103202),('e0HCmlnxARBWXfmYGKmCZfhfMg6RLgecQxNQGdWb',NULL,'23.27.145.138','Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiQW44dkZSZWtvdEc1OG9FYU5HTEZ1VVlWM3ZrT3ZrOTFBcjRqcEYzbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775894686),('f68Zh9iPK6uLDE2VBIwXZdXKlKpACgj6qc6uNxQC',NULL,'3.39.222.30','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiUEF1ZmloUWllVGNJSm5icGdHYzNZR0xWWlVlbHhuRWJRZEw4akZnMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775973310),('FdYCzo6tpVIcHrB69dEpbMZt7CJgplzldOe8l9X5',NULL,'93.123.109.232','Mozilla/5.0 (X11; FreeBSD i386; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25','YTozOntzOjY6Il90b2tlbiI7czo0MDoicUhBS0dkbVd0a2Q5YWVyOVU2UHFWMUdJQXNtMmpDNHNPMW5HYlViOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776053253),('Gtvb6woYs50UcTBrqW9aPgw1TnE8eeZgnJuJ0Yhx',NULL,'93.123.109.232','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiMHZjRGREc2NkY0FOQml1enVRbmlva2Z6Q1E0d28zVzBSNXVrWEZwNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775775515),('hfjnBBHZ7fiyG4sNuRrzlnbrtccS9mj2suCJIat3',NULL,'213.136.72.148','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiNWE3b1ZCbHdZaFRUOUVKenA4ZDVEYXdVMXIwT2pzZ2JGMThGSXlzOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776051462),('hp0xkPfqybMr4iMo8RLgzReHMKfUFSxSoFB5lD9L',NULL,'176.65.132.241','Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:133.0) Gecko/20100101 Firefox/133.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiRWFFWGVkZ3c4WnN4Z1k2M0V3UWdlbmFubWRBTlhLV0FOWFp6VkFXYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQvaW5kZXgucGhwIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1775972353),('i4ioLGAMe25UEAU5omMuvquiacS8NcauSyLp5gzA',NULL,'149.57.180.70','Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWG5xdmszWlYwVEF3U2RUTk5PcnBUWGMzNVZQZkw0NlM4WGpzU09GViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776153677),('isILAAZF2Cyob2vxiB3BGW6FeRdmDfXjwbR2Wkgb',NULL,'81.217.16.32','Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiY0hZUk9TbmpvbGNRMmFRa3AyRFZ0MGg2WVlQbkh0OEpTMjhDdGFGeCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775848767),('iTHlWZVHPE9WBVgVuUQEltoS5SvWI1o0Eia7IoGD',NULL,'84.32.70.55','Mozilla/5.0 (X11; Linux i686; rv:124.0) Gecko/20100101 Firefox/124.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTVE4czNVc2kyOThIdDB3czBXbk1OYkNiUDFCV0JteUhaMHVrNWRVSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775996544),('JrQw9TVfARFnPkPOPM7smLxp9PSRhVI9JgFNyt9e',NULL,'91.90.120.213','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoibldwMkZPZGJ4TUdtMmJZcDBrc280bnpsa0Z5RmR4Q09BOWwycWlrNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775914752),('K3yjxy2cNx7LVTBUbAZsG7x62Q0UpkIt4mW9FUWh',NULL,'81.217.16.32','Mozilla/5.0 (iPhone; CPU iPhone OS 17_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4.1 Mobile/15E148 Safari/604.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYTJ2SldDa0lGYkxMT1VDejIzS3l1SHBCTzhObTVCYTVaQUU0UzVLUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775757220),('k6c5uZspCL8t54UTM7KyIgPp9nKEG43OWETna2O2',NULL,'93.123.109.214','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVU1tNG11MG5KZHEwaWlRdXp0SVoxNVRFeWc0TkdMVTZCVDR1Ymh3VyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775754727),('KCsfFoJdVXz1B5qEWwlgihMzrZkFU8PZHjgRJIGH',NULL,'81.217.16.32','Mozilla/5.0 (iPhone; CPU iPhone OS 17_7_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Mobile/15E148 Safari/604.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiRW5DVHJLemlGcHI3Qm04czR1azluWlNiYmdtbUF6dk5XTEJYdE1xWiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775730191),('KsMF528K8oWlcWWij9HJxYmXdXQistXIOXGp1LnU',NULL,'178.22.106.230','Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Mobile Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUJiMnBmVFVGMHVEUU4xbVRlbzJESEhabzZJTnFmZWJtVDZ6aUpZZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775876818),('Lje1Dbgq9wnml4a14gqIS6d0ade90hIyeL7HpO98',NULL,'213.136.72.148','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWWFGSjVscVFDblo0bjh2bzE5d2lRQVI5UGhRU0ZlUVVjanZRZk9waCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776051463),('lzUSIUoLaNrkRvlRIHjGL8wNX93f4G5O5ekO4c9q',NULL,'34.31.214.46','Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)','YTozOntzOjY6Il90b2tlbiI7czo0MDoiSndMT1ZRWGc4NVNQOG1GZExNcjhFZ0R2b2dQNUxqNHhESFAwTmRObyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775753969),('Mm4KvmBLsvykIf1mpCxZbpC141wOJWR9OT03nQ9U',NULL,'44.197.109.186','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYU0ydmFKWm1DRTcyTkhyQlpMak1tN09xZTFORzJUMzR5MHRnRUZTQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776151603),('MS4Vni5EZDJRtaXgEJ3wYm0aMfTKUg5zglIBMTto',NULL,'23.27.145.78','Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ05qWGRINVVhRUhMRWpOdEd3Z3BianZSRGxGTkk5VHNCOVRIN05kYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775894509),('PhHuBC4e3CEwFGvpQC28TyLe6N7GQsxo6eESovYm',NULL,'93.123.109.214','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTXRnWnIwN0pzQ09QTUoxV3dudU10ZXk2ZlFacjU5SUFpOFBMVzZBcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776105430),('pVSTRMdcwuZIRggE82rP3jFIPsnmYI7tgxWaeYFc',NULL,'180.248.210.109','PostmanRuntime/7.51.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWXR3MWVYcFR1bHpKUThwMnA0azdVVmdPRjBEU0VIS3FuNGJCOHJRaSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775805400),('SJOELRwO4n8HvwSawZiG8SIQRGcwOA7EvEHbpSpc',NULL,'93.123.109.214','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZHdkMjNmNkRWeEV2TzBiWUcwbUx1UDB0SzJROWk0aUlhRU5OQkMxQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775845210),('v54iwt3vPOEFKrb7b8lQkd5hyEJRHFtN1i6p8z4W',NULL,'74.7.243.241','Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; GPTBot/1.3; +https://openai.com/gptbot)','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYzBQY3F2TTJQM3BlZkN1VWhoeE5iVTF3RE5Ic3QzVDByc0xzbkVHeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775893827),('WLU2batDpCn23bX2MWQ1iyW4FGhK7aJUpbLk0sfe',NULL,'136.115.10.175','Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZXVyS1RudUtsZnNWeTR3U2R0ejc4bVA0RFNkN0tiQlhrYmNTeDR6MSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775837459),('XDXgzsN2x7crr6MqOgHoaTrra6pinfTAxJZSVMDc',NULL,'207.154.219.105','Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiSkpKRHA5bGx6SGVMaDNoS0ZEcXE2cjY2aFBBRE1JZ044VHJJUldVdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1775788261),('ZiDZVdIgO7xWBE13pv69rm3SBrr6IKly2bsyl74B',NULL,'34.171.163.145','Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)','YTozOntzOjY6Il90b2tlbiI7czo0MDoibkV1b0t5VTVGbEk0YkQ5c1BRVm9lZ3dqSnAwQ3BackM0bTU1UmdtcyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHBzOi8vc2ltcGFuLWFwaS5jb3JlYXBwcy53ZWIuaWQiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1776001520);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `aktif` tinyint(1) NOT NULL DEFAULT 1,
  `role` enum('admin','petugas','masyarakat') NOT NULL DEFAULT 'masyarakat',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('01384c43-fc4c-40f2-8726-5f27f356feb2','Mushawwir Rahman','mushawwir.rahman@simpan.id',NULL,'$2y$12$ygDtX7Il/IL2ooPJrnrBDOJCF/bxCxv9Uge3hLcTlBE4GQTF.YhD6',1,'masyarakat',NULL,'2026-04-07 21:21:08','2026-04-07 21:21:08'),('0697ddc7-3697-4dfc-b6f3-abd0e2f24a13','Ahmad Wijaya','ahmad.wijaya@simpan.id',NULL,'$2y$12$CpsZzltQkrNF63PgzrsD8.BsnOY6LXeiOGMlcAiYJvXkyAdm2jPp.',1,'masyarakat',NULL,'2026-04-07 21:21:06','2026-04-07 21:21:06'),('27117cb7-92fb-49ef-850f-0bba447237b6','Super Admin','admin@simpan.id',NULL,'$2y$12$KzzdocDAYZ4TRc1RdrINE.TA.LTOJh/eb3wjLbtjQRG46LkNIGu8u',1,'admin',NULL,'2026-04-07 21:21:04','2026-04-07 21:21:04'),('2b4311b5-4b50-4d3f-90e1-74a91780e7d1','Ratna Wijayanti','ratna.wijayanti@simpan.id',NULL,'$2y$12$whGFW1u4g75XpDlnrSGA1OW6WsRfg9k3Kf6LqTDUr.2.bslrjJQOe',1,'masyarakat',NULL,'2026-04-07 21:21:07','2026-04-07 21:21:07'),('3f7ef7a5-2d7d-4fbc-b088-70ff0d6f9cdc','Susi Handayani','susi.handayani@simpan.id',NULL,'$2y$12$tTH4r5rks5q/HpSxXzl7F.2j2Wy7.qemh2BInSpljjzUzJMXsqkCO',1,'masyarakat',NULL,'2026-04-07 21:21:07','2026-04-07 21:21:07'),('4b2a3472-e542-4f87-9dfa-f15e6b691b7c','Petugas Zheka Baila Arkan','petugas.zheka@simpan.id',NULL,'$2y$12$U2B8yK7MkeL.Br0i9fTIUeBbhMwXYxCqGRx4ntC6YdyleXfbpJJOi',1,'petugas',NULL,'2026-04-10 07:14:33','2026-04-10 07:14:33'),('54e23f9e-43b2-4ecf-a2c0-ce8675c0cb74','M Fauzan Gumilang','fauzan@simpan.id',NULL,'$2y$12$oLsIT.l4jxsF76Ijqa0MGuShuVfsunQOPtI4kEKc1WV6cGHo.fZB.',1,'masyarakat',NULL,'2026-04-07 21:21:10','2026-04-07 21:21:10'),('59e05f13-7d2a-4994-8c89-48942ce5b62c','Budi Santoso','budi.santoso@simpan.id',NULL,'$2y$12$SJlNz9ubGuzxg9GzNswd2.FBYPYgK3Mu5IizxJfDeUu24sf/IWbB.',1,'masyarakat',NULL,'2026-04-07 21:21:05','2026-04-07 21:21:05'),('86241c1e-36db-4b6a-bfd4-f2ed2e5e801d','Shafa Rabbani Fityatul Mukarramah','shafarabbani@simpan.id',NULL,'$2y$12$I67cRKLh0DAsHTdI93vHJe5EuOZBa3W7RnCk9IB8Lxc6oyp6vctNG',1,'masyarakat',NULL,'2026-04-07 21:21:09','2026-04-07 21:21:09'),('8631d0fb-05b3-4a14-875a-a966dc11b989','Petugas 2','petugas2@simpan.id',NULL,'$2y$12$fyzZ/0PeuG5Me5lrWb2iv.YhV9L6jdZRzZsk6P6YoclBWN6L9//fO',1,'petugas',NULL,'2026-04-07 21:21:05','2026-04-07 21:21:05'),('93f42258-377a-46e2-8a9b-5adb0f20f242','Muhammad Fauzan Gemilang','fauzam80@gmail.com',NULL,'$2y$12$Uwy8BP.PYAx2HOpdCXvmPeQm1nddl/sUssnS8BynGXoEjAjc9rRxq',1,'masyarakat',NULL,'2026-04-08 14:28:04','2026-04-08 14:28:04'),('96a3da0d-8504-40b8-bdfa-6f7189000dbb','Petugas 1','petugas1@simpan.id',NULL,'$2y$12$Nbcw1Clz8YrHCxDK8uUKM.dYwjM1n2pEhQl9I2iy9KJoWftEZdi/e',1,'petugas',NULL,'2026-04-07 21:21:04','2026-04-07 21:21:04'),('9752e736-3dc3-40d5-b60c-36c931c86158','Zheka Baila Arkan','zhekabaila@simpan.id',NULL,'$2y$12$y80.r.GXictp1yJBIr4H7OYZmZVIzPLFRz7H7g4BMD0Y7g6graYZ.',1,'masyarakat',NULL,'2026-04-07 21:21:09','2026-04-07 21:21:09'),('ad5ad01d-01f7-4af7-ba2f-95e0f7fee947','Dewi Lestari','dewi.lestari@simpan.id',NULL,'$2y$12$y4O6zKffRm0K5n1YKvN9d.fuh13BswBcd8cKeM.oPyuZMF0uzLmwS',1,'masyarakat',NULL,'2026-04-07 21:21:06','2026-04-07 21:21:06'),('c6446680-002a-4c8b-8806-24ed63591ccf','Siti Nurhaliza','siti.nurhaliza@simpan.id',NULL,'$2y$12$lqHdyCsC9bZGiGeUX3rYfegGx/Qdqu4voPkwl9y3.u/HERkdLCjwi',1,'masyarakat',NULL,'2026-04-07 21:21:05','2026-04-07 21:21:05'),('c7974aa9-2822-40df-ae4b-e33fe410ce39','petugas.sapa.dari.admin','petugas.sapa.dari.admin@simpan.id',NULL,'$2y$12$c0QjV4tkiQjB7BQZwbELg.uxcmWvcOqsNqaeSplus9V765plmQBkK',1,'petugas',NULL,'2026-04-08 11:56:22','2026-04-08 11:56:22'),('e491f487-2765-4f81-95dc-9982aefb3fc7','Eka Prasetya','eka.prasetya@simpan.id',NULL,'$2y$12$NwE7EW2l0WEngVn3qn3o8.RisJDQFTxaXT/xWH/1QZCUxS7MISdDa',1,'masyarakat',NULL,'2026-04-07 21:21:07','2026-04-07 21:21:07'),('f4195244-68fb-4817-a85f-97e735ebe6a5','Linda Kusuma','linda.kusuma@simpan.id',NULL,'$2y$12$2gX8QUCbHMi82H3DgfDoPe2ypT6qtBTVBf5wvOTL64TwIf.wk279W',1,'masyarakat',NULL,'2026-04-07 21:21:09','2026-04-07 21:21:09'),('f5b5c922-6b15-4024-abb2-336d527f8c3e','Hendra Gunawan','hendra.gunawan@simpan.id',NULL,'$2y$12$4LnFnPCFrAmmf2wcRYS09.XCSz13wg.aBQ77A0g9AXzy8cH7o7lTu',1,'masyarakat',NULL,'2026-04-07 21:21:08','2026-04-07 21:21:08');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-14 20:13:55
