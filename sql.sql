CREATE TABLE IF NOT EXISTS `r1_personal_documents` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(80) NOT NULL,
  `document_type` VARCHAR(40) NOT NULL DEFAULT 'id',
  `photo` LONGTEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_document` (`identifier`, `document_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `r1_driver_licenses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(80) NOT NULL,
  `license_type` VARCHAR(80) NOT NULL DEFAULT 'Tipo A - Automovilista',
  `officer_identifier` VARCHAR(80) NULL,
  `officer_name` VARCHAR(120) NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'Vigente',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_driver_license` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `r1_weapon_licenses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(80) NOT NULL,
  `license_type` VARCHAR(80) NOT NULL DEFAULT 'Portación civil registrada',
  `officer_identifier` VARCHAR(80) NULL,
  `officer_name` VARCHAR(120) NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'Vigente',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_weapon_license` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `r1_weapon_registrations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `license_id` INT NOT NULL,
  `identifier` VARCHAR(80) NOT NULL,
  `weapon_name` VARCHAR(80) NOT NULL,
  `weapon_label` VARCHAR(120) NULL,
  `weapon_serial` VARCHAR(120) NOT NULL,
  `status` VARCHAR(40) NOT NULL DEFAULT 'Registrada',
  `officer_identifier` VARCHAR(80) NULL,
  `officer_name` VARCHAR(120) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_weapon_serial` (`weapon_serial`),
  KEY `idx_identifier` (`identifier`),
  CONSTRAINT `fk_r1_weapon_license` FOREIGN KEY (`license_id`) REFERENCES `r1_weapon_licenses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ALTER para instalaciones anteriores. Si tu MySQL no soporta ADD COLUMN IF NOT EXISTS,
-- agrega estas columnas manualmente solo si no existen.
ALTER TABLE `r1_weapon_registrations` ADD COLUMN IF NOT EXISTS `weapon_label` VARCHAR(120) NULL AFTER `weapon_name`;
ALTER TABLE `r1_weapon_registrations` ADD COLUMN IF NOT EXISTS `status` VARCHAR(40) NOT NULL DEFAULT 'Registrada' AFTER `weapon_serial`;
ALTER TABLE `r1_weapon_registrations` ADD COLUMN IF NOT EXISTS `officer_identifier` VARCHAR(80) NULL AFTER `status`;
ALTER TABLE `r1_weapon_registrations` ADD COLUMN IF NOT EXISTS `officer_name` VARCHAR(120) NULL AFTER `officer_identifier`;
ALTER TABLE `r1_weapon_registrations` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
