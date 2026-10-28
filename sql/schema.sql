-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: movieticketbooking
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(100) NOT NULL,
  `admin_contact_no` varchar(15) DEFAULT NULL,
  `admin_role` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `show_id` int NOT NULL,
  `booking_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `seats_booked` int NOT NULL DEFAULT '1',
  `total_amount` decimal(10,2) NOT NULL,
  `booking_status` varchar(20) NOT NULL DEFAULT 'Confirmed',
  PRIMARY KEY (`booking_id`),
  KEY `customer_id` (`customer_id`),
  KEY `show_id` (`show_id`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`show_id`) REFERENCES `movie_show` (`show_id`),
  CONSTRAINT `booking_chk_1` CHECK ((`seats_booked` > 0)),
  CONSTRAINT `booking_chk_2` CHECK ((`total_amount` >= 0)),
  CONSTRAINT `booking_chk_3` CHECK ((`booking_status` in (_utf8mb4'Confirmed',_utf8mb4'Cancelled',_utf8mb4'Pending')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `booking_seat`
--

DROP TABLE IF EXISTS `booking_seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_seat` (
  `booking_seat_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `show_id` int NOT NULL,
  `seat_id` int NOT NULL,
  PRIMARY KEY (`booking_seat_id`),
  UNIQUE KEY `show_id` (`show_id`,`seat_id`),
  UNIQUE KEY `booking_id` (`booking_id`,`seat_id`),
  KEY `seat_id` (`seat_id`),
  CONSTRAINT `booking_seat_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`),
  CONSTRAINT `booking_seat_ibfk_2` FOREIGN KEY (`show_id`) REFERENCES `movie_show` (`show_id`),
  CONSTRAINT `booking_seat_ibfk_3` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`seat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `before_booking_seat_insert` BEFORE INSERT ON `booking_seat` FOR EACH ROW BEGIN
    DECLARE booking_show INT;
    DECLARE booking_screen INT;
    DECLARE seat_screen INT;

    SELECT show_id INTO booking_show
    FROM Booking
    WHERE booking_id = NEW.booking_id;

    SELECT screen_id INTO booking_screen
    FROM Movie_Show
    WHERE show_id = NEW.show_id;

    SELECT screen_id INTO seat_screen
    FROM Seat
    WHERE seat_id = NEW.seat_id;

    IF booking_show <> NEW.show_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Booking show_id does not match Booking_Seat show_id';
    END IF;

    IF booking_screen <> seat_screen THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Seat does not belong to the screen for this show';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(100) NOT NULL,
  `customer_address` varchar(255) DEFAULT NULL,
  `customer_contact` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `customer_contact` (`customer_contact`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie` (
  `movie_id` int NOT NULL AUTO_INCREMENT,
  `movie_title` varchar(150) NOT NULL,
  `movie_desc` text,
  `movie_stars` decimal(3,1) DEFAULT NULL,
  PRIMARY KEY (`movie_id`),
  CONSTRAINT `movie_chk_1` CHECK (((`movie_stars` is null) or ((`movie_stars` >= 0) and (`movie_stars` <= 10))))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movie_show`
--

DROP TABLE IF EXISTS `movie_show`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_show` (
  `show_id` int NOT NULL AUTO_INCREMENT,
  `admin_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `screen_id` int NOT NULL,
  `show_date` date NOT NULL,
  `show_time` time NOT NULL,
  PRIMARY KEY (`show_id`),
  UNIQUE KEY `screen_id` (`screen_id`,`show_date`,`show_time`),
  KEY `admin_id` (`admin_id`),
  KEY `movie_id` (`movie_id`),
  CONSTRAINT `movie_show_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`),
  CONSTRAINT `movie_show_ibfk_2` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`),
  CONSTRAINT `movie_show_ibfk_3` FOREIGN KEY (`screen_id`) REFERENCES `screen` (`screen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `screen`
--

DROP TABLE IF EXISTS `screen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screen` (
  `screen_id` int NOT NULL AUTO_INCREMENT,
  `theatre_id` int NOT NULL,
  `screen_no` int NOT NULL,
  `screen_name` varchar(100) DEFAULT NULL,
  `no_of_seats` int NOT NULL,
  PRIMARY KEY (`screen_id`),
  UNIQUE KEY `theatre_id` (`theatre_id`,`screen_no`),
  CONSTRAINT `screen_ibfk_1` FOREIGN KEY (`theatre_id`) REFERENCES `theatre` (`theatre_id`),
  CONSTRAINT `screen_chk_1` CHECK ((`no_of_seats` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seat`
--

DROP TABLE IF EXISTS `seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat` (
  `seat_id` int NOT NULL AUTO_INCREMENT,
  `screen_id` int NOT NULL,
  `seat_number` varchar(10) NOT NULL,
  `seat_type` varchar(20) NOT NULL DEFAULT 'Regular',
  PRIMARY KEY (`seat_id`),
  UNIQUE KEY `screen_id` (`screen_id`,`seat_number`),
  CONSTRAINT `seat_ibfk_1` FOREIGN KEY (`screen_id`) REFERENCES `screen` (`screen_id`),
  CONSTRAINT `seat_chk_1` CHECK ((`seat_type` in (_utf8mb4'Regular',_utf8mb4'Premium')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `theatre`
--

DROP TABLE IF EXISTS `theatre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `theatre` (
  `theatre_id` int NOT NULL AUTO_INCREMENT,
  `theatre_name` varchar(150) NOT NULL,
  `theatre_location` varchar(255) DEFAULT NULL,
  `theatre_city` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`theatre_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-28 20:56:39
