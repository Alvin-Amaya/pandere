-- seed.sql
SET search_path TO public;

INSERT INTO organization(name) VALUES
('Pandere Honduras'),('Fundación Esperanza'),('ONG Verde');

INSERT INTO role(name) VALUES
('ADMIN'),('MANAGER'),('VOLUNTEER'),('FINANCE');

INSERT INTO permission(slug,description) VALUES
('users.read','Leer usuarios'),
('users.write','Editar usuarios'),
('projects.read','Leer proyectos'),
('projects.write','Editar proyectos');

INSERT INTO role_has_permission(role_id,permission_id)
SELECT r.id,p.id FROM role r CROSS JOIN permission p
WHERE (r.name='ADMIN')
OR (r.name='MANAGER' AND p.slug IN ('projects.read','projects.write'))
OR (r.name='VOLUNTEER' AND p.slug='projects.read')
OR (r.name='FINANCE' AND p.slug='projects.read');

INSERT INTO currency(name,value_in_dollars) VALUES
('USD',1.0),('HNL',0.0395);

INSERT INTO location(name,parent_location_id) VALUES
('Honduras',NULL),
('Cortés',1),
('Francisco Morazán',1),
('San Pedro Sula',2),
('Tegucigalpa',3);

INSERT INTO actor(email,actor_type) VALUES
('admin@pandere.org','USER'),
('maria@example.com','DONOR'),
('juan@example.com','VOLUNTEER'),
('empresa@example.com','DONOR');

INSERT INTO person(actor_id,first_name,first_surname,birth_date,dni) VALUES
(1,'Carlos','Mejía','1988-01-10','080119880001'),
(2,'María','López','1990-05-12','080119900002'),
(3,'Juan','Martínez','1995-08-20','080119950003');

INSERT INTO enterprise(actor_id,name,rtn,business_sector)
VALUES(4,'Constructora Centroamericana','08019000123456','Construcción');

INSERT INTO telephone(number,actor_id) VALUES
('99990001',1),('99990002',2),('99990003',3),('22223333',4);

INSERT INTO address(actor_id,location_id,type) VALUES
(1,4,'Residencial'),
(2,5,'Residencial'),
(3,4,'Residencial'),
(4,5,'Fiscal');

INSERT INTO users(actor_id,role_id,nickname,password)
VALUES
(1,(SELECT id FROM role WHERE name='ADMIN'),'admin','$2b$12$dummyhash');

INSERT INTO project(name,description,start_date)
VALUES
('Agua para Todos','Pozos comunitarios','2026-01-10'),
('Reforestación','Siembra de árboles','2026-02-01');

INSERT INTO status(table_name,status_name) VALUES
('project','PLANNED'),
('project','ACTIVE'),
('task','TODO'),
('task','DONE');

INSERT INTO project_has_status(project_id,status_id)
VALUES
(1,1),(2,2);

INSERT INTO skill(name) VALUES
('Carpintería'),
('Primeros Auxilios'),
('Gestión de Proyectos');

INSERT INTO volunteer(actor_id,hours_accumulated)
VALUES(3,45);

INSERT INTO volunteer_has_skill(volunteer_id,skill_id)
VALUES(1,2);

INSERT INTO project_has_skill(project_id,skill_id)
VALUES(1,2),(2,3);

INSERT INTO project_task(project_id,status_id,name,due_date)
VALUES
(1,3,'Excavación','2026-08-01'),
(1,3,'Instalación de bomba','2026-08-15'),
(2,3,'Compra de plantas','2026-07-20');

INSERT INTO donor(actor_id,type)
VALUES(2,'INDIVIDUAL'),(4,'CORPORATE');

INSERT INTO donation(donor_id,project_id,currency_id,amount)
VALUES
(1,1,2,25000),
(2,2,1,5000);

INSERT INTO fund(currency_id,amount)
VALUES(2,25000),(1,5000);

INSERT INTO fund_has_donation VALUES(1,1),(2,2);

INSERT INTO expense(project_id,category,amount)
VALUES
(1,'Materiales',10000),
(2,'Transporte',500);

INSERT INTO budget_allocation(project_id,amount)
VALUES(1,50000),(2,10000);

INSERT INTO indicator(project_id,name,unit,target_value)
VALUES
(1,'Pozos construidos','Unidad',5),
(2,'Árboles sembrados','Unidad',1000);

INSERT INTO achievement_log(indicator_id,value_achieved)
VALUES
(1,2),
(2,300);

INSERT INTO project_publication(project_id,target,media_url)
VALUES
(1,5,'https://example.org/agua'),
(2,1000,'https://example.org/arboles');

INSERT INTO audit_log(user_id,table_name,record_id,action)
VALUES
(1,'project',1,'INSERT'),
(1,'donation',1,'INSERT');
