-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 23, 2019 at 06:58 PM
-- Server version: 10.3.16-MariaDB
-- PHP Version: 7.1.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bmf_scanner`
--

-- --------------------------------------------------------

--
-- Table structure for table `complain`
--

CREATE TABLE `complain` (
  `ID_complain` int(11) NOT NULL,
  `barcode` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `text_complain` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `barcode` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `productName` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `company` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `brand` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `imageP` varchar(200) COLLATE utf8_unicode_ci DEFAULT 'no_image.png',
  `status` int(11) NOT NULL DEFAULT 1,
  `no_complain` int(11) NOT NULL DEFAULT 0,
  `complain_text` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `barcode`, `productName`, `company`, `brand`, `imageP`, `status`, `no_complain`, `complain_text`) VALUES
(116, '9556086011900', 'Life Sos Cili', 'Region Food Industries 289447-T', 'Life', 'no_image.png', 1, 0, NULL),
(117, '9557690130346', 'Sos Tomato', 'Jalen Sdn. Bhd. 180398-P', 'Jalen', 'no_image.png', 1, 0, NULL),
(118, '9555490300402', 'Minyak masak', 'SIME DARBY OILS', 'Alif', 'no_image.png', 1, 0, NULL),
(120, '9556267100027', 'Sardin Dalam Sos Tomato', 'Pertima Terengganu Sdn. Bhd.', 'Pertima', 'no_image.png', 1, 0, NULL),
(121, '9555400907257', 'Sos Pencicah + Extra Bawang Putih & Cili', 'NORA FOOD PRODUCT', 'UMMINORA', 'no_image.png', 1, 0, NULL),
(122, '9556198188149', 'SARDIN', 'Marushin Canneries(M) Sdn Bhd', 'KING CUP', 'no_image.png', 1, 0, NULL),
(123, '9556051160169', 'Bes Perisa Pisang', 'Syarikat Salmi Hj Tamin Sdn. Bhd', 'Tamin', 'no_image.png', 1, 0, NULL),
(124, '9556231110045', 'Roti', 'Gardenia Bakeries (KL) Sdn. Bhd.', 'Gardenia', 'no_image.png', 1, 0, NULL),
(125, '9557404250018', 'Auntie Rosie Kaya', 'Gardenia Sales & Distribution Sdn. Bhd', 'Gardenia', 'no_image.png', 1, 0, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `complain`
--
ALTER TABLE `complain`
  ADD PRIMARY KEY (`ID_complain`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `complain`
--
ALTER TABLE `complain`
  MODIFY `ID_complain` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
