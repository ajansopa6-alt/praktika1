CREATE DATABASE IF NOT EXISTS lipjani_business CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lipjani_business;
CREATE TABLE IF NOT EXISTS users (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, full_name VARCHAR(160) NOT NULL,
 email VARCHAR(190) NOT NULL UNIQUE, phone VARCHAR(40) NOT NULL DEFAULT '',
 password_hash VARCHAR(255) NOT NULL, role ENUM('customer','owner','admin') NOT NULL DEFAULT 'customer',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, INDEX(role)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS categories (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(120) NOT NULL UNIQUE, sort_order SMALLINT NOT NULL DEFAULT 0
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS businesses (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, owner_id BIGINT UNSIGNED NULL,
 category_id INT UNSIGNED NULL, name VARCHAR(190) NOT NULL, description TEXT NULL,
 phone VARCHAR(40) NOT NULL DEFAULT '', address VARCHAR(255) NULL, latitude DECIMAL(10,7) NULL, longitude DECIMAL(10,7) NULL,
 hours_json JSON NULL, logo VARCHAR(255) NULL, cover_image VARCHAR(255) NULL,
 status ENUM('draft','pending','approved','rejected') NOT NULL DEFAULT 'draft',
 views BIGINT UNSIGNED NOT NULL DEFAULT 0, call_clicks BIGINT UNSIGNED NOT NULL DEFAULT 0,
 is_featured TINYINT(1) NOT NULL DEFAULT 0, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_business_owner FOREIGN KEY(owner_id) REFERENCES users(id) ON DELETE SET NULL,
 CONSTRAINT fk_business_category FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE SET NULL,
 INDEX(status), INDEX(category_id), INDEX(owner_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS reviews (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, business_id BIGINT UNSIGNED NOT NULL, user_id BIGINT UNSIGNED NOT NULL,
 rating TINYINT UNSIGNED NOT NULL, body TEXT NOT NULL, status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, CONSTRAINT fk_review_business FOREIGN KEY(business_id) REFERENCES businesses(id) ON DELETE CASCADE,
 CONSTRAINT fk_review_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE, UNIQUE KEY one_review_per_customer(business_id,user_id), INDEX(status)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS favorites (
 user_id BIGINT UNSIGNED NOT NULL, business_id BIGINT UNSIGNED NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY(user_id,business_id), CONSTRAINT fk_fav_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
 CONSTRAINT fk_fav_business FOREIGN KEY(business_id) REFERENCES businesses(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS business_images (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, business_id BIGINT UNSIGNED NOT NULL, path VARCHAR(255) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, CONSTRAINT fk_image_business FOREIGN KEY(business_id) REFERENCES businesses(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS notifications (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, user_id BIGINT UNSIGNED NOT NULL, message VARCHAR(500) NOT NULL,
 read_at TIMESTAMP NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_notification_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS admin_activity (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, admin_id BIGINT UNSIGNED NOT NULL, action VARCHAR(80) NOT NULL,
 entity_type VARCHAR(60) NOT NULL, entity_id BIGINT UNSIGNED NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_activity_admin FOREIGN KEY(admin_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS site_visits (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, ip_hash CHAR(64) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, INDEX(created_at)
) ENGINE=InnoDB;
UPDATE categories SET name=CASE name
 WHEN 'Restaurants & Fast Food' THEN 'Restorante dhe ushqim i shpejtë'
 WHEN 'Cafes & Bars' THEN 'Kafene dhe bare'
 WHEN 'Hotels & Accommodation' THEN 'Hotele dhe akomodim'
 WHEN 'Supermarkets & Shops' THEN 'Supermarkete dhe dyqane'
 WHEN 'Clothing & Fashion' THEN 'Veshje dhe modë'
 WHEN 'Beauty Salons' THEN 'Sallone bukurie'
 WHEN 'Barbershops' THEN 'Berberë'
 WHEN 'Healthcare & Pharmacies' THEN 'Shëndetësi dhe barnatore'
 WHEN 'Dentists' THEN 'Dentistë'
 WHEN 'Car Services & Mechanics' THEN 'Shërbime për vetura dhe mekanikë'
 WHEN 'Construction' THEN 'Ndërtimtari'
 WHEN 'Electronics' THEN 'Elektronikë'
 WHEN 'Education' THEN 'Arsim'
 WHEN 'Fitness & Gyms' THEN 'Fitnes dhe palestra'
 WHEN 'Real Estate' THEN 'Patundshmëri'
 WHEN 'Professional Services' THEN 'Shërbime profesionale'
 WHEN 'Other Businesses' THEN 'Biznese të tjera'
 ELSE name END
WHERE name IN ('Restaurants & Fast Food','Cafes & Bars','Hotels & Accommodation','Supermarkets & Shops','Clothing & Fashion','Beauty Salons','Barbershops','Healthcare & Pharmacies','Dentists','Car Services & Mechanics','Construction','Electronics','Education','Fitness & Gyms','Real Estate','Professional Services','Other Businesses');
UPDATE categories SET name=CASE sort_order
 WHEN 1 THEN 'Restorante dhe ushqim i shpejtë' WHEN 2 THEN 'Kafene dhe bare'
 WHEN 3 THEN 'Hotele dhe akomodim' WHEN 4 THEN 'Supermarkete dhe dyqane'
 WHEN 5 THEN 'Veshje dhe modë' WHEN 6 THEN 'Sallone bukurie' WHEN 7 THEN 'Berberë'
 WHEN 8 THEN 'Shëndetësi dhe barnatore' WHEN 9 THEN 'Dentistë'
 WHEN 10 THEN 'Shërbime për vetura dhe mekanikë' WHEN 11 THEN 'Ndërtimtari'
 WHEN 12 THEN 'Elektronikë' WHEN 13 THEN 'Arsim' WHEN 14 THEN 'Fitnes dhe palestra'
 WHEN 15 THEN 'Patundshmëri' WHEN 16 THEN 'Shërbime profesionale' WHEN 17 THEN 'Biznese të tjera'
 ELSE name END WHERE sort_order BETWEEN 1 AND 17;
INSERT IGNORE INTO categories(name,sort_order) VALUES
('Restorante dhe ushqim i shpejtë',1),('Kafene dhe bare',2),('Hotele dhe akomodim',3),('Supermarkete dhe dyqane',4),
('Veshje dhe modë',5),('Sallone bukurie',6),('Berberë',7),('Shëndetësi dhe barnatore',8),
('Dentistë',9),('Shërbime për vetura dhe mekanikë',10),('Ndërtimtari',11),('Elektronikë',12),
('Arsim',13),('Fitnes dhe palestra',14),('Patundshmëri',15),('Shërbime profesionale',16),('Biznese të tjera',17);
