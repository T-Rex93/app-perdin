-- DATABASE

CREATE DATABASE perjalanan_dinas_db;
USE perjalanan_dinas_db;

-- TABLE ROLES

CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- TABLE USERS

CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    CONSTAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
); 

-- TABLE CITIES

CREATE TABLE cities (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 6) NOT NULL,
    longitude DECIMAL(10, 6) NOT NULL,
    province VARCHAR(100) NOT NULL,
    island VARCHAR(100) NOT NULL,
    is_foreign BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- TABLE BUSINESS_TRIPS

CREATE TABLE business_trips (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    purpose TEXT NOT NULL,
    departure_date DATE NOT NULL,
    return_date DATE NOT NULL,
    origin_city_id BIGINT UNSIGNED NOT NULL,
    destination_city_id BIGINT UNSIGNED NOT NULL,
    duration_days INT NOT NULL,
    distance_km DECIMAL(10, 2) NOT NULL,
    daily_allowance DECIMAL(15, 2) NOT NULL DEFAULT 0,
    total_allowance DECIMAL(15, 2) NOT NULL DEFAULT 0,
    currency VARCHAR(10) NOT NULL DEFAULT 'IDR',
    status ENUM(
        'PENDING',
        'APPROVED',
        'REJECTED'
    ) NOT NULL DEFAULT 'PENDING',
    approved_by BIGINT UNSIGNED NULL,
    approved_at TIMESTAMP NULL,
    rejection_reason TEXT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    
    -- FOREIGN KEYS

    CONSTRAINT fk_business_trip_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_business_trip_origin_city
        FOREIGN KEY (origin_city_id)
        REFERENCES cities(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_business_trip_destination_city
        FOREIGN KEY (destination_city_id)
        REFERENCES cities(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_business_trip_approved_by
        FOREIGN KEY (approved_by)
        REFERENCES users(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- INDEXES

CREATE INDEX idx_users_role_id
ON users(role_id);
CREATE INDEX idx_business_trip_user_id
ON business_trips(user_id)
CREATE INDEX idx_business_trip_status
ON business_trips(status)
CREATE INDEX idx_business_trip_origin_city
ON business_trips(origin_city_id);
CREATE INDEX idx_business_trip_destination_city
ON business_trips(destination_city_id);

-- SEED ROLES

INSERT INTO roles (name)
VALUES ('ADMIN'), ('PEGAWAI'), ('DIVISI_SDM');

-- SEED CITIES

INSERT INTO cities
(
    name,
    latitude,
    longitude,
    province,
    island,
    is_foreign
)
VALUES
(
    'Kota Bandung',
    -6.917500,
    107.619100,
    'Jawa Barat',
    'Jawa',
    FALSE
),
(
    'Kota Surabaya',
    -7.257500,
    112.752100,
    'Jawa Timur',
    'Jawa',
    FALSE
),
(
    'Kota Medan',
    3.595200,
    98.672200,
    'Sumatera Utara',
    'Sumatera',
    FALSE
),
(
    'Singapore',
    1.352100,
    103.819800,
    'Singapore',
    'Singapore',
    TRUE
);

-- SAMPLE USERS
-- PASSWORD EXAMPLE:
-- bcrypt('password123')

INSERT INTO users
(
    role_id,
    name,
    username,
    email,
    password
)
VALUES
(
    1,
    'Administrator',
    'admin',
    'admin@abcd.com',
    '123456'
),
(
    2,
    'Beni - Pegawai',
    'beni',
    'beni@abcd.com',
    '7891011'
),
(
    3,
    'Citra - SDM',
    'citra',
    'citra@abcd.com'
    'abcdef'
);

-- SAMPLE BUSINESS TRIP

INSERT INTO business_trips
(
    user_id,
    purpose,
    departure_date,
    return_date,
    origin_city_id,
    destination_city_id,
    duration_days,
    distance_km,
    daily_allowance,
    total_allowance,
    currency,
    status
)
VALUES
(
     2,
    'Meeting dengan klien cabang Surabaya',
    '2026-05-10',
    '2026-05-12',
    1,
    2,
    3,
    665.00,
    250000,
    750000,
    'IDR',
    'PENDING'
)