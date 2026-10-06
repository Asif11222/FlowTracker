-- FlowTracker local development sample
-- Generated: Tue Oct  6 01:13:32 AM CST 2026

SET FOREIGN_KEY_CHECKS=0;
SET UNIQUE_CHECKS=0;

-- ===============================================
-- COMPLETE DATABASE STRUCTURE
-- ===============================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `subject_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `event` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activities_subject_type_subject_id_index` (`subject_type`,`subject_id`),
  KEY `activities_user_id_foreign` (`user_id`),
  KEY `activities_created_at_index` (`created_at`),
  KEY `ft_activities_subject_created_idx` (`subject_type`,`subject_id`,`created_at`),
  CONSTRAINT `activities_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=42280 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bulk_order_import_rows`
--

DROP TABLE IF EXISTS `bulk_order_import_rows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulk_order_import_rows` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bulk_order_import_id` bigint unsigned NOT NULL,
  `source_row_number` int unsigned DEFAULT NULL,
  `source_row_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_order_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flow_job_id` bigint unsigned DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `payload` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bulk_order_import_rows_flow_job_id_foreign` (`flow_job_id`),
  KEY `bulk_order_import_rows_import_status_idx` (`bulk_order_import_id`,`status`),
  KEY `bulk_order_import_rows_source_idx` (`source_row_id`),
  KEY `bulk_order_import_rows_reference_idx` (`reference_order_no`),
  CONSTRAINT `bulk_order_import_rows_bulk_order_import_id_foreign` FOREIGN KEY (`bulk_order_import_id`) REFERENCES `bulk_order_imports` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bulk_order_import_rows_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bulk_order_imports`
--

DROP TABLE IF EXISTS `bulk_order_imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bulk_order_imports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL,
  `import_number` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `profile` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `default_client_id` bigint unsigned DEFAULT NULL,
  `default_supplier_id` bigint unsigned DEFAULT NULL,
  `duplicate_policy` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'skip',
  `original_filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_fingerprint` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_rows` int unsigned NOT NULL DEFAULT '0',
  `created_count` int unsigned NOT NULL DEFAULT '0',
  `updated_count` int unsigned NOT NULL DEFAULT '0',
  `skipped_count` int unsigned NOT NULL DEFAULT '0',
  `failed_count` int unsigned NOT NULL DEFAULT '0',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'processing',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bulk_order_imports_import_number_unique` (`import_number`),
  KEY `bulk_order_imports_user_id_foreign` (`user_id`),
  KEY `bulk_order_imports_default_client_id_foreign` (`default_client_id`),
  KEY `bulk_order_imports_default_supplier_id_foreign` (`default_supplier_id`),
  KEY `bulk_order_imports_workspace_created_idx` (`workspace_id`,`created_at`),
  CONSTRAINT `bulk_order_imports_default_client_id_foreign` FOREIGN KEY (`default_client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bulk_order_imports_default_supplier_id_foreign` FOREIGN KEY (`default_supplier_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bulk_order_imports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bulk_order_imports_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client_contacts`
--

DROP TABLE IF EXISTS `client_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_contacts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_contacts_client_id_is_primary_index` (`client_id`,`is_primary`),
  KEY `client_contacts_client_id_sort_order_index` (`client_id`,`sort_order`),
  KEY `client_contacts_email_index` (`email`),
  CONSTRAINT `client_contacts_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client_delivery_contacts`
--

DROP TABLE IF EXISTS `client_delivery_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_delivery_contacts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint unsigned NOT NULL,
  `contact_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_country_code` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_delivery_contacts_created_by_foreign` (`created_by`),
  KEY `client_delivery_contacts_lookup_index` (`client_id`,`contact_type`,`last_used_at`),
  KEY `client_delivery_contacts_name_index` (`client_id`,`contact_type`,`name`),
  CONSTRAINT `client_delivery_contacts_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `client_delivery_contacts_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client_shipping_addresses`
--

DROP TABLE IF EXISTS `client_shipping_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_shipping_addresses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint unsigned NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_line1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `suite` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'United States',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_shipping_addresses_client_id_sort_order_index` (`client_id`,`sort_order`),
  CONSTRAINT `client_shipping_addresses_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `legal_business_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_address_line1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_suite` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_city` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_state` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `office_zip` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_same_as_office` tinyint(1) NOT NULL DEFAULT '1',
  `billing_recipient` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_address_line1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_suite` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_city` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_state` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_zip` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_country` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ein_tax_id` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sales_tax_status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'taxable',
  `payment_terms` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `po_required` tinyint(1) NOT NULL DEFAULT '0',
  `contact_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_job_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_manager_id` bigint unsigned DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `preferred_language` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'English',
  `preferred_currency` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `outstanding_balance` decimal(14,2) NOT NULL DEFAULT '0.00',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `archived_at` timestamp NULL DEFAULT NULL,
  `archived_by` bigint unsigned DEFAULT NULL,
  `purged_at` timestamp NULL DEFAULT NULL,
  `purged_by` bigint unsigned DEFAULT NULL,
  `is_draft` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clients_code_unique` (`code`),
  KEY `clients_is_active_name_index` (`is_active`,`name`),
  KEY `ft_clients_active_country_name_idx` (`is_active`,`country`,`name`),
  KEY `ft_clients_manager_active_name_idx` (`account_manager_id`,`is_active`,`name`),
  KEY `clients_archived_by_foreign` (`archived_by`),
  KEY `clients_purged_by_foreign` (`purged_by`),
  KEY `clients_archive_lookup_idx` (`is_active`,`purged_at`,`archived_at`),
  KEY `clients_creator_status_idx` (`created_by`,`is_active`),
  KEY `ft_clients_active_archived_name_idx` (`is_active`,`archived_at`,`name`),
  CONSTRAINT `clients_account_manager_id_foreign` FOREIGN KEY (`account_manager_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `clients_archived_by_foreign` FOREIGN KEY (`archived_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `clients_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `clients_purged_by_foreign` FOREIGN KEY (`purged_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `collection_updates`
--

DROP TABLE IF EXISTS `collection_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection_updates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_collection_id` bigint unsigned NOT NULL,
  `actor_id` bigint unsigned DEFAULT NULL,
  `follow_up_date` date DEFAULT NULL,
  `next_follow_up_at` date DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'update',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `collection_updates_actor_id_foreign` (`actor_id`),
  KEY `collection_updates_flow_job_collection_id_created_at_index` (`flow_job_collection_id`,`created_at`),
  CONSTRAINT `collection_updates_actor_id_foreign` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `collection_updates_flow_job_collection_id_foreign` FOREIGN KEY (`flow_job_collection_id`) REFERENCES `flow_job_collections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `departments_code_unique` (`code`),
  UNIQUE KEY `departments_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `document_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `flow_job_id` bigint unsigned DEFAULT NULL,
  `client_id` bigint unsigned DEFAULT NULL,
  `task_id` bigint unsigned DEFAULT NULL,
  `uploaded_by` bigint unsigned DEFAULT NULL,
  `category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mime_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` bigint unsigned NOT NULL DEFAULT '0',
  `version` smallint unsigned NOT NULL DEFAULT '1',
  `is_final` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `documents_document_number_unique` (`document_number`),
  KEY `documents_uploaded_by_foreign` (`uploaded_by`),
  KEY `documents_flow_job_id_category_index` (`flow_job_id`,`category`),
  KEY `ft_documents_task_category_version_idx` (`task_id`,`category`,`name`,`version`),
  KEY `ft_docs_client_updated_idx` (`client_id`,`updated_at`),
  KEY `ft_docs_job_updated_idx` (`flow_job_id`,`updated_at`),
  KEY `ft_docs_task_updated_idx` (`task_id`,`updated_at`),
  CONSTRAINT `documents_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
  CONSTRAINT `documents_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `documents_task_id_foreign` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `documents_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3144 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_job_collections`
--

DROP TABLE IF EXISTS `flow_job_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_job_collections` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `collection_owner_id` bigint unsigned DEFAULT NULL,
  `last_follow_up_at` date DEFAULT NULL,
  `next_follow_up_at` date DEFAULT NULL,
  `latest_note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `flow_job_collections_flow_job_id_unique` (`flow_job_id`),
  KEY `flow_job_collections_collection_owner_id_next_follow_up_at_index` (`collection_owner_id`,`next_follow_up_at`),
  CONSTRAINT `flow_job_collections_collection_owner_id_foreign` FOREIGN KEY (`collection_owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_job_collections_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_job_inquiries`
--

DROP TABLE IF EXISTS `flow_job_inquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_job_inquiries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `inquiry_id` bigint unsigned NOT NULL,
  `linked_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `flow_job_inquiries_inquiry_unique` (`inquiry_id`),
  UNIQUE KEY `flow_job_inquiries_pair_unique` (`flow_job_id`,`inquiry_id`),
  KEY `flow_job_inquiries_linked_by_foreign` (`linked_by`),
  KEY `flow_job_inquiries_order_created_idx` (`flow_job_id`,`created_at`),
  CONSTRAINT `flow_job_inquiries_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_job_inquiries_inquiry_id_foreign` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_job_inquiries_linked_by_foreign` FOREIGN KEY (`linked_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_job_items`
--

DROP TABLE IF EXISTS `flow_job_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_job_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `catalog_product_id` bigint unsigned DEFAULT NULL,
  `supplier_id` bigint unsigned DEFAULT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `unit_price` decimal(14,2) NOT NULL DEFAULT '0.00',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `is_removed` tinyint(1) NOT NULL DEFAULT '0',
  `removed_at` timestamp NULL DEFAULT NULL,
  `removed_by` bigint unsigned DEFAULT NULL,
  `removal_reason` text COLLATE utf8mb4_unicode_ci,
  `updated_by` bigint unsigned DEFAULT NULL,
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flow_job_items_flow_job_id_sort_order_index` (`flow_job_id`,`sort_order`),
  KEY `flow_job_items_updated_by_foreign` (`updated_by`),
  KEY `flow_job_items_catalog_product_id_foreign` (`catalog_product_id`),
  KEY `flow_job_items_supplier_id_foreign` (`supplier_id`),
  KEY `flow_job_items_active_sort_idx` (`flow_job_id`,`is_removed`,`sort_order`),
  KEY `flow_job_items_removed_by_foreign` (`removed_by`),
  CONSTRAINT `flow_job_items_catalog_product_id_foreign` FOREIGN KEY (`catalog_product_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_job_items_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_job_items_removed_by_foreign` FOREIGN KEY (`removed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_job_items_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_job_items_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1820 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_job_members`
--

DROP TABLE IF EXISTS `flow_job_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_job_members` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `access_level` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'member',
  `can_manage_tasks` tinyint(1) NOT NULL DEFAULT '0',
  `can_upload_documents` tinyint(1) NOT NULL DEFAULT '1',
  `can_view_financials` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `flow_job_members_flow_job_id_user_id_unique` (`flow_job_id`,`user_id`),
  KEY `ft_job_members_user_job_idx` (`user_id`,`flow_job_id`),
  CONSTRAINT `flow_job_members_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_job_members_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20601 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_job_phase_histories`
--

DROP TABLE IF EXISTS `flow_job_phase_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_job_phase_histories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `workflow_phase_id` bigint unsigned NOT NULL,
  `changed_by` bigint unsigned DEFAULT NULL,
  `phase_owner_id` bigint unsigned DEFAULT NULL,
  `target_date` date DEFAULT NULL,
  `health_override` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `entered_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flow_job_phase_histories_workflow_phase_id_foreign` (`workflow_phase_id`),
  KEY `flow_job_phase_histories_changed_by_foreign` (`changed_by`),
  KEY `flow_job_phase_histories_phase_owner_id_foreign` (`phase_owner_id`),
  KEY `fjph_job_phase_entered_idx` (`flow_job_id`,`workflow_phase_id`,`entered_at`),
  CONSTRAINT `flow_job_phase_histories_changed_by_foreign` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_job_phase_histories_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_job_phase_histories_phase_owner_id_foreign` FOREIGN KEY (`phase_owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_job_phase_histories_workflow_phase_id_foreign` FOREIGN KEY (`workflow_phase_id`) REFERENCES `workflow_phases` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3568 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_jobs`
--

DROP TABLE IF EXISTS `flow_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `job_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `received_date` date DEFAULT NULL,
  `supplier_id` bigint unsigned DEFAULT NULL,
  `warehouse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supplier_instruction` text COLLATE utf8mb4_unicode_ci,
  `source_row_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `import_profile` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bulk_import_id` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_id` bigint unsigned DEFAULT NULL,
  `workflow_id` bigint unsigned NOT NULL,
  `workflow_phase_id` bigint unsigned NOT NULL,
  `started_from_phase_id` bigint unsigned DEFAULT NULL,
  `owner_id` bigint unsigned DEFAULT NULL,
  `coordinator_id` bigint unsigned DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `product` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '0',
  `commercial_value` decimal(14,2) NOT NULL DEFAULT '0.00',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'New',
  `health` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'On Track',
  `priority` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Medium',
  `production_urgency_ids` json DEFAULT NULL,
  `shipment_urgency_ids` json DEFAULT NULL,
  `allow_multiple_shipments` tinyint(1) NOT NULL DEFAULT '0',
  `shipment_address_mode` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'same_address',
  `progress` tinyint unsigned NOT NULL DEFAULT '0',
  `delivery_date` date DEFAULT NULL,
  `estimated_delivery_date` date DEFAULT NULL,
  `supplier_delivery_date` date DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `shipping_address` text COLLATE utf8mb4_unicode_ci,
  `shipping_contact_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_contact_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_phone_country_code` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_phone` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_postal_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_source_address_id` bigint unsigned DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `next_action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_handling` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `needs_attention` tinyint(1) NOT NULL DEFAULT '0',
  `attention_requested` tinyint(1) NOT NULL DEFAULT '0',
  `attention_reason` text COLLATE utf8mb4_unicode_ci,
  `attention_by` bigint unsigned DEFAULT NULL,
  `attention_at` timestamp NULL DEFAULT NULL,
  `order_flag_id` bigint unsigned DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `source_workflow_id` bigint unsigned DEFAULT NULL,
  `source_workflow_phase_id` bigint unsigned DEFAULT NULL,
  `source_inquiry_id` bigint unsigned DEFAULT NULL,
  `is_repeat_order` tinyint(1) NOT NULL DEFAULT '0',
  `repeat_order_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cancellation_reason` text COLLATE utf8mb4_unicode_ci,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `cancelled_by` bigint unsigned DEFAULT NULL,
  `shipment_method_ids` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `flow_jobs_job_number_unique` (`job_number`),
  UNIQUE KEY `flow_jobs_source_inquiry_unique` (`source_inquiry_id`),
  UNIQUE KEY `flow_jobs_source_row_id_uq` (`source_row_id`),
  KEY `flow_jobs_started_from_phase_id_foreign` (`started_from_phase_id`),
  KEY `flow_jobs_workflow_phase_id_status_index` (`workflow_phase_id`,`status`),
  KEY `flow_jobs_coordinator_id_status_index` (`coordinator_id`,`status`),
  KEY `flow_jobs_client_id_created_at_index` (`client_id`,`created_at`),
  KEY `flow_jobs_needs_attention_completed_at_index` (`needs_attention`,`completed_at`),
  KEY `ft_jobs_active_delivery_idx` (`deleted_at`,`completed_at`,`status`,`delivery_date`),
  KEY `ft_jobs_owner_active_idx` (`owner_id`,`deleted_at`,`completed_at`,`status`),
  KEY `ft_jobs_client_active_idx` (`client_id`,`deleted_at`,`completed_at`,`status`),
  KEY `ft_jobs_workflow_phase_active_idx` (`workflow_id`,`workflow_phase_id`,`deleted_at`,`completed_at`),
  KEY `ft_jobs_open_delivery_idx` (`deleted_at`,`completed_at`,`delivery_date`),
  KEY `flow_jobs_source_workflow_idx` (`source_workflow_id`,`source_workflow_phase_id`,`deleted_at`),
  KEY `ft_orders_list_created_idx` (`deleted_at`,`status`,`created_at`,`id`),
  KEY `flow_jobs_order_number_idx` (`order_number`),
  KEY `flow_jobs_supplier_id_foreign` (`supplier_id`),
  KEY `flow_jobs_bulk_import_id_idx` (`bulk_import_id`),
  KEY `flow_jobs_creator_deleted_idx` (`created_by`,`deleted_at`),
  KEY `flow_jobs_repeat_order_idx` (`is_repeat_order`,`repeat_order_number`),
  KEY `flow_jobs_order_flag_attention_idx` (`order_flag_id`,`needs_attention`),
  KEY `flow_jobs_attention_by_foreign` (`attention_by`),
  KEY `flow_jobs_attention_requested_index` (`attention_requested`),
  KEY `flow_jobs_shipping_source_address_id_foreign` (`shipping_source_address_id`),
  KEY `flow_jobs_cancelled_by_foreign` (`cancelled_by`),
  KEY `ft_jobs_owner_open_due_idx` (`owner_id`,`deleted_at`,`completed_at`,`delivery_date`),
  KEY `ft_jobs_phase_open_idx` (`workflow_phase_id`,`deleted_at`,`completed_at`,`id`),
  KEY `ft_jobs_attention_updated_idx` (`attention_requested`,`completed_at`,`updated_at`),
  KEY `ft_jobs_source_phase_open_created_idx` (`source_workflow_phase_id`,`deleted_at`,`completed_at`,`created_at`,`id`),
  KEY `ft_jobs_source_phase_open_updated_idx` (`source_workflow_phase_id`,`deleted_at`,`completed_at`,`updated_at`,`id`),
  KEY `ft_jobs_phase_open_updated_idx` (`workflow_phase_id`,`deleted_at`,`completed_at`,`updated_at`,`id`),
  CONSTRAINT `flow_jobs_attention_by_foreign` FOREIGN KEY (`attention_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_cancelled_by_foreign` FOREIGN KEY (`cancelled_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `flow_jobs_coordinator_id_foreign` FOREIGN KEY (`coordinator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_order_flag_id_foreign` FOREIGN KEY (`order_flag_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_shipping_source_address_id_foreign` FOREIGN KEY (`shipping_source_address_id`) REFERENCES `client_shipping_addresses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_source_inquiry_id_foreign` FOREIGN KEY (`source_inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_started_from_phase_id_foreign` FOREIGN KEY (`started_from_phase_id`) REFERENCES `workflow_phases` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_jobs_workflow_id_foreign` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `flow_jobs_workflow_phase_id_foreign` FOREIGN KEY (`workflow_phase_id`) REFERENCES `workflow_phases` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=1721 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_notifications`
--

DROP TABLE IF EXISTS `flow_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `actor_id` bigint unsigned DEFAULT NULL,
  `flow_job_id` bigint unsigned DEFAULT NULL,
  `flow_task_id` bigint unsigned DEFAULT NULL,
  `inquiry_id` bigint unsigned DEFAULT NULL,
  `inquiry_task_id` bigint unsigned DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'info',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flow_notifications_flow_job_id_foreign` (`flow_job_id`),
  KEY `flow_notifications_user_id_read_at_index` (`user_id`,`read_at`),
  KEY `flow_notifications_flow_task_id_foreign` (`flow_task_id`),
  KEY `ft_notifications_user_task_read_idx` (`user_id`,`flow_task_id`,`read_at`),
  KEY `ft_notifications_user_read_created_idx` (`user_id`,`read_at`,`created_at`),
  KEY `ft_notifications_my_work_mentions_idx` (`user_id`,`type`,`flow_task_id`),
  KEY `flow_notifications_inquiry_id_foreign` (`inquiry_id`),
  KEY `flow_notifications_inquiry_task_id_foreign` (`inquiry_task_id`),
  KEY `flow_notifications_inquiry_user_idx` (`user_id`,`inquiry_id`,`read_at`),
  KEY `ft_notifications_my_work_job_mentions_idx` (`user_id`,`type`,`flow_job_id`),
  KEY `flow_notifications_actor_id_foreign` (`actor_id`),
  CONSTRAINT `flow_notifications_actor_id_foreign` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `flow_notifications_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_notifications_flow_task_id_foreign` FOREIGN KEY (`flow_task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_notifications_inquiry_id_foreign` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_notifications_inquiry_task_id_foreign` FOREIGN KEY (`inquiry_task_id`) REFERENCES `inquiry_tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=97045 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_task_checklist_items`
--

DROP TABLE IF EXISTS `flow_task_checklist_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_task_checklist_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_task_id` bigint unsigned NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_completed` tinyint(1) NOT NULL DEFAULT '0',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flow_task_checklist_items_flow_task_id_sort_order_index` (`flow_task_id`,`sort_order`),
  CONSTRAINT `flow_task_checklist_items_flow_task_id_foreign` FOREIGN KEY (`flow_task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flow_task_comments`
--

DROP TABLE IF EXISTS `flow_task_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_task_comments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_task_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flow_task_comments_user_id_foreign` (`user_id`),
  KEY `flow_task_comments_flow_task_id_created_at_index` (`flow_task_id`,`created_at`),
  CONSTRAINT `flow_task_comments_flow_task_id_foreign` FOREIGN KEY (`flow_task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `flow_task_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=41512 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiries`
--

DROP TABLE IF EXISTS `inquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL DEFAULT '1',
  `inquiry_number` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `client_id` bigint unsigned NOT NULL,
  `owner_id` bigint unsigned DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `source_task_pack_id` bigint unsigned DEFAULT NULL,
  `source_workflow_template_id` bigint unsigned DEFAULT NULL,
  `reference_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_contact` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `received_date` date NOT NULL,
  `request_source` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requirement_notes` text COLLATE utf8mb4_unicode_ci,
  `target_price` decimal(14,4) DEFAULT NULL,
  `currency` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `required_delivery_date` date DEFAULT NULL,
  `priority` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Medium',
  `initial_follow_up_date` date DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'In Progress',
  `needs_attention` tinyint(1) NOT NULL DEFAULT '0',
  `attention_reason` text COLLATE utf8mb4_unicode_ci,
  `attention_by` bigint unsigned DEFAULT NULL,
  `attention_at` timestamp NULL DEFAULT NULL,
  `started_at` timestamp NULL DEFAULT NULL,
  `result` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dead_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dead_note` text COLLATE utf8mb4_unicode_ci,
  `converted_job_id` bigint unsigned DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inquiries_inquiry_number_unique` (`inquiry_number`),
  KEY `inquiries_created_by_foreign` (`created_by`),
  KEY `inquiries_source_task_pack_id_foreign` (`source_task_pack_id`),
  KEY `inquiries_converted_job_id_foreign` (`converted_job_id`),
  KEY `inquiries_workspace_status_updated_idx` (`workspace_id`,`status`,`updated_at`),
  KEY `inquiries_owner_status_due_idx` (`owner_id`,`status`,`required_delivery_date`),
  KEY `inquiries_client_created_idx` (`client_id`,`created_at`),
  KEY `inquiries_source_workflow_template_id_foreign` (`source_workflow_template_id`),
  KEY `inquiries_started_at_index` (`started_at`),
  KEY `inquiries_attention_by_foreign` (`attention_by`),
  KEY `inquiries_needs_attention_index` (`needs_attention`),
  KEY `ft_inquiries_workspace_open_updated_idx` (`workspace_id`,`deleted_at`,`completed_at`,`updated_at`),
  KEY `ft_inquiries_owner_open_idx` (`workspace_id`,`owner_id`,`deleted_at`,`completed_at`),
  KEY `ft_inquiries_client_updated_idx` (`workspace_id`,`client_id`,`deleted_at`,`updated_at`),
  CONSTRAINT `inquiries_attention_by_foreign` FOREIGN KEY (`attention_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiries_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `inquiries_converted_job_id_foreign` FOREIGN KEY (`converted_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiries_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiries_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiries_source_task_pack_id_foreign` FOREIGN KEY (`source_task_pack_id`) REFERENCES `task_packs` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiries_source_workflow_template_id_foreign` FOREIGN KEY (`source_workflow_template_id`) REFERENCES `workflow_templates` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=540 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_documents`
--

DROP TABLE IF EXISTS `inquiry_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_documents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inquiry_id` bigint unsigned NOT NULL,
  `inquiry_task_id` bigint unsigned DEFAULT NULL,
  `uploaded_by` bigint unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mime_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` bigint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `inquiry_documents_uploaded_by_foreign` (`uploaded_by`),
  KEY `inquiry_documents_parent_created_idx` (`inquiry_id`,`created_at`),
  KEY `inquiry_documents_task_created_idx` (`inquiry_task_id`,`created_at`),
  KEY `ft_inquiry_documents_parent_updated_idx` (`inquiry_id`,`updated_at`),
  CONSTRAINT `inquiry_documents_inquiry_id_foreign` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inquiry_documents_inquiry_task_id_foreign` FOREIGN KEY (`inquiry_task_id`) REFERENCES `inquiry_tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inquiry_documents_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2406 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_items`
--

DROP TABLE IF EXISTS `inquiry_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inquiry_id` bigint unsigned NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` decimal(14,2) NOT NULL DEFAULT '1.00',
  `unit_price` decimal(14,2) DEFAULT NULL,
  `unit` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pcs',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inquiry_items_inquiry_id_sort_order_index` (`inquiry_id`,`sort_order`),
  CONSTRAINT `inquiry_items_inquiry_id_foreign` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_rfq_invitations`
--

DROP TABLE IF EXISTS `inquiry_rfq_invitations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_rfq_invitations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL,
  `inquiry_id` bigint unsigned NOT NULL,
  `supplier_id` bigint unsigned NOT NULL,
  `invited_by` bigint unsigned DEFAULT NULL,
  `token_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token_cipher` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `invited_at` datetime DEFAULT NULL,
  `due_at` datetime DEFAULT NULL,
  `request_message` text COLLATE utf8mb4_unicode_ci,
  `email_status` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `email_tracking_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reminder_sent_at` datetime DEFAULT NULL,
  `interest_status` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `interest_at` datetime DEFAULT NULL,
  `quote_status` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `quote_submitted_at` datetime DEFAULT NULL,
  `awarded_at` datetime DEFAULT NULL,
  `rejected_at` datetime DEFAULT NULL,
  `rejection_notified_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `supplier_details` text COLLATE utf8mb4_unicode_ci,
  `link_expires_at` datetime DEFAULT NULL,
  `auto_reply_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `reminder_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `reminder_hours_before_due` smallint unsigned NOT NULL DEFAULT '24',
  `allow_revision` tinyint(1) NOT NULL DEFAULT '1',
  `award_email_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `not_selected_email_enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `inq_rfq_invitation_supplier_unique` (`inquiry_id`,`supplier_id`),
  UNIQUE KEY `inquiry_rfq_invitations_token_hash_unique` (`token_hash`),
  KEY `inquiry_rfq_invitations_supplier_id_foreign` (`supplier_id`),
  KEY `inquiry_rfq_invitations_invited_by_foreign` (`invited_by`),
  KEY `inq_rfq_quote_status_idx` (`inquiry_id`,`quote_status`),
  KEY `inquiry_rfq_invitations_workspace_id_index` (`workspace_id`),
  KEY `inquiry_rfq_invitations_due_at_index` (`due_at`),
  KEY `inquiry_rfq_invitations_link_expires_at_index` (`link_expires_at`),
  CONSTRAINT `inquiry_rfq_invitations_inquiry_id_foreign` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inquiry_rfq_invitations_invited_by_foreign` FOREIGN KEY (`invited_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiry_rfq_invitations_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `master_records` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_rfq_quote_documents`
--

DROP TABLE IF EXISTS `inquiry_rfq_quote_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_rfq_quote_documents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `quote_id` bigint unsigned NOT NULL,
  `document_type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mime_type` varchar(160) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` bigint unsigned NOT NULL DEFAULT '0',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inq_rfq_quote_docs_type_idx` (`quote_id`,`document_type`),
  KEY `inq_rfq_quote_docs_sort_idx` (`quote_id`,`sort_order`),
  CONSTRAINT `inquiry_rfq_quote_documents_quote_id_foreign` FOREIGN KEY (`quote_id`) REFERENCES `inquiry_rfq_quotes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_rfq_quote_items`
--

DROP TABLE IF EXISTS `inquiry_rfq_quote_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_rfq_quote_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `quote_id` bigint unsigned NOT NULL,
  `inquiry_item_id` bigint unsigned DEFAULT NULL,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` decimal(14,2) NOT NULL DEFAULT '1.00',
  `unit_price` decimal(14,4) NOT NULL DEFAULT '0.0000',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `moq` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inquiry_rfq_quote_items_inquiry_item_id_foreign` (`inquiry_item_id`),
  KEY `inq_rfq_quote_items_sort_idx` (`quote_id`,`sort_order`),
  CONSTRAINT `inquiry_rfq_quote_items_inquiry_item_id_foreign` FOREIGN KEY (`inquiry_item_id`) REFERENCES `inquiry_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiry_rfq_quote_items_quote_id_foreign` FOREIGN KEY (`quote_id`) REFERENCES `inquiry_rfq_quotes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_rfq_quotes`
--

DROP TABLE IF EXISTS `inquiry_rfq_quotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_rfq_quotes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invitation_id` bigint unsigned NOT NULL,
  `currency` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `freight` decimal(14,2) NOT NULL DEFAULT '0.00',
  `lead_time_days` int unsigned DEFAULT NULL,
  `validity_days` int unsigned DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `submitted_total` decimal(14,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `supplier_contact_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supplier_contact_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supplier_contact_phone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tooling_cost` decimal(14,2) NOT NULL DEFAULT '0.00',
  `sample_cost` decimal(14,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `tax_status` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'excluded',
  `sample_lead_time_days` int unsigned DEFAULT NULL,
  `incoterm` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_port` varchar(160) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estimated_delivery_date` date DEFAULT NULL,
  `specification_compliance` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supporting_information` json DEFAULT NULL,
  `document_notes` text COLLATE utf8mb4_unicode_ci,
  `submitted_by_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `submitted_by_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inquiry_rfq_quotes_invitation_id_unique` (`invitation_id`),
  CONSTRAINT `inquiry_rfq_quotes_invitation_id_foreign` FOREIGN KEY (`invitation_id`) REFERENCES `inquiry_rfq_invitations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_rfq_settings`
--

DROP TABLE IF EXISTS `inquiry_rfq_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_rfq_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL,
  `inquiry_id` bigint unsigned NOT NULL,
  `special_note` text COLLATE utf8mb4_unicode_ci,
  `supplier_details` text COLLATE utf8mb4_unicode_ci,
  `default_due_at` datetime DEFAULT NULL,
  `link_validity_hours` smallint unsigned NOT NULL DEFAULT '720',
  `auto_reply_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `reminder_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `reminder_hours_before_due` smallint unsigned NOT NULL DEFAULT '24',
  `allow_revision` tinyint(1) NOT NULL DEFAULT '1',
  `award_email_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `not_selected_email_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `updated_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inquiry_rfq_settings_inquiry_id_unique` (`inquiry_id`),
  KEY `inquiry_rfq_settings_workspace_id_foreign` (`workspace_id`),
  KEY `inquiry_rfq_settings_updated_by_foreign` (`updated_by`),
  CONSTRAINT `inquiry_rfq_settings_inquiry_id_foreign` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inquiry_rfq_settings_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiry_rfq_settings_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_task_comments`
--

DROP TABLE IF EXISTS `inquiry_task_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_task_comments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inquiry_task_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inquiry_task_comments_user_id_foreign` (`user_id`),
  KEY `inquiry_task_comments_task_created_idx` (`inquiry_task_id`,`created_at`),
  CONSTRAINT `inquiry_task_comments_inquiry_task_id_foreign` FOREIGN KEY (`inquiry_task_id`) REFERENCES `inquiry_tasks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inquiry_task_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_task_links`
--

DROP TABLE IF EXISTS `inquiry_task_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_task_links` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inquiry_task_id` bigint unsigned NOT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inquiry_task_links_created_by_foreign` (`created_by`),
  KEY `inquiry_task_links_task_created_idx` (`inquiry_task_id`,`created_at`),
  CONSTRAINT `inquiry_task_links_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiry_task_links_inquiry_task_id_foreign` FOREIGN KEY (`inquiry_task_id`) REFERENCES `inquiry_tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inquiry_tasks`
--

DROP TABLE IF EXISTS `inquiry_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiry_tasks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inquiry_id` bigint unsigned NOT NULL,
  `source_task_pack_item_id` bigint unsigned DEFAULT NULL,
  `source_workflow_phase_id` bigint unsigned DEFAULT NULL,
  `assignee_id` bigint unsigned DEFAULT NULL,
  `assignee_assigned_at` timestamp NULL DEFAULT NULL,
  `assignee_at_completion` bigint unsigned DEFAULT NULL,
  `assignee_assigned_at_completion` timestamp NULL DEFAULT NULL,
  `setup_assignee_id` bigint unsigned DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sequence` int unsigned NOT NULL DEFAULT '1',
  `due_date` date DEFAULT NULL,
  `status` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Waiting',
  `inquiry_task_status_id` bigint unsigned DEFAULT NULL,
  `needs_attention` tinyint(1) NOT NULL DEFAULT '0',
  `attention_reason` text COLLATE utf8mb4_unicode_ci,
  `started_at` timestamp NULL DEFAULT NULL,
  `requires_submission` tinyint(1) NOT NULL DEFAULT '0',
  `submission_label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inquiry_tasks_sequence_uq` (`inquiry_id`,`sequence`),
  KEY `inquiry_tasks_assignee_open_due_idx` (`assignee_id`,`completed_at`,`due_date`),
  KEY `inquiry_tasks_parent_open_sequence_idx` (`inquiry_id`,`completed_at`,`sequence`),
  KEY `inquiry_tasks_setup_assignee_id_foreign` (`setup_assignee_id`),
  KEY `inq_tasks_setup_assignee_idx` (`source_task_pack_item_id`,`setup_assignee_id`),
  KEY `inquiry_tasks_inquiry_task_status_id_foreign` (`inquiry_task_status_id`),
  KEY `inq_tasks_source_phase_open_idx` (`inquiry_id`,`source_workflow_phase_id`,`completed_at`),
  KEY `inq_tasks_assignee_period_idx` (`assignee_id`,`assignee_assigned_at`),
  KEY `inq_tasks_completion_credit_period_idx` (`assignee_at_completion`,`assignee_assigned_at_completion`),
  KEY `ft_inquiry_tasks_parent_open_seq_idx` (`inquiry_id`,`deleted_at`,`completed_at`,`sequence`),
  KEY `ft_inquiry_tasks_assignee_open_due_idx` (`assignee_id`,`deleted_at`,`completed_at`,`due_date`),
  CONSTRAINT `inquiry_tasks_assignee_at_completion_foreign` FOREIGN KEY (`assignee_at_completion`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiry_tasks_assignee_id_foreign` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiry_tasks_inquiry_id_foreign` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inquiry_tasks_inquiry_task_status_id_foreign` FOREIGN KEY (`inquiry_task_status_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inquiry_tasks_setup_assignee_id_foreign` FOREIGN KEY (`setup_assignee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2176 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` decimal(12,2) NOT NULL DEFAULT '1.00',
  `unit_price` decimal(14,2) NOT NULL DEFAULT '0.00',
  `amount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_items_invoice_id_sort_order_index` (`invoice_id`,`sort_order`),
  CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `sequence` smallint unsigned NOT NULL,
  `invoice_number` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Final invoice',
  `currency` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `issue_date` date NOT NULL,
  `due_date` date NOT NULL,
  `billing_contact_id` bigint unsigned DEFAULT NULL,
  `billing_contact_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `billing_contact_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purchase_order_reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `company_snapshot` json DEFAULT NULL,
  `client_snapshot` json DEFAULT NULL,
  `supporting_document_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supporting_document_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pdf_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pdf_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pdf_generated_at` timestamp NULL DEFAULT NULL,
  `pdf_layout_version` smallint unsigned NOT NULL DEFAULT '1',
  `subtotal` decimal(14,2) NOT NULL DEFAULT '0.00',
  `tax_rate` decimal(7,4) NOT NULL DEFAULT '0.0000',
  `tax_amount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `previously_invoiced` decimal(14,2) NOT NULL DEFAULT '0.00',
  `total` decimal(14,2) NOT NULL DEFAULT '0.00',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `sent_at` timestamp NULL DEFAULT NULL,
  `emailed_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_flow_job_id_sequence_unique` (`flow_job_id`,`sequence`),
  UNIQUE KEY `invoices_invoice_number_unique` (`invoice_number`),
  KEY `invoices_billing_contact_id_foreign` (`billing_contact_id`),
  KEY `invoices_created_by_foreign` (`created_by`),
  KEY `invoices_flow_job_id_status_due_date_index` (`flow_job_id`,`status`,`due_date`),
  CONSTRAINT `invoices_billing_contact_id_foreign` FOREIGN KEY (`billing_contact_id`) REFERENCES `client_contacts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `invoices_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `invoices_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB AUTO_INCREMENT=109120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `master_records`
--

DROP TABLE IF EXISTS `master_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_records` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  `type` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `metadata` json DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `master_records_workspace_type_code_uq` (`workspace_id`,`type`,`code`),
  KEY `master_records_workspace_type_status_idx` (`workspace_id`,`type`,`status`),
  KEY `ft_master_active_sort_idx` (`workspace_id`,`type`,`status`,`sort_order`),
  KEY `ft_master_active_deleted_sort_idx` (`workspace_id`,`type`,`status`,`deleted_at`,`sort_order`),
  KEY `master_records_created_by_foreign` (`created_by`),
  CONSTRAINT `master_records_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1481537 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `master_values`
--

DROP TABLE IF EXISTS `master_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_values` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group_key` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `parent_id` bigint unsigned DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `meta` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `master_values_group_key_code_unique` (`group_key`,`code`),
  KEY `master_values_parent_id_foreign` (`parent_id`),
  KEY `master_values_group_key_is_active_index` (`group_key`,`is_active`),
  CONSTRAINT `master_values_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `master_values` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=144013 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification_rules`
--

DROP TABLE IF EXISTS `notification_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_rules` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `trigger` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipients` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_holds`
--

DROP TABLE IF EXISTS `order_holds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_holds` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `hold_from` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `held_by` bigint unsigned DEFAULT NULL,
  `started_at` timestamp NOT NULL,
  `ended_at` timestamp NULL DEFAULT NULL,
  `released_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_holds_held_by_foreign` (`held_by`),
  KEY `order_holds_released_by_foreign` (`released_by`),
  KEY `order_holds_job_active_idx` (`flow_job_id`,`ended_at`),
  KEY `order_holds_source_started_idx` (`hold_from`,`started_at`),
  CONSTRAINT `order_holds_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_holds_held_by_foreign` FOREIGN KEY (`held_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_holds_released_by_foreign` FOREIGN KEY (`released_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_redos`
--

DROP TABLE IF EXISTS `order_redos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_redos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `original_order_id` bigint unsigned NOT NULL,
  `redo_order_id` bigint unsigned DEFAULT NULL,
  `sequence` smallint unsigned NOT NULL,
  `issue_reported_by` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issue_category` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reported_date` date NOT NULL,
  `affected_quantity` int unsigned NOT NULL,
  `issue_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `scope` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redo_quantity` int unsigned NOT NULL,
  `supplier_id` bigint unsigned DEFAULT NULL,
  `internal_instructions` text COLLATE utf8mb4_unicode_ci,
  `customer_resolution` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_adjustment_type` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'percent',
  `customer_adjustment_value` decimal(10,2) NOT NULL DEFAULT '0.00',
  `customer_discount_percent` decimal(6,2) NOT NULL DEFAULT '0.00',
  `supplier_redo_charge_percent` decimal(6,2) NOT NULL DEFAULT '0.00',
  `supplier_adjustment_type` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'percent',
  `supplier_adjustment_value` decimal(10,2) NOT NULL DEFAULT '0.00',
  `deduct_freight` tinyint(1) NOT NULL DEFAULT '0',
  `freight_amount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `affected_order_value` decimal(14,2) NOT NULL DEFAULT '0.00',
  `order_value_before_adjustment` decimal(14,2) NOT NULL DEFAULT '0.00',
  `order_value_after_adjustment` decimal(14,2) NOT NULL DEFAULT '0.00',
  `customer_impact` decimal(14,2) NOT NULL DEFAULT '0.00',
  `supplier_redo_charge` decimal(14,2) NOT NULL DEFAULT '0.00',
  `total_supplier_recovery` decimal(14,2) NOT NULL DEFAULT '0.00',
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_redos_original_sequence_unique` (`original_order_id`,`sequence`),
  UNIQUE KEY `order_redos_redo_order_id_unique` (`redo_order_id`),
  KEY `order_redos_supplier_id_foreign` (`supplier_id`),
  KEY `order_redos_created_by_foreign` (`created_by`),
  KEY `order_redos_original_created_idx` (`original_order_id`,`created_at`),
  CONSTRAINT `order_redos_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_redos_original_order_id_foreign` FOREIGN KEY (`original_order_id`) REFERENCES `flow_jobs` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `order_redos_redo_order_id_foreign` FOREIGN KEY (`redo_order_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_redos_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_shipments`
--

DROP TABLE IF EXISTS `order_shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_shipments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `sequence` smallint unsigned NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `recipient` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_country_code` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `city` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postal_code` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_source_address_id` bigint unsigned DEFAULT NULL,
  `shipment_method_id` bigint unsigned DEFAULT NULL,
  `shipment_urgency_id` bigint unsigned DEFAULT NULL,
  `courier_id` bigint unsigned DEFAULT NULL,
  `package_reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int unsigned DEFAULT NULL,
  `tracking_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label_printed_at` timestamp NULL DEFAULT NULL,
  `dispatched_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `updated_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_shipments_shipping_source_address_id_foreign` (`shipping_source_address_id`),
  KEY `order_shipments_shipment_method_id_foreign` (`shipment_method_id`),
  KEY `order_shipments_shipment_urgency_id_foreign` (`shipment_urgency_id`),
  KEY `order_shipments_courier_id_foreign` (`courier_id`),
  KEY `order_shipments_created_by_foreign` (`created_by`),
  KEY `order_shipments_updated_by_foreign` (`updated_by`),
  KEY `order_shipments_job_sequence_index` (`flow_job_id`,`sequence`),
  KEY `order_shipments_dispatch_index` (`flow_job_id`,`dispatched_at`),
  KEY `order_shipments_tracking_index` (`flow_job_id`,`tracking_number`),
  CONSTRAINT `order_shipments_courier_id_foreign` FOREIGN KEY (`courier_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_shipments_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_shipments_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_shipments_shipment_method_id_foreign` FOREIGN KEY (`shipment_method_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_shipments_shipment_urgency_id_foreign` FOREIGN KEY (`shipment_urgency_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_shipments_shipping_source_address_id_foreign` FOREIGN KEY (`shipping_source_address_id`) REFERENCES `client_shipping_addresses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `order_shipments_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1270 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_workflow_summaries`
--

DROP TABLE IF EXISTS `order_workflow_summaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_workflow_summaries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `workflow_id` bigint unsigned DEFAULT NULL,
  `workflow_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `workflow_phase_id` bigint unsigned DEFAULT NULL,
  `current_phase_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_phase_short_name` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `current_phase_sequence` smallint unsigned NOT NULL DEFAULT '1',
  `stage_count` smallint unsigned NOT NULL DEFAULT '0',
  `current_task_count` smallint unsigned NOT NULL DEFAULT '0',
  `current_applicable_task_count` smallint unsigned NOT NULL DEFAULT '0',
  `current_completed_task_count` smallint unsigned NOT NULL DEFAULT '0',
  `next_task_id` bigint unsigned DEFAULT NULL,
  `next_task_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `next_task_assignee_id` bigint unsigned DEFAULT NULL,
  `progress_percent` tinyint unsigned NOT NULL DEFAULT '0',
  `order_status` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_on_hold` tinyint(1) NOT NULL DEFAULT '0',
  `is_stale` tinyint(1) NOT NULL DEFAULT '0',
  `refreshed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_workflow_summaries_flow_job_id_unique` (`flow_job_id`),
  KEY `order_wf_summary_workflow_stale_idx` (`workflow_id`,`is_stale`),
  KEY `order_wf_summary_phase_stale_idx` (`workflow_phase_id`,`is_stale`),
  KEY `order_wf_summary_next_task_idx` (`next_task_id`),
  CONSTRAINT `order_workflow_summaries_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3318 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `flow_job_id` bigint unsigned NOT NULL,
  `invoice_id` bigint unsigned DEFAULT NULL,
  `sequence` smallint unsigned NOT NULL,
  `payment_number` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_date` date NOT NULL,
  `method` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Bank transfer',
  `amount` decimal(14,2) NOT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `received_account` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receipt_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `receipt_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `recorded_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payments_flow_job_id_sequence_unique` (`flow_job_id`,`sequence`),
  UNIQUE KEY `payments_payment_number_unique` (`payment_number`),
  KEY `payments_recorded_by_foreign` (`recorded_by`),
  KEY `payments_flow_job_id_payment_date_index` (`flow_job_id`,`payment_date`),
  KEY `payments_invoice_id_payment_date_index` (`invoice_id`,`payment_date`),
  CONSTRAINT `payments_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payments_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE SET NULL,
  CONSTRAINT `payments_recorded_by_foreign` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permission_role`
--

DROP TABLE IF EXISTS `permission_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_role` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `permission_role_role_id_foreign` (`role_id`),
  CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `module` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_supplier_links`
--

DROP TABLE IF EXISTS `product_supplier_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_supplier_links` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `supplier_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_supplier_links_product_supplier_uq` (`product_id`,`supplier_id`),
  KEY `product_supplier_links_supplier_id_foreign` (`supplier_id`),
  KEY `product_supplier_links_workspace_supplier_idx` (`workspace_id`,`supplier_id`),
  KEY `product_supplier_links_workspace_product_idx` (`workspace_id`,`product_id`),
  CONSTRAINT `product_supplier_links_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `master_records` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_supplier_links_supplier_id_foreign` FOREIGN KEY (`supplier_id`) REFERENCES `master_records` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_supplier_links_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1581 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_module_access`
--

DROP TABLE IF EXISTS `role_module_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_module_access` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint unsigned NOT NULL,
  `module_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_scope` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'none',
  `actions` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_module_access_role_id_module_code_unique` (`role_id`,`module_code`),
  KEY `role_module_access_module_code_record_scope_index` (`module_code`,`record_scope`),
  CONSTRAINT `role_module_access_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=590 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `default_scope` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'assigned_jobs',
  `is_system` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sensitive_fields` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_links`
--

DROP TABLE IF EXISTS `task_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_links` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `task_id` bigint unsigned NOT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `task_links_created_by_foreign` (`created_by`),
  KEY `task_links_task_created_idx` (`task_id`,`created_at`),
  CONSTRAINT `task_links_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `task_links_task_id_foreign` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_pack_items`
--

DROP TABLE IF EXISTS `task_pack_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_pack_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `task_pack_id` bigint unsigned NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `automation_key` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#2563EB',
  `default_assignee_id` bigint unsigned DEFAULT NULL,
  `default_department_id` bigint unsigned DEFAULT NULL,
  `priority_id` bigint unsigned DEFAULT NULL,
  `document_category_id` bigint unsigned DEFAULT NULL,
  `document_required_before_completion` tinyint(1) NOT NULL DEFAULT '1',
  `allow_multiple_documents` tinyint(1) NOT NULL DEFAULT '0',
  `document_instructions` text COLLATE utf8mb4_unicode_ci,
  `due_offset_days` int unsigned NOT NULL DEFAULT '1',
  `standard_duration_value` decimal(8,2) DEFAULT NULL,
  `standard_duration_unit` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'business_hours',
  `timer_start_rule` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'status_in_progress',
  `timer_stop_rule` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'status_completed',
  `work_calendar` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'workspace_hours',
  `set_due_from_standard_duration` tinyint(1) NOT NULL DEFAULT '1',
  `allow_efficiency_override` tinyint(1) NOT NULL DEFAULT '0',
  `is_required` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `source_task_pack_item_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `task_pack_items_task_pack_id_index` (`task_pack_id`),
  KEY `task_pack_items_default_assignee_id_index` (`default_assignee_id`),
  KEY `task_pack_items_default_department_id_index` (`default_department_id`),
  KEY `task_pack_items_priority_id_index` (`priority_id`),
  KEY `task_pack_items_document_category_id_index` (`document_category_id`),
  KEY `task_pack_items_source_idx` (`source_task_pack_item_id`),
  KEY `task_pack_items_automation_idx` (`task_pack_id`,`automation_key`)
) ENGINE=InnoDB AUTO_INCREMENT=7852 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_pack_tasks`
--

DROP TABLE IF EXISTS `task_pack_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_pack_tasks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `task_pack_id` bigint unsigned NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#2563EB',
  `sequence` smallint unsigned NOT NULL DEFAULT '1',
  `is_required` tinyint(1) NOT NULL DEFAULT '1',
  `default_department_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `source_task_pack_task_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_pack_tasks_task_pack_id_sequence_unique` (`task_pack_id`,`sequence`),
  KEY `task_pack_tasks_default_department_id_foreign` (`default_department_id`),
  KEY `task_pack_tasks_source_idx` (`source_task_pack_task_id`),
  CONSTRAINT `task_pack_tasks_default_department_id_foreign` FOREIGN KEY (`default_department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `task_pack_tasks_task_pack_id_foreign` FOREIGN KEY (`task_pack_id`) REFERENCES `task_packs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7852 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_packs`
--

DROP TABLE IF EXISTS `task_packs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_packs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL DEFAULT '1',
  `code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_snapshot` tinyint(1) NOT NULL DEFAULT '0',
  `source_task_pack_id` bigint unsigned DEFAULT NULL,
  `snapshot_job_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_packs_name_unique` (`name`),
  UNIQUE KEY `task_packs_slug_unique` (`slug`),
  KEY `task_packs_snapshot_source_idx` (`is_snapshot`,`source_task_pack_id`),
  KEY `task_packs_snapshot_job_idx` (`snapshot_job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1759 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `task_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `flow_job_id` bigint unsigned NOT NULL,
  `workflow_phase_id` bigint unsigned DEFAULT NULL,
  `task_pack_task_id` bigint unsigned DEFAULT NULL,
  `document_category_id` bigint unsigned DEFAULT NULL,
  `document_requirement_source` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `assignee_id` bigint unsigned DEFAULT NULL,
  `assignee_assigned_at` timestamp NULL DEFAULT NULL,
  `assignee_at_completion` bigint unsigned DEFAULT NULL,
  `assignee_assigned_at_completion` timestamp NULL DEFAULT NULL,
  `setup_assignee_id` bigint unsigned DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Ready',
  `order_task_status_id` bigint unsigned DEFAULT NULL,
  `priority` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Medium',
  `progress` tinyint unsigned NOT NULL DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `needs_attention` tinyint(1) NOT NULL DEFAULT '0',
  `order_task_flag_id` bigint unsigned DEFAULT NULL,
  `task_flag_id` bigint unsigned DEFAULT NULL,
  `attention_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tasks_task_number_unique` (`task_number`),
  KEY `tasks_workflow_phase_id_foreign` (`workflow_phase_id`),
  KEY `tasks_task_pack_task_id_foreign` (`task_pack_task_id`),
  KEY `tasks_assignee_id_status_due_date_index` (`assignee_id`,`status`,`due_date`),
  KEY `tasks_flow_job_id_workflow_phase_id_index` (`flow_job_id`,`workflow_phase_id`),
  KEY `ft_tasks_active_due_idx` (`deleted_at`,`completed_at`,`due_date`),
  KEY `ft_tasks_assignee_active_due_idx` (`assignee_id`,`deleted_at`,`completed_at`,`due_date`),
  KEY `ft_tasks_job_active_status_due_idx` (`flow_job_id`,`deleted_at`,`completed_at`,`status`,`due_date`),
  KEY `ft_tasks_job_phase_template_idx` (`flow_job_id`,`workflow_phase_id`,`task_pack_task_id`,`deleted_at`),
  KEY `ft_tasks_job_phase_open_due_idx` (`flow_job_id`,`workflow_phase_id`,`deleted_at`,`completed_at`,`due_date`),
  KEY `ft_tasks_my_work_personal_idx` (`assignee_id`,`deleted_at`,`completed_at`,`status`,`due_date`),
  KEY `ft_tasks_board_assignee_job_idx` (`assignee_id`,`deleted_at`,`flow_job_id`),
  KEY `tasks_task_flag_id_needs_attention_index` (`task_flag_id`,`needs_attention`),
  KEY `tasks_order_task_status_id_foreign` (`order_task_status_id`),
  KEY `tasks_order_task_flag_attention_idx` (`order_task_flag_id`,`needs_attention`),
  KEY `tasks_assignee_period_idx` (`assignee_id`,`assignee_assigned_at`),
  KEY `tasks_completion_credit_period_idx` (`assignee_at_completion`,`assignee_assigned_at_completion`),
  KEY `ft_tasks_job_open_due_idx` (`flow_job_id`,`deleted_at`,`completed_at`,`due_date`),
  KEY `ft_tasks_phase_open_due_idx` (`workflow_phase_id`,`deleted_at`,`completed_at`,`due_date`),
  KEY `ft_tasks_assignee_phase_open_job_idx` (`assignee_id`,`workflow_phase_id`,`deleted_at`,`completed_at`,`flow_job_id`),
  CONSTRAINT `tasks_assignee_at_completion_foreign` FOREIGN KEY (`assignee_at_completion`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tasks_assignee_id_foreign` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tasks_flow_job_id_foreign` FOREIGN KEY (`flow_job_id`) REFERENCES `flow_jobs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tasks_order_task_flag_id_foreign` FOREIGN KEY (`order_task_flag_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tasks_order_task_status_id_foreign` FOREIGN KEY (`order_task_status_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tasks_task_flag_id_foreign` FOREIGN KEY (`task_flag_id`) REFERENCES `master_records` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tasks_task_pack_task_id_foreign` FOREIGN KEY (`task_pack_task_id`) REFERENCES `task_pack_tasks` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tasks_workflow_phase_id_foreign` FOREIGN KEY (`workflow_phase_id`) REFERENCES `workflow_phases` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=41482 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `ft_user_roles_role_user_idx` (`role_id`,`user_id`),
  CONSTRAINT `user_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint unsigned DEFAULT NULL,
  `department_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_super_admin` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `locale` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `profile_image_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `wechat_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_role_id_foreign` (`role_id`),
  KEY `users_department_id_foreign` (`department_id`),
  KEY `users_account_status_index` (`account_status`),
  CONSTRAINT `users_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workflow_phases`
--

DROP TABLE IF EXISTS `workflow_phases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workflow_phases` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workflow_template_id` bigint unsigned DEFAULT NULL,
  `workflow_id` bigint unsigned NOT NULL,
  `task_pack_id` bigint unsigned DEFAULT NULL,
  `document_category_id` bigint unsigned DEFAULT NULL,
  `sequence` smallint unsigned NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allow_job_start` tinyint(1) NOT NULL DEFAULT '0',
  `is_skippable` tinyint(1) NOT NULL DEFAULT '0',
  `can_skip` tinyint(1) NOT NULL DEFAULT '0',
  `requires_approval` tinyint(1) NOT NULL DEFAULT '0',
  `auto_advance_on_ready` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `entry_condition` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exit_condition` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `required_document` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entry_rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `exit_rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `source_workflow_phase_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `workflow_phases_workflow_id_sequence_unique` (`workflow_id`,`sequence`),
  KEY `workflow_phases_task_pack_id_foreign` (`task_pack_id`),
  KEY `ft_workflow_phases_active_sequence_idx` (`workflow_id`,`is_active`,`sequence`),
  KEY `ft_workflow_template_active_sequence_idx` (`workflow_template_id`,`is_active`,`sequence`),
  KEY `workflow_phases_source_idx` (`source_workflow_phase_id`),
  CONSTRAINT `workflow_phases_task_pack_id_foreign` FOREIGN KEY (`task_pack_id`) REFERENCES `task_packs` (`id`) ON DELETE SET NULL,
  CONSTRAINT `workflow_phases_workflow_id_foreign` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1943 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workflow_template_client`
--

DROP TABLE IF EXISTS `workflow_template_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workflow_template_client` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workflow_template_id` bigint unsigned NOT NULL,
  `client_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `workflow_template_client_unique` (`workflow_template_id`,`client_id`),
  KEY `workflow_template_client_client_idx` (`client_id`,`workflow_template_id`),
  CONSTRAINT `workflow_template_client_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `workflow_template_client_workflow_template_id_foreign` FOREIGN KEY (`workflow_template_id`) REFERENCES `workflow_templates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workflow_templates`
--

DROP TABLE IF EXISTS `workflow_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workflow_templates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL,
  `code` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `applies_to` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'orders',
  `client_availability` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `version` int unsigned NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `workflow_templates_workspace_code_uq` (`workspace_id`,`code`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workflows`
--

DROP TABLE IF EXISTS `workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workflows` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_snapshot` tinyint(1) NOT NULL DEFAULT '0',
  `source_workflow_id` bigint unsigned DEFAULT NULL,
  `snapshot_job_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `workflows_slug_unique` (`slug`),
  KEY `workflows_snapshot_source_idx` (`is_snapshot`,`source_workflow_id`),
  KEY `workflows_snapshot_job_idx` (`snapshot_job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=356 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workspace_memberships`
--

DROP TABLE IF EXISTS `workspace_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workspace_memberships` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint unsigned NOT NULL DEFAULT '1',
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned DEFAULT NULL,
  `department_id` bigint unsigned DEFAULT NULL,
  `job_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `joined_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `business_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'both',
  PRIMARY KEY (`id`),
  UNIQUE KEY `workspace_memberships_workspace_id_user_id_unique` (`workspace_id`,`user_id`),
  KEY `workspace_memberships_user_id_foreign` (`user_id`),
  KEY `workspace_memberships_department_id_foreign` (`department_id`),
  KEY `ft_membership_role_active_workspace_idx` (`role_id`,`status`,`workspace_id`,`user_id`),
  CONSTRAINT `workspace_memberships_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `workspace_memberships_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL,
  CONSTRAINT `workspace_memberships_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workspaces`
--

DROP TABLE IF EXISTS `workspaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workspaces` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `timezone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Asia/Dhaka',
  `default_currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `logo_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favicon_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_profile` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `workspaces_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'flowtracker'
--

--
-- Dumping routines for database 'flowtracker'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:07:22

-- ===============================================
-- SAMPLE PRODUCTION DATA
-- ===============================================
SET FOREIGN_KEY_CHECKS=0;
SET UNIQUE_CHECKS=0;


-- ==================================================
-- SAMPLE DATA: activities
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `activities`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT  IGNORE INTO `activities` VALUES (1,'App\\Models\\FlowJob',1,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(2,'App\\Models\\FlowJob',2,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(3,'App\\Models\\FlowJob',3,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(4,'App\\Models\\FlowJob',4,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(5,'App\\Models\\FlowJob',5,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(6,'App\\Models\\FlowJob',6,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(7,'App\\Models\\FlowJob',7,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(8,'App\\Models\\FlowJob',8,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(9,'App\\Models\\FlowJob',9,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(10,'App\\Models\\FlowJob',10,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(11,'App\\Models\\FlowJob',11,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(12,'App\\Models\\FlowJob',12,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(13,'App\\Models\\FlowJob',13,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(14,'App\\Models\\FlowJob',14,NULL,'job.seeded','Job record created and current workflow phase activated.','{\"source\": \"demo-seed\"}','2026-08-04 19:08:34','2026-08-04 19:08:34'),(15,'App\\Models\\Task',22,1,'task.updated','Status changed from In Progress to Waiting for Client','{\"changes\": {\"status\": {\"new\": \"Waiting for Client\", \"old\": \"In Progress\"}}}','2026-08-04 19:48:52','2026-08-04 19:48:52'),(16,'App\\Models\\FlowJob',6,1,'job.task_activity','Internal invoice review: Status changed from In Progress to Waiting for Client','{\"changes\": {\"status\": {\"new\": \"Waiting for Client\", \"old\": \"In Progress\"}}, \"task_id\": 22, \"task_event\": \"task.updated\", \"task_number\": \"TSK-322\"}','2026-08-04 19:48:52','2026-08-04 19:48:52'),(17,'App\\Models\\Task',62,1,'task.updated','Status changed from In Progress to Completed · Progress changed from 75 to 100','{\"changes\": {\"status\": {\"new\": \"Completed\", \"old\": \"In Progress\"}, \"progress\": {\"new\": 100, \"old\": 75}}}','2026-08-04 20:26:26','2026-08-04 20:26:26'),(18,'App\\Models\\FlowJob',17,1,'job.task_activity','Collect supplier / factory costing: Status changed from In Progress to Completed · Progress changed from 75 to 100','{\"changes\": {\"status\": {\"new\": \"Completed\", \"old\": \"In Progress\"}, \"progress\": {\"new\": 100, \"old\": 75}}, \"task_id\": 62, \"task_event\": \"task.updated\", \"task_number\": \"TSK-366\"}','2026-08-04 20:26:26','2026-08-04 20:26:26'),(19,'App\\Models\\Task',64,1,'task.updated','Status changed from Ready to Completed · Progress changed from 10 to 100','{\"changes\": {\"status\": {\"new\": \"Completed\", \"old\": \"Ready\"}, \"progress\": {\"new\": 100, \"old\": 10}}}','2026-08-04 20:26:36','2026-08-04 20:26:36'),(20,'App\\Models\\FlowJob',17,1,'job.task_activity','Internal quotation review: Status changed from Ready to Completed · Progress changed from 10 to 100','{\"changes\": {\"status\": {\"new\": \"Completed\", \"old\": \"Ready\"}, \"progress\": {\"new\": 100, \"old\": 10}}, \"task_id\": 64, \"task_event\": \"task.updated\", \"task_number\": \"TSK-368\"}','2026-08-04 20:26:36','2026-08-04 20:26:36');
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: bulk_order_import_rows
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `bulk_order_import_rows`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `bulk_order_import_rows` WRITE;
/*!40000 ALTER TABLE `bulk_order_import_rows` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulk_order_import_rows` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: bulk_order_imports
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `bulk_order_imports`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `bulk_order_imports` WRITE;
/*!40000 ALTER TABLE `bulk_order_imports` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulk_order_imports` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29
-- DATA SKIPPED FOR SECURITY/RUNTIME TABLE: cache
-- DATA SKIPPED FOR SECURITY/RUNTIME TABLE: cache_locks

-- ==================================================
-- SAMPLE DATA: client_contacts
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `client_contacts`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `client_contacts` WRITE;
/*!40000 ALTER TABLE `client_contacts` DISABLE KEYS */;
INSERT  IGNORE INTO `client_contacts` VALUES (21,14,'sample',NULL,'sample@email.com','+1 877-240-4349',1,0,'2026-08-11 10:30:36','2026-09-03 00:43:46'),(26,11,'Amin',NULL,'amin@imprintid.com','+1 8773857785',1,0,'2026-08-31 00:47:09','2026-08-31 22:06:55');
/*!40000 ALTER TABLE `client_contacts` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: client_delivery_contacts
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `client_delivery_contacts`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `client_delivery_contacts` WRITE;
/*!40000 ALTER TABLE `client_delivery_contacts` DISABLE KEYS */;
INSERT  IGNORE INTO `client_delivery_contacts` VALUES (1,14,'end_customer','Reward Connections Inc.','+1','905.238.8445',47,'2026-09-01 17:05:27','2026-09-01 17:05:27','2026-09-01 17:05:27'),(2,14,'end_customer','Christina Casselman','+1','269-966-6402',47,'2026-09-02 17:24:24','2026-09-02 17:24:24','2026-09-02 17:24:24'),(3,14,'end_customer','Jerrett Nelson','+1','907-262-7825',47,'2026-09-02 17:27:03','2026-09-02 17:27:03','2026-09-02 17:27:03'),(4,14,'end_customer','Jonathan Tanco','+1','952.204.7748',47,'2026-09-02 17:29:31','2026-09-02 17:29:31','2026-09-02 17:29:31'),(5,14,'end_customer','Cassandra Olson','+1','(218) 935-2161',47,'2026-09-02 17:42:27','2026-09-02 17:42:27','2026-09-02 17:42:27'),(6,14,'end_customer','JOSH BARRON','+1','410-279-6481',47,'2026-09-03 00:40:02','2026-09-03 00:40:02','2026-09-03 00:40:02'),(7,14,'end_customer','Nancy Melvin','+1','248-207-6556',47,'2026-09-03 00:46:39','2026-09-03 00:46:39','2026-09-03 00:46:39'),(8,14,'end_customer','4 Marks Printing','+1','317-960-4840',47,'2026-09-03 00:50:39','2026-09-03 00:50:39','2026-09-03 00:50:39'),(9,14,'end_customer','Ken Stank','+1','(717) 627-0370',47,'2026-09-27 18:48:09','2026-09-03 00:56:14','2026-09-27 18:48:09'),(10,14,'end_customer','Sydney McCarthy','+1','772-562-0079',47,'2026-09-03 01:02:04','2026-09-03 01:02:04','2026-09-03 01:02:04'),(11,14,'end_customer','Larry Weeks','+1','248-946-8764',47,'2026-09-03 01:08:44','2026-09-03 01:08:44','2026-09-03 01:08:44'),(12,14,'end_customer','JONES, CJ / LIFESTYLE','+1','(650) 853-5000',47,'2026-09-04 18:17:05','2026-09-03 01:52:49','2026-09-04 18:17:05'),(13,14,'end_customer','sample','+1','877-240-4349',47,'2026-09-28 23:58:29','2026-09-04 17:36:22','2026-09-28 23:58:29'),(14,14,'end_customer','Logos Galore','+1','989-772-0566',47,'2026-09-04 17:50:47','2026-09-04 17:50:47','2026-09-04 17:50:47'),(15,14,'end_customer','Kristin Hess','+1','936-546-1973',47,'2026-09-04 18:07:23','2026-09-04 18:07:23','2026-09-04 18:07:23'),(16,14,'end_customer','Olivia Jones','+1','503-631-7025',47,'2026-09-04 18:11:17','2026-09-04 18:11:17','2026-09-04 18:11:17'),(17,11,'end_customer','Amin','+1','8773857785',36,'2026-09-29 22:21:13','2026-09-07 21:55:58','2026-09-29 22:21:13'),(18,14,'end_customer','Shania Fenton/ Student Engagement Office','+1','(401) 341-2225',47,'2026-09-08 17:29:01','2026-09-08 17:29:01','2026-09-08 17:29:01'),(19,14,'end_customer','Kodie Richardson','+1','215-260-3870',47,'2026-09-08 17:40:33','2026-09-08 17:40:33','2026-09-08 17:40:33'),(20,14,'end_customer','Silkworm, Inc.','+1','618-687-4077',47,'2026-09-08 17:44:12','2026-09-08 17:44:12','2026-09-08 17:44:12');
/*!40000 ALTER TABLE `client_delivery_contacts` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: client_shipping_addresses
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `client_shipping_addresses`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `client_shipping_addresses` WRITE;
/*!40000 ALTER TABLE `client_shipping_addresses` DISABLE KEYS */;
INSERT  IGNORE INTO `client_shipping_addresses` VALUES (6,14,'sample',NULL,'sample',NULL,'sample','Delaware (DE)','10001','United States',1,0,'2026-08-11 10:30:36','2026-08-11 10:30:36'),(11,11,'sample',NULL,'11875 Lexington Valley Dr., Manassas, VA 20109',NULL,'Manassas','Virginia (VA)','20109','United States',1,0,'2026-08-31 00:47:09','2026-08-31 00:47:09');
/*!40000 ALTER TABLE `client_shipping_addresses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: clients
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `clients`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT  IGNORE INTO `clients` VALUES (1,'Deleted client #1',NULL,NULL,NULL,'DEL-1-6B86B2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:10:30',NULL,'2026-08-11 21:32:46',1,0,'2026-08-04 19:08:28','2026-08-11 21:32:46'),(2,'Deleted client #2',NULL,NULL,NULL,'DEL-2-D4735E',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:09:12',NULL,'2026-08-11 21:32:52',1,0,'2026-08-04 19:08:28','2026-08-11 21:32:52'),(3,'Deleted client #3',NULL,NULL,NULL,'DEL-3-4E0740',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:08:49',NULL,'2026-08-11 21:32:55',1,0,'2026-08-04 19:08:28','2026-08-11 21:32:55'),(4,'Deleted client #4',NULL,NULL,NULL,'DEL-4-4B2277',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:11:32',NULL,'2026-08-11 21:33:05',1,0,'2026-08-04 19:08:28','2026-08-11 21:33:05'),(5,'Deleted client #5',NULL,NULL,NULL,'DEL-5-EF2D12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:11:20',NULL,'2026-08-11 21:33:02',1,0,'2026-08-04 19:08:28','2026-08-11 21:33:02'),(6,'Deleted client #6',NULL,NULL,NULL,'DEL-6-E7F6C0',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:09:38',NULL,'2026-08-11 21:32:49',1,0,'2026-08-04 19:08:28','2026-08-11 21:32:49'),(7,'Deleted client #7',NULL,NULL,NULL,'DEL-7-790269',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:11:40',NULL,'2026-08-11 21:33:08',1,0,'2026-08-04 19:08:28','2026-08-11 21:33:08'),(8,'Deleted client #8',NULL,NULL,NULL,'DEL-8-2C6242',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:10:38',NULL,'2026-08-11 21:33:00',1,0,'2026-08-04 19:08:28','2026-08-11 21:33:00'),(9,'Deleted client #9',NULL,NULL,NULL,'DEL-9-19581E',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:09:55',NULL,'2026-08-11 21:32:43',1,0,'2026-08-04 19:08:28','2026-08-11 21:32:43'),(10,'Deleted client #10',NULL,NULL,NULL,'DEL-10-4A44DC',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-05 17:09:00',NULL,'2026-08-11 21:32:57',1,0,'2026-08-04 19:08:28','2026-08-11 21:32:57'),(11,'IID ','client-logos/11/vEHzsQ3K8vHMVKQXYh2xyOaKZ3VEi4JAyHkNfkS0.png','ImprintID','https://www.imprintid.com/','CL-011','United States','sample, sample, Arkansas (AR) 10001, United States','sample',NULL,'sample','Arkansas (AR)','10001',0,'Amin','11875 Lexington Valley Dr., Manassas, VA 20109',NULL,'Manassas','Virginia (VA)','20109','United States',NULL,'taxable','Net 45',1,'Amin',NULL,'amin@imprintid.com',NULL,57,NULL,'English','USD',0.00,'Working for new project and development and bulk shipment',1,NULL,NULL,NULL,NULL,0,'2026-08-05 15:36:50','2026-08-31 00:43:34'),(12,'Deleted client #12',NULL,NULL,NULL,'DEL-12-6B51D4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-10 03:45:51',NULL,'2026-08-11 21:33:14',1,0,'2026-08-08 20:11:15','2026-08-11 21:33:14'),(13,'Deleted client #13',NULL,NULL,NULL,'DEL-13-3FDBA3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-10 03:45:47',NULL,'2026-08-11 21:33:10',1,0,'2026-08-09 21:35:00','2026-08-11 21:33:10'),(14,'NEP','client-logos/14/UtNqQtv9YXS6fASLyj7c4SiFJK3L9fzQbUE7icRK.webp',NULL,NULL,'CL-014','United States','sample, sample, Connecticut (CT) 10018, United States','sample',NULL,'sample','Connecticut (CT)','10018',1,NULL,'sample',NULL,'sample','Connecticut (CT)','10018','United States',NULL,'taxable',NULL,0,'sample',NULL,'sample@email.com',NULL,57,NULL,'English','USD',0.00,NULL,1,NULL,NULL,NULL,NULL,0,'2026-08-10 01:11:08','2026-08-11 10:30:36'),(15,'Deleted client #15',NULL,NULL,NULL,'DEL-15-E629FA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-10 22:37:08',NULL,'2026-08-11 21:33:39',1,0,'2026-08-10 22:28:26','2026-08-11 21:33:39'),(16,'Deleted client #16',NULL,NULL,NULL,'DEL-16-B17EF6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-10 22:37:04',NULL,'2026-08-11 21:33:36',1,0,'2026-08-10 22:28:50','2026-08-11 21:33:36'),(17,'Deleted client #17',NULL,NULL,NULL,'DEL-17-452354',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-10 23:11:45',NULL,'2026-08-11 21:32:35',1,0,'2026-08-10 23:08:13','2026-08-11 21:32:35'),(18,'Deleted client #18',NULL,NULL,NULL,'DEL-18-4EC959',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taxable',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'English','USD',0.00,NULL,0,'2026-08-10 23:11:51',NULL,'2026-08-11 21:32:32',1,0,'2026-08-10 23:08:22','2026-08-11 21:32:32');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: collection_updates
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `collection_updates`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `collection_updates` WRITE;
/*!40000 ALTER TABLE `collection_updates` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_updates` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: departments
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `departments`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT  IGNORE INTO `departments` VALUES (1,'MGT','Management','Operations and leadership',1,'2026-08-04 19:08:18','2026-08-04 19:08:18'),(2,'SAL','Sales','Client and quotation management',1,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(3,'DES','Design','Artwork preparation',1,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(4,'SRC','Sourcing','Supplier and sample coordination',1,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(5,'PRO','Production',NULL,1,'2026-08-04 19:08:19','2026-08-02 10:32:39'),(6,'QUA','Quality','Quality inspection',1,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(7,'SHP','Shipment','Logistics and delivery',1,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(8,'ACC','Accounts','Invoice and collection',1,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(9,'SAM','Sampling','Samples and swatches',1,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(40,'DEP-010','Artwork',NULL,1,'2026-08-02 10:25:30','2026-08-02 10:25:30'),(41,'DEP-011','E-commerce',NULL,1,'2026-08-02 10:25:50','2026-08-02 10:25:50'),(42,'DEP-012','Embroidery',NULL,1,'2026-08-02 10:27:34','2026-08-02 10:27:43'),(43,'DEP-013','Finance Department',NULL,1,'2026-08-02 10:28:00','2026-08-02 10:28:00'),(44,'DEP-014','HR',NULL,1,'2026-08-02 10:30:01','2026-08-02 10:30:01'),(45,'DEP-015','IID',NULL,1,'2026-08-02 10:31:38','2026-08-02 10:31:38'),(46,'DEP-016','Luggage Sales',NULL,1,'2026-08-02 10:31:53','2026-08-02 10:31:53'),(47,'DEP-017','NEP',NULL,1,'2026-08-02 10:32:10','2026-08-02 10:32:10'),(48,'DEP-019','Purchase',NULL,1,'2026-08-02 10:32:59','2026-08-02 10:32:59'),(49,'DEP-020','Reception',NULL,1,'2026-08-02 10:34:58','2026-08-02 10:34:58');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: documents
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `documents`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT  IGNORE INTO `documents` VALUES (26,'DOC-000001',30,14,468,47,'Client Purchase Order','2026-0810-Nepart-7721-HALO-CT+ logo.pdf',NULL,'flowtrack/documents/30/5a0991c3-e129-4ab4-8633-bdcda8f22fc6.pdf','application/pdf',335890,1,0,'2026-08-12 01:38:41','2026-08-12 01:38:41'),(27,'DOC-000027',30,14,468,47,'Client Purchase Order','(Card Tech Jersey) Template.pdf',NULL,'flowtrack/documents/30/b232d2ca-f630-4b98-83ec-0352fd9d8782.pdf','application/pdf',279201,1,0,'2026-08-12 01:38:52','2026-08-12 01:38:52'),(28,'DOC-000028',30,14,468,47,'Client Purchase Order','Jersey image.jpg',NULL,'flowtrack/documents/30/3cdce478-9f69-4a85-85c2-2e38d35f4e7a.jpg','image/jpeg',1190361,1,0,'2026-08-12 01:38:58','2026-08-12 01:38:58'),(29,'DOC-000029',30,14,469,47,'Task attachment','(Card Tech Jersey) Template.pdf',NULL,'flowtrack/documents/30/1146b57c-2374-4d1b-b2b1-faf023ce5f8a.pdf','application/pdf',279201,1,0,'2026-08-12 01:39:45','2026-08-12 01:39:45'),(30,'DOC-000030',30,14,469,47,'Task attachment','2026-0810-Nepart-7721-HALO-CT+ logo.pdf',NULL,'flowtrack/documents/30/b05e612f-fcb5-4720-a779-244bb6778e21.pdf','application/pdf',335890,1,0,'2026-08-12 01:39:45','2026-08-12 01:39:45'),(31,'DOC-000031',30,14,469,47,'Task attachment','Jersey image.jpg',NULL,'flowtrack/documents/30/1a4cc287-3309-44f4-98bf-2f3209d34d2d.jpg','image/jpeg',1190361,1,0,'2026-08-12 01:39:45','2026-08-12 01:39:45'),(32,'DOC-000032',30,14,12564,47,'Task attachment','NEP-65550826 - Version 1.pdf',NULL,'flowtrack/documents/30/8060dc4a-0e61-4bac-9229-d4c87248308a.pdf','application/pdf',5051310,1,0,'2026-08-12 01:40:18','2026-08-30 08:50:04'),(33,'DOC-000033',31,11,NULL,36,'Order attachment','FO-331122-2.pdf',NULL,'flowtrack/documents/31/d2094c45-7ec4-415c-8f3f-6c1dd282e6ad.pdf','application/pdf',4223750,1,0,'2026-08-14 01:17:15','2026-08-14 01:17:15'),(34,'DOC-000034',31,11,NULL,36,'Order attachment','FO-331122-2.pdf',NULL,'flowtrack/documents/31/c0ca77ae-2e09-471a-b18c-2f63aeb9b9bf.pdf','application/pdf',4223750,2,0,'2026-08-14 01:17:15','2026-08-14 01:17:15'),(35,'DOC-000035',31,11,NULL,36,'Order attachment','FO-331122-1.pdf',NULL,'flowtrack/documents/31/de0a8a7a-4a18-40f3-acae-58c35d741183.pdf','application/pdf',9992091,1,0,'2026-08-14 01:17:15','2026-08-14 01:17:15'),(36,'DOC-000036',32,11,NULL,36,'Order attachment','FO-331396.pdf',NULL,'flowtrack/documents/32/46e9270c-f6e0-4b79-9b1f-a502937cb76c.pdf','application/pdf',3642037,1,0,'2026-08-14 01:24:42','2026-08-14 01:24:42'),(37,'DOC-000037',33,11,NULL,36,'Order attachment','FO-331389(1-2).pdf',NULL,'flowtrack/documents/33/e57624d7-5174-481f-b1ca-09edca1d6ea7.pdf','application/pdf',5162470,1,0,'2026-08-14 01:39:37','2026-08-14 01:39:37'),(38,'DOC-000038',34,14,NULL,47,'Order attachment','Topcon - Knit Scarf with Tassles - (1).pdf',NULL,'flowtrack/documents/34/1f065c85-8ea5-4651-bf66-9e6f46c64209.pdf','application/pdf',739204,1,0,'2026-08-14 01:40:30','2026-08-14 01:40:30'),(39,'DOC-000039',34,14,NULL,47,'Order attachment','Topcon - Knit Scarf with Tassles - (1).png',NULL,'flowtrack/documents/34/88dca84d-169b-42fb-b7ca-c4c3848d30c2.png','image/png',147952,1,0,'2026-08-14 01:40:30','2026-08-14 01:40:30'),(40,'DOC-000040',34,14,NULL,47,'Order attachment','Topcon - Knit Scarf with Tassles - CMYK.png',NULL,'flowtrack/documents/34/b03f7ca6-644b-4707-88a7-e0d47b27dcbb.png','image/png',3614,1,0,'2026-08-14 01:40:30','2026-08-14 01:40:30'),(41,'DOC-000041',35,14,NULL,47,'Order attachment','ear band patches.pdf',NULL,'flowtrack/documents/35/ba10b75c-94ff-4b88-b1c6-58dcc0ca9f9c.pdf','application/pdf',1228019,1,0,'2026-08-14 02:04:28','2026-08-14 02:04:28'),(42,'DOC-000042',35,14,NULL,47,'Order attachment','Special quote from AMY (3).png',NULL,'flowtrack/documents/35/1135f29c-0810-4299-9d24-55337316018f.png','image/png',71654,1,0,'2026-08-14 02:04:28','2026-08-14 02:04:28'),(43,'DOC-000043',36,11,NULL,37,'Order attachment','FO-331114(1-2).pdf',NULL,'flowtrack/documents/36/a86d568d-53c3-47b7-9d50-1359ea6aeca8.pdf','application/pdf',1358459,1,0,'2026-08-14 02:07:46','2026-08-14 02:07:46'),(44,'DOC-000044',37,11,NULL,36,'Order attachment','FO-331396.pdf',NULL,'flowtrack/documents/37/c0b7e64f-6ff5-4362-9498-00d085c9c315.pdf','application/pdf',3642037,1,0,'2026-08-14 04:53:29','2026-08-14 04:53:29'),(45,'DOC-000045',38,11,NULL,36,'Order attachment','FO-331385.pdf',NULL,'flowtrack/documents/38/2b41123f-d703-4637-b2a4-78e8e40e7d74.pdf','application/pdf',20862442,1,0,'2026-08-14 04:59:19','2026-08-14 04:59:19');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29
-- DATA SKIPPED FOR SECURITY/RUNTIME TABLE: failed_jobs

-- ==================================================
-- SAMPLE DATA: flow_job_collections
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_job_collections`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_job_collections` WRITE;
/*!40000 ALTER TABLE `flow_job_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_job_collections` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:29

-- ==================================================
-- SAMPLE DATA: flow_job_inquiries
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_job_inquiries`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_job_inquiries` WRITE;
/*!40000 ALTER TABLE `flow_job_inquiries` DISABLE KEYS */;
INSERT  IGNORE INTO `flow_job_inquiries` VALUES (1,35,44,47,'2026-08-14 02:04:28','2026-09-02 19:28:06'),(2,536,252,47,'2026-09-02 19:53:36','2026-09-03 01:34:08'),(7,34,259,47,'2026-09-03 17:16:08','2026-09-03 17:16:08'),(8,344,220,47,'2026-09-03 17:17:11','2026-09-03 17:17:11'),(9,329,261,47,'2026-09-03 17:23:52','2026-09-03 17:23:52'),(10,636,262,47,'2026-09-06 17:12:56','2026-09-06 17:12:56'),(11,638,255,36,'2026-09-07 21:55:57','2026-09-07 21:55:57'),(12,612,256,36,'2026-09-07 22:17:59','2026-09-07 22:17:59'),(13,613,257,36,'2026-09-07 22:24:38','2026-09-07 22:24:38'),(14,649,308,47,'2026-09-10 17:19:34','2026-09-10 17:19:34'),(15,888,362,47,'2026-09-17 17:40:38','2026-09-17 17:40:38'),(16,879,374,47,'2026-09-17 17:45:50','2026-09-17 17:45:50'),(17,881,407,47,'2026-09-17 17:51:03','2026-09-17 17:51:03');
/*!40000 ALTER TABLE `flow_job_inquiries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: flow_job_items
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_job_items`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_job_items` WRITE;
/*!40000 ALTER TABLE `flow_job_items` DISABLE KEYS */;
INSERT  IGNORE INTO `flow_job_items` VALUES (1,1,NULL,NULL,'Woven Lanyard','Lanyards',10000,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:30','2026-08-04 19:08:30'),(2,2,NULL,NULL,'Embroidered Cap','Caps',2500,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:30','2026-08-04 19:08:30'),(3,3,NULL,NULL,'Sublimation Jersey','Garments',1200,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:30','2026-08-04 19:08:30'),(4,3,NULL,NULL,'Companion Sublimation Jersey','Garments',360,0.00,NULL,0,NULL,NULL,NULL,NULL,1,'2026-08-04 19:08:30','2026-08-04 19:08:30'),(5,4,NULL,NULL,'Hard-shell Luggage','Luggage',800,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:31','2026-08-04 19:08:31'),(6,5,NULL,NULL,'Drawstring Backpack','Backpacks',5000,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:31','2026-08-04 19:08:31'),(7,6,NULL,NULL,'Silicone Wristband','Wristbands',20000,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:31','2026-08-04 19:08:31'),(8,7,NULL,NULL,'Polo Shirt','Garments',1800,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:31','2026-08-04 19:08:31'),(9,7,NULL,NULL,'Companion Polo Shirt','Garments',540,0.00,NULL,0,NULL,NULL,NULL,NULL,1,'2026-08-04 19:08:31','2026-08-04 19:08:31'),(10,8,NULL,NULL,'Canvas Tote Bag','Bags',6000,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:31','2026-08-04 19:08:31'),(11,9,NULL,NULL,'Debossed Wristband','Wristbands',7500,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:31','2026-08-04 19:08:31'),(12,10,NULL,NULL,'Printed Lanyard','Lanyards',3500,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:32','2026-08-04 19:08:32'),(13,11,NULL,NULL,'Laptop Backpack','Backpacks',1500,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:32','2026-08-04 19:08:32'),(14,11,NULL,NULL,'Companion Laptop Backpack','Backpacks',450,0.00,NULL,0,NULL,NULL,NULL,NULL,1,'2026-08-04 19:08:32','2026-08-04 19:08:32'),(15,12,NULL,NULL,'Dry-fit T-shirt','Garments',4000,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:32','2026-08-04 19:08:32'),(16,13,NULL,NULL,'Welcome Kit','Gift Sets',900,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:32','2026-08-04 19:08:32'),(17,14,NULL,NULL,'Travel Duffel','Bags',600,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:32','2026-08-04 19:08:32'),(18,15,NULL,NULL,'Performance Cap','Caps',3000,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:33','2026-08-04 19:08:33'),(19,15,NULL,NULL,'Companion Performance Cap','Caps',900,0.00,NULL,0,NULL,NULL,NULL,NULL,1,'2026-08-04 19:08:33','2026-08-04 19:08:33'),(20,16,NULL,NULL,'Uniform Set','Garments',1100,0.00,NULL,0,NULL,NULL,NULL,NULL,0,'2026-08-04 19:08:33','2026-08-04 19:08:33');
/*!40000 ALTER TABLE `flow_job_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: flow_job_members
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_job_members`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_job_members` WRITE;
/*!40000 ALTER TABLE `flow_job_members` DISABLE KEYS */;
INSERT  IGNORE INTO `flow_job_members` VALUES (93,19,1,'lead',1,1,1,'2026-08-04 21:54:17','2026-08-04 21:54:17'),(94,20,1,'lead',1,1,1,'2026-08-05 05:21:54','2026-08-05 05:21:54'),(95,7,34,'member',0,1,0,'2026-08-05 06:35:48','2026-08-05 06:35:48'),(96,10,34,'member',0,1,0,'2026-08-05 06:35:48','2026-08-05 06:35:48'),(97,13,34,'member',0,1,0,'2026-08-05 06:35:48','2026-08-05 06:35:48'),(98,17,34,'member',0,1,0,'2026-08-05 06:35:48','2026-08-05 06:35:48'),(99,19,34,'member',0,1,0,'2026-08-05 06:35:48','2026-08-05 06:35:48'),(100,20,34,'member',0,1,0,'2026-08-05 06:35:48','2026-08-05 06:35:48'),(101,21,57,'lead',1,1,1,'2026-08-05 06:40:38','2026-08-05 06:40:38'),(102,21,1,'member',0,1,0,'2026-08-05 06:40:38','2026-08-05 06:40:38'),(103,21,16,'member',0,1,0,'2026-08-05 06:40:38','2026-08-05 06:40:38'),(104,21,26,'member',0,1,0,'2026-08-05 06:40:39','2026-08-05 06:40:39'),(105,21,48,'member',0,1,0,'2026-08-05 06:42:38','2026-08-05 06:42:38'),(106,21,44,'member',0,1,0,'2026-08-05 06:42:55','2026-08-05 06:42:55'),(107,22,57,'member',0,1,0,'2026-08-05 15:40:04','2026-08-05 16:10:55'),(108,22,34,'member',0,1,0,'2026-08-05 15:40:04','2026-08-05 15:40:04'),(109,22,14,'member',0,1,0,'2026-08-05 15:41:56','2026-08-05 15:41:56'),(110,22,37,'lead',1,1,1,'2026-08-05 16:10:55','2026-08-05 16:10:55'),(111,22,35,'member',0,1,0,'2026-08-05 16:43:38','2026-08-05 16:43:38'),(112,22,40,'member',0,1,0,'2026-08-05 19:32:16','2026-08-05 19:32:16');
/*!40000 ALTER TABLE `flow_job_members` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: flow_job_phase_histories
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_job_phase_histories`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_job_phase_histories` WRITE;
/*!40000 ALTER TABLE `flow_job_phase_histories` DISABLE KEYS */;
INSERT  IGNORE INTO `flow_job_phase_histories` VALUES (1,1,240,NULL,NULL,'2026-08-08','At Risk','active','2026-08-03 19:08:30',NULL,'2026-08-04 19:08:30','2026-08-07 08:34:44'),(2,2,183,NULL,NULL,'2026-08-21','Needs Attention','active','2026-08-02 19:08:30',NULL,'2026-08-04 19:08:30','2026-08-07 08:34:43'),(3,3,206,NULL,NULL,'2026-09-03','On Track','active','2026-08-01 19:08:30',NULL,'2026-08-04 19:08:31','2026-08-07 08:34:43'),(4,4,251,NULL,NULL,'2026-08-29','Blocked','active','2026-07-31 19:08:31',NULL,'2026-08-04 19:08:31','2026-08-07 08:34:44'),(5,5,274,NULL,NULL,'2026-08-04','On Track','active','2026-07-30 19:08:31',NULL,'2026-08-04 19:08:31','2026-08-07 08:34:44'),(6,6,308,NULL,NULL,'2026-07-18','Needs Attention','active','2026-08-03 19:08:31',NULL,'2026-08-04 19:08:31','2026-08-07 08:34:44'),(7,7,148,NULL,NULL,'2026-09-18','On Track','active','2026-08-02 19:08:31',NULL,'2026-08-04 19:08:31','2026-08-07 08:34:43'),(8,8,320,NULL,NULL,'2026-07-12','Completed','active','2026-08-01 19:08:31',NULL,'2026-08-04 19:08:31','2026-08-07 08:34:44'),(9,9,285,NULL,NULL,'2026-08-02','On Track','active','2026-07-31 19:08:32',NULL,'2026-08-04 19:08:32','2026-08-07 08:34:44'),(10,10,136,NULL,NULL,'2026-09-02','On Track','active','2026-07-30 19:08:32',NULL,'2026-08-04 19:08:32','2026-08-07 08:34:43'),(11,11,172,NULL,NULL,'2026-08-25','At Risk','active','2026-08-03 19:08:32',NULL,'2026-08-04 19:08:32','2026-08-07 08:34:43'),(12,12,229,NULL,NULL,'2026-08-16','On Track','active','2026-08-02 19:08:32',NULL,'2026-08-04 19:08:32','2026-08-07 08:34:44'),(13,13,113,NULL,NULL,'2026-10-01','On Track','active','2026-08-01 19:08:32',NULL,'2026-08-04 19:08:32','2026-08-07 08:34:42'),(14,14,297,NULL,NULL,'2026-07-28','On Track','active','2026-07-31 19:08:33',NULL,'2026-08-04 19:08:33','2026-08-07 08:34:44'),(15,15,195,NULL,NULL,'2026-08-17','Needs Attention','active','2026-07-30 19:08:33',NULL,'2026-08-04 19:08:33','2026-08-07 08:34:43'),(16,16,218,NULL,NULL,'2026-08-10','Delayed','active','2026-08-03 19:08:33',NULL,'2026-08-04 19:08:33','2026-08-07 08:34:44'),(17,17,101,NULL,NULL,'2026-09-30','On Track','completed','2026-08-02 19:08:34','2026-08-04 20:27:27','2026-08-04 19:08:34','2026-08-07 08:34:42'),(18,18,263,NULL,NULL,'2026-08-01','On Track','active','2026-08-01 19:08:34',NULL,'2026-08-04 19:08:34','2026-08-07 08:34:44'),(19,17,102,1,NULL,'2026-09-30','On Track','active','2026-08-04 20:27:27',NULL,'2026-08-04 20:27:27','2026-08-07 08:34:42'),(20,19,68,1,1,'2026-09-04','On Track','active','2026-08-04 21:54:17',NULL,'2026-08-04 21:54:17','2026-08-07 08:34:42');
/*!40000 ALTER TABLE `flow_job_phase_histories` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: flow_jobs
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_jobs`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_jobs` WRITE;
/*!40000 ALTER TABLE `flow_jobs` DISABLE KEYS */;
INSERT  IGNORE INTO `flow_jobs` VALUES (1,'JOB-2026-00125','ORD-2026-00089',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,22,240,240,NULL,NULL,1,'10,000 woven lanyards for annual conference','Woven Lanyard','Lanyards',10000,12400.00,'USD','In Progress','At Risk','High',NULL,NULL,0,'same_address',68,'2026-08-08',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Resolve dye colour variation',NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 21:05:34',1,8,NULL,0,NULL,NULL,NULL,NULL,NULL),(2,'JOB-2026-00124','ORD-2026-00088',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,17,183,183,NULL,NULL,1,'Custom navy baseball caps','Embroidered Cap','Caps',2500,16750.00,'USD','Waiting for Client','Needs Attention','High',NULL,NULL,0,'same_address',43,'2026-08-21',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Client artwork approval',NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43','2026-08-04 21:05:35',1,6,NULL,0,NULL,NULL,NULL,NULL,NULL),(3,'JOB-2026-00123','ORD-2026-00087',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,19,206,206,NULL,NULL,1,'Junior football club jerseys','Sublimation Jersey','Garments',1200,22800.00,'USD','In Progress','On Track','Medium',NULL,NULL,0,'same_address',55,'2026-09-03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Approve second fabric swatch',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43','2026-08-04 21:05:35',1,7,NULL,0,NULL,NULL,NULL,NULL,NULL),(4,'JOB-2026-00122','ORD-2026-00086',NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,23,251,251,NULL,NULL,1,'Premium carry-on luggage collection','Hard-shell Luggage','Luggage',800,62400.00,'USD','Blocked','Blocked','Critical',NULL,NULL,0,'same_address',61,'2026-08-29',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Confirm replacement wheel supplier',NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 21:05:36',1,8,NULL,0,NULL,NULL,NULL,NULL,NULL),(5,'JOB-2026-00121','ORD-2026-00085',NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,25,274,274,NULL,NULL,1,'Conference drawstring backpacks','Drawstring Backpack','Backpacks',5000,19500.00,'USD','Ready','On Track','High',NULL,NULL,0,'same_address',82,'2026-08-04',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Complete shipment booking',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 21:05:36',1,9,NULL,0,NULL,NULL,NULL,NULL,NULL),(6,'JOB-2026-00120','ORD-2026-00084',NULL,NULL,NULL,NULL,NULL,NULL,NULL,6,28,308,308,NULL,NULL,1,'Silicone wristbands — 6 colour mix','Silicone Wristband','Wristbands',20000,9800.00,'USD','Waiting for Payment','Needs Attention','Medium',NULL,NULL,0,'same_address',84,'2026-07-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Follow up overdue balance',NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 21:05:37',1,10,NULL,0,NULL,NULL,NULL,NULL,NULL),(7,'JOB-2026-00119',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,14,148,148,NULL,NULL,1,'Hotel staff polo shirts','Polo Shirt','Garments',1800,0.00,'USD','Negotiation','On Track','Medium',NULL,NULL,0,'same_address',24,'2026-09-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Revise quotation pricing',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43','2026-08-04 21:05:38',1,4,NULL,0,NULL,NULL,NULL,NULL,NULL),(8,'JOB-2026-00118','ORD-2026-00083',NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,29,320,320,NULL,NULL,1,'Retail launch canvas tote bags','Canvas Tote Bag','Bags',6000,27600.00,'USD','Completed','Completed','Medium',NULL,NULL,0,'same_address',100,'2026-07-12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Closed',NULL,NULL,1,0,NULL,NULL,NULL,NULL,'2026-07-15 19:08:28','2026-08-04 19:08:28','2026-08-10 01:26:17','2026-08-10 01:26:17',1,11,NULL,0,NULL,NULL,NULL,NULL,NULL),(9,'JOB-2026-00117','ORD-2026-00082',NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,26,285,285,NULL,NULL,1,'School house-colour wristbands','Debossed Wristband','Wristbands',7500,6900.00,'USD','In Transit','On Track','Medium',NULL,NULL,0,'same_address',86,'2026-08-02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Monitor DHL delivery',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 21:05:38',1,9,NULL,0,NULL,NULL,NULL,NULL,NULL),(10,'JOB-2026-00116',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,13,136,136,NULL,NULL,1,'Festival staff badge lanyards','Printed Lanyard','Lanyards',3500,0.00,'USD','Submitted','On Track','Low',NULL,NULL,0,'same_address',18,'2026-09-02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Await quotation response',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43','2026-08-04 21:05:39',1,3,NULL,0,NULL,NULL,NULL,NULL,NULL),(11,'JOB-2026-00115','ORD-2026-00081',NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,16,172,172,NULL,NULL,1,'Premium laptop backpacks','Laptop Backpack','Backpacks',1500,47250.00,'USD','Revision Required','At Risk','High',NULL,NULL,0,'same_address',39,'2026-08-25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Artwork revision v3',NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43','2026-08-04 20:32:52',1,6,NULL,0,NULL,NULL,NULL,NULL,NULL),(12,'JOB-2026-00114','ORD-2026-00080',NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,21,229,229,NULL,NULL,1,'Running event dry-fit T-shirts','Dry-fit T-shirt','Garments',4000,28800.00,'USD','In Progress','On Track','High',NULL,NULL,0,'same_address',72,'2026-08-16',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Complete 75% production update',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 20:32:52',1,8,NULL,0,NULL,NULL,NULL,NULL,NULL),(13,'JOB-2026-00113',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,11,113,113,NULL,NULL,1,'Employee welcome kit quotation','Welcome Kit','Gift Sets',900,0.00,'USD','In Progress','On Track','Low',NULL,NULL,0,'same_address',10,'2026-10-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Collect supplier costs',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:42','2026-08-04 20:32:53',1,2,NULL,0,NULL,NULL,NULL,NULL,NULL),(14,'JOB-2026-00112','ORD-2026-00079',NULL,NULL,NULL,NULL,NULL,NULL,NULL,6,27,297,297,NULL,NULL,1,'Executive travel duffel bags','Travel Duffel','Bags',600,20400.00,'USD','Partially Paid','On Track','Medium',NULL,NULL,0,'same_address',94,'2026-07-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Collect final 40% payment',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 20:32:54',1,10,NULL,0,NULL,NULL,NULL,NULL,NULL),(15,'JOB-2026-00111','ORD-2026-00078',NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,18,195,195,NULL,NULL,1,'Branded marathon caps','Performance Cap','Caps',3000,17100.00,'USD','Waiting for Supplier','Needs Attention','High',NULL,NULL,0,'same_address',49,'2026-08-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Supplier to resubmit colour swatch',NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43','2026-08-04 20:32:40',1,7,NULL,0,NULL,NULL,NULL,NULL,NULL),(16,'JOB-2026-00110','ORD-2026-00077',NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,20,218,218,NULL,NULL,1,'Resort housekeeping uniforms','Uniform Set','Garments',1100,31900.00,'USD','In Progress','Delayed','Critical',NULL,NULL,0,'same_address',63,'2026-08-10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Recover 3-day production delay',NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 20:32:41',1,8,NULL,0,NULL,NULL,NULL,NULL,NULL),(17,'JOB-2026-00109',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,10,102,102,NULL,NULL,1,'Promotional luggage tags','PVC Luggage Tag','Travel Accessories',9000,0.00,'USD','In Progress','On Track','Low',NULL,NULL,0,'same_address',9,'2026-09-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Requirement confirmed',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:42','2026-08-04 20:32:42',1,2,NULL,0,NULL,NULL,NULL,NULL,NULL),(18,'JOB-2026-00108','ORD-2026-00076',NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,24,263,263,NULL,NULL,1,'Corporate anniversary jackets','Softshell Jacket','Garments',700,24500.00,'USD','Ready to Ship','On Track','High',NULL,NULL,0,'same_address',84,'2026-08-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Shipment release approval',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44','2026-08-04 20:32:42',1,9,NULL,0,NULL,NULL,NULL,NULL,NULL),(19,'JOB-2026-00144',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10,7,68,68,1,1,1,'sample','Silicone Wristband','Wristbands',1000,0.00,'USD','New','On Track','Critical',NULL,NULL,0,'same_address',0,'2026-09-04',NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Job created','Normal start',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-04 21:54:17','2026-08-07 08:34:42','2026-08-05 04:46:39',1,1,NULL,0,NULL,NULL,NULL,NULL,NULL),(20,'JOB-2026-00145',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,15,159,159,1,1,1,'sample ','Dye-Sublimation Utility Waist Apron w/ Two Front Pockets','10OZ canvas Apron',1001,0.00,'USD','New','On Track','Critical',NULL,NULL,0,'same_address',27,'2026-09-22',NULL,NULL,'sample',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Client feedback received','Normal start',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-08-05 05:21:54','2026-08-07 08:34:43','2026-08-05 06:53:43',1,4,NULL,0,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `flow_jobs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: flow_notifications
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_notifications`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_notifications` WRITE;
/*!40000 ALTER TABLE `flow_notifications` DISABLE KEYS */;
INSERT  IGNORE INTO `flow_notifications` VALUES (1,1,NULL,2,NULL,NULL,NULL,'approval','Artwork approval overdue','JOB-2026-00124 has been waiting for client approval for 3 days.','2026-08-05 15:45:13','2026-08-04 19:08:34','2026-08-05 15:45:13'),(2,1,NULL,4,NULL,NULL,NULL,'risk','Production blocker reported','Replacement wheel supplier is not confirmed for JOB-2026-00122.','2026-08-05 15:45:13','2026-08-04 19:08:34','2026-08-05 15:45:13'),(3,1,NULL,16,NULL,NULL,NULL,'mention','You were mentioned','Zhao Lin mentioned you in the production recovery discussion.','2026-08-05 15:45:13','2026-08-04 19:08:34','2026-08-05 15:45:13'),(4,1,NULL,6,NULL,NULL,NULL,'payment','Invoice is overdue','USD 3,500 remains outstanding for JOB-2026-00120.','2026-08-05 15:45:13','2026-08-04 19:08:34','2026-08-05 15:45:13'),(5,1,NULL,18,NULL,NULL,NULL,'shipment','Shipment ready for release','JOB-2026-00108 is ready for shipment approval.','2026-08-05 15:45:13','2026-08-04 19:08:34','2026-08-05 15:45:13'),(6,1,NULL,15,NULL,NULL,NULL,'file','Swatch revision uploaded','Supplier uploaded the second cap-colour swatch.','2026-08-05 15:45:13','2026-08-04 19:08:34','2026-08-05 15:45:13'),(7,1,NULL,6,22,NULL,NULL,'update','Task updated: Internal invoice review','Status changed from In Progress to Waiting for Client','2026-08-05 15:45:13','2026-08-04 19:48:52','2026-08-05 15:45:13'),(9,1,NULL,17,62,NULL,NULL,'update','Task updated: Collect supplier / factory costing','Status changed from In Progress to Completed · Progress changed from 75 to 100','2026-08-05 15:45:13','2026-08-04 20:26:26','2026-08-05 15:45:13'),(12,1,NULL,17,64,NULL,NULL,'update','Task updated: Internal quotation review','Status changed from Ready to Completed · Progress changed from 10 to 100','2026-08-05 15:45:13','2026-08-04 20:26:36','2026-08-05 15:45:13'),(15,1,NULL,17,69,NULL,NULL,'update','Task updated: Submit quotation','Status changed from Ready to Completed · Progress changed from 0 to 100','2026-08-05 15:45:13','2026-08-04 20:26:39','2026-08-05 15:45:13'),(17,1,NULL,17,63,NULL,NULL,'update','Document uploaded on Prepare quotation','Document uploaded: 6. Semester Wise Course Plan.pdf','2026-08-05 15:45:13','2026-08-04 20:27:07','2026-08-05 15:45:13'),(20,1,NULL,17,63,NULL,NULL,'update','Task updated: Prepare quotation','Status changed from Ready to Completed · Progress changed from 45 to 100','2026-08-05 15:45:13','2026-08-04 20:27:12','2026-08-05 15:45:13'),(23,1,NULL,17,NULL,NULL,NULL,'update','Job moved to Quotation in Progress','JOB-2026-00109 · Current phase is now Quotation in Progress','2026-08-05 15:45:13','2026-08-04 20:27:27','2026-08-05 15:45:13'),(25,1,NULL,15,NULL,NULL,NULL,'update','Job deleted','JOB-2026-00111 · Branded marathon caps','2026-08-05 15:45:13','2026-08-04 20:32:40','2026-08-05 15:45:13'),(27,1,NULL,16,NULL,NULL,NULL,'update','Job deleted','JOB-2026-00110 · Resort housekeeping uniforms','2026-08-05 15:45:13','2026-08-04 20:32:41','2026-08-05 15:45:13'),(29,1,NULL,17,NULL,NULL,NULL,'update','Job deleted','JOB-2026-00109 · Promotional luggage tags','2026-08-05 15:45:13','2026-08-04 20:32:41','2026-08-05 15:45:13'),(31,1,NULL,18,NULL,NULL,NULL,'update','Job deleted','JOB-2026-00108 · Corporate anniversary jackets','2026-08-05 15:45:13','2026-08-04 20:32:42','2026-08-05 15:45:13'),(33,1,NULL,11,NULL,NULL,NULL,'update','Job deleted','JOB-2026-00115 · Premium laptop backpacks','2026-08-05 15:45:13','2026-08-04 20:32:51','2026-08-05 15:45:13'),(35,1,NULL,12,NULL,NULL,NULL,'update','Job deleted','JOB-2026-00114 · Running event dry-fit T-shirts','2026-08-05 15:45:13','2026-08-04 20:32:52','2026-08-05 15:45:13'),(37,1,NULL,13,NULL,NULL,NULL,'update','Job deleted','JOB-2026-00113 · Employee welcome kit quotation','2026-08-05 15:45:13','2026-08-04 20:32:52','2026-08-05 15:45:13');
/*!40000 ALTER TABLE `flow_notifications` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: flow_task_checklist_items
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_task_checklist_items`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_task_checklist_items` WRITE;
/*!40000 ALTER TABLE `flow_task_checklist_items` DISABLE KEYS */;
INSERT  IGNORE INTO `flow_task_checklist_items` VALUES (2,215,'prepare the requirements sheet',1,1,'2026-08-05 06:46:13','2026-08-05 06:46:46'),(3,215,'submit for internal review.',1,2,'2026-08-05 06:46:37','2026-08-05 06:46:51'),(4,255,'I need to collect quotation',1,1,'2026-08-06 12:47:45','2026-08-06 12:52:39'),(5,255,'I need to prepare quotation',1,2,'2026-08-06 12:48:00','2026-08-06 12:52:52'),(6,255,'First Collect The  quotation',1,3,'2026-08-06 12:48:32','2026-08-06 12:52:52'),(7,257,'i need to check with Mr SHU',1,1,'2026-08-06 13:07:30','2026-08-06 13:08:34'),(8,257,'I also need to check with Ms Yang. for fabric',1,2,'2026-08-06 13:07:44','2026-08-06 13:10:15'),(9,257,'then i will prepare the quotation',1,3,'2026-08-06 13:07:57','2026-08-06 13:10:24'),(10,257,'Then will submit to momen',1,4,'2026-08-06 13:08:06','2026-08-06 13:10:27'),(11,257,'If momen apprives then i will submit to client',1,5,'2026-08-06 13:08:19','2026-08-06 13:12:45'),(12,258,'请查看附件并检查',0,1,'2026-08-06 14:01:44','2026-08-06 16:21:51'),(13,258,'pls check the quotation ,and sample list',0,2,'2026-08-06 14:05:17','2026-08-06 16:21:49'),(14,414,'Need to check document',0,1,'2026-08-08 07:46:53','2026-08-08 07:46:53');
/*!40000 ALTER TABLE `flow_task_checklist_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: flow_task_comments
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `flow_task_comments`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `flow_task_comments` WRITE;
/*!40000 ALTER TABLE `flow_task_comments` DISABLE KEYS */;
INSERT  IGNORE INTO `flow_task_comments` VALUES (1,1,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:30','2026-08-04 19:08:30'),(2,2,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:30','2026-08-04 19:08:30'),(3,3,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:30','2026-08-04 19:08:30'),(4,3,NULL,'Resolve dye colour variation','2026-08-04 19:08:30','2026-08-04 19:08:30'),(5,4,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:30','2026-08-04 19:08:30'),(6,5,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:30','2026-08-04 19:08:30'),(7,6,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:30','2026-08-04 19:08:30'),(8,7,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:30','2026-08-04 19:08:30'),(9,7,NULL,'Client artwork approval','2026-08-04 19:08:30','2026-08-04 19:08:30'),(10,8,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:30','2026-08-04 19:08:30'),(11,9,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31'),(12,10,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31'),(13,11,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31'),(14,12,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31'),(15,13,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31'),(16,14,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31'),(17,15,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31'),(18,15,NULL,'Confirm replacement wheel supplier','2026-08-04 19:08:31','2026-08-04 19:08:31'),(19,16,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31'),(20,17,NULL,'Task created from the configured phase Task Pack.','2026-08-04 19:08:31','2026-08-04 19:08:31');
/*!40000 ALTER TABLE `flow_task_comments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiries
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiries`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiries` WRITE;
/*!40000 ALTER TABLE `inquiries` DISABLE KEYS */;
INSERT  IGNORE INTO `inquiries` VALUES (1,1,'INQ-2026-0001',11,1,1,NULL,30,'Sample','Amin','2026-08-09',NULL,'Sample Inquiery','Sample Inquiry',NULL,'USD',NULL,'Critical',NULL,'Waiting for Supplier',0,NULL,NULL,NULL,'2026-08-09 05:55:08',NULL,NULL,NULL,28,NULL,'2026-08-09 05:55:08','2026-08-10 04:19:40','2026-08-10 04:19:40'),(2,1,'INQ-2026-0002',11,1,1,NULL,33,'SAM0002','Amin','2026-08-09',NULL,'Sample Inquiry 3','Sample inuqiry',NULL,'USD',NULL,'Medium',NULL,'In Progress',0,NULL,NULL,NULL,'2026-08-09 10:05:09',NULL,NULL,NULL,NULL,NULL,'2026-08-09 10:05:09','2026-08-10 01:25:51','2026-08-10 01:25:51'),(3,1,'INQ-2026-0003',13,1,1,NULL,33,'sample','sample','2026-08-10','Other','sample','<!--flowtrack-rich-text-->hello<br><img src=\"/rich-text-images/1fc105c9-da04-4563-969f-3b9373f2d1b8.png\" alt=\"Pasted image\" loading=\"lazy\"><br><br>',NULL,'USD',NULL,'Medium',NULL,'In Progress',0,NULL,NULL,NULL,'2026-08-09 21:37:39',NULL,NULL,NULL,28,NULL,'2026-08-09 21:37:07','2026-08-10 07:43:49','2026-08-10 07:43:49'),(4,1,'INQ-2026-0004',14,1,1,NULL,33,'RF-0001','Ashraf','2026-08-10','Phone','2500 pcs of socks and 350 pcs of Lanyards','<!--flowtrack-rich-text-->Need to send quotationt to Arman ASAP.',NULL,'USD',NULL,'Medium',NULL,'In Progress',0,NULL,NULL,NULL,'2026-08-10 11:22:23',NULL,NULL,NULL,NULL,NULL,'2026-08-10 08:38:26','2026-08-10 11:22:45','2026-08-10 11:22:45'),(5,1,'INQ-2026-0005',14,33,1,NULL,36,'RF0002','Ashraf','2026-08-11','Email','999 Pcs of Power Bank','<!--flowtrack-rich-text-->This is sample Inquiry',NULL,'USD',NULL,'Medium',NULL,'In Progress',0,NULL,NULL,NULL,'2026-08-10 10:15:41',NULL,NULL,NULL,NULL,NULL,'2026-08-10 10:15:04','2026-08-10 11:22:41','2026-08-10 11:22:41'),(6,1,'INQ-2026-0006',14,15,15,NULL,36,NULL,'sample','2026-08-11','Email','QT0810908','<!--flowtrack-rich-text--><p><br></p><p>Need a quote on your item bcp-stk-b131.\n</p><p>1,500 units with 2 embroidered patches. 2.5 and max size on front.</p><p>\n</p>',NULL,'USD',NULL,'Medium',NULL,'Ready',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 22:38:30','2026-08-10 22:50:43','2026-08-10 22:50:43'),(7,1,'INQ-2026-0007',14,15,15,NULL,36,NULL,'sample','2026-08-11','Email','RFQ-BG-PP-R8FC13 and Lanyard','<!--flowtrack-rich-text-->Hi Amy,\n<p>Could you please quote the following items?\n</p><p>Laminated Tote Bag – BG-PP-R8FC13\n</p><p>Size: 15\" H × 13\" W × 10\" D\n</p><p>Handle length: 22\"\n</p><p>Quantity: 1,150\n</p><p>Full-color artwork on both sides\n</p><p>Lanyards\n</p><p>Size: 3/4\" wide\n</p><p>Attachment: Bulldog clip\n</p><p>White: 1,200 pieces\n</p><p>Black: 1,000 pieces\n</p><p>Full-color artwork on both sides\n</p><p>Please include:\n</p><p>Unit pricing and setup charges\n</p><p>Production time\n</p><p>Shipping cost to ZIP code 02108\n</p><p>Air and ocean shipping options, if available\n</p><p><br></p>',NULL,'USD',NULL,'Medium',NULL,'Ready',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-10 22:39:46','2026-08-10 22:50:40','2026-08-10 22:50:40'),(8,1,'INQ-2026-0008',14,15,15,NULL,36,NULL,'sample','2026-08-11','Email','RFQ-BG-PP-R8FC13 and Lanyard','<!--flowtrack-rich-text-->Hi Amy,\n<p>Could you please quote the following items?\n</p><p>Laminated Tote Bag – BG-PP-R8FC13\n</p><p>Size: 15\" H × 13\" W × 10\" D\n</p><p>Handle length: 22\"\n</p><p>Quantity: 1,150\n</p><p>Full-color artwork on both sides\n</p><p>Lanyards\n</p><p>Size: 3/4\" wide\n</p><p>Attachment: Bulldog clip\n</p><p>White: 1,200 pieces\n</p><p>Black: 1,000 pieces\n</p><p>Full-color artwork on both sides\n</p><p>Please include:\n</p><p>Unit pricing and setup charges\n</p><p>Production time\n</p><p>Shipping cost to ZIP code 02108\n</p><p>Air and ocean shipping options, if available\n</p><p><br></p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-10 23:13:44',NULL,NULL,NULL,NULL,'2026-08-10 23:27:38','2026-08-10 22:51:29','2026-08-13 09:32:07',NULL),(9,1,'INQ-2026-0009',14,50,15,NULL,36,'QT0810908','sample','2026-08-11','Email','QT0810908','<!--flowtrack-rich-text-->Hello Amy,\n<p>\n</p><p>Need a quote on your item bcp-stk-b131.\n</p><p>1,500 units with 2 embroidered patches. 2.5 and max size on front.</p><p>\n</p>',NULL,'USD',NULL,'Medium',NULL,'Ready',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-08-11 00:20:58','2026-08-11 00:22:14','2026-08-11 00:22:14'),(10,1,'INQ-2026-0010',14,51,15,NULL,36,'QT0810908','sample','2026-08-11','Email','QT0810908','<!--flowtrack-rich-text-->Hello Amy,\n<p>\n</p><p><ol><li>Need a quote on your item bcp-stk-b131.\n</li><li>1,500 units with 2 embroidered patches. 2.5 and max size on front.\n</li></ol></p><p><br><br><strong>You can also copy and paste screen shots here.<br><br>You璀璨 土黄色&nbsp;</strong></p><p>\n</p>',NULL,'USD',NULL,'Critical',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-11 00:51:24',NULL,NULL,NULL,NULL,'2026-08-11 02:55:24','2026-08-11 00:22:57','2026-08-13 09:36:52',NULL),(11,1,'INQ-2026-0011',11,60,60,NULL,33,'ES-219208','Amin','2026-08-11','Email','Lapel Pins ES-219208','<!--flowtrack-rich-text-->Hello,<p><br></p><p>Can you send me pricing for 4 different options. Customer is looking for 2 different designs of lapel pins (100 each):</p><p><br></p><p>Option 1:      All Black Lapel Pins (Custom Shape with Pin Back)</p><p>Option 1.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Dyed Black Nickel Plating</p><p>Prints:  Die Struck Direct</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>Option 1.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single card, then polybagged.</p><p>&nbsp;</p><p><br></p><p>Option 2:      Soft Enamel Lapel Pins (Custom Shape with Pin Back)</p><p>option 2.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Nickel Plating</p><p>Prints:  Soft Enamel with 2 Color Fill</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>option 2.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single Custom Card, then polybagged.</p><p>&nbsp;</p><p><br></p><p><br></p><p>Thank you,</p><p>Danny</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:28:12',NULL,NULL,NULL,NULL,'2026-08-17 17:15:44','2026-08-11 01:29:53','2026-08-17 17:15:44',NULL),(12,1,'INQ-2026-0012',11,40,60,NULL,33,'ES-219208','Amin','2026-08-11','Email','Lapel Pins ES-219208','<!--flowtrack-rich-text-->Hello,<p><br></p><p>Can you send me pricing for 4 different options. Customer is looking for 2 different designs of lapel pins (100 each):</p><p><br></p><p>Option 1:      All Black Lapel Pins (Custom Shape with Pin Back)</p><p>Option 1.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Dyed Black Nickel Plating</p><p>Prints:  Die Struck Direct</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>Option 1.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single card, then polybagged.</p><p>&nbsp;</p><p><br></p><p>Option 2:      Soft Enamel Lapel Pins (Custom Shape with Pin Back)</p><p>option 2.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Nickel Plating</p><p>Prints:  Soft Enamel with 2 Color Fill</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>option 2.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single Custom Card, then polybagged.</p><p>&nbsp;</p><p><br></p><p><br></p><p>Thank you,</p><p>Danny</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:27:32',NULL,NULL,NULL,NULL,'2026-08-17 17:16:55','2026-08-11 01:30:52','2026-08-17 17:16:55',NULL),(13,1,'INQ-2026-0013',11,60,60,NULL,33,'ES-219208','Amin','2026-08-11','Email','Lapel Pins ES-219208','<!--flowtrack-rich-text-->Hello,<p><br></p><p>Can you send me pricing for 4 different options. Customer is looking for 2 different designs of lapel pins (100 each):</p><p><br></p><p>Option 1:      All Black Lapel Pins (Custom Shape with Pin Back)</p><p>Option 1.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Dyed Black Nickel Plating</p><p>Prints:  Die Struck Direct</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>Option 1.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single card, then polybagged.</p><p>&nbsp;</p><p><br></p><p>Option 2:      Soft Enamel Lapel Pins (Custom Shape with Pin Back)</p><p>option 2.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Nickel Plating</p><p>Prints:  Soft Enamel with 2 Color Fill</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>option 2.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single Custom Card, then polybagged.</p><p>&nbsp;</p><p><br></p><p><br></p><p>Thank you,</p><p>Danny</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:26:37',NULL,NULL,NULL,NULL,'2026-08-17 17:17:18','2026-08-11 01:32:05','2026-08-17 17:17:18',NULL),(14,1,'INQ-2026-0014',11,40,60,NULL,33,'ES-219208','Amin','2026-08-11','Email','Lapel Pins ES-219208','<!--flowtrack-rich-text-->Hello,<p><br></p><p>Can you send me pricing for 4 different options. Customer is looking for 2 different designs of lapel pins (100 each):</p><p><br></p><p>Option 1:      All Black Lapel Pins (Custom Shape with Pin Back)</p><p>Option 1.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Dyed Black Nickel Plating</p><p>Prints:  Die Struck Direct</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>Option 1.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single card, then polybagged.</p><p>&nbsp;</p><p><br></p><p>Option 2:      Soft Enamel Lapel Pins (Custom Shape with Pin Back)</p><p>option 2.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Nickel Plating</p><p>Prints:  Soft Enamel with 2 Color Fill</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>option 2.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single Custom Card, then polybagged.</p><p>&nbsp;</p><p><br></p><p><br></p><p>Thank you,</p><p>Danny</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:25:43',NULL,NULL,NULL,NULL,'2026-08-17 17:17:48','2026-08-11 01:49:17','2026-08-17 17:17:48',NULL),(15,1,'INQ-2026-0015',11,40,60,NULL,33,'ES-219208','Amin','2026-08-11','Email','Lapel Pins ES-219208','<!--flowtrack-rich-text-->Hello,<p><br></p><p>Can you send me pricing for 4 different options. Customer is looking for 2 different designs of lapel pins (100 each):</p><p><br></p><p>Option 1:      All Black Lapel Pins (Custom Shape with Pin Back)</p><p>Option 1.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Dyed Black Nickel Plating</p><p>Prints:  Die Struck Direct</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>Option 1.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single card, then polybagged.</p><p>&nbsp;</p><p><br></p><p>Option 2:      Soft Enamel Lapel Pins (Custom Shape with Pin Back)</p><p>option 2.1</p><p>Qty:     100 Republic Airways | 100 LIFT Academy</p><p>Size:     2.00”W x 0.92”H Republic | 1.5”W x 1.22”H LIFT</p><p>Stock:   Nickel Plating</p><p>Prints:  Soft Enamel with 2 Color Fill</p><p>Misc:   Butterfly Clutch &amp; Individually Polybagged</p><p>option 2.2</p><p>Same as above, except we want a Custom Backer Card as well as of polybagging.</p><p>Card Size is 3.5” x 3.5” | Prints 4/0 with Bleeds</p><p>Both pins (1 of each design) are applied to a single Custom Card, then polybagged.</p><p>&nbsp;</p><p><br></p><p><br></p><p>Thank you,</p><p>Danny</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:24:26',NULL,NULL,NULL,NULL,'2026-08-17 17:18:46','2026-08-11 05:40:18','2026-08-17 17:18:46',NULL),(16,1,'INQ-2026-0016',11,40,60,NULL,33,'ES-219191','Amin','2026-08-11','Email','Large quote request PB002 // ES-219191','<!--flowtrack-rich-text-->Hello,<p><br></p><p>I\'m looking for a pricing on #PB002</p><p>Quantity: 500</p><p>Decoration: Full Color Digital / 2 Locations (assuming both sides of the paddle)</p><p>Shipping to 97217</p><p><br></p><p>Thank you,</p><p>Julie</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:23:41',NULL,NULL,NULL,NULL,'2026-08-17 17:19:10','2026-08-11 05:41:10','2026-08-17 17:19:10',NULL),(17,1,'INQ-2026-0017',11,40,60,NULL,33,'ES-219178','Amin','2026-08-11','Email','Pricing needed - || ES-219178','<!--flowtrack-rich-text-->Hello there,<p><br></p><p>Can you please provide the pricing for the visor?</p><p><br></p><p>- VSIC148 - Fully Customizable Made-to-Order Visors</p><p><br></p><p>&nbsp;Style: Solid visor</p><p>• Material: Cotton</p><p>• Closure: Metal buckle</p><p>• Decoration: Custom embroidery</p><p><br></p><p>Qty: 12, 24, and 36 units.</p><p><br></p><p>Let me know if you have any questions.</p><p><br></p><p>Thank you</p><p>Martin</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:20:43',NULL,NULL,NULL,NULL,'2026-08-17 17:18:12','2026-08-11 05:41:40','2026-08-17 17:18:12',NULL),(18,1,'INQ-2026-0018',11,40,60,NULL,33,'ES -166981','Amin','2026-08-11','Email','NEW ORDER ES - 166981 FOR PRICING','<!--flowtrack-rich-text-->Please share the best pricing for economical laminate bags<p><br></p><p>15,000 - 20,000</p><p><br></p><p>15”x14”</p><p><br></p><p>with laminated handle.&nbsp;&nbsp;</p><p><br></p><p>shipping to 20109</p><p><br></p><p>Single color print  on a black or maroon bag</p><p><br></p><p>Thank you</p><p>Joe</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:20:01',NULL,NULL,NULL,NULL,'2026-08-17 17:16:31','2026-08-11 05:42:15','2026-08-17 17:16:31',NULL),(19,1,'INQ-2026-0019',11,40,60,NULL,33,'ES-219156','Amin','2026-08-11','Email','Pricing needed - || ES-219156','<!--flowtrack-rich-text-->Hello There,<p><br></p><p>Can you please provide a pricing quote?</p><p><br></p><p>We need a rubber patch with a Velcro back.</p><p><br></p><p>Approximately 3.5” diameter</p><p><br></p><p>&nbsp;2000 pieces</p><p><br></p><p>Shipping ZIP - Wichita, Kansas 67226</p><p><br></p><p>Thank you</p><p>Martin</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:18:35',NULL,NULL,NULL,NULL,'2026-08-21 01:18:37','2026-08-11 05:42:59','2026-08-21 01:18:37',NULL),(20,1,'INQ-2026-0020',11,40,60,NULL,33,'ES-219139','Amin','2026-08-11','Email','Pricing Request ES-219139','<!--flowtrack-rich-text-->Hello,<p><br></p><p>Can you please provide me with pricing for the following details:</p><p><br></p><p>Size: 8.5\" × 11\"</p><p>Pages: 70 pages</p><p>Binding: Spiral-bound</p><p>Cover: 100# gloss cover, full-color on one side</p><p>Back Cover: Black leatherette</p><p>Inside Pages: 70# text, 4/4 full color</p><p><br></p><p>Quantity: 300&nbsp;</p><p><br></p><p>&nbsp;ZIP code 33606 Tampa, Florida</p><p><br></p><p>Thank you,</p><p>Emily</p>',NULL,'USD',NULL,'Medium',NULL,'Completed',0,NULL,NULL,NULL,'2026-08-17 02:08:24',NULL,NULL,NULL,NULL,'2026-08-17 17:16:02','2026-08-11 05:44:33','2026-08-17 17:16:02',NULL);
/*!40000 ALTER TABLE `inquiries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_documents
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_documents`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_documents` WRITE;
/*!40000 ALTER TABLE `inquiry_documents` DISABLE KEYS */;
INSERT  IGNORE INTO `inquiry_documents` VALUES (1,1,NULL,1,'Codex Image Aug 9, 2026, 09_47_57 PM.png','flowtrack/inquiries/1/TYwb9vF22wvHAE3m3SXPoYXLyz1DXUD2fDMkCIX5.png','image/png',1028267,'2026-08-09 05:55:08','2026-08-09 05:55:08',NULL),(2,1,1,1,'Codex Image Aug 9, 2026, 09_47_57 PM.png','flowtrack/inquiries/1/RIMPt0FaflgMXLP1j9FGWvdT1JnLLMTQvQ3PU4re.png','image/png',1028267,'2026-08-09 05:55:41','2026-08-09 05:55:41',NULL),(5,3,29,1,'workflow issues.png','flowtrack/inquiries/3/5FyXMQFn5UTQ0H8gtBW6VxE38sTRDBWU5nQn3Qo9.png','image/png',275329,'2026-08-10 01:19:33','2026-08-10 01:19:33',NULL),(8,3,30,1,'FlowTrack_Bulk_Order_Import_Template_v2.xlsx','flowtrack/inquiries/3/bErGB6ztobCnBA8xyEW5OWRluluLuupxV1FXxTbl.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',21928,'2026-08-10 04:27:27','2026-08-10 04:27:27',NULL),(9,3,NULL,1,'FlowTrack-Revised-Task-Statuses-and-Flags.xlsx','flowtrack/inquiries/3/bDPhCca6qMya4dH86KjdF8VK2zbF4RECH9PvPGeM.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',13068,'2026-08-10 07:42:33','2026-08-10 07:42:33',NULL),(10,3,31,1,'FlowTrack-Revised-Task-Statuses-and-Flags.xlsx','flowtrack/inquiries/3/OD45tj0sovcCNZE9eVhu19sXTysJPu56iz6C05NE.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',13068,'2026-08-10 07:42:44','2026-08-10 07:42:44',NULL),(11,4,33,1,'FlowTrack-Revised-Task-Statuses-and-Flags.xlsx','flowtrack/inquiries/4/nT1m82eyUjbd7tIgs0QTMWaTYWg7FxKUfx6SPWSQ.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',13068,'2026-08-10 08:39:41','2026-08-10 08:39:41',NULL),(12,5,36,1,'NEP Logo.png','flowtrack/inquiries/5/wvsOGhXYjZ9qUleYsMKi4d2fpRbskbwY9kYKtG4n.png','image/png',13196,'2026-08-10 10:15:36','2026-08-10 10:15:36',NULL),(13,5,37,1,'NEP Logo.png','flowtrack/inquiries/5/pqAc2h0NacMA9UJPhydtaBwKDd8h3G59qBEi1s2x.png','image/png',13196,'2026-08-10 10:15:57','2026-08-10 10:15:57',NULL),(14,6,NULL,15,'报价 NEQ-2026699 QT0810908.xlsx','flowtrack/inquiries/6/y0qdvd5wQyJllTfo0iTMYMl5BxjM429GBUnH083U.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',744836,'2026-08-10 22:38:30','2026-08-10 22:38:30',NULL),(15,6,NULL,15,'报价 NEQ-2026699 QT0810908.xlsx','flowtrack/inquiries/6/dDMSEwCgjrcuOwlen38rwUHAsGDXi9jOspCJD14d.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',744836,'2026-08-10 22:38:30','2026-08-10 22:38:30',NULL),(16,7,NULL,15,'processed-ECA65CC2-97CA-447F-9891-4817C4962320.jpeg','flowtrack/inquiries/7/LiSdCFYwUtGpMfpEBWqoLODyVRoA7K4Ha6pXtu0r.jpg','image/jpeg',973831,'2026-08-10 22:39:46','2026-08-10 22:39:46',NULL),(17,7,NULL,15,'报价 NEQ-2026698 FQ-BG-PP-R8FC13 and Lanyard.xlsx','flowtrack/inquiries/7/8a1vqoDEMizSBkJ4mZmhmW1NTnHJOQ4qVaDTt2Ox.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',10790,'2026-08-10 22:39:46','2026-08-10 22:39:46',NULL),(18,8,NULL,15,'processed-ECA65CC2-97CA-447F-9891-4817C4962320.jpeg','flowtrack/inquiries/8/DLLCe4quiIn0tWr8SnLKA53Z5Nk3hzVNOdjBYfiA.jpg','image/jpeg',973831,'2026-08-10 22:51:29','2026-08-10 22:51:29',NULL),(19,8,NULL,15,'报价 NEQ-2026698 FQ-BG-PP-R8FC13 and Lanyard.xlsx','flowtrack/inquiries/8/kTqyNJgOB4u3UmUur1zApkymOMEcQYcgdKW3tl0H.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',10790,'2026-08-10 22:51:29','2026-08-10 22:51:29',NULL),(20,8,48,50,'2026698报价模板(1).xls','flowtrack/inquiries/8/k3AVYEOwyypsWifsMd5Zu7ehtsoOaLdjmcip7WmX.xls','application/vnd.ms-excel',1973248,'2026-08-10 23:14:49','2026-08-10 23:14:49',NULL),(21,8,49,51,'NEQ-2026698 COST FQ-BG-PP-R8FC13 and Lanyard.xls','flowtrack/inquiries/8/zuMrK0Xb7Tj6PGLQtAeZlAzopgNkqCn2TxLJbVGy.xls','application/vnd.ms-excel',2608128,'2026-08-10 23:17:00','2026-08-10 23:17:00',NULL),(22,8,50,51,'NEQ-2026698 OFFER FQ-BG-PP-R8FC13 and Lanyard.xlsx','flowtrack/inquiries/8/6iQfnAsj9NjCpzBP69BXejFwJzxi7YxAdsp0B4YZ.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',1182085,'2026-08-10 23:17:29','2026-08-10 23:17:29',NULL),(23,8,51,15,'__NEQ-2026698 OFFER FQ-BG-PP-R8FC13 and Lanyard.xlsx__','flowtrack/inquiries/8/OPw0f8HFAcbRb8pefDCBJhKFb7YoJZUMs2px43Fn.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',1182085,'2026-08-10 23:27:27','2026-08-10 23:27:27',NULL),(24,9,NULL,15,'报价 NEQ-2026699 QT0810908.xlsx','flowtrack/inquiries/9/5jssq8DCtoDZOiTAb2utNK3H8dGs5jO9Qt69ESy5.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',744836,'2026-08-11 00:20:58','2026-08-11 00:20:58',NULL);
/*!40000 ALTER TABLE `inquiry_documents` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_items
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_items`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_items` WRITE;
/*!40000 ALTER TABLE `inquiry_items` DISABLE KEYS */;
INSERT  IGNORE INTO `inquiry_items` VALUES (1,22,'120G Pongee','Sublimation Pongee Full-Button Shirt - Men, Women, Kids',1000.00,NULL,'pcs',NULL,0,'2026-08-11 09:15:24','2026-08-11 09:15:24'),(2,24,'Glove','Non-slip Gloves w/ 3 Finger Touch',1500.00,NULL,'pcs',NULL,0,'2026-08-11 16:56:38','2026-08-11 16:56:38'),(9,226,'Lanyards','1 inch Dye Sublimation Lanyards w/ Retractable Reel Combo',1000.00,NULL,'units',NULL,0,'2026-08-30 09:42:12','2026-08-30 09:42:12');
/*!40000 ALTER TABLE `inquiry_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_rfq_invitations
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_rfq_invitations`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_rfq_invitations` WRITE;
/*!40000 ALTER TABLE `inquiry_rfq_invitations` DISABLE KEYS */;
INSERT  IGNORE INTO `inquiry_rfq_invitations` VALUES (1,1,226,1349993,58,'806388674c3e13ee160cc86dacadb9a09c7f18d436d88c7ba4e5f88274524ed0','eyJpdiI6IlJkK2UvWXMxS2I3dWZFU1pQdzlWclE9PSIsInZhbHVlIjoiVkhvcXVnbzQ3ODBmUyt6SE81T0NFaXQxRmV0cHpYdHJXQ1lBWVBaRkhLMmpTYXJXQzdrUzJzdEsycW9Nd1djbjFBZmp2eXFjUTFzK0NiMTBSVHBtYVJSSnBtSUVrYytZV01pa1FtNjJVVlE9IiwibWFjIjoiNjAyMTlmNTlhMzA2Nzg4YzliNmVhMjEzNjljZDVmMTU3ZjY0NzUzYjI2OWI3YTkyMmM1MWRjOGEzY2Y4ZDFlYSIsInRhZyI6IiJ9',NULL,'2026-09-14 23:59:59','Please quote your best unit price, lead time, shipping and sample options.','Draft',NULL,NULL,'pending',NULL,'pending',NULL,NULL,NULL,NULL,'2026-08-30 09:42:12','2026-08-30 09:42:12',NULL,NULL,1,1,24,1,1,1),(2,1,226,1349994,58,'8a316a905564c6953ef634eeb8291366925a5af91e3f7ecd691dce78537f8227','eyJpdiI6InBsUjhBVVBsU0t6MnpodFRKWnVVK1E9PSIsInZhbHVlIjoiQUQwaWpIdURlQUVZRXQyTURHbUVOS0lkYUVPdncwWk0zaXRUK0IzeDBUKzBENzFJcUZ0Wmxia0FWbHlMUDdVRWFHbXNOYXVwellaNEdxQlFEdUE5clZ2MkhPTkRUcFA5Q0N4aDNySFlucXc9IiwibWFjIjoiYWRhZmEzODJhNTYxZGI1Y2I4ZTE4MDA4M2QxYmYxOTlhMjk2M2I2MjkyNWZmZTU5NjMwOTM1N2QxMDRmMWE1ZiIsInRhZyI6IiJ9',NULL,'2026-09-14 23:59:59','Please quote your best unit price, lead time, shipping and sample options.','Draft',NULL,NULL,'pending',NULL,'pending',NULL,NULL,NULL,NULL,'2026-08-30 09:42:12','2026-08-30 09:42:12',NULL,NULL,1,1,24,1,1,1);
/*!40000 ALTER TABLE `inquiry_rfq_invitations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_rfq_quote_documents
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_rfq_quote_documents`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_rfq_quote_documents` WRITE;
/*!40000 ALTER TABLE `inquiry_rfq_quote_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiry_rfq_quote_documents` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_rfq_quote_items
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_rfq_quote_items`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_rfq_quote_items` WRITE;
/*!40000 ALTER TABLE `inquiry_rfq_quote_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiry_rfq_quote_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_rfq_quotes
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_rfq_quotes`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_rfq_quotes` WRITE;
/*!40000 ALTER TABLE `inquiry_rfq_quotes` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiry_rfq_quotes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_rfq_settings
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_rfq_settings`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_rfq_settings` WRITE;
/*!40000 ALTER TABLE `inquiry_rfq_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiry_rfq_settings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_task_comments
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_task_comments`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_task_comments` WRITE;
/*!40000 ALTER TABLE `inquiry_task_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiry_task_comments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_task_links
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_task_links`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_task_links` WRITE;
/*!40000 ALTER TABLE `inquiry_task_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiry_task_links` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: inquiry_tasks
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `inquiry_tasks`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `inquiry_tasks` WRITE;
/*!40000 ALTER TABLE `inquiry_tasks` DISABLE KEYS */;
INSERT  IGNORE INTO `inquiry_tasks` VALUES (1,1,369,321,36,'2026-08-09 05:55:08',NULL,NULL,36,'Download & Upload Purchase Order',NULL,1,'2026-08-10','In Progress',1348922,0,NULL,'2026-08-09 05:55:08',1,'Client Purchase Order',NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(2,1,370,321,36,'2026-08-09 05:55:08',NULL,NULL,36,'Send Purchase Order to Artwork Team',NULL,2,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(3,1,371,322,36,'2026-08-09 05:55:08',NULL,NULL,36,'Prepare Artwork',NULL,3,'2026-08-10','Waiting',1348924,1,NULL,NULL,1,'Artwork Working File',NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(4,1,372,322,18,'2026-08-09 05:55:08',NULL,NULL,18,'Send Artwork to Order Team',NULL,4,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(5,1,373,322,36,'2026-08-09 05:55:08',NULL,NULL,36,'Upload Artwork to ERP',NULL,5,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(6,1,374,322,37,'2026-08-09 05:55:08',NULL,NULL,37,'Add Artwork Revision Comment',NULL,6,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(7,1,375,322,18,'2026-08-09 05:55:08',NULL,NULL,18,'Revise Artwork',NULL,7,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(8,1,376,322,37,'2026-08-09 05:55:08',NULL,NULL,37,'Upload Revised Artwork',NULL,8,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(9,1,377,322,38,'2026-08-18 21:53:08',NULL,NULL,38,'Mark Artwork as Final Approved',NULL,9,'2026-08-10','Waiting',1348924,1,NULL,NULL,1,'Artwork Approval',NULL,'2026-08-09 05:55:08','2026-08-18 21:53:08',NULL),(10,1,378,322,38,'2026-08-18 21:53:08',NULL,NULL,38,'Send Approved Artwork, Sample, or Swatch to Supplier',NULL,10,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-18 21:53:08',NULL),(11,1,379,322,33,'2026-08-09 05:55:08',NULL,NULL,33,'Get Sample Approval from Client',NULL,11,'2026-08-10','Waiting',1348924,1,NULL,NULL,1,'Sample Approval',NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(12,1,380,323,34,'2026-08-09 05:55:08',NULL,NULL,34,'Upload Production Issue to FlowTrack',NULL,12,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(13,1,381,323,34,'2026-08-09 05:55:08',NULL,NULL,34,'Resolve Production Issue',NULL,13,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(14,1,382,324,54,'2026-08-09 05:55:08',NULL,NULL,54,'Receive Products from Supplier',NULL,14,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(15,1,383,324,38,'2026-08-09 05:55:08',NULL,NULL,38,'Check Products Received from Supplier',NULL,15,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(16,1,384,324,34,'2026-08-09 05:55:08',NULL,NULL,34,'Send Products for Redo',NULL,16,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(17,1,385,324,41,'2026-08-09 05:55:08',NULL,NULL,41,'Print Courier Labels',NULL,17,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(18,1,386,324,54,'2026-08-09 05:55:08',NULL,NULL,54,'Stick Labels on Packages',NULL,18,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(19,1,387,324,54,'2026-08-09 05:55:08',NULL,NULL,54,'Separate Packages by Courier',NULL,19,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL),(20,1,388,324,54,'2026-08-09 05:55:08',NULL,NULL,54,'Send Post-Shipment Artwork to Finance',NULL,20,'2026-08-10','Waiting',1348924,1,NULL,NULL,0,NULL,NULL,'2026-08-09 05:55:08','2026-08-13 09:32:07',NULL);
/*!40000 ALTER TABLE `inquiry_tasks` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: invoice_items
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `invoice_items`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: invoices
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `invoices`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30
-- DATA SKIPPED FOR SECURITY/RUNTIME TABLE: job_batches
-- DATA SKIPPED FOR SECURITY/RUNTIME TABLE: jobs

-- ==================================================
-- SAMPLE DATA: master_records
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `master_records`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `master_records` WRITE;
/*!40000 ALTER TABLE `master_records` DISABLE KEYS */;
INSERT  IGNORE INTO `master_records` VALUES (1,1,NULL,NULL,'product_category','LAN','Lanyards','Promotional accessories','{\"main_category\": \"Lanyard and ID products\", \"main_category_id\": 1348930, \"excel_main_category\": \"Lanyard and ID products\"}','active',1,'2026-08-04 19:09:32','2026-08-13 10:34:52',NULL,NULL),(2,1,NULL,NULL,'product_category','WRI','Wristbands','Silicone, fabric and event bands',NULL,'active',2,'2026-08-04 19:09:32','2026-08-05 16:11:48','2026-08-05 16:11:48',NULL),(3,1,NULL,NULL,'product_category','CAP','Caps','Sports and promotional headwear',NULL,'active',3,'2026-08-04 19:09:32','2026-08-05 16:11:57','2026-08-05 16:11:57',NULL),(4,1,NULL,NULL,'product_category','GAR','Garments','Jerseys, T-shirts and uniforms',NULL,'active',4,'2026-08-04 19:09:32','2026-08-05 16:12:02','2026-08-05 16:12:02',NULL),(5,1,NULL,NULL,'product_category','BAG','Backpacks & Bags','Drawstring, travel and custom bags',NULL,'active',5,'2026-08-04 19:09:32','2026-08-05 16:12:05','2026-08-05 16:12:05',NULL),(6,1,NULL,NULL,'product_category','LUG','Luggage','Hard and soft luggage',NULL,'active',6,'2026-08-04 19:09:32','2026-08-05 16:12:08','2026-08-05 16:12:08',NULL),(7,1,NULL,NULL,'product_category','GFT','Gift Sets','Bundled promotional kits',NULL,'active',7,'2026-08-04 19:09:32','2026-08-05 16:12:12','2026-08-05 16:12:12',NULL),(8,1,NULL,NULL,'product','PRD-001','Woven Lanyard','Lanyards · Custom woven',NULL,'active',8,'2026-08-04 19:09:32','2026-08-05 07:04:30','2026-08-05 07:04:30',NULL),(9,1,NULL,2,'product','PRD-002','Silicone Wristband','Wristbands',NULL,'active',9,'2026-08-04 19:09:32','2026-08-05 07:04:36','2026-08-05 07:04:36',NULL),(10,1,NULL,3,'product','PRD-003','Performance Cap','Caps',NULL,'active',10,'2026-08-04 19:09:32','2026-08-05 07:04:40','2026-08-05 07:04:40',NULL),(11,1,NULL,4,'product','PRD-004','Dry-fit T-shirt','Garments',NULL,'active',11,'2026-08-04 19:09:32','2026-08-05 07:04:44','2026-08-05 07:04:44',NULL),(12,1,NULL,5,'product','PRD-005','Drawstring Backpack','Backpacks & Bags',NULL,'active',12,'2026-08-04 19:09:32','2026-08-05 07:04:48','2026-08-05 07:04:48',NULL),(13,1,NULL,6,'product','PRD-006','Hard-shell Luggage','Luggage',NULL,'active',13,'2026-08-04 19:09:32','2026-08-05 07:05:01','2026-08-05 07:05:01',NULL),(14,1,NULL,NULL,'shipment_method','AIR','Air Freight','Airport-to-airport and door delivery',NULL,'active',14,'2026-08-04 19:09:32','2026-08-05 08:05:04',NULL,NULL),(15,1,NULL,NULL,'shipment_method','SEA','Sea Freight','FCL and LCL',NULL,'active',15,'2026-08-04 19:09:32','2026-08-05 08:05:04',NULL,NULL),(16,1,NULL,NULL,'shipment_method','EXP','Express Courier','DHL, FedEx and UPS',NULL,'active',16,'2026-08-04 19:09:32','2026-08-05 08:05:04',NULL,NULL),(17,1,NULL,NULL,'currency','USD','US Dollar','Default commercial currency',NULL,'active',17,'2026-08-04 19:09:32','2026-08-05 08:05:04',NULL,NULL),(18,1,NULL,NULL,'currency','CNY','Chinese Yuan','Local sourcing currency',NULL,'active',18,'2026-08-04 19:09:32','2026-08-05 08:05:04',NULL,NULL),(19,1,NULL,NULL,'currency','GBP','British Pound','UK clients',NULL,'active',19,'2026-08-04 19:09:32','2026-08-05 08:05:04',NULL,NULL),(20,1,NULL,NULL,'currency','EUR','Euro','European clients',NULL,'active',20,'2026-08-04 19:09:32','2026-08-05 08:05:04',NULL,NULL);
/*!40000 ALTER TABLE `master_records` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:30

-- ==================================================
-- SAMPLE DATA: master_values
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `master_values`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `master_values` WRITE;
/*!40000 ALTER TABLE `master_values` DISABLE KEYS */;
INSERT  IGNORE INTO `master_values` VALUES (14,'shipment_methods','AIR','Air Freight','Airport-to-airport and door delivery',NULL,1,NULL,'2026-08-04 19:08:27','2026-07-28 17:36:36'),(15,'shipment_methods','SEA','Sea Freight','FCL and LCL',NULL,1,NULL,'2026-08-04 19:08:27','2026-07-28 17:36:36'),(16,'shipment_methods','EXP','Express Courier','DHL, FedEx and UPS',NULL,1,NULL,'2026-08-04 19:08:27','2026-07-28 17:36:36'),(17,'currencies','USD','US Dollar','Default commercial currency',NULL,1,NULL,'2026-08-04 19:08:27','2026-07-28 17:36:36'),(18,'currencies','CNY','Chinese Yuan','Local sourcing currency',NULL,1,NULL,'2026-08-04 19:08:27','2026-07-28 17:36:36'),(19,'currencies','GBP','British Pound','UK clients',NULL,1,NULL,'2026-08-04 19:08:27','2026-07-28 17:36:36'),(20,'currencies','EUR','Euro','European clients',NULL,1,NULL,'2026-08-04 19:08:27','2026-07-28 17:36:36'),(21,'document_categories','REQ','Client Requirement','References and specifications',NULL,0,NULL,'2026-08-04 19:08:27','2026-08-05 07:06:17'),(22,'document_categories','QUO','Quotation','Commercial quotation versions',NULL,0,NULL,'2026-08-04 19:08:27','2026-08-05 07:06:20'),(23,'document_categories','ART','Artwork','Working artwork files',NULL,0,NULL,'2026-08-04 19:08:27','2026-08-05 07:06:23'),(24,'document_categories','APR','Artwork Approval','Final approved artwork',NULL,0,NULL,'2026-08-04 19:08:27','2026-08-05 07:06:26'),(25,'document_categories','SAM','Sample Approval','Swatch or sample confirmation',NULL,0,NULL,'2026-08-04 19:08:27','2026-08-05 07:06:29'),(26,'document_categories','QCI','Quality Inspection','QC evidence and reports',NULL,0,NULL,'2026-08-04 19:08:27','2026-08-05 07:06:36'),(27,'document_categories','SHP','Shipping Document','Packing list, AWB and B/L',NULL,0,NULL,'2026-08-04 19:08:27','2026-08-05 07:06:39'),(28,'document_categories','INV','Invoice','Invoice and payment documents',NULL,0,NULL,'2026-08-04 19:08:27','2026-08-05 07:06:41'),(29,'priorities','LOW','Normal','Normal monitoring',NULL,1,'{\"color\": \"#64748B\"}','2026-08-04 19:08:27','2026-08-14 01:18:59'),(30,'priorities','MED','Urgent','Standard business priority',NULL,1,'{\"color\": \"#EB8E24\"}','2026-08-04 19:08:27','2026-08-14 01:19:30'),(31,'priorities','HIG','High','Close monitoring required',NULL,0,'{\"color\": \"#D97706\"}','2026-08-04 19:08:27','2026-08-14 01:19:46'),(32,'priorities','CRI','Super Urgent','Immediate management attention',NULL,1,'{\"color\": \"#DC2626\"}','2026-08-04 19:08:27','2026-08-14 01:19:57'),(8231,'shipment_methods','ROAD','Road Freight','Regional delivery',NULL,1,NULL,'2026-07-28 17:36:36','2026-07-28 17:36:36');
/*!40000 ALTER TABLE `master_values` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: migrations
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `migrations`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT  IGNORE INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_08_04_000100_create_flowtrack_core_tables',1),(5,'2026_08_04_000200_create_board_support_tables',1),(6,'2026_08_04_000300_add_client_profile_fields',1),(7,'2026_08_04_000400_align_setup_with_supplied_sql',1),(8,'2026_08_04_000500_add_task_detail_fields',1),(9,'2026_08_04_000600_add_role_matrix_access_control',1),(10,'2026_08_04_000700_add_task_to_flow_notifications',1),(11,'2026_08_04_000800_remove_automatic_task_checklist_defaults',1),(12,'2026_08_04_000900_realign_generated_task_assignees',1),(13,'2026_08_04_001000_sync_current_task_pack_assignments',2),(14,'2026_08_05_000100_restrict_master_data_parents_to_products',3),(15,'2026_08_05_000200_add_flowtrack_performance_indexes',3),(16,'2026_08_05_000300_optimize_china_request_paths',4),(17,'2026_08_07_000100_add_job_workflow_snapshots',5),(18,'2026_08_07_000100_add_profile_image_to_users',5),(19,'2026_08_07_000200_ensure_workspace_branding_columns',6),(20,'2026_08_07_000300_backfill_legacy_product_category_links',7);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: notification_rules
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `notification_rules`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `notification_rules` WRITE;
/*!40000 ALTER TABLE `notification_rules` DISABLE KEYS */;
INSERT  IGNORE INTO `notification_rules` VALUES (1,'Task due reminder','2 days before due','Assignee',1,'2026-08-04 19:08:34','2026-08-04 19:08:34'),(2,'Overdue escalation','1 day overdue','Assignee + Manager',1,'2026-08-04 19:08:34','2026-08-04 19:08:34'),(3,'Approval reminder','24 hours pending','Approver',1,'2026-08-04 19:08:34','2026-08-04 19:08:34'),(4,'Shipment deadline','3 days before ship date','Shipment + Manager',1,'2026-08-04 19:08:34','2026-08-04 19:08:34'),(5,'Invoice due reminder','5 days before due','Accounts + Sales',1,'2026-08-04 19:08:34','2026-08-04 19:08:34'),(6,'Blocked task escalation','Immediately','Manager + Job owner',1,'2026-08-04 19:08:34','2026-08-04 19:08:34');
/*!40000 ALTER TABLE `notification_rules` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: order_holds
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `order_holds`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `order_holds` WRITE;
/*!40000 ALTER TABLE `order_holds` DISABLE KEYS */;
INSERT  IGNORE INTO `order_holds` VALUES (1,107,'client','Amin','',32,'2026-09-10 19:18:03','2026-09-10 19:18:58',32,'2026-09-10 19:18:03','2026-09-10 19:18:58'),(2,107,'client','Amin','',32,'2026-09-10 19:19:31','2026-09-10 19:21:18',32,'2026-09-10 19:19:31','2026-09-10 19:21:18'),(3,107,'client','Amin','',32,'2026-09-10 19:29:13','2026-09-10 19:29:32',32,'2026-09-10 19:29:13','2026-09-10 19:29:32'),(4,387,'client','Amin','Sample not conifrm by client',31,'2026-09-16 19:40:51','2026-09-16 19:44:28',31,'2026-09-16 19:40:51','2026-09-16 19:44:28'),(5,387,'client','Amin','sample not confirm',31,'2026-09-16 19:46:08',NULL,NULL,'2026-09-16 19:46:08','2026-09-16 19:46:08');
/*!40000 ALTER TABLE `order_holds` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: order_redos
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `order_redos`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `order_redos` WRITE;
/*!40000 ALTER TABLE `order_redos` DISABLE KEYS */;
INSERT  IGNORE INTO `order_redos` VALUES (1,255,637,1,'Customer','Other','2026-09-07',200,'<!--flowtrack-rich-text-->wrong address','artwork',200,NULL,NULL,'free','percent',20.00,20.00,40.00,'percent',40.00,0,0.00,0.00,0.00,0.00,0.00,0.00,0.00,34,'2026-09-06 19:26:22','2026-09-06 19:26:22'),(2,592,1083,1,'Customer','Artwork / production mismatch','2026-09-18',60,'<!--flowtrack-rich-text-->website image wrong, client informed we missing woven label based website image','artwork',60,1350033,'artwork update proof to redo','discount','percent',50.00,50.00,0.00,'percent',0.00,0,0.00,0.00,0.00,0.00,0.00,0.00,0.00,34,'2026-09-17 22:57:22','2026-09-17 22:57:22'),(3,585,NULL,1,'Customer','Other','2026-09-18',28,'<!--flowtrack-rich-text-->all of the shirts have the name \"Tyler\" on the left chest, instead of the personalized names provided.','discount',28,1350007,'artwork-wing created wrong cutout','discount','percent',20.00,20.00,0.00,'percent',0.00,0,0.00,0.00,0.00,0.00,0.00,0.00,0.00,34,'2026-09-17 23:30:09','2026-09-17 23:30:09'),(4,392,1719,1,'Customer','Artwork / production mismatch','2026-10-05',50,'<!--flowtrack-rich-text-->client needs flat bill caps, the goods are curve','artwork',50,1349997,NULL,'free','percent',20.00,20.00,100.00,'percent',100.00,1,320.00,0.00,0.00,0.00,0.00,0.00,320.00,34,'2026-10-05 02:04:35','2026-10-05 02:04:35'),(5,916,1720,1,'Customer','Artwork / production mismatch','2026-10-05',6,'<!--flowtrack-rich-text-->6 XL double print','production',6,1350007,NULL,'free','percent',20.00,20.00,100.00,'percent',100.00,0,0.00,0.00,0.00,0.00,0.00,0.00,0.00,34,'2026-10-05 02:08:13','2026-10-05 02:08:13');
/*!40000 ALTER TABLE `order_redos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: order_shipments
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `order_shipments`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `order_shipments` WRITE;
/*!40000 ALTER TABLE `order_shipments` DISABLE KEYS */;
INSERT  IGNORE INTO `order_shipments` VALUES (1,626,1,1,'sample','+1','877-240-4349','Maurissa Russell\nFirst Class Sea Storage\nAttn: Island Luck-Marketing Department\n1561 NW 82nd Ave. Doral, FL 33126\nUSA',NULL,NULL,'33126','United States',NULL,NULL,NULL,1350043,NULL,NULL,'1Z68W83F6678206404',NULL,NULL,58,58,'2026-09-04 10:16:05','2026-09-04 10:16:05',NULL),(2,628,1,1,'sample','+1','877-240-4349','Ava Liao\nSony Electronics\n655 Stockton Street\nApt 311\nSan Francisco, CA\n94108\nUnited States',NULL,NULL,'94108',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,47,47,'2026-09-04 16:37:03','2026-09-04 16:37:03',NULL),(3,629,1,1,'sample','+1','877-240-4349','ATTN: Morgan Everett/488369  Mele Printing  619 N Tyler St.  Covington LA 70433  USA','Covington','Louisiana (LA)','70433','United States',NULL,16,NULL,NULL,NULL,100,NULL,NULL,NULL,47,47,'2026-09-04 17:36:21','2026-09-04 17:36:21',NULL),(4,274,1,1,NULL,NULL,'8773857785','Alicia Bruyea\nDelta Hotel\n18 Queen St\nCharlottetown, Prince Edward Island C1A 4A1\nCANADA\n\nReference : Alicia Bruyea (check in Sept 8)',NULL,NULL,'C1A 4A1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,32,32,'2026-09-04 17:39:44','2026-09-04 17:39:44',NULL),(5,630,1,1,'Logos Galore','+1','989-772-0566','Logos Galore / Mordica Sales Associates, Inc. 2135 E Remus Rd Mt Pleasant, MI 48858 USA','Pleasant','Michigan (MI)','48858','United States',NULL,16,1349157,NULL,NULL,NULL,NULL,NULL,NULL,47,47,'2026-09-04 17:50:45','2026-09-04 17:50:45',NULL),(6,232,1,1,'IID','','8773857785','** UPS GND **\n\nLegendary Awards\nLegendary Awards\n9812 White Barn Way\nRiverview, FL 33569\nUS\n\nReference : .','SSSSS','Alabama (AL)','FL 33569','United States',NULL,16,NULL,1350044,NULL,NULL,'536777830981',NULL,'2026-09-04 18:26:57',32,32,'2026-09-04 17:51:55','2026-09-04 18:26:57',NULL),(7,631,1,1,'sample','+1','877-240-4349','Elmos Heagar All Nations Christian Church 113 South Spring Field Clifton Heights PA 19018 USA','Clifton Heights','Pennsylvania (PA)','19018','United States',NULL,16,1349157,NULL,NULL,NULL,NULL,NULL,NULL,47,47,'2026-09-04 17:56:20','2026-09-04 17:56:20',NULL),(8,632,1,1,'sample','+1','877-240-4349','ATTN: SKOLPASKY STAR EMS 63 OAKLAND AVENUE PONTIAC MI 48342 USA','PONTIAC','Michigan (MI)','48342','United States',NULL,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,47,47,'2026-09-04 18:00:29','2026-09-04 18:00:29',NULL),(9,633,1,1,'Kristin Hess','+1','936-546-1973','Nucor IPG - Utah Attn: Kristin Hess 1101 Watery Ln Bringham City, Utah.  84302','Bringham City','Utah (UT)','84302','United States',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,47,47,'2026-09-04 18:07:22','2026-09-04 18:07:22',NULL),(10,634,1,1,'Olivia Jones','+1','503-631-7025','Olivia Jones AIA PLATINUM PROMO 15742 SE 130th Ave suite b Suite 510 Clackamas, OR 97015-8902 United States','Clackamas','Oregon (OR)','97015-8902','United States',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,47,47,'2026-09-04 18:11:15','2026-09-04 18:11:15',NULL),(11,635,1,1,'JONES, CJ / LIFESTYLE','+1','(650) 853-5000','VI LIVING AT PALO ALTO Attn: JONES, CJ / LIFESTYLE 620 SANDHILL ROAD PALO ALTO, CA 94304-2002 USA','PALO ALTO','California (CA)','94304-2002','United States',NULL,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,47,47,'2026-09-04 18:17:03','2026-09-04 18:17:03',NULL),(12,232,2,0,NULL,NULL,'8773857785','** UPS GND **\n\nLegendary Awards\nLegendary Awards\n9812 White Barn Way\nRiverview, FL 33569\nUS\n\nReference : .',NULL,NULL,'FL 33569',NULL,NULL,16,NULL,NULL,NULL,NULL,NULL,NULL,NULL,32,32,'2026-09-04 18:21:34','2026-09-04 18:22:23','2026-09-04 18:22:23'),(13,93,1,1,'IID','','8773857785','** UPS GND **\n\nTERESA MCFADDEN\nCBRE\n1420 5TH AVE\nSTE 3800\nSeattle, WA 98101\nUS\n\nReference : .','wa','Alaska (AK)','WA 98101','United States',NULL,16,NULL,1350044,NULL,NULL,'530191014103',NULL,'2026-09-04 19:00:04',32,32,'2026-09-04 18:27:31','2026-09-04 19:00:04',NULL),(14,602,1,1,'Amin','+1','8773857785','** UPS GND **\n\nProg:SHAR Master PO:8358443\nHALO MAIN WAREHOUSE\n1500 HALO WAY\nSterling, IL 61081\nUS\n\nReference : .',NULL,NULL,'IL 61081 US',NULL,NULL,16,NULL,1350043,NULL,NULL,'1Z35866A0433331902',NULL,'2026-09-21 21:39:15',32,44,'2026-09-04 19:07:45','2026-09-21 21:39:15',NULL),(15,136,1,1,NULL,NULL,NULL,'P&S Fulfillment Center\nMike Maluccio\n29033 Avenue Sherman\nSuite #213\nValencia CA 91355-5411\nUSA',NULL,NULL,'91355-5411',NULL,NULL,16,NULL,1350043,NULL,NULL,'1Z35866A0434224375',NULL,'2026-09-17 00:28:32',49,42,'2026-09-04 19:15:02','2026-09-17 00:28:32',NULL),(16,137,1,1,NULL,NULL,'312-558-6150','Michelle Dylo Winston Taylor LLP\n300 North LaSalle Drive\nSuite 4400\nChicago, IL\n60654\nUnited States',NULL,NULL,'60654',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,49,49,'2026-09-04 19:18:02','2026-09-04 19:18:02',NULL),(17,138,1,1,NULL,NULL,'954-442-6000','Impressive Imprints Corp\nAttention: PEDRO or MARTHA\nStreet: 1931 NW 150 Ave   #238\nCity: PEMBROKE PINES\nState:FL\nZip Code: 33028',NULL,NULL,'33028',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,49,49,'2026-09-04 19:20:32','2026-09-04 19:20:32',NULL),(18,139,1,1,NULL,NULL,'317-960-4840','4 Marks Printing\n5305 Commerce Square Drive\nB\nIndianapolis, Indiana 46237',NULL,NULL,'46237',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,49,49,'2026-09-04 19:21:52','2026-09-04 19:21:52',NULL),(19,140,1,1,NULL,NULL,'(612) 990-9373','Hunt Electric - Taxable\n\n1000 Blue Gentian Rd\nSuite 300\nEagan MN 55121\nUnited States',NULL,NULL,'55121',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,49,49,'2026-09-04 19:25:32','2026-09-04 19:25:32',NULL),(20,218,1,1,NULL,NULL,'772-562-0079','Sydney McCarthy\nThe Brandit Agency\n1175 19th Street\nVero Beach, FL\n32960\nUnited States',NULL,NULL,'32960',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,49,49,'2026-09-04 19:28:21','2026-09-04 19:28:21',NULL);
/*!40000 ALTER TABLE `order_shipments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: order_workflow_summaries
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `order_workflow_summaries`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `order_workflow_summaries` WRITE;
/*!40000 ALTER TABLE `order_workflow_summaries` DISABLE KEYS */;
INSERT  IGNORE INTO `order_workflow_summaries` VALUES (1,52,32,'NEP Order Workflow',1941,'Billing','Billing',6,7,2,2,0,12759,'Prepare Invoice',42,71,'In Progress',0,0,'2026-09-10 09:28:06','2026-09-10 09:28:06','2026-09-10 09:28:06'),(2,649,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,2,20051,'Monitor / Resolve Production Issue',48,36,'In Progress',0,0,'2026-09-13 22:57:27','2026-09-10 09:28:41','2026-09-13 22:57:27'),(3,650,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,0,20069,'Set estimated delivery date',49,29,'Waiting',0,1,'2026-09-17 17:52:50','2026-09-10 09:33:13','2026-09-30 00:39:52'),(4,641,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,3,19892,'Finish Production',53,39,'In Progress',0,0,'2026-09-10 18:12:56','2026-09-10 09:34:00','2026-09-10 18:12:56'),(5,651,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,1,20090,'Start Production',53,32,'In Progress',0,0,'2026-10-04 17:19:45','2026-09-10 17:16:31','2026-10-04 17:19:45'),(6,636,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,3,19792,'Finish Production',49,39,'In Progress',0,0,'2026-09-10 17:20:04','2026-09-10 17:20:04','2026-09-10 17:20:04'),(7,648,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,2,20031,'Monitor / Resolve Production Issue',48,36,'In Progress',0,0,'2026-09-10 18:15:05','2026-09-10 17:22:06','2026-09-10 18:15:05'),(8,640,32,'NEP Order Workflow',334,'QC','QC',4,7,3,3,0,19873,'Perform QC Check',48,43,'In Progress',0,0,'2026-09-17 22:03:56','2026-09-10 17:23:29','2026-09-17 22:04:11'),(9,644,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,3,19952,'Finish Production',49,39,'In Progress',0,1,'2026-09-15 01:22:31','2026-09-10 17:59:09','2026-09-22 23:47:56'),(11,647,32,'NEP Order Workflow',334,'QC','QC',4,7,3,3,0,20013,'Perform QC Check',48,43,'In Progress',0,0,'2026-09-21 22:19:13','2026-09-10 18:01:51','2026-09-21 22:19:33'),(13,645,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,2,19971,'Monitor / Resolve Production Issue',48,36,'In Progress',0,0,'2026-09-10 18:08:22','2026-09-10 18:05:57','2026-09-10 18:08:22'),(27,646,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,3,19992,'Finish Production',49,39,'In Progress',0,1,'2026-09-10 18:18:38','2026-09-10 18:15:29','2026-09-22 23:48:02'),(33,642,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,3,19912,'Finish Production',49,39,'In Progress',0,1,'2026-09-10 18:21:25','2026-09-10 18:19:00','2026-09-22 23:48:11'),(39,639,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,2,19851,'Monitor / Resolve Production Issue',48,36,'In Progress',0,0,'2026-09-10 18:32:44','2026-09-10 18:26:08','2026-09-10 18:33:23'),(52,602,30,'IID Order workflow',1939,'Billing','Billing',6,7,2,2,0,19119,'Prepare Invoice',NULL,71,'In Progress',0,0,'2026-09-21 21:39:16','2026-09-10 18:52:33','2026-09-21 21:39:16'),(53,69,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,3,12992,'Finish Production',49,39,'In Progress',0,1,'2026-09-10 18:58:26','2026-09-10 18:53:19','2026-09-11 00:32:50'),(60,107,30,'IID Order workflow',1939,'Billing','Billing',6,7,2,2,0,8719,'Prepare Invoice',NULL,71,'In Progress',0,0,'2026-09-18 19:36:51','2026-09-10 19:16:41','2026-09-18 19:36:51'),(61,652,32,'NEP Order Workflow',333,'Production','Production',3,7,4,4,1,20110,'Start Production',53,32,'In Progress',0,0,'2026-10-04 17:24:01','2026-09-10 19:29:48','2026-10-04 17:24:01'),(65,629,32,'NEP Order Workflow',334,'QC','QC',4,7,3,3,0,19653,'Perform QC Check',48,43,'In Progress',0,0,'2026-09-18 00:14:30','2026-09-10 22:06:33','2026-09-18 00:14:48'),(75,625,32,'NEP Order Workflow',335,'Shipment','Shipment',5,7,3,3,2,19578,'Dispatch shipment',NULL,67,'In Progress',0,0,'2026-09-17 01:37:57','2026-09-11 09:58:24','2026-09-17 01:37:57');
/*!40000 ALTER TABLE `order_workflow_summaries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31
-- DATA SKIPPED FOR SECURITY/RUNTIME TABLE: password_reset_tokens

-- ==================================================
-- SAMPLE DATA: payments
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `payments`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: permission_role
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `permission_role`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `permission_role` WRITE;
/*!40000 ALTER TABLE `permission_role` DISABLE KEYS */;
INSERT  IGNORE INTO `permission_role` VALUES (1,5),(2,5),(3,5),(4,5),(5,5),(6,5),(7,5),(8,5),(9,5),(10,5),(1,13),(2,13),(3,13),(4,13),(5,13),(6,13),(7,13),(8,13),(9,13),(10,13);
/*!40000 ALTER TABLE `permission_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: permissions
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `permissions`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT  IGNORE INTO `permissions` VALUES (1,'dashboard','Dashboard View','dashboard.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(2,'jobs','Jobs View','jobs.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(3,'jobs','Jobs Create','jobs.create',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(4,'jobs','Jobs Update','jobs.update',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(5,'tasks','Tasks View','tasks.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(6,'tasks','Tasks Update','tasks.update',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(7,'clients','Clients View','clients.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(8,'documents','Documents View','documents.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(9,'reports','Reports View','reports.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(10,'notifications','Notifications View','notifications.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(11,'workflow','Workflow Manage','workflow.manage',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(12,'master','Master Manage','master.manage',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(13,'users','Users Manage','users.manage',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: product_supplier_links
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `product_supplier_links`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `product_supplier_links` WRITE;
/*!40000 ALTER TABLE `product_supplier_links` DISABLE KEYS */;
INSERT  IGNORE INTO `product_supplier_links` VALUES (1,1,35028,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(2,1,35428,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(3,1,35320,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(4,1,34980,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(5,1,35031,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(6,1,35429,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(7,1,35321,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(8,1,34981,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(9,1,35032,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(10,1,35431,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(11,1,35323,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(12,1,34983,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(13,1,35030,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(14,1,35432,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(15,1,35324,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(16,1,34984,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(17,1,35015,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(18,1,35417,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(19,1,35306,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12'),(20,1,34967,1349993,'2026-08-30 09:07:12','2026-08-30 09:07:12');
/*!40000 ALTER TABLE `product_supplier_links` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: role_module_access
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `role_module_access`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `role_module_access` WRITE;
/*!40000 ALTER TABLE `role_module_access` DISABLE KEYS */;
INSERT  IGNORE INTO `role_module_access` VALUES (1,1,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:12','2026-08-11 04:10:58'),(2,1,'clients','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\"]','2026-08-04 19:08:12','2026-08-11 04:10:58'),(3,1,'jobs','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"link\"]','2026-08-04 19:08:12','2026-08-11 04:10:58'),(4,1,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\"]','2026-08-04 19:08:12','2026-08-11 04:10:58'),(5,1,'quotation','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:12','2026-08-04 19:08:12'),(6,1,'artwork','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:12','2026-08-04 19:08:12'),(7,1,'sample','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:12','2026-08-04 19:08:12'),(8,1,'production','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:12','2026-08-04 19:08:12'),(9,1,'shipment','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(10,1,'invoice','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(11,1,'documents','all_records','[\"view\", \"create\", \"delete\", \"link\", \"export\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(12,1,'reports','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(13,1,'workflow','all_records','[\"manage\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(14,1,'masterdata','all_records','[\"manage\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(15,1,'users','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(16,1,'audit','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(17,1,'notifications','all_records','[\"view\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(18,2,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(19,2,'clients','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(20,2,'jobs','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-04 19:08:13','2026-08-11 04:10:58');
/*!40000 ALTER TABLE `role_module_access` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: roles
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `roles`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT  IGNORE INTO `roles` VALUES (1,1,'Admin','admin','ADMIN','Admin with unrestricted FlowTrack access.','all_records',1,1,'[\"supplier_cost\", \"gross_margin\", \"client_target_price\", \"confirmed_selling_price\", \"invoice_amount\", \"payment_history\", \"internal_management_notes\", \"client_contact_details\", \"supplier_banking_details\"]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(2,1,'Management','management','MANAGEMENT','Organization-wide visibility and exception management.','all_records',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(3,1,'Job Manager','job-manager','JOB_MANAGER','Manages assigned Jobs, phases, people and tasks.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(4,1,'Sales User','sales-user','SALES','Creates and maintains client, Job and quotation records for assigned work.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(5,1,'Designer','designer','DESIGNER','Works on assigned artwork tasks and document versions.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(6,1,'Sourcing Coordinator','sourcing-coordinator','SOURCING','Coordinates supplier costing, samples and sourcing tasks.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(7,1,'Production User','production-user','PRODUCTION','Updates assigned production tasks and production evidence.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(8,1,'Shipment User','shipment-user','SHIPMENT','Updates assigned shipment tasks, tracking and documents.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(9,1,'Accounts User','accounts-user','ACCOUNTS','Handles assigned invoice, payment and reporting work.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(10,1,'General Team Member','general-team-member','TEAM_MEMBER','Views and updates only work assigned to the user.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(11,1,'Read-only Auditor','read-only-auditor','AUDITOR','Read/export access without operational updates.','all_records',1,1,'[]','2026-08-04 19:08:09','2026-08-04 19:08:09'),(12,1,'Super Admin','super-admin','SUPER_ADMIN','Super Admin with unrestricted FlowTrack access.','all_records',1,1,NULL,'2026-08-04 19:08:18','2026-08-04 19:08:18'),(13,NULL,'Operations Manager','operations-manager',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(14,NULL,'Sales Manager','sales-manager',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(15,NULL,'Sales Executive','sales-executive',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(16,NULL,'Sourcing Coordinator','sourcing',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(17,NULL,'Production Coordinator','production',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(18,NULL,'Quality Inspector','quality',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(19,NULL,'Shipping Executive','shipment',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(20,NULL,'Accounts Officer','accounts',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31
-- DATA SKIPPED FOR SECURITY/RUNTIME TABLE: sessions

-- ==================================================
-- SAMPLE DATA: task_links
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `task_links`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `task_links` WRITE;
/*!40000 ALTER TABLE `task_links` DISABLE KEYS */;
INSERT  IGNORE INTO `task_links` VALUES (1,1319,47,'https://wormhole.app/1B8PPN#3Go9L_XvOou-0uDPfUbx5A','2026-08-17 21:45:50','2026-08-17 21:45:50'),(2,1319,47,'https://wormhole.app/1B8PPN#3Go9L_XvOou-0uDPfUbx5A','2026-08-17 21:47:19','2026-08-17 21:47:19'),(3,1756,47,'https://we.tl/t-57MwHrSMAhfYVOfj','2026-08-18 17:10:36','2026-08-18 17:10:36'),(4,1802,47,'https://we.tl/t-RbxXPb71QNzVA4YJ','2026-08-18 17:17:22','2026-08-18 17:17:22'),(5,1803,47,'https://we.tl/t-RbxXPb71QNzVA4YJ','2026-08-18 17:20:31','2026-08-18 17:20:31'),(6,2883,47,'https://we.tl/t-SqUj18S1QtZ81Mks','2026-08-19 17:22:17','2026-08-19 17:22:17'),(7,2906,47,'https://we.tl/t-64wk1ep3dCZ9X0Eo','2026-08-19 17:28:57','2026-08-19 17:28:57'),(8,7575,47,'https://wormhole.app/OLeDeX#u1NZmiycDFts75TnHOtO7w','2026-08-27 17:23:29','2026-08-27 17:23:29'),(9,7598,47,'https://we.tl/t-TkPsOQFjQCAKTt7K?utm_source=sendgrid&utm_medium=email&utm_campaign=TRN_TDL_05&trk=TRN_TDL_05','2026-08-27 17:32:13','2026-08-27 17:32:13');
/*!40000 ALTER TABLE `task_links` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: task_pack_items
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `task_pack_items`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `task_pack_items` WRITE;
/*!40000 ALTER TABLE `task_pack_items` DISABLE KEYS */;
INSERT  IGNORE INTO `task_pack_items` VALUES (248,102,'Conduct final quality inspection',NULL,NULL,'#2563EB',NULL,NULL,32,NULL,1,0,NULL,0,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,0,'2026-08-07 07:22:00','2026-08-07 07:22:00',188),(249,102,'Resolve defects and complete rework',NULL,NULL,'#7C3AED',NULL,NULL,31,NULL,1,0,NULL,0,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,1,'2026-08-07 07:22:00','2026-08-07 07:22:00',189),(250,102,'Approve finished products for packaging',NULL,NULL,'#0891B2',NULL,NULL,32,NULL,1,0,NULL,0,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,2,'2026-08-07 07:22:00','2026-08-07 07:22:00',190),(251,103,'Conduct final quality inspection',NULL,NULL,'#2563EB',NULL,NULL,32,NULL,1,0,NULL,0,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,0,'2026-08-07 07:22:00','2026-08-07 07:22:00',188),(252,103,'Resolve defects and complete rework',NULL,NULL,'#7C3AED',NULL,NULL,31,NULL,1,0,NULL,0,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,1,'2026-08-07 07:22:00','2026-08-07 07:22:00',189),(253,103,'Approve finished products for packaging',NULL,NULL,'#0891B2',NULL,NULL,32,NULL,1,0,NULL,0,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,2,'2026-08-07 07:22:00','2026-08-07 07:22:00',190),(254,104,'Review client requirement',NULL,NULL,'#2563EB',34,34721,31,NULL,1,0,NULL,1,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1),(255,104,'Collect supplier / factory costing',NULL,NULL,'#7C3AED',NULL,NULL,30,NULL,1,0,NULL,2,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,1,'2026-08-07 08:34:42','2026-08-07 08:34:42',2),(256,104,'Prepare quotation',NULL,NULL,'#0891B2',NULL,NULL,31,21,1,0,NULL,3,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,2,'2026-08-07 08:34:42','2026-08-07 08:34:42',3),(257,104,'Internal quotation review',NULL,NULL,'#0F766E',NULL,NULL,30,NULL,1,0,NULL,4,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,3,'2026-08-07 08:34:42','2026-08-07 08:34:42',4),(258,104,'Submit quotation',NULL,NULL,'#16A34A',NULL,NULL,30,NULL,1,0,NULL,5,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,0,4,'2026-08-07 08:34:42','2026-08-07 08:34:42',5),(259,105,'Review client requirement',NULL,NULL,'#2563EB',34,34721,31,NULL,1,0,NULL,1,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1),(260,105,'Collect supplier / factory costing',NULL,NULL,'#7C3AED',NULL,NULL,30,NULL,1,0,NULL,2,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,1,'2026-08-07 08:34:42','2026-08-07 08:34:42',2),(261,105,'Prepare quotation',NULL,NULL,'#0891B2',NULL,NULL,31,21,1,0,NULL,3,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,2,'2026-08-07 08:34:42','2026-08-07 08:34:42',3),(262,105,'Internal quotation review',NULL,NULL,'#0F766E',NULL,NULL,30,NULL,1,0,NULL,4,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,3,'2026-08-07 08:34:42','2026-08-07 08:34:42',4),(263,105,'Submit quotation',NULL,NULL,'#16A34A',NULL,NULL,30,NULL,1,0,NULL,5,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,0,4,'2026-08-07 08:34:42','2026-08-07 08:34:42',5),(264,106,'Review client requirement',NULL,NULL,'#2563EB',34,34721,31,NULL,1,0,NULL,1,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1),(265,106,'Collect supplier / factory costing',NULL,NULL,'#7C3AED',NULL,NULL,30,NULL,1,0,NULL,2,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,1,'2026-08-07 08:34:42','2026-08-07 08:34:42',2),(266,106,'Prepare quotation',NULL,NULL,'#0891B2',NULL,NULL,31,21,1,0,NULL,3,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,2,'2026-08-07 08:34:42','2026-08-07 08:34:42',3),(267,106,'Internal quotation review',NULL,NULL,'#0F766E',NULL,NULL,30,NULL,1,0,NULL,4,NULL,'TPD-001','TPS-001','TPE-001','TPW-001',1,0,1,3,'2026-08-07 08:34:42','2026-08-07 08:34:42',4);
/*!40000 ALTER TABLE `task_pack_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: task_pack_tasks
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `task_pack_tasks`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `task_pack_tasks` WRITE;
/*!40000 ALTER TABLE `task_pack_tasks` DISABLE KEYS */;
INSERT  IGNORE INTO `task_pack_tasks` VALUES (248,102,'Conduct final quality inspection','#2563EB',1,1,NULL,'2026-08-07 07:22:00','2026-08-07 07:22:00',188),(249,102,'Resolve defects and complete rework','#7C3AED',2,1,NULL,'2026-08-07 07:22:00','2026-08-07 07:22:00',189),(250,102,'Approve finished products for packaging','#0891B2',3,1,NULL,'2026-08-07 07:22:00','2026-08-07 07:22:00',190),(251,103,'Conduct final quality inspection','#2563EB',1,1,NULL,'2026-08-07 07:22:00','2026-08-07 07:22:00',188),(252,103,'Resolve defects and complete rework','#7C3AED',2,1,NULL,'2026-08-07 07:22:00','2026-08-07 07:22:00',189),(253,103,'Approve finished products for packaging','#0891B2',3,1,NULL,'2026-08-07 07:22:00','2026-08-07 07:22:00',190),(254,104,'Review client requirement','#2563EB',1,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',1),(255,104,'Collect supplier / factory costing','#7C3AED',2,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',2),(256,104,'Prepare quotation','#0891B2',3,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',3),(257,104,'Internal quotation review','#0F766E',4,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',4),(258,104,'Submit quotation','#16A34A',5,0,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',5),(259,105,'Review client requirement','#2563EB',1,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',1),(260,105,'Collect supplier / factory costing','#7C3AED',2,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',2),(261,105,'Prepare quotation','#0891B2',3,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',3),(262,105,'Internal quotation review','#0F766E',4,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',4),(263,105,'Submit quotation','#16A34A',5,0,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',5),(264,106,'Review client requirement','#2563EB',1,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',1),(265,106,'Collect supplier / factory costing','#7C3AED',2,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',2),(266,106,'Prepare quotation','#0891B2',3,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',3),(267,106,'Internal quotation review','#0F766E',4,1,NULL,'2026-08-07 08:34:42','2026-08-07 08:34:42',4);
/*!40000 ALTER TABLE `task_pack_tasks` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: task_packs
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `task_packs`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `task_packs` WRITE;
/*!40000 ALTER TABLE `task_packs` DISABLE KEYS */;
INSERT  IGNORE INTO `task_packs` VALUES (102,1,'JOB21-P79-M1UA5','[Job JOB-2026-00146] Final Quality Control','job-21-pack-79-dtly2w',NULL,0,'2026-08-07 07:22:00','2026-08-07 07:22:00',1,79,21),(103,1,'JOB23-P79-ZYUPA','[Job JOB-2026-00148] Final Quality Control','job-23-pack-79-cf7rua',NULL,0,'2026-08-07 07:22:00','2026-08-07 07:22:00',1,79,23),(104,1,'JOB19-P1-3CXZ0','[Job JOB-2026-00144] Quotation','job-19-pack-1-nec7ut','Reusable Quotation phase tasks',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,19),(105,1,'JOB24-P1-QDNZK','[Job JOB-2026-00149] Quotation','job-24-pack-1-smyary','Reusable Quotation phase tasks',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,24),(106,1,'JOB25-P1-LIXNI','[Job JOB-2026-00150] Quotation','job-25-pack-1-0pavjn','Reusable Quotation phase tasks',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,25),(107,1,'JOB17-P1-GVDEJ','[Job JOB-2026-00109] Quotation','job-17-pack-1-rgzlwz','Reusable Quotation phase tasks',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,17),(108,1,'JOB13-P1-JX1XS','[Job JOB-2026-00113] Quotation','job-13-pack-1-qxzrvc','Reusable Quotation phase tasks',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,13),(109,1,'JOB22-P1-6R5JS','[Job JOB-2026-00147] Quotation','job-22-pack-1-raemjo','Reusable Quotation phase tasks',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,22),(110,1,'JOB10-P1-IHGXW','[Job JOB-2026-00116] Quotation','job-10-pack-1-giy4ni','Reusable Quotation phase tasks',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,10),(111,1,'JOB7-P1-IBBAH','[Job JOB-2026-00119] Quotation','job-7-pack-1-shun64','Reusable Quotation phase tasks',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,7),(112,1,'JOB20-P1-XOLVX','[Job JOB-2026-00145] Quotation','job-20-pack-1-1kn7u1','Reusable Quotation phase tasks',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,20),(113,1,'JOB11-P1-ZJNV0','[Job JOB-2026-00115] Quotation','job-11-pack-1-vfelje','Reusable Quotation phase tasks',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,11),(114,1,'JOB2-P1-GFXTH','[Job JOB-2026-00124] Quotation','job-2-pack-1-8qt3za','Reusable Quotation phase tasks',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,2),(115,1,'JOB15-P1-Z3JJO','[Job JOB-2026-00111] Quotation','job-15-pack-1-rkse9m','Reusable Quotation phase tasks',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,15),(116,1,'JOB3-P1-1JQ7E','[Job JOB-2026-00123] Quotation','job-3-pack-1-yfowvs','Reusable Quotation phase tasks',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,3),(117,1,'JOB16-P1-LTECP','[Job JOB-2026-00110] Quotation','job-16-pack-1-dotwcz','Reusable Quotation phase tasks',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,16),(118,1,'JOB12-P1-HRCCX','[Job JOB-2026-00114] Quotation','job-12-pack-1-fnalhi','Reusable Quotation phase tasks',0,'2026-08-07 08:34:44','2026-08-07 08:34:44',1,1,12),(119,1,'JOB1-P1-WGUK2','[Job JOB-2026-00125] Quotation','job-1-pack-1-zaniti','Reusable Quotation phase tasks',0,'2026-08-07 08:34:44','2026-08-07 08:34:44',1,1,1),(120,1,'JOB4-P1-WFXQA','[Job JOB-2026-00122] Quotation','job-4-pack-1-vkwz5m','Reusable Quotation phase tasks',0,'2026-08-07 08:34:44','2026-08-07 08:34:44',1,1,4),(121,1,'JOB18-P1-JRQ8F','[Job JOB-2026-00108] Quotation','job-18-pack-1-rf0ahl','Reusable Quotation phase tasks',0,'2026-08-07 08:34:44','2026-08-07 08:34:44',1,1,18);
/*!40000 ALTER TABLE `task_packs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: tasks
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `tasks`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT  IGNORE INTO `tasks` VALUES (1,'TSK-301',1,240,NULL,26,'task_pack',NULL,NULL,NULL,NULL,NULL,'Confirm materials ready',NULL,'Completed',1349174,'High',100,NULL,'2026-08-04',0,NULL,NULL,NULL,'2026-08-03 19:08:28','2026-08-04 19:08:28','2026-08-07 08:34:44',NULL),(2,'TSK-302',1,240,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Start production',NULL,'In Progress',1349171,'High',75,NULL,'2026-08-05',1,1349167,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44',NULL),(3,'TSK-303',1,240,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Update production milestone',NULL,'Ready',1349170,'High',45,NULL,'2026-08-06',1,1349167,1348850,'Blocked',NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44',NULL),(4,'TSK-304',1,240,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Perform quality inspection',NULL,'Ready',1349170,'High',10,NULL,'2026-08-07',1,1349167,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:44',NULL),(5,'TSK-305',2,183,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Collect artwork requirements',NULL,'Completed',1349174,'High',100,NULL,'2026-08-17',0,NULL,NULL,NULL,'2026-08-03 19:08:28','2026-08-04 19:08:28','2026-08-07 08:34:43',NULL),(6,'TSK-306',2,183,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Prepare artwork',NULL,'In Progress',1349171,'High',75,NULL,'2026-08-18',0,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43',NULL),(7,'TSK-307',2,183,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Internal artwork review',NULL,'Waiting for Client',NULL,'High',45,NULL,'2026-08-19',1,1349160,1348850,'Blocked',NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43',NULL),(8,'TSK-308',2,183,NULL,24,'task_pack',NULL,NULL,NULL,NULL,NULL,'Submit artwork to client',NULL,'Ready',1349170,'High',10,NULL,'2026-08-20',0,NULL,NULL,NULL,NULL,'2026-08-04 19:08:28','2026-08-07 08:34:43',NULL),(9,'TSK-309',3,206,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Prepare swatch or sample',NULL,'Completed',1349174,'Medium',100,NULL,'2026-08-30',0,NULL,NULL,NULL,'2026-08-03 19:08:29','2026-08-04 19:08:29','2026-08-07 08:34:43',NULL),(10,'TSK-310',3,206,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Internal swatch review',NULL,'In Progress',1349171,'Medium',75,NULL,'2026-08-31',0,NULL,NULL,NULL,NULL,'2026-08-04 19:08:29','2026-08-07 08:34:43',NULL),(11,'TSK-311',3,206,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Arrange courier submission',NULL,'Ready',1349170,'Medium',45,NULL,'2026-09-01',0,NULL,NULL,NULL,NULL,'2026-08-04 19:08:29','2026-08-07 08:34:43',NULL),(12,'TSK-312',3,206,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Record client feedback',NULL,'Ready',1349170,'Medium',10,NULL,'2026-09-02',0,NULL,NULL,NULL,NULL,'2026-08-04 19:08:29','2026-08-07 08:34:43',NULL),(13,'TSK-313',4,251,NULL,26,'task_pack',NULL,NULL,NULL,NULL,NULL,'Confirm materials ready',NULL,'Completed',1349174,'Critical',100,NULL,'2026-08-25',0,NULL,NULL,NULL,'2026-08-03 19:08:29','2026-08-04 19:08:29','2026-08-07 08:34:44',NULL),(14,'TSK-314',4,251,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Start production',NULL,'In Progress',1349171,'Critical',75,NULL,'2026-08-26',0,NULL,NULL,NULL,NULL,'2026-08-04 19:08:29','2026-08-07 08:34:44',NULL),(15,'TSK-315',4,251,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Update production milestone',NULL,'Blocked',NULL,'Critical',45,NULL,'2026-08-27',1,1349160,1348850,'Blocked',NULL,'2026-08-04 19:08:29','2026-08-07 08:34:44',NULL),(16,'TSK-316',4,251,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Perform quality inspection',NULL,'Ready',1349170,'Critical',10,NULL,'2026-08-28',0,NULL,NULL,NULL,NULL,'2026-08-04 19:08:29','2026-08-07 08:34:44',NULL),(17,'TSK-317',5,274,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Review or update shipment details',NULL,'Completed',1349174,'High',100,NULL,'2026-07-31',0,NULL,NULL,NULL,'2026-08-03 19:08:29','2026-08-04 19:08:29','2026-08-31 20:10:18',NULL),(18,'TSK-318',5,274,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Prepare packing list',NULL,'In Progress',1349171,'High',75,NULL,'2026-08-01',1,1349167,NULL,NULL,NULL,'2026-08-04 19:08:29','2026-08-07 08:34:44',NULL),(19,'TSK-319',5,274,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Book shipment',NULL,'Ready',1349170,'High',45,NULL,'2026-08-02',1,1349167,NULL,NULL,NULL,'2026-08-04 19:08:29','2026-08-07 08:34:44',NULL),(20,'TSK-320',5,274,NULL,27,'task_pack',NULL,NULL,NULL,NULL,NULL,'Upload shipment documents',NULL,'Ready',1349170,'High',10,NULL,'2026-08-03',1,1349167,NULL,NULL,NULL,'2026-08-04 19:08:29','2026-08-07 08:34:44',NULL);
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: user_roles
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `user_roles`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT  IGNORE INTO `user_roles` VALUES (1,12,'2026-08-04 19:08:18','2026-08-10 01:29:20'),(14,10,'2026-08-05 05:44:07','2026-08-07 20:46:21'),(15,1,'2026-09-29 02:16:54','2026-09-29 02:16:54'),(15,24,'2026-08-19 19:31:16','2026-08-19 19:31:16'),(15,25,'2026-08-05 05:46:11','2026-08-14 02:03:25'),(16,5,'2026-08-05 05:50:23','2026-08-14 01:39:10'),(17,5,'2026-08-05 05:51:15','2026-08-14 01:56:43'),(18,5,'2026-08-05 05:52:27','2026-08-14 01:57:01'),(19,10,'2026-08-05 05:53:15','2026-08-07 20:56:18'),(20,10,'2026-08-05 05:54:07','2026-08-07 20:55:43'),(21,10,'2026-08-05 05:58:40','2026-08-07 20:55:05'),(22,10,'2026-08-05 05:59:14','2026-08-07 20:54:18'),(23,10,'2026-08-05 05:59:49','2026-08-07 20:53:34'),(24,10,'2026-08-05 06:00:50','2026-08-07 20:52:51'),(25,10,'2026-08-05 06:01:19','2026-08-07 20:52:05'),(26,9,'2026-08-05 06:01:52','2026-08-14 02:11:39'),(27,9,'2026-08-05 06:02:25','2026-08-14 02:12:48'),(28,10,'2026-08-05 06:03:38','2026-08-07 20:48:49'),(29,10,'2026-08-05 06:04:19','2026-08-07 20:48:00'),(30,10,'2026-08-05 06:06:57','2026-08-07 18:31:02');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: users
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `users`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT  IGNORE INTO `users` VALUES (1,12,1,'StepPromo Super Admin','admin@flowtrack.com','2026-08-08 03:09:48','$2y$12$7KGMhogdo/.5JC0XS9irO.oQPHtIZjuXtax.QBM1lqhUJyXJ2mR6O',1,1,'en','profile-images/1/P9OcfQFg2ZXwvLIi4ns8F6GehKry2GFtkEqryjZ4.webp','NqWhXdpXpw9i1RUJusKO4AcxhXQOgICZGgyBVztTHZaMQghDiceDnsXRFEva','2026-08-04 19:08:18','2026-08-10 01:29:20',NULL,NULL,'active'),(14,10,44,'Cindy','hr@luggageornate.com',NULL,'$2y$12$It0VIVTFZnErOILrAXsa0OhAmkaSaLPtATeDk7sBtRgCyWQNCGcjO',0,1,'en','profile-images/14/I9ObP41zDUfieD1TBuEt0XTosUo0vZFvZ7Ge6S1s.png','3SEOGKnOnOAP4BZkuqrgcIvXm3Er3Tu4hoajhBfqq0dLMadFQvuEPGAL9RnV','2026-08-05 05:44:07','2026-09-29 22:14:56',NULL,'13555618855','active'),(15,25,47,'Amy','inquiry@steppromo.com',NULL,'$2y$12$JOAgpd2r59cYbqo33fCpA.kk42RyHo3a8/6cKMILge5aHheVVcT9e',0,1,'en','profile-images/15/RVaajwTGyP3Qc8vMOBDXrUSGZ576r76UNlM2oGo0.webp','R6u8AzpE0O4ns7H6MkcQnHqFUw4NB0QTMiktBoHpgN33kSHDq8iu4J6grrcT','2026-08-05 05:46:11','2026-08-14 02:03:25',NULL,'15322688871','active'),(16,5,40,'Qiao','artist2@steppromo.com',NULL,'$2y$12$yY3q7vhv2OmDppz3hmwlierKUrH0Q0RYIAYmSXjugJ5IlzDaXYr5a',0,1,'en','profile-images/16/X72y5OYGOCLLR9dtz2xuG1IHRFb6dHY1WGS40Sdm.webp','58Ea9vuT9nGQWEAMWneg99F006yQIOLVbmUp40Yk7hi2tSsTLUKi3xg4E3dC','2026-08-05 05:50:23','2026-09-29 22:22:08',NULL,'13630403189','active'),(17,5,40,'Luna','779496212@qq.com',NULL,'$2y$12$Lwwj3szPkJnYzySoRk94SO3UCeojZmL2Xn/7FlmDQR5zJKXLxvDk2',0,1,'en','profile-images/17/bGXK56W0wWLqdYlGdPTthRYi1tjlw95L9VpjQl9P.webp',NULL,'2026-08-05 05:51:15','2026-08-14 01:56:43',NULL,'13612271819','active'),(18,5,40,'WING','cl4all@steppromo.com',NULL,'$2y$12$QEoyWah18PVpjZKEmmio0ue6y8.7DEtzn/XfcdSFvP7G1NkF0Qzf.',0,1,'en','profile-images/18/oa9kaqMo9ZyyZlbo9uMyzQ18wa50aQfAwnIwmdEJ.png','ZpMhFWuveJYDhxYXp3rbaAFrMm5zMVwjcL5fWbB9VFSfpNoTKJNQPcwW3zFQ','2026-08-05 05:52:27','2026-09-29 22:06:39',NULL,'15994894621','active'),(19,10,41,'Klein','zhouhai24@qq.com',NULL,'$2y$12$VzkJtnF88VSM9y5vEGkcueSmsSJG19jadXmBlVC7JfSZAdPikcdq6',0,1,'en','profile-images/19/gCYpVZDrQHVpmGWMPXl4ylHfDFEylAsrk4nJpT9U.png',NULL,'2026-08-05 05:53:15','2026-08-07 20:56:18',NULL,'13702240716','active'),(20,10,41,'Kiki','1733453716@qq.com',NULL,'$2y$12$.2CsEP3QN33VRggD2UHTYOXiqEVlfz4gPqI6ExjdteZZHrJASC.ai',0,1,'en','profile-images/20/r4Au7vLFxs4WxktZAPFDwRnA8ApEQQqj4RV8FxV5.png',NULL,'2026-08-05 05:54:07','2026-08-07 20:55:43',NULL,'13822430289','active'),(21,10,41,'Sharon','286769679@qq.com',NULL,'$2y$12$FdthDK83sJV/Yf27WJ/Od.eVTqZ2IfjZkUSzqawrKnensD1v47ZIa',0,1,'en','profile-images/21/r50bVszLRP8q4Sx2fWyn4PMd79hE3hCqNVyqDC7z.png',NULL,'2026-08-05 05:58:40','2026-08-07 20:55:05',NULL,'13427418082','active'),(22,10,41,'Kira','291883133@qq.com',NULL,'$2y$12$Vb60NWLBsXopYDjJC3Zi9OAvSgJ2pcPN3t/DDLbgo5yNch6lzv5ly',0,1,'en','profile-images/22/UgGxACeW5TCmBrhHqL9uzcI175rWKF3ZzamLVXaI.png',NULL,'2026-08-05 05:59:14','2026-08-07 20:54:18',NULL,'13059288443','active'),(23,10,41,'Lily','953875435@qq.com',NULL,'$2y$12$jrowlNUEklNoj5uZbo7mYOlvW5guxgT38IiDSQVpMkqezG/1yKJ0C',0,1,'en','profile-images/23/DM8ZDLtHa1ANSGqiuklwLJDHviCeHHkKWzRau6FZ.png',NULL,'2026-08-05 05:59:49','2026-08-07 20:53:34',NULL,'15817792059','active'),(24,10,41,'Zoe','zoe@flowtrack.com',NULL,'$2y$12$/Dx/b5lN5RqANVE.T5JlAOfw193EvnUclK469ll8Gcvr8AElNfCs.',0,1,'en','profile-images/24/YP3qNLQeQCADb6SbEDMnEclwKl6xWZhPIE1snvL4.png',NULL,'2026-08-05 06:00:50','2026-08-07 20:52:51',NULL,'19185904489','active'),(25,10,42,'Qiong','hr1@luggageornate.com',NULL,'$2y$12$xuCnia9LwDrHtIJSNe3X7.he44tfmuW0xDULYqYeqQC2CirUzDvLC',0,1,'en','profile-images/25/dEyxhHjWN92xZLDnuzRlr2V1L81tgpaR1CfOSIpx.png',NULL,'2026-08-05 06:01:19','2026-09-29 22:11:28',NULL,'18926398139','active'),(26,9,43,'Sunny','3201773314@QQ.com',NULL,'$2y$12$CSB73B64nkkUdsxxekJtye6CA/GiVB1r1gOSlKNpgR4Uwg3Suo6Ou',0,1,'en','profile-images/26/qfY6IIadYwbD9EHry2dai9cCMgYrd5cvzuUYd0Ix.png','qKevQZc7qRpFXjBSRsRk05zLihUqg2hiBegaYFU6ArDcOaeI5nlxwWcI4w7I','2026-08-05 06:01:52','2026-08-14 02:11:39',NULL,'18138661862','active'),(27,9,43,'Yoyo','240172815@qq.com',NULL,'$2y$12$7BeFyROR..Z4/leUWrxafOLnQvGWAGTp3U2JQpzBf.c/TNGryHXCu',0,1,'en','profile-images/27/aMhWHYRerL1aT6bmJ595NBzqgrPKpgie9RuPEcbe.png','pGbgvPJMp4EwXofze5m16c40v1RkBzadUcOnSmA5lr6n8zfHUO3SA2PaNjg9','2026-08-05 06:02:25','2026-08-14 02:12:48',NULL,'13422502805','active'),(28,10,43,'Michelle','mich@flowtrack.com',NULL,'$2y$12$Ur.onwB8FWH84XXNBXdmMeV5x32uxHr4HE22SpjGxYCpkA37Ytwmm',0,1,'en','profile-images/28/1ezJdhpLWme6TuXwzlkwqWdyW49IApSeKYRHGrhK.png',NULL,'2026-08-05 06:03:38','2026-08-07 20:48:49',NULL,'13702410889','active'),(29,10,43,'Milly','accountant@luggageornate.com',NULL,'$2y$12$2/m3JlVLf/7xsbHpC7Jpy.rRW9z19ljQFNzIEpbbUHbMAPE2seWRy',0,1,'en','profile-images/29/UcfO59IeZ17FmajUOSgRziy8xs0SAcEdIe7AwnOc.png','jOLFeXaQdBlKEeg2V2l75r6pwASKlhLKQpkCdpRON7EYUG1jGXdVS4hdji8S','2026-08-05 06:04:19','2026-10-04 22:37:55',NULL,'13702240515','active'),(30,10,44,'Ina','sales4@luggageornate.com',NULL,'$2y$12$cUqFqKlWjUS8yh4lob2.Qu.dwzSar9Ae4d7ly7DpGE3ysD17k1DLK',0,1,'en','profile-images/30/Rym5J3P627TN06MBr42eFA2ZbHdqfa5XJip28Jnw.webp',NULL,'2026-08-05 06:06:57','2026-08-07 18:31:02',NULL,'13702240031','active'),(31,24,45,'Nicole','inquiry2@steppromo.com',NULL,'$2y$12$VC/r4in1H3MGRoE.PtGN8OFP4iGj3hJRd.EGcSPDtkxL/oznmuBPy',0,1,'en','profile-images/31/mTyqKCfA9exy2E4vPbtsDiya1P17fd4F37fGMJnt.webp','8oaWrnrlH1j7cqFzK73IOCwX8zgV4pu5P46r4fHsur0LUIt5TxnBtV7zVbFc','2026-08-05 06:07:34','2026-09-29 21:47:29',NULL,'13119669572','active'),(32,24,45,'Yen','info@steppromo.com',NULL,'$2y$12$j1xAbj6OLIGte/IguOyDCO1/gaaHtAZu/3FlFZPg9iyATQYso/T1q',0,1,'en','profile-images/32/4lsUnsgvRtUA7yJQnrU6dqZLBoRJc30Rh8zExXfb.webp','6mZwKScGxSMbPWZnyIdnZSbRAe5E9TRjZ0DXVvd8z0p7LIPRwBsRBGtVh7Xr','2026-08-05 06:08:30','2026-08-17 23:35:29',NULL,'15975015332','active');
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

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: workflow_phases
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `workflow_phases`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `workflow_phases` WRITE;
/*!40000 ALTER TABLE `workflow_phases` DISABLE KEYS */;
INSERT  IGNORE INTO `workflow_phases` VALUES (44,NULL,5,NULL,NULL,1,'Sales & Requirements','SR','#7C3AED',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',12),(45,NULL,5,NULL,NULL,2,'Costing & Quotation','CQ','#2563EB',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',13),(46,NULL,5,NULL,NULL,3,'Order Confirmation & Planning','OCP','#D97706',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',14),(47,NULL,5,NULL,NULL,4,'Artwork & Pre-Production Approval','ARP','#059669',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',15),(48,NULL,5,NULL,NULL,5,'Procurement & Material Receiving','PMR','#DB2777',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',16),(49,NULL,5,NULL,NULL,6,'Printing & Dye-Sublimation','PDS','#0891B2',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',17),(50,NULL,5,NULL,NULL,7,'Laser Cutting','LC','#DC2626',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',18),(51,NULL,5,NULL,NULL,8,'Sewing & Assembly','SA','#4F46E5',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',19),(52,NULL,5,102,NULL,9,'Final Quality Control','FQC','#7C3AED',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',20),(53,NULL,5,NULL,NULL,10,'Packaging','PAC','#2563EB',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',21),(54,NULL,5,NULL,NULL,11,'Finished Goods & Dispatch','FGD','#D97706',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',22),(55,NULL,5,NULL,NULL,12,'Delivery, Billing & Closure','DBC','#059669',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',23),(56,NULL,6,NULL,NULL,1,'Sales & Requirements','SR','#7C3AED',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',12),(57,NULL,6,NULL,NULL,2,'Costing & Quotation','CQ','#2563EB',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',13),(58,NULL,6,NULL,NULL,3,'Order Confirmation & Planning','OCP','#D97706',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',14),(59,NULL,6,NULL,NULL,4,'Artwork & Pre-Production Approval','ARP','#059669',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',15),(60,NULL,6,NULL,NULL,5,'Procurement & Material Receiving','PMR','#DB2777',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',16),(61,NULL,6,NULL,NULL,6,'Printing & Dye-Sublimation','PDS','#0891B2',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',17),(62,NULL,6,NULL,NULL,7,'Laser Cutting','LC','#DC2626',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',18),(63,NULL,6,NULL,NULL,8,'Sewing & Assembly','SA','#4F46E5',1,1,1,0,1,1,'Previous phase complete','Required work complete',NULL,'Previous phase complete','Required work complete','2026-08-07 07:22:00','2026-08-07 07:22:00',19);
/*!40000 ALTER TABLE `workflow_phases` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:31

-- ==================================================
-- SAMPLE DATA: workflow_template_client
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `workflow_template_client`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `workflow_template_client` WRITE;
/*!40000 ALTER TABLE `workflow_template_client` DISABLE KEYS */;
INSERT  IGNORE INTO `workflow_template_client` VALUES (1,30,11,'2026-08-10 01:05:08','2026-08-10 01:05:08'),(3,32,14,'2026-08-10 01:11:30','2026-08-10 01:11:30'),(4,33,11,'2026-08-10 10:07:56','2026-08-10 10:07:56'),(5,36,14,'2026-08-10 10:13:14','2026-08-10 10:13:14');
/*!40000 ALTER TABLE `workflow_template_client` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:32

-- ==================================================
-- SAMPLE DATA: workflow_templates
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `workflow_templates`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `workflow_templates` WRITE;
/*!40000 ALTER TABLE `workflow_templates` DISABLE KEYS */;
INSERT  IGNORE INTO `workflow_templates` VALUES (30,1,'IID_WORKFLOW','IID Order workflow',NULL,'orders','specific',1,1,2,'2026-08-07 08:39:07','2026-08-30 08:47:38'),(32,1,'NEP_WORKFLOW','NEP Order Workflow',NULL,'orders','specific',1,0,2,'2026-08-07 13:57:26','2026-08-30 08:50:04'),(33,1,'INQUIRY_FLOW','IID Inquiry Flow','Inquiry flow for the request','inquiries','specific',1,0,1,'2026-08-08 12:12:28','2026-08-10 10:07:56'),(36,1,'INQUIRY_NEP','NEP Inquiry Flow',NULL,'inquiries','specific',1,0,1,'2026-08-10 10:13:14','2026-08-10 10:20:22');
/*!40000 ALTER TABLE `workflow_templates` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:32

-- ==================================================
-- SAMPLE DATA: workflows
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `workflows`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `workflows` WRITE;
/*!40000 ALTER TABLE `workflows` DISABLE KEYS */;
INSERT  IGNORE INTO `workflows` VALUES (5,'Custom Promo Products','job-21-custom-promo-products-ay5a6k','Manages custom printed and sewn product Jobs from client requirements, costing and artwork approval through material procurement, printing, dye-sublimation, cutting, sewing, quality control, packaging, shipment, invoicing and final delivery.',0,'2026-08-07 07:22:00','2026-08-07 07:22:00',1,2,21),(6,'Custom Promo Products','job-23-custom-promo-products-xaswdp','Manages custom printed and sewn product Jobs from client requirements, costing and artwork approval through material procurement, printing, dye-sublimation, cutting, sewing, quality control, packaging, shipment, invoicing and final delivery.',0,'2026-08-07 07:22:00','2026-08-07 07:22:00',1,2,23),(7,'Standard Promotional Products','job-19-standard-promotional-products-tpl0kp','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,19),(8,'Standard Promotional Products','job-24-standard-promotional-products-z8n7mh','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,24),(9,'Standard Promotional Products','job-25-standard-promotional-products-wpbbvp','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,25),(10,'Standard Promotional Products','job-17-standard-promotional-products-16nuan','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,17),(11,'Standard Promotional Products','job-13-standard-promotional-products-ylmkrl','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,13),(12,'Standard Promotional Products','job-22-standard-promotional-products-6ogovs','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:42','2026-08-07 08:34:42',1,1,22),(13,'Standard Promotional Products','job-10-standard-promotional-products-swgyhu','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,10),(14,'Standard Promotional Products','job-7-standard-promotional-products-yoqwxt','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,7),(15,'Standard Promotional Products','job-20-standard-promotional-products-b4xrp6','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,20),(16,'Standard Promotional Products','job-11-standard-promotional-products-t5ilso','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,11),(17,'Standard Promotional Products','job-2-standard-promotional-products-nm4vsr','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,2),(18,'Standard Promotional Products','job-15-standard-promotional-products-k0eas8','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,15),(19,'Standard Promotional Products','job-3-standard-promotional-products-3dsv99','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,3),(20,'Standard Promotional Products','job-16-standard-promotional-products-kc0yrf','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:43','2026-08-07 08:34:43',1,1,16),(21,'Standard Promotional Products','job-12-standard-promotional-products-w1ap3w','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:44','2026-08-07 08:34:44',1,1,12),(22,'Standard Promotional Products','job-1-standard-promotional-products-pwndzp','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:44','2026-08-07 08:34:44',1,1,1),(23,'Standard Promotional Products','job-4-standard-promotional-products-mzs0bq','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:44','2026-08-07 08:34:44',1,1,4),(24,'Standard Promotional Products','job-18-standard-promotional-products-vtzvri','Full request-to-payment process for new enquiries and custom orders.',0,'2026-08-07 08:34:44','2026-08-07 08:34:44',1,1,18);
/*!40000 ALTER TABLE `workflows` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:32

-- ==================================================
-- SAMPLE DATA: workspace_memberships
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `workspace_memberships`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `workspace_memberships` WRITE;
/*!40000 ALTER TABLE `workspace_memberships` DISABLE KEYS */;
INSERT  IGNORE INTO `workspace_memberships` VALUES (1,1,1,12,1,'Super Administrator','active','2026-08-04 19:08:18','2026-08-04 19:08:18','2026-08-04 19:08:18','both'),(14,1,14,10,44,'HR Manager','active','2026-08-05 05:44:07','2026-08-05 05:44:07','2026-08-07 20:46:21','both'),(15,1,15,25,47,'Product development manager','active','2026-08-05 05:46:11','2026-08-05 05:46:11','2026-08-14 02:03:25','both'),(16,1,16,5,40,'Graphic Designer','active','2026-08-05 05:50:23','2026-08-05 05:50:24','2026-08-14 01:39:10','both'),(17,1,17,5,40,'Product Designer','active','2026-08-05 05:51:15','2026-08-05 05:51:15','2026-08-14 01:56:43','both'),(18,1,18,5,40,'Graphic Designer','active','2026-08-05 05:52:27','2026-08-05 05:52:27','2026-08-14 01:57:01','both'),(19,1,19,10,41,'Operations Supervisor','active','2026-08-05 05:53:15','2026-08-05 05:53:16','2026-08-07 20:56:18','both'),(20,1,20,10,41,'PDD-customer service','active','2026-08-05 05:54:07','2026-08-05 05:54:07','2026-08-07 20:55:43','both'),(21,1,21,10,41,'1688 customer service','active','2026-08-05 05:58:40','2026-08-05 05:58:40','2026-08-07 20:55:05','both'),(22,1,22,10,41,'Tik Tok  anchor','active','2026-08-05 05:59:14','2026-08-05 05:59:14','2026-08-07 20:54:18','both'),(23,1,23,10,41,'Tik Tok  anchor','active','2026-08-05 05:59:49','2026-08-05 05:59:49','2026-08-07 20:53:34','both'),(24,1,24,10,41,'Tik Tok  anchor','active','2026-08-05 06:00:50','2026-08-05 06:00:50','2026-08-07 20:52:51','both'),(25,1,25,10,42,'Embroidery Supervisor','active','2026-08-05 06:01:19','2026-08-05 06:01:19','2026-08-07 20:52:05','both'),(26,1,26,9,43,'Cashier','active','2026-08-05 06:01:52','2026-08-05 06:01:52','2026-08-14 02:11:39','both'),(27,1,27,9,43,'Accounting','active','2026-08-05 06:02:25','2026-08-05 06:02:25','2026-08-14 02:12:48','both'),(28,1,28,10,43,'Cost accounting','active','2026-08-05 06:03:38','2026-08-05 06:03:38','2026-08-07 20:48:49','both'),(29,1,29,10,43,'Junior cashier','active','2026-08-05 06:04:19','2026-08-05 06:04:19','2026-08-07 20:48:00','both'),(30,1,30,10,44,'HR Analyst','active','2026-08-05 06:06:57','2026-08-05 06:06:57','2026-08-07 18:31:02','both'),(31,1,31,24,45,'Junior Business Representative','active','2026-08-05 06:07:34','2026-08-05 06:07:34','2026-09-29 21:47:29','iid'),(32,1,32,24,45,'Business representative','active','2026-08-05 06:08:30','2026-08-05 06:08:30','2026-08-17 23:35:29','both');
/*!40000 ALTER TABLE `workspace_memberships` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:32

-- ==================================================
-- SAMPLE DATA: workspaces
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `workspaces`
--
-- WHERE:  1 LIMIT 20

LOCK TABLES `workspaces` WRITE;
/*!40000 ALTER TABLE `workspaces` DISABLE KEYS */;
INSERT  IGNORE INTO `workspaces` VALUES (1,'FlowTrack','flowtrack','Asia/Dhaka','USD','branding/1/logo/986c1b2d-c228-49e0-bb54-5766a5f010fc.webp','branding/1/favicon/82da04cf-857b-4f4f-ba89-e2cf83159af5.webp','{\"city\": \"\", \"phone\": \"\", \"country\": \"\", \"website\": \"\", \"bank_iban\": \"\", \"bank_name\": \"\", \"bank_swift\": \"\", \"legal_name\": \"Step Promo\", \"tax_number\": \"\", \"postal_code\": \"\", \"state_region\": \"\", \"trading_name\": \"\", \"billing_email\": \"\", \"address_line_1\": \"\", \"address_line_2\": \"\", \"invoice_footer\": \"\", \"bank_account_name\": \"\", \"bank_account_number\": \"\", \"registration_number\": \"\", \"payment_instructions\": \"\"}',1,'2026-08-04 19:08:01','2026-08-16 19:20:40');
/*!40000 ALTER TABLE `workspaces` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:08:32

SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;

-- ===============================================
-- REQUIRED ADMIN / SUPER ADMIN ACCOUNTS
-- ===============================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `users`
--
-- WHERE:  id IN (1,15,32,57,58)

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT  IGNORE INTO `users` VALUES (1,12,1,'StepPromo Super Admin','admin@flowtrack.com','2026-08-08 03:09:48','$2y$12$7KGMhogdo/.5JC0XS9irO.oQPHtIZjuXtax.QBM1lqhUJyXJ2mR6O',1,1,'en','profile-images/1/P9OcfQFg2ZXwvLIi4ns8F6GehKry2GFtkEqryjZ4.webp','NqWhXdpXpw9i1RUJusKO4AcxhXQOgICZGgyBVztTHZaMQghDiceDnsXRFEva','2026-08-04 19:08:18','2026-08-10 01:29:20',NULL,NULL,'active'),(15,25,47,'Amy','inquiry@steppromo.com',NULL,'$2y$12$JOAgpd2r59cYbqo33fCpA.kk42RyHo3a8/6cKMILge5aHheVVcT9e',0,1,'en','profile-images/15/RVaajwTGyP3Qc8vMOBDXrUSGZ576r76UNlM2oGo0.webp','R6u8AzpE0O4ns7H6MkcQnHqFUw4NB0QTMiktBoHpgN33kSHDq8iu4J6grrcT','2026-08-05 05:46:11','2026-08-14 02:03:25',NULL,'15322688871','active'),(32,24,45,'Yen','info@steppromo.com',NULL,'$2y$12$j1xAbj6OLIGte/IguOyDCO1/gaaHtAZu/3FlFZPg9iyATQYso/T1q',0,1,'en','profile-images/32/4lsUnsgvRtUA7yJQnrU6dqZLBoRJc30Rh8zExXfb.webp','6mZwKScGxSMbPWZnyIdnZSbRAe5E9TRjZ0DXVvd8z0p7LIPRwBsRBGtVh7Xr','2026-08-05 06:08:30','2026-08-17 23:35:29',NULL,'15975015332','active'),(57,1,1,'Ashraf','ashraf@flowtrack.com',NULL,'$2y$12$E.60/BPK2Qn4j2kFtZoqYuC4jVgGH13wApLI2SeD3qAmfFA2rN2kG',0,1,'en','profile-images/57/lkiDohq9EYM0ClnnPZUK6QIdt8hGL2a75ASW0VmU.webp','Y0icSYaNCiWtN6t6O3F3NfXQEwBdEn6syy8DQt2sX1LfEEPJvTWumghNr7hB','2026-08-05 06:27:48','2026-08-10 01:31:09',NULL,NULL,'active'),(58,12,NULL,'StepPromo Admin','admin@flowtracker.com',NULL,'$2y$12$NkhQ5hSQhr74WhVnK0p5YeMP0bZDgvF2E1tcfIhKZo6Jmnx.T8ANi',0,1,'en','profile-images/58/48H3Gtpo2OhQElHNtGxwtkCt5EGRHm4VAFLdTH6I.webp','TNFUhWNAYqT3EayjUDle423F6XVJJu6EZDBKKJsgHdt5hyzilQaV5iZYpZQK','2026-08-05 17:29:22','2026-08-10 01:29:06',NULL,NULL,'active');
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

-- Dump completed on 2026-10-06  1:12:39

-- ===============================================
-- COMPLETE AUTHORIZATION CONFIGURATION
-- ===============================================
SET FOREIGN_KEY_CHECKS=0;
SET UNIQUE_CHECKS=0;


-- ==================================================
-- FULL AUTH CONFIG: workspaces
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `workspaces`
--

LOCK TABLES `workspaces` WRITE;
/*!40000 ALTER TABLE `workspaces` DISABLE KEYS */;
INSERT  IGNORE INTO `workspaces` VALUES (1,'FlowTrack','flowtrack','Asia/Dhaka','USD','branding/1/logo/986c1b2d-c228-49e0-bb54-5766a5f010fc.webp','branding/1/favicon/82da04cf-857b-4f4f-ba89-e2cf83159af5.webp','{\"city\": \"\", \"phone\": \"\", \"country\": \"\", \"website\": \"\", \"bank_iban\": \"\", \"bank_name\": \"\", \"bank_swift\": \"\", \"legal_name\": \"Step Promo\", \"tax_number\": \"\", \"postal_code\": \"\", \"state_region\": \"\", \"trading_name\": \"\", \"billing_email\": \"\", \"address_line_1\": \"\", \"address_line_2\": \"\", \"invoice_footer\": \"\", \"bank_account_name\": \"\", \"bank_account_number\": \"\", \"registration_number\": \"\", \"payment_instructions\": \"\"}',1,'2026-08-04 19:08:01','2026-08-16 19:20:40');
/*!40000 ALTER TABLE `workspaces` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:12:53

-- ==================================================
-- FULL AUTH CONFIG: roles
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT  IGNORE INTO `roles` VALUES (1,1,'Admin','admin','ADMIN','Admin with unrestricted FlowTrack access.','all_records',1,1,'[\"supplier_cost\", \"gross_margin\", \"client_target_price\", \"confirmed_selling_price\", \"invoice_amount\", \"payment_history\", \"internal_management_notes\", \"client_contact_details\", \"supplier_banking_details\"]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(2,1,'Management','management','MANAGEMENT','Organization-wide visibility and exception management.','all_records',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(3,1,'Job Manager','job-manager','JOB_MANAGER','Manages assigned Jobs, phases, people and tasks.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(4,1,'Sales User','sales-user','SALES','Creates and maintains client, Job and quotation records for assigned work.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(5,1,'Designer','designer','DESIGNER','Works on assigned artwork tasks and document versions.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(6,1,'Sourcing Coordinator','sourcing-coordinator','SOURCING','Coordinates supplier costing, samples and sourcing tasks.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(7,1,'Production User','production-user','PRODUCTION','Updates assigned production tasks and production evidence.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(8,1,'Shipment User','shipment-user','SHIPMENT','Updates assigned shipment tasks, tracking and documents.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(9,1,'Accounts User','accounts-user','ACCOUNTS','Handles assigned invoice, payment and reporting work.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(10,1,'General Team Member','general-team-member','TEAM_MEMBER','Views and updates only work assigned to the user.','assigned_jobs',1,1,'[]','2026-08-04 19:08:08','2026-08-04 19:08:08'),(11,1,'Read-only Auditor','read-only-auditor','AUDITOR','Read/export access without operational updates.','all_records',1,1,'[]','2026-08-04 19:08:09','2026-08-04 19:08:09'),(12,1,'Super Admin','super-admin','SUPER_ADMIN','Super Admin with unrestricted FlowTrack access.','all_records',1,1,NULL,'2026-08-04 19:08:18','2026-08-04 19:08:18'),(13,NULL,'Operations Manager','operations-manager',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(14,NULL,'Sales Manager','sales-manager',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(15,NULL,'Sales Executive','sales-executive',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(16,NULL,'Sourcing Coordinator','sourcing',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(17,NULL,'Production Coordinator','production',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(18,NULL,'Quality Inspector','quality',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(19,NULL,'Shipping Executive','shipment',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(20,NULL,'Accounts Officer','accounts',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(21,NULL,'Sample Coordinator','sampling',NULL,NULL,'assigned_jobs',0,1,NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(22,1,'Wei','transfer-machine-operation','TRANSFER MACHINE OPERATION',NULL,'assigned_jobs',0,1,NULL,'2026-08-07 21:03:02','2026-08-07 21:03:02'),(23,1,'Inquiry Team','inquiry-team','INQUIRY_TEAM',NULL,'none',0,1,NULL,'2026-08-10 23:29:01','2026-08-10 23:29:01'),(24,1,'Order Team','order-team','ORDER_TEAM',NULL,'assigned_jobs',0,1,NULL,'2026-08-14 00:58:53','2026-08-14 00:58:53'),(25,1,'Manager','manager','MANAGER',NULL,'all_records',0,1,NULL,'2026-08-14 02:02:24','2026-08-14 02:02:24');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:12:53

-- ==================================================
-- FULL AUTH CONFIG: permissions
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT  IGNORE INTO `permissions` VALUES (1,'dashboard','Dashboard View','dashboard.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(2,'jobs','Jobs View','jobs.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(3,'jobs','Jobs Create','jobs.create',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(4,'jobs','Jobs Update','jobs.update',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(5,'tasks','Tasks View','tasks.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(6,'tasks','Tasks Update','tasks.update',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(7,'clients','Clients View','clients.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(8,'documents','Documents View','documents.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(9,'reports','Reports View','reports.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(10,'notifications','Notifications View','notifications.view',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(11,'workflow','Workflow Manage','workflow.manage',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(12,'master','Master Manage','master.manage',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19'),(13,'users','Users Manage','users.manage',NULL,'2026-08-04 19:08:19','2026-08-04 19:08:19');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:12:53

-- ==================================================
-- FULL AUTH CONFIG: permission_role
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `permission_role`
--

LOCK TABLES `permission_role` WRITE;
/*!40000 ALTER TABLE `permission_role` DISABLE KEYS */;
INSERT  IGNORE INTO `permission_role` VALUES (1,5),(2,5),(3,5),(4,5),(5,5),(6,5),(7,5),(8,5),(9,5),(10,5),(1,13),(2,13),(3,13),(4,13),(5,13),(6,13),(7,13),(8,13),(9,13),(10,13),(1,14),(2,14),(3,14),(4,14),(5,14),(6,14),(7,14),(8,14),(9,14),(10,14),(1,15),(2,15),(3,15),(4,15),(5,15),(6,15),(7,15),(8,15),(9,15),(10,15),(1,16),(2,16),(3,16),(4,16),(5,16),(6,16),(7,16),(8,16),(9,16),(10,16),(1,17),(2,17),(3,17),(4,17),(5,17),(6,17),(7,17),(8,17),(9,17),(10,17),(1,18),(2,18),(3,18),(4,18),(5,18),(6,18),(7,18),(8,18),(9,18),(10,18),(1,19),(2,19),(3,19),(4,19),(5,19),(6,19),(7,19),(8,19),(9,19),(10,19),(1,20),(2,20),(3,20),(4,20),(5,20),(6,20),(7,20),(8,20),(9,20),(10,20),(1,21),(2,21),(3,21),(4,21),(5,21),(6,21),(7,21),(8,21),(9,21),(10,21);
/*!40000 ALTER TABLE `permission_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:12:53

-- ==================================================
-- FULL AUTH CONFIG: role_module_access
-- ==================================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `role_module_access`
--

LOCK TABLES `role_module_access` WRITE;
/*!40000 ALTER TABLE `role_module_access` DISABLE KEYS */;
INSERT  IGNORE INTO `role_module_access` VALUES (1,1,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:12','2026-08-11 04:10:58'),(2,1,'clients','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\"]','2026-08-04 19:08:12','2026-08-11 04:10:58'),(3,1,'jobs','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"link\"]','2026-08-04 19:08:12','2026-08-11 04:10:58'),(4,1,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\"]','2026-08-04 19:08:12','2026-08-11 04:10:58'),(5,1,'quotation','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:12','2026-08-04 19:08:12'),(6,1,'artwork','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:12','2026-08-04 19:08:12'),(7,1,'sample','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:12','2026-08-04 19:08:12'),(8,1,'production','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:12','2026-08-04 19:08:12'),(9,1,'shipment','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(10,1,'invoice','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(11,1,'documents','all_records','[\"view\", \"create\", \"delete\", \"link\", \"export\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(12,1,'reports','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(13,1,'workflow','all_records','[\"manage\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(14,1,'masterdata','all_records','[\"manage\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(15,1,'users','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(16,1,'audit','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"approve\", \"link\", \"export\", \"override\", \"manage\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(17,1,'notifications','all_records','[\"view\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(18,2,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(19,2,'clients','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(20,2,'jobs','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(21,2,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(22,2,'quotation','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(23,2,'artwork','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(24,2,'sample','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(25,2,'production','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(26,2,'shipment','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(27,2,'invoice','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(28,2,'documents','all_records','[\"view\", \"create\", \"link\", \"export\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(29,2,'reports','all_records','[\"view\", \"export\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(30,2,'workflow','none','[]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(31,2,'masterdata','none','[]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(32,2,'users','none','[]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(33,2,'audit','all_records','[\"view\", \"export\"]','2026-08-04 19:08:13','2026-08-04 19:08:13'),(34,2,'notifications','all_records','[\"view\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(35,3,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:13','2026-08-11 04:10:58'),(36,3,'clients','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(37,3,'jobs','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(38,3,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(39,3,'quotation','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\", \"link\", \"manage\"]','2026-08-04 19:08:14','2026-08-10 22:20:36'),(40,3,'artwork','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\", \"link\"]','2026-08-04 19:08:14','2026-08-10 22:20:33'),(41,3,'sample','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(42,3,'production','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(43,3,'shipment','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"approve\", \"export\", \"override\"]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(44,3,'invoice','assigned_jobs','[\"edit_all\", \"assign\", \"view\", \"create\"]','2026-08-04 19:08:14','2026-08-11 01:21:22'),(45,3,'documents','assigned_jobs','[\"view\", \"create\", \"link\", \"export\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(46,3,'reports','assigned_jobs','[\"export\", \"edit_own\", \"edit_all\", \"assign\", \"view\"]','2026-08-04 19:08:14','2026-08-19 01:47:34'),(47,3,'workflow','none','[]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(48,3,'masterdata','none','[]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(49,3,'users','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"assign\", \"approve\"]','2026-08-04 19:08:14','2026-08-10 23:06:38'),(50,3,'audit','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"assign\", \"approve\"]','2026-08-04 19:08:14','2026-08-10 23:06:41'),(51,3,'notifications','all_records','[\"view\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(52,4,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(53,4,'clients','all_records','[\"create\", \"edit_own\", \"assign\", \"view\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(54,4,'jobs','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"assign\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(55,4,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"assign\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(56,4,'quotation','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"export\"]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(57,4,'artwork','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(58,4,'sample','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(59,4,'production','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(60,4,'shipment','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(61,4,'invoice','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(62,4,'documents','assigned_jobs','[\"view\", \"create\", \"link\", \"export\"]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(63,4,'reports','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(64,4,'workflow','none','[]','2026-08-04 19:08:14','2026-08-11 04:10:58'),(65,4,'masterdata','none','[]','2026-08-04 19:08:14','2026-08-11 04:10:59'),(66,4,'users','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(67,4,'audit','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(68,4,'notifications','all_records','[\"view\"]','2026-08-04 19:08:14','2026-08-11 04:10:59'),(69,5,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:14','2026-08-11 04:10:59'),(70,5,'clients','all_records','[\"view\"]','2026-08-04 19:08:14','2026-08-11 04:10:59'),(71,5,'jobs','all_records','[\"view\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-04 19:08:14','2026-08-16 19:12:09'),(72,5,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-04 19:08:14','2026-08-14 01:46:25'),(73,5,'quotation','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(74,5,'artwork','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:14','2026-08-04 19:08:21'),(75,5,'sample','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(76,5,'production','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(77,5,'shipment','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(78,5,'invoice','none','[]','2026-08-04 19:08:14','2026-08-04 19:08:14'),(79,5,'documents','all_records','[\"view\", \"create\", \"link\", \"edit_own\", \"edit_all\", \"assign\", \"export\"]','2026-08-04 19:08:14','2026-08-14 01:46:29'),(80,5,'reports','assigned_jobs','[]','2026-08-04 19:08:14','2026-08-20 01:12:29'),(81,5,'workflow','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(82,5,'masterdata','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(83,5,'users','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(84,5,'audit','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(85,5,'notifications','all_records','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(86,6,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(87,6,'clients','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(88,6,'jobs','assigned_jobs','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(89,6,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(90,6,'quotation','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"export\"]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(91,6,'artwork','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(92,6,'sample','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"export\"]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(93,6,'production','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"export\"]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(94,6,'shipment','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(95,6,'invoice','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(96,6,'documents','assigned_jobs','[\"view\", \"create\", \"link\", \"export\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(97,6,'reports','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(98,6,'workflow','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(99,6,'masterdata','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(100,6,'users','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(101,6,'audit','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(102,6,'notifications','all_records','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(103,7,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(104,7,'clients','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(105,7,'jobs','assigned_jobs','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(106,7,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(107,7,'quotation','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(108,7,'artwork','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(109,7,'sample','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(110,7,'production','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(111,7,'shipment','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(112,7,'invoice','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(113,7,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(114,7,'reports','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(115,7,'workflow','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(116,7,'masterdata','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(117,7,'users','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(118,7,'audit','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(119,7,'notifications','all_records','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(120,8,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(121,8,'clients','none','[]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(122,8,'jobs','assigned_jobs','[\"view\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(123,8,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:15','2026-08-11 04:10:59'),(124,8,'quotation','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(125,8,'artwork','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(126,8,'sample','none','[]','2026-08-04 19:08:15','2026-08-04 19:08:15'),(127,8,'production','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(128,8,'shipment','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"export\"]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(129,8,'invoice','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(130,8,'documents','assigned_jobs','[\"view\", \"create\", \"link\", \"export\"]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(131,8,'reports','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(132,8,'workflow','none','[]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(133,8,'masterdata','none','[]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(134,8,'users','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(135,8,'audit','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(136,8,'notifications','all_records','[\"view\"]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(137,9,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(138,9,'clients','all_records','[\"view\"]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(139,9,'jobs','assigned_jobs','[\"view\"]','2026-08-04 19:08:16','2026-08-18 01:20:12'),(140,9,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"delete\", \"assign\", \"link\", \"export\"]','2026-08-04 19:08:16','2026-08-14 02:13:48'),(141,9,'quotation','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(142,9,'artwork','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(143,9,'sample','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(144,9,'production','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(145,9,'shipment','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(146,9,'invoice','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"approve\", \"export\"]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(147,9,'documents','all_records','[\"view\", \"create\", \"edit_own\", \"delete\", \"assign\", \"link\", \"export\"]','2026-08-04 19:08:16','2026-08-14 02:13:46'),(148,9,'reports','assigned_jobs','[\"view\", \"export\"]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(149,9,'workflow','none','[]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(150,9,'masterdata','none','[]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(151,9,'users','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(152,9,'audit','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(153,9,'notifications','all_records','[\"view\"]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(154,10,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(155,10,'clients','all_records','[\"view\"]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(156,10,'jobs','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"assign\", \"link\", \"export\"]','2026-08-04 19:08:16','2026-08-11 04:27:26'),(157,10,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"assign\", \"link\", \"export\"]','2026-08-04 19:08:16','2026-08-11 04:27:26'),(158,10,'quotation','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(159,10,'artwork','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(160,10,'sample','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(161,10,'production','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(162,10,'shipment','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(163,10,'invoice','none','[]','2026-08-04 19:08:16','2026-08-04 19:08:16'),(164,10,'documents','assigned_jobs','[\"view\", \"create\", \"edit_all\", \"edit_own\", \"assign\", \"link\", \"export\"]','2026-08-04 19:08:16','2026-08-17 19:24:50'),(165,10,'reports','assigned_jobs','[\"view\"]','2026-08-04 19:08:16','2026-08-19 01:47:12'),(166,10,'workflow','none','[]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(167,10,'masterdata','none','[]','2026-08-04 19:08:16','2026-08-11 04:10:59'),(168,10,'users','none','[]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(169,10,'audit','assigned_jobs','[\"view\"]','2026-08-04 19:08:17','2026-08-11 01:19:47'),(170,10,'notifications','all_records','[\"view\"]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(171,11,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(172,11,'clients','all_records','[\"view\"]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(173,11,'jobs','all_records','[\"view\"]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(174,11,'tasks','all_records','[\"view\"]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(175,11,'quotation','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(176,11,'artwork','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(177,11,'sample','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(178,11,'production','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(179,11,'shipment','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(180,11,'invoice','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(181,11,'documents','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(182,11,'reports','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(183,11,'workflow','none','[]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(184,11,'masterdata','none','[]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(185,11,'users','none','[]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(186,11,'audit','all_records','[\"view\", \"export\"]','2026-08-04 19:08:17','2026-08-04 19:08:17'),(187,11,'notifications','all_records','[\"view\"]','2026-08-04 19:08:17','2026-08-11 04:10:59'),(188,13,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:19','2026-08-11 04:10:59'),(189,13,'clients','all_records','[\"view\", \"edit_all\", \"assign\"]','2026-08-04 19:08:19','2026-08-11 04:10:59'),(190,13,'jobs','all_records','[\"view\", \"create\", \"edit_all\", \"assign\"]','2026-08-04 19:08:19','2026-08-11 04:10:59'),(191,13,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-04 19:08:19','2026-08-11 04:10:59'),(192,13,'quotation','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"export\"]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(193,13,'artwork','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"export\"]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(194,13,'sample','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"export\"]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(195,13,'production','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"export\"]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(196,13,'shipment','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"export\"]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(197,13,'invoice','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"export\"]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(198,13,'documents','all_records','[\"view\", \"create\", \"link\", \"export\"]','2026-08-04 19:08:19','2026-08-11 04:10:59'),(199,13,'reports','all_records','[\"view\", \"export\", \"edit_all\", \"assign\"]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(200,13,'workflow','none','[]','2026-08-04 19:08:19','2026-08-11 04:10:59'),(201,13,'masterdata','none','[]','2026-08-04 19:08:19','2026-08-11 04:10:59'),(202,13,'users','none','[]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(203,13,'audit','none','[]','2026-08-04 19:08:19','2026-08-04 19:08:19'),(204,13,'notifications','all_records','[\"view\"]','2026-08-04 19:08:19','2026-08-11 04:10:59'),(205,14,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(206,14,'clients','all_records','[\"view\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(207,14,'jobs','assigned_jobs','[\"view\", \"create\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(208,14,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(209,14,'quotation','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(210,14,'artwork','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(211,14,'sample','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(212,14,'production','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(213,14,'shipment','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(214,14,'invoice','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(215,14,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(216,14,'reports','assigned_jobs','[\"view\", \"export\"]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(217,14,'workflow','none','[]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(218,14,'masterdata','none','[]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(219,14,'users','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(220,14,'audit','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(221,14,'notifications','all_records','[\"view\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(222,15,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(223,15,'clients','all_records','[\"view\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(224,15,'jobs','assigned_jobs','[\"view\", \"create\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(225,15,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(226,15,'quotation','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(227,15,'artwork','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(228,15,'sample','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(229,15,'production','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(230,15,'shipment','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(231,15,'invoice','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(232,15,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(233,15,'reports','assigned_jobs','[\"view\", \"export\"]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(234,15,'workflow','none','[]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(235,15,'masterdata','none','[]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(236,15,'users','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(237,15,'audit','none','[]','2026-08-04 19:08:20','2026-08-04 19:08:20'),(238,15,'notifications','all_records','[\"view\"]','2026-08-04 19:08:20','2026-08-11 04:10:59'),(239,16,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(240,16,'clients','none','[]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(241,16,'jobs','assigned_jobs','[\"view\", \"create\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(242,16,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(243,16,'quotation','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(244,16,'artwork','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(245,16,'sample','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(246,16,'production','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(247,16,'shipment','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(248,16,'invoice','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(249,16,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(250,16,'reports','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(251,16,'workflow','none','[]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(252,16,'masterdata','none','[]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(253,16,'users','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(254,16,'audit','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(255,16,'notifications','all_records','[\"view\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(256,17,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(257,17,'clients','none','[]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(258,17,'jobs','assigned_jobs','[\"view\", \"create\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(259,17,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(260,17,'quotation','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(261,17,'artwork','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(262,17,'sample','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(263,17,'production','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(264,17,'shipment','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(265,17,'invoice','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(266,17,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(267,17,'reports','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(268,17,'workflow','none','[]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(269,17,'masterdata','none','[]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(270,17,'users','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(271,17,'audit','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(272,17,'notifications','all_records','[\"view\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(273,18,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(274,18,'clients','none','[]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(275,18,'jobs','assigned_jobs','[\"view\", \"create\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(276,18,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:21','2026-08-11 04:10:59'),(277,18,'quotation','none','[]','2026-08-04 19:08:21','2026-08-04 19:08:21'),(278,18,'artwork','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(279,18,'sample','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(280,18,'production','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(281,18,'shipment','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(282,18,'invoice','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(283,18,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(284,18,'reports','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(285,18,'workflow','none','[]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(286,18,'masterdata','none','[]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(287,18,'users','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(288,18,'audit','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(289,18,'notifications','all_records','[\"view\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(290,19,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(291,19,'clients','none','[]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(292,19,'jobs','assigned_jobs','[\"view\", \"create\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(293,19,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(294,19,'quotation','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(295,19,'artwork','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(296,19,'sample','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(297,19,'production','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(298,19,'shipment','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(299,19,'invoice','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(300,19,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(301,19,'reports','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(302,19,'workflow','none','[]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(303,19,'masterdata','none','[]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(304,19,'users','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(305,19,'audit','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(306,19,'notifications','all_records','[\"view\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(307,20,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(308,20,'clients','all_records','[\"view\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(309,20,'jobs','assigned_jobs','[\"view\", \"create\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(310,20,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(311,20,'quotation','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(312,20,'artwork','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(313,20,'sample','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(314,20,'production','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(315,20,'shipment','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(316,20,'invoice','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(317,20,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(318,20,'reports','assigned_jobs','[\"view\", \"export\"]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(319,20,'workflow','none','[]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(320,20,'masterdata','none','[]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(321,20,'users','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(322,20,'audit','none','[]','2026-08-04 19:08:22','2026-08-04 19:08:22'),(323,20,'notifications','all_records','[\"view\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(324,21,'dashboard','all_records','[\"view\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(325,21,'clients','none','[]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(326,21,'jobs','assigned_jobs','[\"view\", \"create\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(327,21,'tasks','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:22','2026-08-11 04:10:59'),(328,21,'quotation','none','[]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(329,21,'artwork','none','[]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(330,21,'sample','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(331,21,'production','none','[]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(332,21,'shipment','none','[]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(333,21,'invoice','none','[]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(334,21,'documents','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-04 19:08:23','2026-08-11 04:10:59'),(335,21,'reports','none','[]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(336,21,'workflow','none','[]','2026-08-04 19:08:23','2026-08-11 04:10:59'),(337,21,'masterdata','none','[]','2026-08-04 19:08:23','2026-08-11 04:10:59'),(338,21,'users','none','[]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(339,21,'audit','none','[]','2026-08-04 19:08:23','2026-08-04 19:08:23'),(340,21,'notifications','all_records','[\"view\"]','2026-08-04 19:08:23','2026-08-11 04:10:59'),(341,22,'dashboard','none','[]','2026-08-07 21:03:02','2026-08-11 04:10:59'),(342,22,'clients','none','[]','2026-08-07 21:03:02','2026-08-11 04:10:59'),(343,22,'jobs','none','[]','2026-08-07 21:03:02','2026-08-11 04:10:59'),(344,22,'tasks','none','[]','2026-08-07 21:03:02','2026-08-11 04:10:59'),(345,22,'quotation','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(346,22,'artwork','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(347,22,'sample','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(348,22,'production','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(349,22,'shipment','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(350,22,'invoice','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(351,22,'documents','none','[]','2026-08-07 21:03:02','2026-08-11 04:10:59'),(352,22,'reports','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(353,22,'workflow','none','[]','2026-08-07 21:03:02','2026-08-11 04:10:59'),(354,22,'masterdata','none','[]','2026-08-07 21:03:02','2026-08-11 04:10:59'),(355,22,'users','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(356,22,'audit','none','[]','2026-08-07 21:03:02','2026-08-07 21:03:02'),(357,22,'notifications','none','[]','2026-08-07 21:03:02','2026-08-11 04:10:59'),(358,1,'inquiries','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(359,2,'inquiries','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(360,3,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(361,4,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"assign\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(362,5,'inquiries','all_records','[\"view\"]','2026-08-08 11:39:39','2026-08-16 19:12:17'),(363,6,'inquiries','assigned_jobs','[\"view\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(364,7,'inquiries','assigned_jobs','[\"view\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(365,8,'inquiries','assigned_jobs','[\"view\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(366,9,'inquiries','assigned_jobs','[\"view\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(367,10,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"assign\", \"link\", \"export\"]','2026-08-08 11:39:39','2026-08-11 04:27:21'),(368,11,'inquiries','all_records','[\"view\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(369,13,'inquiries','all_records','[\"view\", \"create\", \"edit_all\", \"assign\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(370,14,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(371,15,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(372,16,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(373,17,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(374,18,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(375,19,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(376,20,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(377,21,'inquiries','assigned_jobs','[\"view\", \"create\", \"edit_own\"]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(378,22,'inquiries','none','[]','2026-08-08 11:39:39','2026-08-11 04:10:59'),(379,23,'dashboard','all_records','[\"view\"]','2026-08-10 23:29:01','2026-08-11 04:15:38'),(380,23,'clients','all_records','[\"view\"]','2026-08-10 23:29:01','2026-08-14 02:03:42'),(381,23,'inquiries','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-10 23:29:01','2026-08-12 01:21:43'),(382,23,'jobs','all_records','[\"view\"]','2026-08-10 23:29:01','2026-08-14 02:03:53'),(383,23,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-10 23:29:01','2026-08-11 04:31:41'),(384,23,'quotation','none','[]','2026-08-10 23:29:01','2026-08-10 23:29:01'),(385,23,'artwork','none','[\"view\", \"create\", \"edit_own\", \"assign\", \"link\", \"export\"]','2026-08-10 23:29:01','2026-08-11 00:02:42'),(386,23,'sample','none','[\"create\", \"view\", \"edit_own\", \"assign\", \"link\", \"export\"]','2026-08-10 23:29:01','2026-08-11 00:02:51'),(387,23,'production','none','[]','2026-08-10 23:29:01','2026-08-10 23:29:01'),(388,23,'shipment','none','[]','2026-08-10 23:29:01','2026-08-10 23:29:01'),(389,23,'invoice','none','[]','2026-08-10 23:29:01','2026-08-10 23:29:01'),(390,23,'documents','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-10 23:29:01','2026-08-17 11:56:15'),(391,23,'reports','assigned_jobs','[\"view\"]','2026-08-10 23:29:01','2026-08-19 01:47:19'),(392,23,'workflow','none','[]','2026-08-10 23:29:01','2026-08-11 04:10:59'),(393,23,'masterdata','none','[]','2026-08-10 23:29:01','2026-08-12 23:44:59'),(394,23,'users','none','[]','2026-08-10 23:29:01','2026-08-10 23:29:01'),(395,23,'audit','none','[]','2026-08-10 23:29:01','2026-08-10 23:29:01'),(396,23,'notifications','all_records','[\"view\"]','2026-08-10 23:29:01','2026-08-11 04:15:40'),(397,20,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(398,9,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(399,1,'taskpacks','all_records','[\"view\", \"create\", \"edit_all\", \"delete\", \"manage\"]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(400,5,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(401,10,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(402,23,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(403,3,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(404,2,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(405,13,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(406,17,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(407,7,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(408,18,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(409,11,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(410,15,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(411,14,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(412,4,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(413,21,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(414,19,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(415,8,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(416,16,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(417,6,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(418,12,'taskpacks','all_records','[\"view\", \"create\", \"edit_all\", \"delete\", \"manage\"]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(419,22,'taskpacks','none','[]','2026-08-11 04:10:59','2026-08-11 04:10:59'),(421,1,'finance','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"link\", \"export\", \"manage\"]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(423,2,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(425,3,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(427,4,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(429,5,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(431,6,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(433,7,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(435,8,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(437,9,'finance','all_records','[\"view\", \"create\", \"edit_own\", \"delete\", \"assign\", \"link\", \"export\"]','2026-08-12 10:01:19','2026-08-14 02:13:12'),(439,10,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(441,11,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(443,12,'finance','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"delete\", \"assign\", \"link\", \"export\", \"manage\"]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(445,13,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(447,14,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(449,15,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(451,16,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(453,17,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(455,18,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(457,19,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(459,20,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(461,21,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(463,22,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(465,23,'finance','none','[]','2026-08-12 10:01:19','2026-08-12 10:01:19'),(466,1,'catalog_products','all_records','[\"manage\"]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(467,1,'product_categories','all_records','[\"manage\"]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(468,1,'suppliers','all_records','[\"manage\"]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(469,2,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(470,2,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(471,2,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(472,3,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(473,3,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(474,3,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(475,4,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(476,4,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(477,4,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(478,5,'catalog_products','all_records','[\"view\"]','2026-08-12 23:05:12','2026-08-14 01:38:17'),(479,5,'product_categories','all_records','[\"view\"]','2026-08-12 23:05:12','2026-08-14 01:38:21'),(480,5,'suppliers','all_records','[\"view\"]','2026-08-12 23:05:12','2026-08-14 20:05:16'),(481,6,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(482,6,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(483,6,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(484,7,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(485,7,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(486,7,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(487,8,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(488,8,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(489,8,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(490,9,'catalog_products','all_records','[\"view\"]','2026-08-12 23:05:12','2026-08-14 02:13:01'),(491,9,'product_categories','all_records','[\"view\"]','2026-08-12 23:05:12','2026-08-14 02:13:02'),(492,9,'suppliers','all_records','[\"view\"]','2026-08-12 23:05:12','2026-08-14 02:13:04'),(493,10,'catalog_products','all_records','[\"view\", \"create\"]','2026-08-12 23:05:12','2026-08-14 00:55:50'),(494,10,'product_categories','all_records','[\"view\"]','2026-08-12 23:05:12','2026-08-14 00:55:46'),(495,10,'suppliers','all_records','[\"view\"]','2026-08-12 23:05:12','2026-08-14 00:55:47'),(496,11,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(497,11,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(498,11,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(499,12,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(500,12,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(501,12,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(502,13,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(503,13,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(504,13,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(505,14,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(506,14,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(507,14,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(508,15,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(509,15,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(510,15,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(511,16,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(512,16,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(513,16,'suppliers','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(514,17,'catalog_products','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(515,17,'product_categories','none','[]','2026-08-12 23:05:12','2026-08-12 23:05:12'),(516,17,'suppliers','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(517,18,'catalog_products','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(518,18,'product_categories','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(519,18,'suppliers','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(520,19,'catalog_products','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(521,19,'product_categories','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(522,19,'suppliers','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(523,20,'catalog_products','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(524,20,'product_categories','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(525,20,'suppliers','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(526,21,'catalog_products','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(527,21,'product_categories','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(528,21,'suppliers','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(529,22,'catalog_products','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(530,22,'product_categories','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(531,22,'suppliers','none','[]','2026-08-12 23:05:13','2026-08-12 23:05:13'),(532,23,'catalog_products','all_records','[\"view\"]','2026-08-12 23:05:13','2026-08-14 02:04:16'),(533,23,'product_categories','all_records','[\"view\"]','2026-08-12 23:05:13','2026-08-14 02:04:28'),(534,23,'suppliers','all_records','[\"view\"]','2026-08-12 23:05:13','2026-08-14 02:04:32'),(535,24,'dashboard','all_records','[\"view\"]','2026-08-14 00:58:53','2026-08-14 00:59:00'),(536,24,'notifications','all_records','[\"view\"]','2026-08-14 00:58:53','2026-08-14 00:59:02'),(537,24,'clients','all_records','[\"view\"]','2026-08-14 00:58:53','2026-08-14 00:59:03'),(538,24,'inquiries','all_records','[\"view\", \"create\", \"edit_own\", \"assign\", \"link\", \"export\", \"edit_all\"]','2026-08-14 00:58:53','2026-09-03 00:55:58'),(539,24,'jobs','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 00:58:53','2026-08-14 01:34:52'),(540,24,'catalog_products','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 00:58:53','2026-08-14 01:00:01'),(541,24,'product_categories','all_records','[\"view\", \"create\", \"edit_own\", \"assign\", \"edit_all\", \"link\", \"export\"]','2026-08-14 00:58:53','2026-08-14 01:00:09'),(542,24,'suppliers','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 00:58:53','2026-08-14 01:00:20'),(543,24,'finance','none','[]','2026-08-14 00:58:53','2026-08-14 00:58:53'),(544,24,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 00:58:53','2026-08-14 01:57:41'),(545,24,'documents','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"link\", \"assign\", \"export\"]','2026-08-14 00:58:53','2026-08-14 01:57:44'),(546,24,'workflow','none','[]','2026-08-14 00:58:53','2026-08-14 00:58:53'),(547,24,'taskpacks','none','[]','2026-08-14 00:58:53','2026-08-14 00:58:53'),(548,24,'masterdata','none','[]','2026-08-14 00:58:53','2026-08-14 00:58:53'),(549,25,'dashboard','all_records','[\"view\"]','2026-08-14 02:02:24','2026-08-14 02:02:35'),(550,25,'notifications','all_records','[\"view\"]','2026-08-14 02:02:24','2026-08-14 02:02:36'),(551,25,'clients','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 02:02:24','2026-08-14 02:02:50'),(552,25,'inquiries','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 02:02:24','2026-09-03 00:56:26'),(553,25,'jobs','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 02:02:24','2026-09-03 00:56:31'),(554,25,'catalog_products','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 02:02:24','2026-08-14 02:02:58'),(555,25,'product_categories','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 02:02:24','2026-08-14 02:03:00'),(556,25,'suppliers','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 02:02:24','2026-08-14 02:03:06'),(557,25,'finance','all_records','[\"view\"]','2026-08-14 02:02:24','2026-08-19 19:29:18'),(558,25,'tasks','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-14 02:02:24','2026-08-14 02:03:09'),(559,25,'documents','all_records','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\", \"delete\"]','2026-08-14 02:02:24','2026-08-17 04:22:47'),(560,25,'workflow','none','[]','2026-08-14 02:02:24','2026-08-14 02:02:24'),(561,25,'taskpacks','none','[]','2026-08-14 02:02:24','2026-08-14 02:02:24'),(562,25,'masterdata','all_records','[]','2026-08-14 02:02:24','2026-08-18 05:02:19'),(563,1,'document_archive','all_records','[\"view\", \"create\", \"delete\", \"link\", \"export\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(564,2,'document_archive','all_records','[\"view\", \"create\", \"link\", \"export\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(565,3,'document_archive','assigned_jobs','[\"view\"]','2026-08-18 04:50:27','2026-08-18 05:01:35'),(566,4,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\", \"export\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(567,5,'document_archive','assigned_jobs','[]','2026-08-18 04:50:27','2026-08-20 01:12:08'),(568,6,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\", \"export\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(569,7,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(570,8,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\", \"export\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(571,9,'document_archive','all_records','[\"view\", \"create\", \"edit_own\", \"delete\", \"assign\", \"link\", \"export\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(572,10,'document_archive','assigned_jobs','[\"view\"]','2026-08-18 04:50:27','2026-08-18 05:01:22'),(573,11,'document_archive','all_records','[\"view\", \"export\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(574,12,'document_archive','none','[]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(575,13,'document_archive','all_records','[\"view\", \"create\", \"link\", \"export\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(576,14,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(577,15,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(578,16,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(579,17,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(580,18,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(581,19,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(582,20,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(583,21,'document_archive','assigned_jobs','[\"view\", \"create\", \"link\"]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(584,22,'document_archive','none','[]','2026-08-18 04:50:27','2026-08-18 04:50:27'),(585,23,'document_archive','assigned_jobs','[\"view\"]','2026-08-18 04:50:27','2026-08-18 05:01:53'),(586,24,'document_archive','assigned_jobs','[\"view\", \"create\", \"edit_own\", \"edit_all\", \"assign\", \"link\", \"export\"]','2026-08-18 04:50:27','2026-08-18 05:04:34'),(587,25,'document_archive','all_records','[\"view\"]','2026-08-18 04:50:27','2026-08-18 05:02:11'),(588,25,'reports','all_records','[\"view\"]','2026-08-19 01:47:23','2026-08-19 01:47:23'),(589,24,'reports','assigned_jobs','[\"view\"]','2026-08-19 01:47:26','2026-08-19 01:47:26');
/*!40000 ALTER TABLE `role_module_access` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:12:53

SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;

-- ===============================================
-- ADMIN ROLE ASSIGNMENTS
-- ===============================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `user_roles`
--
-- WHERE:  user_id IN (1,15,32,57,58)

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT  IGNORE INTO `user_roles` VALUES (1,12,'2026-08-04 19:08:18','2026-08-10 01:29:20'),(15,1,'2026-09-29 02:16:54','2026-09-29 02:16:54'),(15,24,'2026-08-19 19:31:16','2026-08-19 19:31:16'),(15,25,'2026-08-05 05:46:11','2026-08-14 02:03:25'),(32,1,'2026-09-29 02:16:37','2026-09-29 02:16:37'),(32,24,'2026-08-17 23:35:29','2026-08-17 23:35:29'),(32,25,'2026-08-19 19:30:43','2026-08-19 19:30:43'),(57,1,'2026-08-05 06:27:48','2026-08-10 01:31:09'),(58,12,'2026-08-05 17:29:22','2026-08-10 01:29:06');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:13:03

-- ===============================================
-- ADMIN WORKSPACE MEMBERSHIPS
-- ===============================================
-- MySQL dump 10.13  Distrib 8.0.46, for Linux (aarch64)
--
-- Host: 127.0.0.1    Database: flowtracker
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `workspace_memberships`
--
-- WHERE:  user_id IN (1,15,32,57,58)

LOCK TABLES `workspace_memberships` WRITE;
/*!40000 ALTER TABLE `workspace_memberships` DISABLE KEYS */;
INSERT  IGNORE INTO `workspace_memberships` VALUES (1,1,1,12,1,'Super Administrator','active','2026-08-04 19:08:18','2026-08-04 19:08:18','2026-08-04 19:08:18','both'),(15,1,15,25,47,'Product development manager','active','2026-08-05 05:46:11','2026-08-05 05:46:11','2026-08-14 02:03:25','both'),(32,1,32,24,45,'Business representative','active','2026-08-05 06:08:30','2026-08-05 06:08:30','2026-08-17 23:35:29','both'),(57,1,57,1,1,NULL,'active','2026-08-05 06:27:48','2026-08-05 06:27:48','2026-08-07 19:38:06','both'),(58,1,58,12,NULL,NULL,'active','2026-08-05 17:29:22','2026-08-05 17:29:22','2026-08-05 17:29:22','both');
/*!40000 ALTER TABLE `workspace_memberships` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06  1:13:09

SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
