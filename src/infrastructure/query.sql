-- DROP DATABASE IF EXISTS pandere;

-- CREATE DATABASE pandere
--     WITH
--     OWNER = postgres
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'Spanish_Honduras.1252'
--     LC_CTYPE = 'Spanish_Honduras.1252'
--     LOCALE_PROVIDER = 'libc'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1
--     IS_TEMPLATE = False;



CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;

-- =============================================================================
-- MÓDULO 1: CORE DE ACTORES Y LOCALIZACIÓN
-- =============================================================================

-- Table: location (Jerárquica)
CREATE TABLE IF NOT EXISTS location (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    parent_location_id INT NULL,
    
    CONSTRAINT pk_location PRIMARY KEY (id),
    CONSTRAINT fk_location_parent FOREIGN KEY (parent_location_id)
        REFERENCES location (id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX idx_location_parent ON location (parent_location_id);

-- Table: actor
CREATE TABLE IF NOT EXISTS actor (
    id INT GENERATED ALWAYS AS IDENTITY,
    email VARCHAR(255) NULL,
    actor_type VARCHAR(10) NULL, -- Ej: 'USER', 'DONOR', 'STAFF'
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    
    CONSTRAINT pk_actor PRIMARY KEY (id),
    CONSTRAINT uq_actor_email UNIQUE (email),
    CONSTRAINT chk_actor_deleted CHECK (deleted_at IS NULL OR is_active = FALSE)
);

-- Table: address (Relación de ubicación de actores)
CREATE TABLE IF NOT EXISTS address (
    actor_id INT NOT NULL,
    location_id INT NOT NULL,
    type VARCHAR(50) NULL, -- Ej: 'Residencial', 'Fiscal'
    
    CONSTRAINT pk_address PRIMARY KEY (actor_id, location_id),
    CONSTRAINT fk_address_actor FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_address_location FOREIGN KEY (location_id)
        REFERENCES location (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX idx_address_location ON address (location_id);

-- Table: telephone
CREATE TABLE IF NOT EXISTS telephone (
    id INT GENERATED ALWAYS AS IDENTITY,
    number VARCHAR(20) NOT NULL,
    actor_id INT NOT NULL,
    
    CONSTRAINT pk_telephone PRIMARY KEY (id),
    CONSTRAINT fk_telephone_actor FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_telephone_actor ON telephone (actor_id);

-- Table: person
CREATE TABLE IF NOT EXISTS person (
    id INT GENERATED ALWAYS AS IDENTITY,
    actor_id INT NOT NULL,
    first_name VARCHAR(75) NOT NULL,
    middle_name VARCHAR(75) NULL,
    first_surname VARCHAR(75) NOT NULL,
    second_surname VARCHAR(75) NULL,
    birth_date DATE NOT NULL,
    dni VARCHAR(20) NOT NULL,
    
    CONSTRAINT pk_person PRIMARY KEY (id),
    CONSTRAINT uq_person_actor UNIQUE (actor_id),
    CONSTRAINT uq_person_dni UNIQUE (dni),
    CONSTRAINT fk_person_actor FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_person_birth CHECK (birth_date > '1900-01-01' AND birth_date < CURRENT_DATE)
);

-- Table: enterprise
CREATE TABLE IF NOT EXISTS enterprise (
    id INT GENERATED ALWAYS AS IDENTITY,
    actor_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    rtn VARCHAR(20) NOT NULL,
    business_sector VARCHAR(100) NULL,
    
    CONSTRAINT pk_enterprise PRIMARY KEY (id),
    CONSTRAINT uq_enterprise_actor UNIQUE (actor_id),
    CONSTRAINT uq_enterprise_rtn UNIQUE (rtn),
    CONSTRAINT fk_enterprise_actor FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: legal_representative_history
CREATE TABLE IF NOT EXISTS legal_representative_history (
    person_id INT NOT NULL,
    enterprise_id INT NOT NULL,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE NULL,
    
    CONSTRAINT pk_legal_representative_history PRIMARY KEY (person_id, enterprise_id),
    CONSTRAINT fk_legal_rep_person FOREIGN KEY (person_id)
        REFERENCES person (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_legal_rep_enterprise FOREIGN KEY (enterprise_id)
        REFERENCES enterprise (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_legal_rep_dates CHECK (end_date IS NULL OR end_date >= start_date)
);
CREATE INDEX idx_legal_rep_enterprise ON legal_representative_history (enterprise_id);

CREATE TABLE IF NOT EXISTS file
(
    id INT NOT NULL,
    url VARCHAR(512) NOT NULL,
    blob_url VARCHAR(512) NOT NULL,
    filename VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE NULL DEFAULT now(),
    CONSTRAINT pk_file PRIMARY KEY (id)
);
-- =============================================================================
-- MÓDULO 2: ORGANIZACIÓN, ROLES Y SEGURIDAD
-- =============================================================================

-- Table: organization
CREATE TABLE IF NOT EXISTS organization (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    
    CONSTRAINT pk_organization PRIMARY KEY (id),
    CONSTRAINT uq_organization_name UNIQUE (name)
);

-- Table: role
CREATE TABLE IF NOT EXISTS role (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    
    CONSTRAINT pk_role PRIMARY KEY (id),
    CONSTRAINT uq_role_name UNIQUE (name)
);

-- Table: permission
CREATE TABLE IF NOT EXISTS permission (
    id INT GENERATED ALWAYS AS IDENTITY,
    slug VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    
    CONSTRAINT pk_permission PRIMARY KEY (id),
    CONSTRAINT uq_permission_slug UNIQUE (slug)
);

-- Table: role_has_permission (Tabla intermedia de N:M)
CREATE TABLE IF NOT EXISTS role_has_permission (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    
    CONSTRAINT pk_role_has_permission PRIMARY KEY (role_id, permission_id),
    CONSTRAINT fk_role_permission_role FOREIGN KEY (role_id)
        REFERENCES role (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_role_permission_permission FOREIGN KEY (permission_id)
        REFERENCES permission (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_role_permission_permission ON role_has_permission (permission_id);

-- Table: users (Se mantiene en plural por ser palabra reservada restringida en PostgreSQL)
CREATE TABLE IF NOT EXISTS users (
    id INT GENERATED ALWAYS AS IDENTITY,
    actor_id INT NOT NULL,
    role_id INT NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL, -- Tamaño óptimo para hashing seguro (ej: bcrypt o argon2)
    avatar_id INT,
    
    CONSTRAINT pk_users PRIMARY KEY (id),
    CONSTRAINT uq_users_actor UNIQUE (actor_id),
    CONSTRAINT uq_users_nickname UNIQUE (nickname),
    CONSTRAINT fk_users_actor FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id)
        REFERENCES role (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_users_avatar FOREIGN KEY (avatar_id)
        REFERENCES file (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX idx_users_role ON users (role_id);


-- =============================================================================
-- MÓDULO 3: PROYECTOS, TAREAS Y ESTADOS
-- =============================================================================

-- Table: status
CREATE TABLE IF NOT EXISTS status (
    id INT GENERATED ALWAYS AS IDENTITY,
    table_name VARCHAR(50) NOT NULL,
    status_name VARCHAR(50) NOT NULL,
    
    CONSTRAINT pk_status PRIMARY KEY (id),
    CONSTRAINT uq_status_combination UNIQUE (table_name, status_name)
);

-- Table: allowed_transitions
CREATE TABLE IF NOT EXISTS allowed_transitions (
    from_status_id INT NOT NULL,
    to_status_id INT NOT NULL,
    
    CONSTRAINT pk_allowed_transitions PRIMARY KEY (from_status_id, to_status_id),
    CONSTRAINT fk_transitions_from FOREIGN KEY (from_status_id)
        REFERENCES status (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_transitions_to FOREIGN KEY (to_status_id)
        REFERENCES status (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_transitions_to ON allowed_transitions (to_status_id);

-- Table: project
CREATE TABLE IF NOT EXISTS project (
    id INT GENERATED ALWAYS AS IDENTITY,
    organization_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT NULL, -- TEXT maneja strings dinámicos extensos de forma más óptima en PostgreSQL
    start_date DATE NULL,
    end_date DATE NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    
    CONSTRAINT pk_project PRIMARY KEY (id),
    CONSTRAINT fk_project_organization FOREIGN KEY (organization_id)
        REFERENCES organization (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_project_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE IF NOT EXISTS project_has_file
(
    project_id INT NOT NULL,
    file_id INT NOT NULL,
    
    CONSTRAINT pk_project_has_file PRIMARY KEY (project_id, file_id),
    CONSTRAINT fk_project_has_file_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_project_has_file_file FOREIGN KEY (file_id)
        REFERENCES file (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table: project_has_status
CREATE TABLE IF NOT EXISTS project_has_status (
    project_id INT NOT NULL,
    status_id INT NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP WITH TIME ZONE NULL,
    
    CONSTRAINT pk_project_has_status PRIMARY KEY (project_id, status_id, start_date),
    CONSTRAINT fk_project_status_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_project_status_status FOREIGN KEY (status_id)
        REFERENCES status (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_project_status_dates CHECK (end_date IS NULL OR end_date >= start_date)
);
CREATE INDEX idx_project_status_status ON project_has_status (status_id);

-- Table: project_task
CREATE TABLE IF NOT EXISTS project_task (
    id INT GENERATED ALWAYS AS IDENTITY,
    project_id INT NOT NULL,
    status_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    due_date DATE NULL,
    
    CONSTRAINT pk_project_task PRIMARY KEY (id),
    CONSTRAINT fk_task_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_task_status FOREIGN KEY (status_id)
        REFERENCES status (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX idx_task_project ON project_task (project_id);
CREATE INDEX idx_task_status ON project_task (status_id);


-- =============================================================================
-- MÓDULO 4: RECURSOS HUMANOS, HABILIDADES Y VOLUNTARIADO
-- =============================================================================

-- Table: skill
CREATE TABLE IF NOT EXISTS skill (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255) NULL,
    
    CONSTRAINT pk_skill PRIMARY KEY (id),
    CONSTRAINT uq_skill_name UNIQUE (name)
);

-- Table: volunteer
CREATE TABLE IF NOT EXISTS volunteer (
    id INT GENERATED ALWAYS AS IDENTITY,
    actor_id INT NOT NULL,
    hours_accumulated NUMERIC(8, 2) NOT NULL DEFAULT 0.00,
    
    CONSTRAINT pk_volunteer PRIMARY KEY (id),
    CONSTRAINT uq_volunteer_actor UNIQUE (actor_id),
    CONSTRAINT fk_volunteer_actor FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_volunteer_hours CHECK (hours_accumulated >= 0)
);

-- Table: volunteer_has_skill
CREATE TABLE IF NOT EXISTS volunteer_has_skill (
    volunteer_id INT NOT NULL,
    skill_id INT NOT NULL,
    
    CONSTRAINT pk_volunteer_has_skill PRIMARY KEY (volunteer_id, skill_id),
    CONSTRAINT fk_vol_skills_volunteer FOREIGN KEY (volunteer_id)
        REFERENCES volunteer (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_vol_skills_skill FOREIGN KEY (skill_id)
        REFERENCES skill (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_vol_skills_skill ON volunteer_has_skill (skill_id);

-- Table: project_has_skill
CREATE TABLE IF NOT EXISTS project_has_skill (
    project_id INT NOT NULL,
    skill_id INT NOT NULL,
    
    CONSTRAINT pk_project_has_skill PRIMARY KEY (project_id, skill_id),
    CONSTRAINT fk_proj_skills_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_proj_skills_skill FOREIGN KEY (skill_id)
        REFERENCES skill (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_proj_skills_skill ON project_has_skill (skill_id);

-- Table: work_log
CREATE TABLE IF NOT EXISTS work_log (
    id INT GENERATED ALWAYS AS IDENTITY,
    volunteer_id INT NOT NULL,
    project_id INT NOT NULL,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    hours NUMERIC(4, 2) NOT NULL,
    
    CONSTRAINT pk_work_log PRIMARY KEY (id, volunteer_id, project_id),
    CONSTRAINT fk_work_log_volunteer FOREIGN KEY (volunteer_id)
        REFERENCES volunteer (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_work_log_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_work_log_hours CHECK (hours > 0)
);
CREATE INDEX idx_work_log_volunteer ON work_log (volunteer_id);
CREATE INDEX idx_work_log_project ON work_log (project_id);

-- Table: staff
CREATE TABLE IF NOT EXISTS staff (
    id INT GENERATED ALWAYS AS IDENTITY,
    actor_id INT NOT NULL,
    salary NUMERIC(19, 4) NOT NULL DEFAULT 0.0000,
    hiring_date DATE NOT NULL DEFAULT CURRENT_DATE,
    
    CONSTRAINT pk_staff PRIMARY KEY (id),
    CONSTRAINT uq_staff_actor UNIQUE (actor_id),
    CONSTRAINT fk_staff_actor FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_staff_salary CHECK (salary >= 0)
);

-- Table: job_title
CREATE TABLE IF NOT EXISTS job_title (
    id INT GENERATED ALWAYS AS IDENTITY,
    organization_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    
    CONSTRAINT pk_job_title PRIMARY KEY (id),
    CONSTRAINT fk_job_title_organization FOREIGN KEY (organization_id)
        REFERENCES organization (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_job_title_organization ON job_title (organization_id);

-- Table: staff_has_job_title_history
CREATE TABLE IF NOT EXISTS staff_has_job_title_history (
    id INT GENERATED ALWAYS AS IDENTITY,
    staff_id INT NOT NULL,
    job_title_id INT NOT NULL,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE NULL,
    
    CONSTRAINT pk_staff_has_job_title_history PRIMARY KEY (id, staff_id, job_title_id),
    CONSTRAINT fk_job_hist_staff FOREIGN KEY (staff_id)
        REFERENCES staff (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_job_hist_title FOREIGN KEY (job_title_id)
        REFERENCES job_title (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_job_hist_dates CHECK (end_date IS NULL OR end_date >= start_date)
);
CREATE INDEX idx_job_hist_staff ON staff_has_job_title_history (staff_id);
CREATE INDEX idx_job_hist_title ON staff_has_job_title_history (job_title_id);


-- =============================================================================
-- MÓDULO 5: FINANZAS Y FONDOS
-- =============================================================================

-- Table: currency
CREATE TABLE IF NOT EXISTS currency (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    value_in_dollars NUMERIC(12, 6) NOT NULL,
    
    CONSTRAINT pk_currency PRIMARY KEY (id),
    CONSTRAINT uq_currency_name UNIQUE (name)
);

-- Table: donor
CREATE TABLE IF NOT EXISTS donor (
    id INT GENERATED ALWAYS AS IDENTITY,
    actor_id INT NOT NULL,
    type VARCHAR(10) NOT NULL, -- Ej: 'INDIVIDUAL', 'CORPORATE'
    
    CONSTRAINT pk_donor PRIMARY KEY (id),
    CONSTRAINT uq_donor_actor UNIQUE (actor_id),
    CONSTRAINT fk_donor_actor FOREIGN KEY (actor_id)
        REFERENCES actor (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: donation
CREATE TABLE IF NOT EXISTS donation (
    id INT GENERATED ALWAYS AS IDENTITY,
    donor_id INT NOT NULL,
    project_id INT NOT NULL,
    currency_id INT NOT NULL,
    amount NUMERIC(19, 4) NOT NULL,
    date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_restricted BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    
    CONSTRAINT pk_donation PRIMARY KEY (id),
    CONSTRAINT fk_donation_donor FOREIGN KEY (donor_id)
        REFERENCES donor (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_donation_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_donation_currency FOREIGN KEY (currency_id)
        REFERENCES currency (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_donation_amount CHECK (amount > 0)
);
CREATE INDEX idx_donation_donor ON donation (donor_id);
CREATE INDEX idx_donation_project ON donation (project_id);
CREATE INDEX idx_donation_currency ON donation (currency_id);

-- Table: fund
CREATE TABLE IF NOT EXISTS fund (
    id INT GENERATED ALWAYS AS IDENTITY,
    currency_id INT NOT NULL,
    amount NUMERIC(19, 4) NOT NULL DEFAULT 0.0000,
    
    CONSTRAINT pk_fund PRIMARY KEY (id),
    CONSTRAINT fk_fund_currency FOREIGN KEY (currency_id)
        REFERENCES currency (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_fund_amount CHECK (amount >= 0)
);
CREATE INDEX idx_fund_currency ON fund (currency_id);

-- Table: fund_has_donation (Tabla intermedia N:M corregida y ortografía resuelta)
CREATE TABLE IF NOT EXISTS fund_has_donation (
    fund_id INT NOT NULL,
    donation_id INT NOT NULL,
    
    CONSTRAINT pk_fund_has_donation PRIMARY KEY (fund_id, donation_id),
    CONSTRAINT fk_fund_donation_fund FOREIGN KEY (fund_id)
        REFERENCES fund (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fund_donation_donation FOREIGN KEY (donation_id)
        REFERENCES donation (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_fund_donation_donation ON fund_has_donation (donation_id);

-- Table: expense
CREATE TABLE IF NOT EXISTS expense (
    id INT GENERATED ALWAYS AS IDENTITY,
    project_id INT NOT NULL,
    category VARCHAR(75) NOT NULL,
    amount NUMERIC(19, 4) NOT NULL DEFAULT 0.0000,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    receipt_url VARCHAR(512) NULL,
    
    CONSTRAINT pk_expense PRIMARY KEY (id),
    CONSTRAINT fk_expense_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_expense_amount CHECK (amount > 0)
);
CREATE INDEX idx_expense_project ON expense (project_id);

-- Table: budget_allocation
CREATE TABLE IF NOT EXISTS budget_allocation (
    id INT GENERATED ALWAYS AS IDENTITY,
    project_id INT NOT NULL,
    amount NUMERIC(19, 4) NOT NULL DEFAULT 0.0000,
    
    CONSTRAINT pk_budget_allocation PRIMARY KEY (id),
    CONSTRAINT fk_budget_alloc_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_budget_alloc_amount CHECK (amount >= 0)
);
CREATE INDEX idx_budget_alloc_project ON budget_allocation (project_id);


-- =============================================================================
-- MÓDULO 6: RENDIMIENTO, PUBLICACIÓN Y AUDITORÍA
-- =============================================================================

-- Table: indicator
CREATE TABLE IF NOT EXISTS indicator (
    id INT GENERATED ALWAYS AS IDENTITY,
    project_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    unit VARCHAR(50) NULL, -- VARCHAR dinámico para métricas flexibles ('Porcentaje', 'Horas', etc.)
    target_value NUMERIC(12, 4) NULL,
    
    CONSTRAINT pk_indicator PRIMARY KEY (id),
    CONSTRAINT fk_indicator_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_indicator_project ON indicator (project_id);

-- Table: achievement_log
CREATE TABLE IF NOT EXISTS achievement_log (
    id INT GENERATED ALWAYS AS IDENTITY,
    indicator_id INT NOT NULL,
    value_achieved NUMERIC(12, 4) NOT NULL,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    evidence_url VARCHAR(512) NULL,
    
    CONSTRAINT pk_achievement_log PRIMARY KEY (id),
    CONSTRAINT fk_achievement_indicator FOREIGN KEY (indicator_id)
        REFERENCES indicator (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_achievement_log_indicator ON achievement_log (indicator_id);

-- Table: project_publication
CREATE TABLE IF NOT EXISTS project_publication (
    id INT GENERATED ALWAYS AS IDENTITY,
    project_id INT NOT NULL,
    target NUMERIC(19, 4) NULL,
    media_url VARCHAR(512) NULL,
    
    CONSTRAINT pk_project_publication PRIMARY KEY (id),
    CONSTRAINT fk_publication_project FOREIGN KEY (project_id)
        REFERENCES project (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_publication_project ON project_publication (project_id);

-- Table: audit_log
CREATE TABLE IF NOT EXISTS audit_log (
    id INT GENERATED ALWAYS AS IDENTITY,
    user_id INT NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id INT NOT NULL,
    action VARCHAR(50) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    old_value JSONB NULL,        -- JSONB optimiza búsquedas indexadas y performance en Postgres
    new_value JSONB NULL,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_audit_log PRIMARY KEY (id),
    CONSTRAINT fk_audit_log_user FOREIGN KEY (user_id)
        REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX idx_audit_log_user ON audit_log (user_id);