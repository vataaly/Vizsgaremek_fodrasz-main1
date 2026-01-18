-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1:3307
-- Létrehozás ideje: 2026. Jan 07. 11:10
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `fodrasz`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `stylist_id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `appointment_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` enum('booked','cancelled','completed') NOT NULL DEFAULT 'booked',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `services`
--

CREATE TABLE `services` (
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `duration_minutes` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `stylists`
--

CREATE TABLE `stylists` (
  `stylist_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `specialization` varchar(120) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `timeslots`
--

CREATE TABLE `timeslots` (
  `slot_id` bigint(20) UNSIGNED NOT NULL,
  `stylist_id` bigint(20) UNSIGNED NOT NULL,
  `slot_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 1
) ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD UNIQUE KEY `ux_appointments_stylist_start` (`stylist_id`,`appointment_date`,`start_time`),
  ADD KEY `idx_appointments_user_date` (`user_id`,`appointment_date`),
  ADD KEY `idx_appointments_stylist_date` (`stylist_id`,`appointment_date`),
  ADD KEY `idx_appointments_status` (`status`),
  ADD KEY `fk_appointments_service` (`service_id`);

--
-- A tábla indexei `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`service_id`);

--
-- A tábla indexei `stylists`
--
ALTER TABLE `stylists`
  ADD PRIMARY KEY (`stylist_id`),
  ADD UNIQUE KEY `ux_stylists_email` (`email`);

--
-- A tábla indexei `timeslots`
--
ALTER TABLE `timeslots`
  ADD PRIMARY KEY (`slot_id`),
  ADD UNIQUE KEY `ux_timeslots_stylist_start` (`stylist_id`,`slot_date`,`start_time`),
  ADD KEY `idx_timeslots_stylist_date` (`stylist_id`,`slot_date`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `ux_users_email` (`email`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `appointments`
--
ALTER TABLE `appointments`
  MODIFY `appointment_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `services`
--
ALTER TABLE `services`
  MODIFY `service_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `stylists`
--
ALTER TABLE `stylists`
  MODIFY `stylist_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `timeslots`
--
ALTER TABLE `timeslots`
  MODIFY `slot_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `fk_appointments_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appointments_stylist` FOREIGN KEY (`stylist_id`) REFERENCES `stylists` (`stylist_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appointments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Megkötések a táblához `timeslots`
--
ALTER TABLE `timeslots`
  ADD CONSTRAINT `fk_timeslots_stylist` FOREIGN KEY (`stylist_id`) REFERENCES `stylists` (`stylist_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
