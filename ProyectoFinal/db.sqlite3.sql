BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS django_migrations (
    id SERIAL PRIMARY KEY,
    app VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    applied TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS django_content_type (
    id SERIAL PRIMARY KEY,
    app_label VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS auth_group_permissions (
    id SERIAL PRIMARY KEY,
    group_id INTEGER NOT NULL,
    permission_id INTEGER NOT NULL,
    FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS auth_permission (
    id SERIAL PRIMARY KEY,
    content_type_id INTEGER NOT NULL,
    codename VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS auth_group (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS custom_user_customuser_groups (
    id SERIAL PRIMARY KEY,
    customuser_id BIGINT NOT NULL,
    group_id INTEGER NOT NULL,
    FOREIGN KEY (customuser_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS custom_user_customuser_user_permissions (
    id SERIAL PRIMARY KEY,
    customuser_id BIGINT NOT NULL,
    permission_id INTEGER NOT NULL,
    FOREIGN KEY (customuser_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS django_admin_log (
    id SERIAL PRIMARY KEY,
    object_id TEXT,
    object_repr VARCHAR(200) NOT NULL,
    action_flag SMALLINT NOT NULL CHECK (action_flag >= 0),
    change_message TEXT NOT NULL,
    content_type_id INTEGER,
    user_id BIGINT NOT NULL,
    action_time TIMESTAMP NOT NULL,
    FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (user_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS alumno_alumno (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    fk_id_carrera_id BIGINT,
    fk_id_usuario_id BIGINT,
    FOREIGN KEY (fk_id_usuario_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (fk_id_carrera_id) REFERENCES carrera_carrera(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS django_session (
    session_key VARCHAR(40) PRIMARY KEY,
    session_data TEXT NOT NULL,
    expire_date TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS carrera_votacioncarrera (
    id SERIAL PRIMARY KEY,
    valor INTEGER NOT NULL,
    carrera_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (carrera_id) REFERENCES carrera_carrera(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS materia_votacionmateria (
    id SERIAL PRIMARY KEY,
    valor INTEGER NOT NULL,
    materia_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    FOREIGN KEY (materia_id) REFERENCES materia_materia(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (usuario_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS feedback_feedback (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS cursada_cursada (
    id SERIAL PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    titulo VARCHAR(50),
    materia_id BIGINT NOT NULL,
    profesor_id BIGINT NOT NULL,
    FOREIGN KEY (materia_id) REFERENCES materia_materia(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (profesor_id) REFERENCES profesor_profesor(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS materia_materia (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    carrera_id BIGINT NOT NULL,
    profesor_id BIGINT,
    FOREIGN KEY (profesor_id) REFERENCES profesor_profesor(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (carrera_id) REFERENCES carrera_carrera(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS opinion_opinion (
    id SERIAL PRIMARY KEY,
    fecha TIMESTAMP NOT NULL,
    autor_id BIGINT NOT NULL,
    contenido TEXT NOT NULL,
    content_type_id INTEGER,
    object_id INTEGER CHECK (object_id >= 0),
    titulo VARCHAR(200) NOT NULL,
    calificacion INTEGER NOT NULL CHECK (calificacion >= 0),
    FOREIGN KEY (autor_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS carrera_carrera (
    id SERIAL PRIMARY KEY,
    duracion INTEGER NOT NULL CHECK (duracion >= 0),
    institucion_id BIGINT NOT NULL,
    nombre VARCHAR(150),
    img_perfil VARCHAR(100),
    FOREIGN KEY (institucion_id) REFERENCES institucion_institucion(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS feedback_emaillog (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS account_emailconfirmation (
    id SERIAL PRIMARY KEY,
    created TIMESTAMP NOT NULL,
    sent TIMESTAMP,
    key VARCHAR(64) NOT NULL UNIQUE,
    email_address_id INTEGER NOT NULL,
    FOREIGN KEY (email_address_id) REFERENCES account_emailaddress(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS account_emailaddress (
    id SERIAL PRIMARY KEY,
    verified BOOLEAN NOT NULL,
    primary BOOLEAN NOT NULL,
    user_id BIGINT NOT NULL,
    email VARCHAR(254) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS socialaccount_socialapp (
    id SERIAL PRIMARY KEY,
    provider VARCHAR(30) NOT NULL,
    name VARCHAR(40) NOT NULL,
    client_id VARCHAR(191) NOT NULL,
    secret VARCHAR(191) NOT NULL,
    key VARCHAR(191) NOT NULL,
    provider_id VARCHAR(200) NOT NULL,
    settings TEXT NOT NULL CHECK (jsonb_valid(settings) OR settings IS NULL)
);

CREATE TABLE IF NOT EXISTS socialaccount_socialtoken (
    id SERIAL PRIMARY KEY,
    token TEXT NOT NULL,
    token_secret TEXT NOT NULL,
    expires_at TIMESTAMP,
    account_id INTEGER NOT NULL,
    app_id INTEGER,
    FOREIGN KEY (account_id) REFERENCES socialaccount_socialaccount(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (app_id) REFERENCES socialaccount_socialapp(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS socialaccount_socialaccount (
    id SERIAL PRIMARY KEY,
    provider VARCHAR(200) NOT NULL,
    uid VARCHAR(191) NOT NULL,
    last_login TIMESTAMP NOT NULL,
    date_joined TIMESTAMP NOT NULL,
    user_id BIGINT NOT NULL,
    extra_data TEXT NOT NULL CHECK (jsonb_valid(extra_data) OR extra_data IS NULL),
    FOREIGN KEY (user_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS profesor_profesor_carrera (
    id SERIAL PRIMARY KEY,
    profesor_id BIGINT NOT NULL,
    carrera_id BIGINT NOT NULL,
    FOREIGN KEY (profesor_id) REFERENCES profesor_profesor(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (carrera_id) REFERENCES carrera_carrera(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS profesor_profesor_institucion (
    id SERIAL PRIMARY KEY,
    profesor_id BIGINT NOT NULL,
    institucion_id BIGINT NOT NULL,
    FOREIGN KEY (profesor_id) REFERENCES profesor_profesor(id) DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (institucion_id) REFERENCES institucion_institucion(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS profesor_profesor (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    usuario_id BIGINT NOT NULL,
    img_perfil VARCHAR(100),
    FOREIGN KEY (usuario_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE IF NOT EXISTS custom_user_customuser (
    id SERIAL PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    last_login TIMESTAMP,
    is_superuser BOOLEAN NOT NULL,
    nombre VARCHAR(100),
    email VARCHAR(254) NOT NULL UNIQUE,
    descripcion TEXT,
    is_active BOOLEAN NOT NULL,
    is_staff BOOLEAN NOT NULL,
    tipo_usuario VARCHAR(20),
    genero VARCHAR(1),
    institucion VARCHAR(100),
    fecha_de_nacimiento DATE,
    img_perfil VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS institucion_institucion (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    url VARCHAR(250),
    usuario_id BIGINT NOT NULL,
    direccion VARCHAR(250),
    coordenadas VARCHAR(250),
    img_perfil VARCHAR(100),
    FOREIGN KEY (usuario_id) REFERENCES custom_user_customuser(id) DEFERRABLE INITIALLY DEFERRED
);

INSERT INTO "django_migrations" ("id","app","name","applied") VALUES (1,'contenttypes','0001_initial','2023-11-10 22:06:51.037385'),
 (2,'contenttypes','0002_remove_content_type_name','2023-11-10 22:06:51.046337'),
 (3,'auth','0001_initial','2023-11-10 22:06:51.062569'),
 (4,'auth','0002_alter_permission_name_max_length','2023-11-10 22:06:51.071502'),
 (5,'auth','0003_alter_user_email_max_length','2023-11-10 22:06:51.079347'),
 (6,'auth','0004_alter_user_username_opts','2023-11-10 22:06:51.087267'),
 (7,'auth','0005_alter_user_last_login_null','2023-11-10 22:06:51.095271'),
 (8,'auth','0006_require_contenttypes_0002','2023-11-10 22:06:51.101437'),
 (9,'auth','0007_alter_validators_add_error_messages','2023-11-10 22:06:51.108943'),
 (10,'auth','0008_alter_user_username_max_length','2023-11-10 22:06:51.116803'),
 (11,'auth','0009_alter_user_last_name_max_length','2023-11-10 22:06:51.124306'),
 (12,'auth','0010_alter_group_name_max_length','2023-11-10 22:06:51.132526'),
 (13,'auth','0011_update_proxy_permissions','2023-11-10 22:06:51.140372'),
 (14,'auth','0012_alter_user_first_name_max_length','2023-11-10 22:06:51.148374'),
 (15,'custom_user','0001_initial','2023-11-10 22:06:51.164386'),
 (16,'admin','0001_initial','2023-11-10 22:06:51.179398'),
 (17,'admin','0002_logentry_remove_auto_add','2023-11-10 22:06:51.189503'),
 (18,'admin','0003_logentry_add_action_flag_choices','2023-11-10 22:06:51.197567'),
 (19,'carrera','0001_initial','2023-11-10 22:06:51.211522'),
 (20,'alumno','0001_initial','2023-11-10 22:06:51.218344'),
 (21,'alumno','0002_initial','2023-11-10 22:06:51.233763'),
 (22,'alumno','0003_initial','2023-11-10 22:06:51.253553'),
 (23,'cursada','0001_initial','2023-11-10 22:06:51.260338'),
 (24,'calificacion','0001_initial','2023-11-10 22:06:51.267547'),
 (25,'calificacion','0002_initial','2023-11-10 22:06:51.275555'),
 (26,'calificacion','0003_initial','2023-11-10 22:06:51.286478'),
 (27,'institucion','0001_initial','2023-11-10 22:06:51.301361'),
 (28,'carrera','0002_initial','2023-11-10 22:06:51.317460'),
 (29,'profesor','0001_initial','2023-11-10 22:06:51.332865'),
 (30,'materia','0001_initial','2023-11-10 22:06:51.354101'),
 (31,'cursada','0002_initial','2023-11-10 22:06:51.371573'),
 (32,'opinion','0001_initial','2023-11-10 22:06:51.388982'),
 (33,'sessions','0001_initial','2023-11-10 22:06:51.401489'),
 (34,'cursada','0003_cursada_titulo','2023-11-10 22:29:26.976182'),
 (35,'carrera','0003_votacioncarrera_delete_votacion','2023-11-10 22:55:05.826664'),
 (36,'materia','0002_votacionmateria_delete_votacion','2023-11-10 22:55:05.844856'),
 (37,'calificacion','0004_alter_calificacion_fk_id_cursada_and_more','2023-11-10 23:02:41.447061'),
 (38,'detalle_calificacion','0001_initial','2023-11-10 23:26:59.452523'),
 (39,'carrera','0004_alter_carrera_titulo','2023-11-12 19:03:45.702904'),
 (40,'institucion','0002_alter_institucion_nombre_alter_institucion_ubicacion','2023-11-12 19:03:45.719997'),
 (41,'materia','0003_alter_materia_nombre','2023-11-12 19:03:45.730308'),
 (42,'custom_user','0002_alter_customuser_tipo_usuario','2023-11-12 19:37:23.357827'),
 (43,'institucion','0003_institucion_url','2023-11-14 22:02:17.099874'),
 (44,'profesor','0002_profesor_id_institucion','2023-11-16 22:39:44.297331'),
 (45,'custom_user','0003_customuser_edad_customuser_genero_and_more','2024-04-05 23:01:52.771016'),
 (46,'custom_user','0004_remove_customuser_edad_and_more','2024-04-09 00:42:18.507853'),
 (47,'custom_user','0005_alter_customuser_img_perfil','2024-04-14 13:39:01.789884'),
 (48,'custom_user','0006_alter_customuser_img_perfil','2024-04-14 13:39:01.804077'),
 (49,'calificacion','0005_remove_calificacion_fk_id_cursada_and_more','2024-04-29 07:38:30.028570'),
 (50,'carrera','0005_carrera_img_perfil','2024-04-29 07:38:30.037562'),
 (51,'institucion','0004_institucion_img_perfil','2024-04-29 07:38:30.051074'),
 (52,'opinion','0002_rename_fk_id_usuario_opinion_autor_and_more','2024-04-29 07:38:30.112043'),
 (53,'carrera','0006_alter_carrera_img_perfil_alter_carrera_titulo','2024-04-30 19:50:44.715638'),
 (54,'institucion','0005_alter_institucion_img_perfil','2024-04-30 19:50:44.730116'),
 (55,'feedback','0001_initial','2024-05-01 15:53:12.398513'),
 (56,'profesor','0003_rename_fk_id_usuario_profesor_usuario_and_more','2024-05-01 22:51:25.255765'),
 (57,'profesor','0004_profesor_img_perfil','2024-05-01 23:04:51.696346'),
 (58,'calificacion','0006_alter_calificacion_autor','2024-05-02 01:04:47.655996'),
 (59,'cursada','0004_rename_fk_id_materia_cursada_materia_and_more','2024-05-02 01:04:47.674363'),
 (60,'carrera','0007_rename_fk_id_institucion_carrera_institucion','2024-05-02 01:54:24.938125'),
 (61,'institucion','0006_rename_fk_id_usuario_institucion_usuario','2024-05-02 01:54:24.951944'),
 (62,'materia','0004_rename_fk_id_carrera_materia_carrera','2024-05-02 01:54:24.963932'),
 (63,'opinion','0003_remove_opinion_curso','2024-05-02 03:32:53.312407'),
 (64,'calificacion','0007_remove_calificacion_curso','2024-05-02 04:14:54.928085'),
 (65,'calificacion','0008_rename_calificacion_num_calificacion_valor','2024-05-03 01:45:23.258469'),
 (66,'calificacion','0009_remove_calificacion_autor','2024-05-03 03:20:19.443255'),
 (67,'opinion','0004_alter_opinion_calificacion','2024-05-03 03:43:57.827100'),
 (68,'carrera','0008_rename_titulo_carrera_nombre','2024-05-03 04:10:53.054783'),
 (69,'carrera','0009_alter_carrera_img_perfil','2024-05-15 17:21:12.829499'),
 (70,'institucion','0007_alter_institucion_img_perfil','2024-05-15 17:21:12.842289'),
 (71,'profesor','0005_alter_profesor_img_perfil','2024-05-15 17:21:12.859975'),
 (72,'profesor','0006_profesor_institucion','2024-05-15 19:03:12.919169'),
 (73,'feedback','0002_emaillog','2024-05-16 02:07:05.336413'),
 (74,'custom_user','0007_alter_customuser_img_perfil','2024-05-16 03:43:13.498854'),
 (75,'account','0001_initial','2024-05-19 20:10:39.209216'),
 (76,'account','0002_email_max_length','2024-05-19 20:10:39.219200'),
 (77,'account','0003_alter_emailaddress_create_unique_verified_email','2024-05-19 20:10:39.242686'),
 (78,'account','0004_alter_emailaddress_drop_unique_email','2024-05-19 20:10:39.257583'),
 (79,'account','0005_emailaddress_idx_upper_email','2024-05-19 20:10:39.268037'),
 (80,'socialaccount','0001_initial','2024-05-19 20:10:39.307115'),
 (81,'socialaccount','0002_token_max_lengths','2024-05-19 20:10:39.327433'),
 (82,'socialaccount','0003_extra_data_default_dict','2024-05-19 20:10:39.340366'),
 (83,'socialaccount','0004_app_provider_id_settings','2024-05-19 20:10:39.361739'),
 (84,'socialaccount','0005_socialtoken_nullable_app','2024-05-19 20:10:39.376637'),
 (85,'socialaccount','0006_alter_socialaccount_extra_data','2024-05-19 20:10:39.391054'),
 (86,'profesor','0007_profesor_carrera','2024-05-26 22:26:56.615405'),
 (87,'profesor','0008_remove_profesor_materia','2024-05-26 22:33:16.789952'),
 (88,'materia','0005_materia_profesor','2024-05-26 23:00:45.592565'),
 (89,'profesor','0009_remove_profesor_carrera_remove_profesor_institucion_and_more','2024-05-26 23:00:45.638179'),
 (90,'materia','0006_alter_materia_profesor','2024-05-26 23:22:55.866716'),
 (91,'profesor','0010_alter_profesor_institucion','2024-05-26 23:22:55.893725'),
 (92,'custom_user','0008_alter_customuser_nombre','2024-05-27 00:04:59.523853'),
 (93,'profesor','0011_alter_profesor_img_perfil','2024-05-27 01:43:52.387063'),
 (94,'custom_user','0009_alter_customuser_img_perfil','2024-05-27 01:47:14.784764'),
 (95,'institucion','0008_rename_ubicacion_institucion_direccion_and_more','2024-05-27 19:43:56.133843'),
 (96,'institucion','0009_alter_institucion_img_perfil','2024-05-30 20:45:34.759884');

INSERT INTO "django_content_type" ("id","app_label","model") VALUES (1,'admin','logentry'),
 (2,'auth','permission'),
 (3,'auth','group'),
 (4,'contenttypes','contenttype'),
 (5,'sessions','session'),
 (6,'alumno','alumno'),
 (8,'carrera','carrera'),
 (9,'carrera','votacion'),
 (10,'cursada','cursada'),
 (11,'custom_user','customuser'),
 (13,'institucion','institucion'),
 (14,'materia','materia'),
 (15,'materia','votacion'),
 (16,'opinion','opinion'),
 (17,'profesor','profesor'),
 (18,'carrera','votacioncarrera'),
 (19,'materia','votacionmateria'),
 (20,'feedback','feedback'),
 (21,'feedback','emaillog'),
 (22,'account','emailaddress'),
 (23,'account','emailconfirmation'),
 (24,'socialaccount','socialaccount'),
 (25,'socialaccount','socialapp'),
 (26,'socialaccount','socialtoken'),
 (27,'allauth','socialapp'),
 (28,'allauth','socialaccount'),
 (29,'allauth','socialtoken');

INSERT INTO "auth_permission" ("id","content_type_id","codename","name") VALUES (1,1,'add_logentry','Can add log entry'),
 (2,1,'change_logentry','Can change log entry'),
 (3,1,'delete_logentry','Can delete log entry'),
 (4,1,'view_logentry','Can view log entry'),
 (5,2,'add_permission','Can add permission'),
 (6,2,'change_permission','Can change permission'),
 (7,2,'delete_permission','Can delete permission'),
 (8,2,'view_permission','Can view permission'),
 (9,3,'add_group','Can add group'),
 (10,3,'change_group','Can change group'),
 (11,3,'delete_group','Can delete group'),
 (12,3,'view_group','Can view group'),
 (13,4,'add_contenttype','Can add content type'),
 (14,4,'change_contenttype','Can change content type'),
 (15,4,'delete_contenttype','Can delete content type'),
 (16,4,'view_contenttype','Can view content type'),
 (17,5,'add_session','Can add session'),
 (18,5,'change_session','Can change session'),
 (19,5,'delete_session','Can delete session'),
 (20,5,'view_session','Can view session'),
 (21,6,'add_alumno','Can add alumno'),
 (22,6,'change_alumno','Can change alumno'),
 (23,6,'delete_alumno','Can delete alumno'),
 (24,6,'view_alumno','Can view alumno'),
 (25,7,'add_calificacion','Can add calificacion'),
 (26,7,'change_calificacion','Can change calificacion'),
 (27,7,'delete_calificacion','Can delete calificacion'),
 (28,7,'view_calificacion','Can view calificacion'),
 (29,8,'add_carrera','Can add carrera'),
 (30,8,'change_carrera','Can change carrera'),
 (31,8,'delete_carrera','Can delete carrera'),
 (32,8,'view_carrera','Can view carrera'),
 (33,9,'add_votacion','Can add votacion'),
 (34,9,'change_votacion','Can change votacion'),
 (35,9,'delete_votacion','Can delete votacion'),
 (36,9,'view_votacion','Can view votacion'),
 (37,10,'add_cursada','Can add cursada'),
 (38,10,'change_cursada','Can change cursada'),
 (39,10,'delete_cursada','Can delete cursada'),
 (40,10,'view_cursada','Can view cursada'),
 (41,11,'add_customuser','Can add custom user'),
 (42,11,'change_customuser','Can change custom user'),
 (43,11,'delete_customuser','Can delete custom user'),
 (44,11,'view_customuser','Can view custom user'),
 (49,13,'add_institucion','Can add institucion'),
 (50,13,'change_institucion','Can change institucion'),
 (51,13,'delete_institucion','Can delete institucion'),
 (52,13,'view_institucion','Can view institucion'),
 (53,14,'add_materia','Can add materia'),
 (54,14,'change_materia','Can change materia'),
 (55,14,'delete_materia','Can delete materia'),
 (56,14,'view_materia','Can view materia'),
 (57,15,'add_votacion','Can add votacion'),
 (58,15,'change_votacion','Can change votacion'),
 (59,15,'delete_votacion','Can delete votacion'),
 (60,15,'view_votacion','Can view votacion'),
 (61,16,'add_opinion','Can add opinion'),
 (62,16,'change_opinion','Can change opinion'),
 (63,16,'delete_opinion','Can delete opinion'),
 (64,16,'view_opinion','Can view opinion'),
 (65,17,'add_profesor','Can add profesor'),
 (66,17,'change_profesor','Can change profesor'),
 (67,17,'delete_profesor','Can delete profesor'),
 (68,17,'view_profesor','Can view profesor'),
 (69,18,'add_votacioncarrera','Can add votacion carrera'),
 (70,18,'change_votacioncarrera','Can change votacion carrera'),
 (71,18,'delete_votacioncarrera','Can delete votacion carrera'),
 (72,18,'view_votacioncarrera','Can view votacion carrera'),
 (73,19,'add_votacionmateria','Can add votacion materia'),
 (74,19,'change_votacionmateria','Can change votacion materia'),
 (75,19,'delete_votacionmateria','Can delete votacion materia'),
 (76,19,'view_votacionmateria','Can view votacion materia'),
 (77,20,'add_feedback','Can add feedback'),
 (78,20,'change_feedback','Can change feedback'),
 (79,20,'delete_feedback','Can delete feedback'),
 (80,20,'view_feedback','Can view feedback'),
 (81,21,'add_emaillog','Can add email log'),
 (82,21,'change_emaillog','Can change email log'),
 (83,21,'delete_emaillog','Can delete email log'),
 (84,21,'view_emaillog','Can view email log'),
 (85,22,'add_emailaddress','Can add email address'),
 (86,22,'change_emailaddress','Can change email address'),
 (87,22,'delete_emailaddress','Can delete email address'),
 (88,22,'view_emailaddress','Can view email address'),
 (89,23,'add_emailconfirmation','Can add email confirmation'),
 (90,23,'change_emailconfirmation','Can change email confirmation'),
 (91,23,'delete_emailconfirmation','Can delete email confirmation'),
 (92,23,'view_emailconfirmation','Can view email confirmation'),
 (93,24,'add_socialaccount','Can add social account'),
 (94,24,'change_socialaccount','Can change social account'),
 (95,24,'delete_socialaccount','Can delete social account'),
 (96,24,'view_socialaccount','Can view social account'),
 (97,25,'add_socialapp','Can add social application'),
 (98,25,'change_socialapp','Can change social application'),
 (99,25,'delete_socialapp','Can delete social application'),
 (100,25,'view_socialapp','Can view social application'),
 (101,26,'add_socialtoken','Can add social application token'),
 (102,26,'change_socialtoken','Can change social application token'),
 (103,26,'delete_socialtoken','Can delete social application token'),
 (104,26,'view_socialtoken','Can view social application token'),
 (105,27,'add_socialapp','Can add social application'),
 (106,27,'change_socialapp','Can change social application'),
 (107,27,'delete_socialapp','Can delete social application'),
 (108,27,'view_socialapp','Can view social application'),
 (109,28,'add_socialaccount','Can add social account'),
 (110,28,'change_socialaccount','Can change social account'),
 (111,28,'delete_socialaccount','Can delete social account'),
 (112,28,'view_socialaccount','Can view social account'),
 (113,29,'add_socialtoken','Can add social application token'),
 (114,29,'change_socialtoken','Can change social application token'),
 (115,29,'delete_socialtoken','Can delete social application token'),
 (116,29,'view_socialtoken','Can view social application token');

INSERT INTO "django_admin_log" ("id","object_id","object_repr","action_flag","change_message","content_type_id","user_id","action_time") VALUES (1,'2','dfts_ifts18_de2@bue.edu.ar',1,'[{"added": {}}]',11,1,'2023-11-10 22:17:15.873481'),
 (2,'1','Institucion object (1)',1,'[{"added": {}}]',13,1,'2023-11-10 22:17:22.884473'),
 (3,'1','Carrera object (1)',1,'[{"added": {}}]',8,1,'2023-11-10 22:18:00.812929'),
 (4,'3','juan@gmail.com',1,'[{"added": {}}]',11,1,'2023-11-10 22:22:40.192195'),
 (5,'1','Bonini',1,'[{"added": {}}]',6,1,'2023-11-10 22:22:50.898403'),
 (6,'4','juanB@gmail.com',1,'[{"added": {}}]',11,1,'2023-11-10 22:25:18.480253'),
 (7,'1','Juan2',1,'[{"added": {}}]',17,1,'2023-11-10 22:25:20.453921'),
 (8,'1','Materia object (1)',1,'[{"added": {}}]',14,1,'2023-11-10 22:26:30.107799'),
 (9,'2','Materia object (2)',1,'[{"added": {}}]',14,1,'2023-11-10 22:30:55.025642'),
 (10,'3','Materia object (3)',1,'[{"added": {}}]',14,1,'2023-11-10 22:33:05.528728'),
 (11,'4','Materia object (4)',1,'[{"added": {}}]',14,1,'2023-11-10 22:35:11.453441'),
 (12,'5','Backend',1,'[{"added": {}}]',14,1,'2023-11-10 22:39:38.679786'),
 (13,'6','Backend',1,'[{"added": {}}]',14,1,'2023-11-10 22:40:23.671668'),
 (14,'7','Backend',1,'[{"added": {}}]',14,1,'2023-11-10 22:43:11.817490'),
 (15,'8','Backend',1,'[{"added": {}}]',14,1,'2023-11-10 22:55:43.422754'),
 (16,'8','Backend',3,'',14,1,'2023-11-10 22:56:30.060654'),
 (17,'7','Backend',3,'',14,1,'2023-11-10 22:56:30.076653'),
 (18,'6','Backend',3,'',14,1,'2023-11-10 22:56:30.083455'),
 (19,'5','Backend',3,'',14,1,'2023-11-10 22:56:30.089722'),
 (20,'4','Backend',3,'',14,1,'2023-11-10 22:56:30.095724'),
 (21,'3','Backend',3,'',14,1,'2023-11-10 22:56:30.101658'),
 (22,'2','Backend',3,'',14,1,'2023-11-10 22:56:30.108046'),
 (23,'1','Backend09082023',1,'[{"added": {}}]',10,1,'2023-11-10 22:58:46.475275'),
 (24,'1','Calificación de admin',1,'[{"added": {}}]',7,1,'2023-11-10 23:02:14.285908'),
 (25,'2','Calificación de admin',1,'[{"added": {}}]',7,1,'2023-11-10 23:03:38.090945'),
 (26,'3','Calificación de admin',1,'[{"added": {}}]',7,1,'2023-11-10 23:27:53.676900'),
 (27,'2','Calificación de admin',3,'',7,1,'2023-11-10 23:28:13.689737'),
 (28,'3','Calificación de admin',3,'',7,1,'2023-11-10 23:28:19.254252'),
 (29,'3','Juan',2,'[{"changed": {"fields": ["Password"]}}]',11,1,'2023-11-10 23:56:24.500376'),
 (30,'5','IFTS 1',1,'[{"added": {}}]',11,1,'2023-11-11 21:21:29.236440'),
 (31,'2','IFTS 1',1,'[{"added": {}}]',13,1,'2023-11-11 21:21:35.765120'),
 (32,'6','IFTS 2',1,'[{"added": {}}]',11,1,'2023-11-11 21:35:07.934736'),
 (33,'3','IFTS 2',1,'[{"added": {}}]',13,1,'2023-11-11 21:35:09.859843'),
 (34,'7','IFTS 3',1,'[{"added": {}}]',11,1,'2023-11-11 21:41:35.919622'),
 (35,'4','IFTS 3',1,'[{"added": {}}]',13,1,'2023-11-11 21:41:57.414670'),
 (36,'3','IFTS 2',2,'[{"changed": {"fields": ["Ubicacion"]}}]',13,1,'2023-11-11 21:42:26.068553'),
 (37,'4','IFTS 3',2,'[{"changed": {"fields": ["Ubicacion"]}}]',13,1,'2023-11-11 21:42:51.168275'),
 (38,'6','IFTS 2',2,'[{"changed": {"fields": ["Img perfil"]}}]',11,1,'2023-11-11 21:53:55.587731'),
 (39,'3','IFTS 2',2,'[]',13,1,'2023-11-11 21:54:15.059594'),
 (40,'8','alumno1',1,'[{"added": {}}]',11,1,'2023-11-12 18:56:05.726968'),
 (41,'9','Cloud',1,'[{"added": {}}]',14,1,'2023-11-12 18:57:32.720097'),
 (42,'10','Ingenieria de Software',1,'[{"added": {}}]',14,1,'2023-11-12 18:57:59.080254'),
 (43,'11','Frontend',1,'[{"added": {}}]',14,1,'2023-11-12 18:58:27.951286'),
 (44,'2','Técnico Superior en Análisis de Sistemas',1,'[{"added": {}}]',8,1,'2023-11-12 18:59:29.940362'),
 (45,'3','Técnico Superior Ciencia de Datos e Inteligencia',1,'[{"added": {}}]',8,1,'2023-11-12 19:00:23.998348'),
 (46,'3','Técnico Superior en Ciencia de Datos e Inteligencia Artificial',2,'[{"changed": {"fields": ["Titulo"]}}]',8,1,'2023-11-12 19:04:47.870687'),
 (47,'1','Técnico Superior en Desarrollo de Software',2,'[{"changed": {"fields": ["Titulo"]}}]',8,1,'2023-11-12 19:05:17.656150'),
 (48,'9','Alejandro Peña',1,'[{"added": {}}]',11,1,'2023-11-12 19:07:16.389966'),
 (49,'2','Alejandro Peña',1,'[{"added": {}}]',17,1,'2023-11-12 19:07:21.513158'),
 (50,'10','Eduardo Iberti',1,'[{"added": {}}]',11,1,'2023-11-12 19:10:34.407728'),
 (51,'3','Eduardo Iberti',1,'[{"added": {}}]',17,1,'2023-11-12 19:10:36.313691'),
 (52,'4','Juan Bonini',2,'[]',11,1,'2023-11-12 19:11:02.761710'),
 (53,'1','Juan Bonini',2,'[{"changed": {"fields": ["Nombre"]}}]',17,1,'2023-11-12 19:11:06.798332'),
 (54,'3','Dummy',2,'[{"changed": {"fields": ["Nombre", "Email", "Descripcion"]}}]',11,1,'2023-11-12 19:12:03.136699'),
 (55,'1','Dummy1',2,'[{"changed": {"fields": ["Nombre"]}}]',6,1,'2023-11-12 19:12:06.472160'),
 (56,'11','Dummy2',1,'[{"added": {}}]',11,1,'2023-11-12 19:13:16.121246'),
 (57,'2','Dummy2',1,'[{"added": {}}]',6,1,'2023-11-12 19:13:20.026922'),
 (58,'4','Juan Bonini',2,'[{"changed": {"fields": ["Descripcion"]}}]',11,1,'2023-11-12 19:14:09.377813'),
 (59,'9','Alejandro Peña',2,'[{"changed": {"fields": ["Descripcion"]}}]',11,1,'2023-11-12 19:14:45.675212'),
 (60,'4','Juan Bonini',2,'[{"changed": {"fields": ["Tipo usuario"]}}]',11,1,'2023-11-12 19:38:00.070713'),
 (61,'1','Juan Bonini',2,'[]',17,1,'2023-11-12 19:38:02.344037'),
 (62,'9','Alejandro Peña',2,'[{"changed": {"fields": ["Tipo usuario"]}}]',11,1,'2023-11-12 19:38:09.040057'),
 (63,'2','Alejandro Peña',2,'[]',17,1,'2023-11-12 19:38:10.296316'),
 (64,'10','Eduardo Iberti',2,'[{"changed": {"fields": ["Tipo usuario"]}}]',11,1,'2023-11-12 19:38:16.328731'),
 (65,'3','Eduardo Iberti',2,'[]',17,1,'2023-11-12 19:38:17.737424'),
 (66,'1','IFTS 18',2,'[{"changed": {"fields": ["Url"]}}]',13,1,'2023-11-14 22:03:59.054998'),
 (67,'2','IFTS 1',2,'[{"changed": {"fields": ["Url"]}}]',13,1,'2023-11-14 22:04:51.201852'),
 (68,'12','Usuario1',1,'[{"added": {}}]',11,1,'2023-11-17 01:15:53.023956'),
 (69,'13','Usuario2',1,'[{"added": {}}]',11,1,'2023-11-17 01:16:47.482078'),
 (70,'14','Usuario3',1,'[{"added": {}}]',11,1,'2023-11-17 01:17:19.600597'),
 (71,'11','Dummy2',2,'[{"changed": {"fields": ["Password", "Img perfil"]}}]',11,1,'2023-11-17 19:56:26.829443'),
 (72,'8','alumno1',2,'[{"changed": {"fields": ["Descripcion", "Img perfil"]}}]',11,1,'2023-11-17 20:08:54.564848'),
 (73,'12','Usuario1',2,'[{"changed": {"fields": ["Password"]}}]',11,1,'2023-11-17 21:46:33.246969'),
 (74,'12','Usuario1',2,'[]',11,1,'2023-11-17 22:02:59.894583'),
 (75,'3','Dummy 3',1,'[{"added": {}}]',6,1,'2024-03-24 20:46:14.808557'),
 (76,'3','Dummy1',2,'[{"changed": {"fields": ["Password", "Img perfil"]}}]',11,1,'2024-03-29 21:24:14.807750'),
 (77,'11','Dummy2',2,'[{"changed": {"fields": ["Password"]}}]',11,1,'2024-03-29 22:24:47.808004'),
 (78,'20','Test1',1,'[{"added": {}}]',11,1,'2024-03-29 22:26:00.922472'),
 (79,'19','prueba2@gmail.com',2,'[{"changed": {"fields": ["Password"]}}]',11,1,'2024-04-06 01:47:19.488387'),
 (80,'19','prueba2@gmail.com',2,'[{"changed": {"fields": ["Img perfil"]}}]',11,1,'2024-04-06 01:47:42.862656'),
 (81,'19','prueba2@gmail.com',2,'[]',11,1,'2024-04-06 01:47:48.693678'),
 (82,'1','admin@gmail.com',2,'[{"changed": {"fields": ["Descripcion", "Img perfil", "Institucion", "Fecha de nacimiento", "Genero"]}}]',11,1,'2024-04-12 23:01:33.091663'),
 (83,'21','diego@gmail.com',3,'',11,1,'2024-04-14 13:24:34.524752'),
 (84,'20','test1@gmail.com',3,'',11,1,'2024-04-14 13:24:34.528244'),
 (85,'19','prueba2@gmail.com',3,'',11,1,'2024-04-14 13:24:34.538200'),
 (86,'18','prueba1@gmail.com',3,'',11,1,'2024-04-14 13:24:34.544780'),
 (87,'17','mihumildemail@gmail.com',3,'',11,1,'2024-04-14 13:24:34.545780'),
 (88,'8','alumno1@gmail.com',3,'',11,1,'2024-04-14 13:24:34.557031'),
 (89,'2','IFTS 1',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-29 17:51:35.984290'),
 (90,'3','IFTS 2',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-29 17:51:49.918910'),
 (91,'4','IFTS 3',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-29 18:01:00.251636'),
 (92,'1','IFTS 18',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-29 18:01:10.565885'),
 (93,'32','bedelesifts4@gmail.com',1,'[{"added": {}}]',11,1,'2024-04-29 18:03:35.446662'),
 (94,'5','IFTS N°4',1,'[{"added": {}}]',13,1,'2024-04-29 18:03:51.504275'),
 (95,'33','iftscinco@gmail.com',1,'[{"added": {}}]',11,1,'2024-04-29 18:05:29.730823'),
 (96,'6','IFTS N°5',1,'[{"added": {}}]',13,1,'2024-04-29 18:05:31.954763'),
 (97,'4','IFTS N°3',2,'[{"changed": {"fields": ["Nombre", "Url"]}}]',13,1,'2024-04-29 18:07:42.981588'),
 (98,'3','IFTS N°2',2,'[{"changed": {"fields": ["Nombre", "Url"]}}]',13,1,'2024-04-29 18:08:08.673920'),
 (99,'2','IFTS N°1',2,'[{"changed": {"fields": ["Nombre"]}}]',13,1,'2024-04-29 18:08:19.689000'),
 (100,'1','IFTS N°18',2,'[{"changed": {"fields": ["Nombre"]}}]',13,1,'2024-04-29 18:08:28.262483'),
 (101,'2','Calificación de 31',1,'[{"added": {}}]',7,1,'2024-04-29 18:10:09.191386'),
 (102,'1','Opinión de borra01@gmail.com',1,'[{"added": {}}]',16,1,'2024-04-29 18:10:56.575954'),
 (103,'2','Opinión de borra01@gmail.com',1,'[{"added": {}}]',16,1,'2024-04-29 18:11:29.093363'),
 (104,'29','test123@gmail.com',3,'',11,1,'2024-04-30 18:11:57.793026'),
 (105,'28','borra2@gmail.com',3,'',11,1,'2024-04-30 18:11:57.808553'),
 (106,'27','borra1@gmail.com',3,'',11,1,'2024-04-30 18:11:57.814540'),
 (107,'16','user5@edu.ar',3,'',11,1,'2024-04-30 18:11:57.822776'),
 (108,'15','user6@edu.ar',3,'',11,1,'2024-04-30 18:11:57.829710'),
 (109,'14','user3@edu.ar',3,'',11,1,'2024-04-30 18:11:57.832340'),
 (110,'13','user2@edu.ar',3,'',11,1,'2024-04-30 18:11:57.839913'),
 (111,'12','user1@edu.ar',3,'',11,1,'2024-04-30 18:11:57.849628'),
 (112,'11','dummy2@gmail.com',3,'',11,1,'2024-04-30 18:11:57.852443'),
 (113,'3','dummy1@gmail.com',3,'',11,1,'2024-04-30 18:11:57.861077'),
 (114,'2','5to cuatrimestre',1,'[{"added": {}}]',10,1,'2024-04-30 18:13:04.705851'),
 (115,'2','IFTS N°1',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 18:14:21.197244'),
 (116,'3','IFTS N°2',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 18:14:37.341584'),
 (117,'4','IFTS N°3',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 18:17:59.388876'),
 (118,'34','ifts6@gmail.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:24:52.429664'),
 (119,'7','IFTS N°6',1,'[{"added": {}}]',13,1,'2024-04-30 18:24:56.956172'),
 (120,'7','IFTS N°6',2,'[]',13,1,'2024-04-30 18:25:00.456760'),
 (121,'3','IFTS N°2',2,'[]',13,1,'2024-04-30 18:25:10.576998'),
 (122,'4','IFTS N°3',2,'[]',13,1,'2024-04-30 18:25:13.562543'),
 (123,'5','IFTS N°4',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 18:25:24.579641'),
 (124,'6','IFTS N°5',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 18:25:39.269812'),
 (125,'7','IFTS N°6',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 18:25:55.427934'),
 (126,'1','IFTS N°18',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 18:26:04.566604'),
 (127,'35','ifts7@gmail.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:28:18.855260'),
 (128,'8','IFTS N°7',1,'[{"added": {}}]',13,1,'2024-04-30 18:28:32.980504'),
 (129,'36','ifts8@gmail.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:31:30.908550'),
 (130,'9','IFTS N°8',1,'[{"added": {}}]',13,1,'2024-04-30 18:31:35.671390'),
 (131,'37','ifts9@gmail.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:33:07.018117'),
 (132,'10','IFTS N°9',1,'[{"added": {}}]',13,1,'2024-04-30 18:33:11.243680'),
 (133,'38','ifts10@gmail.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:34:29.494379'),
 (134,'11','IFTS N°10',1,'[{"added": {}}]',13,1,'2024-04-30 18:34:33.344843'),
 (135,'39','ifts11@gmail.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:36:01.230560'),
 (136,'12','IFTS N°11',1,'[{"added": {}}]',13,1,'2024-04-30 18:36:06.913910'),
 (137,'40','ifts12@gmail.com',1,'[{"added": {}}]',11,1,'2024-04-30 18:37:58.473239'),
 (138,'13','IFTS N°12',1,'[{"added": {}}]',13,1,'2024-04-30 18:38:10.210161'),
 (139,'41','ifts13@gmail.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:39:51.004100'),
 (140,'14','IFTS N°13',1,'[{"added": {}}]',13,1,'2024-04-30 18:39:55.028176'),
 (141,'42','bedelia.ifts14@bue.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:43:27.108455'),
 (142,'15','IFTS N°14',1,'[{"added": {}}]',13,1,'2024-04-30 18:43:40.246769'),
 (143,'43','ifts15@gmail.edu.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:45:31.518753'),
 (144,'16','IFTS N°15',1,'[{"added": {}}]',13,1,'2024-04-30 18:45:35.780270'),
 (145,'44','DFTS_IFTS16_DE21@BUE.EDU.AR',1,'[{"added": {}}]',11,1,'2024-04-30 18:48:21.980659'),
 (146,'17','IFTS N°16',1,'[{"added": {}}]',13,1,'2024-04-30 18:48:24.503993'),
 (147,'45','tecnicatura@agip.gov.ar',1,'[{"added": {}}]',11,1,'2024-04-30 18:50:03.683693'),
 (148,'18','IFTS N°17',1,'[{"added": {}}]',13,1,'2024-04-30 18:50:05.463522'),
 (149,'4','Tecnicatura Superior En Seguros',1,'[{"added": {}}]',8,1,'2024-04-30 19:07:34.984556'),
 (150,'5','TÉCNICO SUPERIOR EN EMPRENDIMIENTOS GASTRONÓMICOS',1,'[{"added": {}}]',8,1,'2024-04-30 19:13:35.992858'),
 (151,'6','Tecnicatura Superior en Administración de Empresas',1,'[{"added": {}}]',8,1,'2024-04-30 19:21:46.637312'),
 (152,'7','Técnico Superior en Desarrollo de Software',1,'[{"added": {}}]',8,1,'2024-04-30 19:29:13.884159'),
 (153,'8','Técnico Superior en Analisis de Datos',1,'[{"added": {}}]',8,1,'2024-04-30 19:29:47.198096'),
 (154,'9','Técnico Superior en Desarrollo de Software de Simuladores',1,'[{"added": {}}]',8,1,'2024-04-30 19:32:54.830044'),
 (155,'10','Tecnico Superior en  Comercio Internacional y Aduanas (6)',1,'[{"added": {}}]',8,1,'2024-04-30 19:34:10.846740'),
 (156,'11','Tecnico Superior en Comercio Internacional',1,'[{"added": {}}]',8,1,'2024-04-30 19:36:13.892273'),
 (157,'12','Técnico Superior en Comercialización',1,'[{"added": {}}]',8,1,'2024-04-30 19:36:57.803739'),
 (158,'13','Técnico Superior en Analisis de Sistemas',1,'[{"added": {}}]',8,1,'2024-04-30 19:37:26.917983'),
 (159,'14','Técnico Superior en Administración de Empresas',1,'[{"added": {}}]',8,1,'2024-04-30 19:38:37.381433'),
 (160,'15','Técnico Superior en Administración de Servicios de Salud',1,'[{"added": {}}]',8,1,'2024-04-30 19:39:21.681044'),
 (161,'16','Técnico Superior en Guía de Turismo con Especialización en CABA',1,'[{"added": {}}]',8,1,'2024-04-30 19:40:11.250569'),
 (162,'17','Tecnicatura Superior en ADMINISTRACIÓN Y RELACIONES DEL TRABAJO',1,'[{"added": {}}]',8,1,'2024-04-30 19:42:10.396549'),
 (163,'18','Tecnicatura Superior en ADMINISTRACIÓN COMERCIAL',1,'[{"added": {}}]',8,1,'2024-04-30 19:42:48.492428'),
 (164,'19','Técnico Superior en Administración de Empresas',1,'[{"added": {}}]',8,1,'2024-04-30 19:44:23.039401'),
 (165,'20','Técnico Superior en Administración y Relaciones del Trabajo',1,'[{"added": {}}]',8,1,'2024-04-30 19:44:57.898237'),
 (166,'21','Técnico Superior en Administración',1,'[{"added": {}}]',8,1,'2024-04-30 19:45:14.282251'),
 (167,'1','IFTS N°18',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:54:04.235956'),
 (168,'1','IFTS N°18',2,'[]',13,1,'2024-04-30 19:54:28.630725'),
 (169,'2','IFTS N°1',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:54:36.590785'),
 (170,'3','IFTS N°2',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:54:43.403617'),
 (171,'4','IFTS N°3',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:54:50.931684'),
 (172,'5','IFTS N°4',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:55:06.310451'),
 (173,'33','ifts5@gmail.com',2,'[{"changed": {"fields": ["Email"]}}]',11,1,'2024-04-30 19:55:33.953942'),
 (174,'6','IFTS N°5',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:55:43.429723'),
 (175,'7','IFTS N°6',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:55:53.403253'),
 (176,'8','IFTS N°7',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:56:00.353949'),
 (177,'9','IFTS N°8',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:56:07.372566'),
 (178,'10','IFTS N°9',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:56:15.566503'),
 (179,'11','IFTS N°10',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:56:24.561029'),
 (180,'12','IFTS N°11',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:56:32.078727'),
 (181,'14','IFTS N°13',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:56:38.584868'),
 (182,'15','IFTS N°14',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:56:45.442537'),
 (183,'16','IFTS N°15',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:56:52.220418'),
 (184,'17','IFTS N°16',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:57:00.077785'),
 (185,'18','IFTS N°17',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 19:57:07.684769'),
 (186,'1','Técnico Superior en Desarrollo de Software',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:57:55.909072'),
 (187,'2','Técnico Superior en Análisis de Sistemas',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:58:08.354350'),
 (188,'3','Técnico Superior en Ciencia de Datos e Inteligencia Artificial',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:58:16.871193'),
 (189,'4','Tecnicatura Superior En Seguros',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:58:30.865714'),
 (190,'5','TÉCNICO SUPERIOR EN EMPRENDIMIENTOS GASTRONÓMICOS',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:58:40.645340'),
 (191,'6','Tecnicatura Superior en Administración de Empresas',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:58:51.786120'),
 (192,'7','Técnico Superior en Desarrollo de Software',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:58:59.530327'),
 (193,'8','Técnico Superior en Analisis de Datos',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:59:08.351968'),
 (194,'9','Técnico Superior en Desarrollo de Software de Simuladores',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:59:20.009527'),
 (195,'10','Tecnico Superior en  Comercio Internacional y Aduanas (6)',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:59:31.519741'),
 (196,'11','Tecnico Superior en Comercio Internacional',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:59:43.769255'),
 (197,'12','Técnico Superior en Comercialización',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:59:51.383500'),
 (198,'13','Técnico Superior en Analisis de Sistemas',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 19:59:59.258972'),
 (199,'14','Técnico Superior en Administración de Empresas',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 20:00:06.541614'),
 (200,'15','Técnico Superior en Administración de Servicios de Salud',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 20:00:15.049665'),
 (201,'16','Técnico Superior en Guía de Turismo con Especialización en CABA',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 20:00:30.919541'),
 (202,'17','Tecnicatura Superior en ADMINISTRACIÓN Y RELACIONES DEL TRABAJO',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 20:00:41.548644'),
 (203,'18','Tecnicatura Superior en ADMINISTRACIÓN COMERCIAL',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 20:00:51.151380'),
 (204,'19','Técnico Superior en Administración de Empresas',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 20:00:59.902907'),
 (205,'20','Técnico Superior en Administración y Relaciones del Trabajo',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 20:01:10.188130'),
 (206,'21','Técnico Superior en Administración',2,'[{"changed": {"fields": ["Img perfil"]}}]',8,1,'2024-04-30 20:01:16.602540'),
 (207,'13','IFTS N°12',2,'[{"changed": {"fields": ["Img perfil"]}}]',13,1,'2024-04-30 20:05:39.573505'),
 (208,'12','Técnicas de programación',1,'[{"added": {}}]',14,1,'2024-05-01 23:15:18.437295'),
 (209,'13','Administración de Base de Datos',1,'[{"added": {}}]',14,1,'2024-05-01 23:15:45.605074'),
 (210,'14','Elementos de Análisis Matemático',1,'[{"added": {}}]',14,1,'2024-05-01 23:16:05.866659'),
 (211,'15','Desarrollo de Sistemas Orientados a Objetos',1,'[{"added": {}}]',14,1,'2024-05-01 23:16:23.189020'),
 (212,'16','Lógica Computacional',1,'[{"added": {}}]',14,1,'2024-05-01 23:16:38.251091'),
 (213,'17','Modelado y Diseño de Software',1,'[{"added": {}}]',14,1,'2024-05-01 23:16:51.594724'),
 (214,'18','Estadística y Probabilidad para el Desarrollo de Software',1,'[{"added": {}}]',14,1,'2024-05-01 23:17:05.448623'),
 (215,'19','Inglés',1,'[{"added": {}}]',14,1,'2024-05-01 23:17:15.075254'),
 (216,'20','Práctica Profesional I',1,'[{"added": {}}]',14,1,'2024-05-01 23:17:27.167097'),
 (217,'21','Desarrollo de Aplicaciones para Dispositivos Móviles',1,'[{"added": {}}]',14,1,'2024-05-01 23:17:39.197098'),
 (218,'22','Metodología de Prueba de Sistemas',1,'[{"added": {}}]',14,1,'2024-05-01 23:18:02.225023'),
 (219,'23','Tecnologías de la Información y de la Comunicación',1,'[{"added": {}}]',14,1,'2024-05-01 23:18:14.901878'),
 (220,'24','Taller de Comunicación',1,'[{"added": {}}]',14,1,'2024-05-01 23:18:30.327813'),
 (221,'25','PPII: Desarrollo de Sistemas de Información Orientados a la Gestión y Apoyo a las Decisiones',1,'[{"added": {}}]',14,1,'2024-05-01 23:18:44.403355'),
 (222,'26','Programación sobre Redes',1,'[{"added": {}}]',14,1,'2024-05-01 23:19:01.122047'),
 (223,'27','Seminario de Profundización y/o Actualización',1,'[{"added": {}}]',14,1,'2024-05-01 23:19:11.954003'),
 (224,'28','Gestión de Proyectos',1,'[{"added": {}}]',14,1,'2024-05-01 23:19:25.209313'),
 (225,'29','Trabajo, Tecnología y Sociedad',1,'[{"added": {}}]',14,1,'2024-05-01 23:19:38.603554'),
 (226,'30','Proyecto Integrador',1,'[{"added": {}}]',14,1,'2024-05-01 23:20:06.360474'),
 (227,'9','Desarrollo e Implementación de Sistemas en la Nube',2,'[{"changed": {"fields": ["Nombre"]}}]',14,1,'2024-05-01 23:20:19.481905'),
 (228,'4','Juan Bonini',1,'[{"added": {}}]',17,1,'2024-05-02 00:15:01.249030'),
 (229,'1','Juan Bonini',2,'[]',17,1,'2024-05-02 00:15:22.767260'),
 (230,'46','vir_russo18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:24:26.480447'),
 (231,'1','Virginia Russo',2,'[{"changed": {"fields": ["Nombre", "Usuario", "Materia"]}}]',17,1,'2024-05-02 00:24:30.949648'),
 (232,'2','Alejandro Peña',2,'[{"changed": {"fields": ["Materia"]}}]',17,1,'2024-05-02 00:24:39.953037'),
 (233,'3','Eduardo Iberti',2,'[{"changed": {"fields": ["Materia"]}}]',17,1,'2024-05-02 00:24:48.262121'),
 (234,'2','Alejandro Peña',2,'[]',17,1,'2024-05-02 00:24:51.470742'),
 (235,'4','Juan Bonini',2,'[]',17,1,'2024-05-02 00:24:56.331719'),
 (236,'1','Virginia Russo',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-02 00:25:11.422359'),
 (237,'47','maria.e.18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:26:15.539230'),
 (238,'5','Maria Ester',1,'[{"added": {}}]',17,1,'2024-05-02 00:26:26.252240'),
 (239,'48','ale.gon.18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:27:34.831709'),
 (240,'6','Alejandro González',1,'[{"added": {}}]',17,1,'2024-05-02 00:27:52.578689'),
 (241,'49','ema.od.18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:29:06.489438'),
 (242,'7','Emanuel Odstrcil',1,'[{"added": {}}]',17,1,'2024-05-02 00:29:14.147441'),
 (243,'50','pablo.len.18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:30:52.615002'),
 (244,'8','Pablo Lencinas',1,'[{"added": {}}]',17,1,'2024-05-02 00:30:57.427353'),
 (245,'51','maria.lau.18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:32:00.837427'),
 (246,'9','Maria Laura',1,'[{"added": {}}]',17,1,'2024-05-02 00:32:05.803916'),
 (247,'52','martin.san.18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:33:27.257916'),
 (248,'10','Martin Santoro',1,'[{"added": {}}]',17,1,'2024-05-02 00:33:38.894653'),
 (249,'11','Alejandro Peña',1,'[{"added": {}}]',17,1,'2024-05-02 00:36:23.825538'),
 (250,'53','alberto.camp.18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:37:54.823037'),
 (251,'12','Alberto Campagna',1,'[{"added": {}}]',17,1,'2024-05-02 00:38:06.972591'),
 (252,'54','hernan.cun.18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:39:25.240815'),
 (253,'13','Hernan Cunarro',1,'[{"added": {}}]',17,1,'2024-05-02 00:39:43.410907'),
 (254,'55','virgi.pol@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:40:42.404878'),
 (255,'14','Virginia Polcan',1,'[{"added": {}}]',17,1,'2024-05-02 00:40:52.790915'),
 (256,'56','esteban.fass@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-02 00:41:41.573620'),
 (257,'15','Esteban Fassio',1,'[{"added": {}}]',17,1,'2024-05-02 00:41:44.441884'),
 (258,'2','Opinión de borra01@gmail.com',3,'',16,1,'2024-05-02 00:45:11.627163'),
 (259,'3','Cuatrimestre Admin',1,'[{"added": {}}]',10,1,'2024-05-02 00:46:15.776726'),
 (260,'3','Calificación de 1',1,'[{"added": {}}]',7,1,'2024-05-02 00:46:33.254454'),
 (261,'3','Opinión de admin@gmail.com',1,'[{"added": {}}]',16,1,'2024-05-02 00:46:57.553825'),
 (262,'3','Tiene una Calificación de 5 estrellas por admin',3,'',7,1,'2024-05-02 04:17:20.765617'),
 (263,'1','Calificación de 10 estrellas sin autor asignado',3,'',7,1,'2024-05-02 04:17:20.778946'),
 (264,'5','Tiene una Calificación de 4 estrellas por admin',1,'[{"added": {}}]',7,1,'2024-05-02 04:17:45.222728'),
 (265,'5','Tiene una Calificación de 4 estrellas por admin',3,'',7,1,'2024-05-03 02:22:42.871004'),
 (266,'6','Tiene una Calificación de 2 estrellas por Kayn',1,'[{"added": {}}]',7,1,'2024-05-03 02:23:16.016653'),
 (267,'7','Tiene una Calificación de 3 estrellas por admin',1,'[{"added": {}}]',7,1,'2024-05-03 03:15:51.277477'),
 (268,'19','Opinión de admin@gmail.com',1,'[{"added": {}}]',16,1,'2024-05-03 03:16:05.674698'),
 (269,'8','La Calificación es de 5 estrellas',1,'[{"added": {}}]',7,1,'2024-05-03 03:22:15.732718'),
 (270,'1','Google Auth',1,'[{"added": {}}]',25,1,'2024-05-19 21:11:11.602887'),
 (271,'9','Maria Laura',2,'[{"changed": {"fields": ["Materia"]}}]',17,1,'2024-05-26 22:29:49.711738'),
 (272,'15','Esteban Fassio',2,'[{"changed": {"fields": ["Materia"]}}]',17,1,'2024-05-26 22:30:01.880001'),
 (273,'12','Alberto Campagna',2,'[{"changed": {"fields": ["Institucion", "Carrera", "Img perfil"]}}]',17,1,'2024-05-26 23:57:34.508386'),
 (274,'1','Virginia Russo',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:57:49.766761'),
 (275,'2','Alejandro Peña',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:57:56.421939'),
 (276,'3','Eduardo Iberti',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:00.890827'),
 (277,'4','Juan Bonini',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:04.962705'),
 (278,'5','Maria Ester',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:09.442963'),
 (279,'6','Alejandro González',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:15.957620'),
 (280,'7','Emanuel Odstrcil',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:20.419450'),
 (281,'8','Pablo Lencinas',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:25.226565'),
 (282,'9','Maria Laura',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:30.429633'),
 (283,'10','Martin Santoro',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:33.954442'),
 (284,'11','Alejandro Peña',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:45.384079'),
 (285,'13','Hernan Cunarro',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:58:54.661162'),
 (286,'14','Virginia Polcan',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:59:00.716595'),
 (287,'15','Esteban Fassio',2,'[{"changed": {"fields": ["Institucion", "Carrera"]}}]',17,1,'2024-05-26 23:59:05.140169'),
 (288,'24','Taller de Comunicación',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:07:19.376291'),
 (289,'30','Proyecto Integrador',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:07:27.507028'),
 (290,'29','Trabajo, Tecnología y Sociedad',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:07:37.287521'),
 (291,'28','Gestión de Proyectos',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:07:58.386486'),
 (292,'27','Seminario de Profundización y/o Actualización',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:08:15.510927'),
 (293,'26','Programación sobre Redes',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:08:36.679592'),
 (294,'25','PPII: Desarrollo de Sistemas de Información Orientados a la Gestión y Apoyo a las Decisiones',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:08:44.251386'),
 (295,'24','Taller de Comunicación',2,'[]',14,1,'2024-05-27 00:08:55.875220'),
 (296,'23','Tecnologías de la Información y de la Comunicación',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:09:04.033077'),
 (297,'60','carlos_quintero18@gmail.com',1,'[{"added": {}}]',11,1,'2024-05-27 00:13:52.797650'),
 (298,'16','Carlos Quinteros',1,'[{"added": {}}]',17,1,'2024-05-27 00:14:08.434306'),
 (299,'22','Metodología de Prueba de Sistemas',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:14:12.201550'),
 (300,'1','Backend',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:15:07.786270'),
 (301,'9','Desarrollo e Implementación de Sistemas en la Nube',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:15:12.640268'),
 (302,'10','Ingenieria de Software',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:15:20.999763'),
 (303,'11','Frontend',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:15:25.716354'),
 (304,'12','Técnicas de programación',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:15:35.304799'),
 (305,'13','Administración de Base de Datos',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:15:43.572606'),
 (306,'15','Desarrollo de Sistemas Orientados a Objetos',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:16:04.504193'),
 (307,'16','Lógica Computacional',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:16:26.792814'),
 (308,'17','Modelado y Diseño de Software',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:16:38.149484'),
 (309,'21','Desarrollo de Aplicaciones para Dispositivos Móviles',2,'[{"changed": {"fields": ["Profesor"]}}]',14,1,'2024-05-27 00:16:44.102831'),
 (310,'2','Alejandro Peña',3,'',17,1,'2024-05-27 00:23:26.244635'),
 (311,'16','Carlos Quinteros',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:40:25.234892'),
 (312,'15','Esteban Fassio',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:40:34.400087'),
 (313,'16','Carlos Quinteros',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:45:57.548713'),
 (314,'10','Martin Santoro',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:46:26.923866'),
 (315,'1','Virginia Russo',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:48:14.675414'),
 (316,'3','Eduardo Iberti',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:48:20.365619'),
 (317,'4','Juan Bonini',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:48:26.439551'),
 (318,'5','Maria Ester',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:48:32.680790'),
 (319,'6','Alejandro González',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:48:41.419795'),
 (320,'7','Emanuel Odstrcil',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:48:48.463371'),
 (321,'9','Maria Laura',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:48:55.163216'),
 (322,'10','Martin Santoro',2,'[]',17,1,'2024-05-27 01:48:59.085943'),
 (323,'11','Alejandro Peña',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:49:10.336713'),
 (324,'12','Alberto Campagna',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:49:34.614036'),
 (325,'15','Esteban Fassio',2,'[{"changed": {"fields": ["Img perfil"]}}]',17,1,'2024-05-27 01:49:45.645893'),
 (326,'2','IFTS N°1',2,'[{"changed": {"fields": ["Coordenadas"]}}]',13,1,'2024-05-27 19:44:57.729364'),
 (327,'3','IFTS N°2',2,'[{"changed": {"fields": ["Coordenadas"]}}]',13,1,'2024-05-27 19:45:31.499946'),
 (328,'4','IFTS N°3',2,'[{"changed": {"fields": ["Coordenadas"]}}]',13,1,'2024-05-27 19:46:00.354306'),
 (329,'1','IFTS N°18',2,'[{"changed": {"fields": ["Coordenadas"]}}]',13,1,'2024-05-27 19:46:28.449745'),
 (330,'1','IFTS N°18',2,'[]',13,1,'2024-05-27 19:54:09.311161'),
 (331,'1','IFTS N°180',2,'[{"changed": {"fields": ["Nombre"]}}]',13,1,'2024-05-27 19:54:46.707212'),
 (332,'19','IFTS N°18',1,'[{"added": {}}]',13,1,'2024-05-27 19:56:05.553803'),
 (333,'19','IFTS N°19',2,'[{"changed": {"fields": ["Nombre"]}}]',13,1,'2024-05-27 20:06:22.571393'),
 (334,'1','IFTS N°18',2,'[{"changed": {"fields": ["Nombre"]}}]',13,1,'2024-05-27 20:06:27.394454'),
 (335,'1','Virginia Russo',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:32:54.094179'),
 (336,'3','Eduardo Iberti',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:00.373702'),
 (337,'4','Juan Bonini',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:05.292815'),
 (338,'4','Juan Bonini',2,'[]',17,1,'2024-05-27 21:33:08.435502'),
 (339,'5','Maria Ester',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:13.652226'),
 (340,'6','Alejandro González',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:17.710774'),
 (341,'6','Alejandro González',2,'[]',17,1,'2024-05-27 21:33:20.384372'),
 (342,'7','Emanuel Odstrcil',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:24.004339'),
 (343,'8','Pablo Lencinas',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:28.031793'),
 (344,'9','Maria Laura',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:39.098390'),
 (345,'10','Martin Santoro',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:43.037879'),
 (346,'10','Martin Santoro',2,'[]',17,1,'2024-05-27 21:33:45.897743'),
 (347,'11','Alejandro Peña',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:48.724052'),
 (348,'12','Alberto Campagna',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:33:52.780175'),
 (349,'13','Hernan Cunarro',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:34:02.776999'),
 (350,'14','Virginia Polcan',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:34:07.797161'),
 (351,'15','Esteban Fassio',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:34:13.070361'),
 (352,'16','Carlos Quinteros',2,'[{"changed": {"fields": ["Institucion"]}}]',17,1,'2024-05-27 21:34:17.887534'),
 (353,'10','Tecnico Superior en  Comercio Internacional y Aduanas',2,'[{"changed": {"fields": ["Nombre"]}}]',8,1,'2024-05-27 21:36:08.530009');

INSERT INTO "django_session" ("session_key","session_data","expire_date") VALUES ('ez63s2khf5ah49jbmt90ci95al8idcbx','.eJxVjMsOwiAQRf-FtSFAGR4u3fsNhIFBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hzuzMJnb63TCmB7Ud5Htst85Tb-syI98VftDBrz3T83K4fwc1jvqtdcxUNDlJ1jmRQFrU4Ce0ooD1RBakyyYrow2CndAbIRQW5RN4KZDY-wPbVDdb:1r48ho:Kq71hshur7RqkLX2s4Xi6hVLkd7a4X5rWIGd-uhjV8Q','2023-12-01 23:57:00.107619'),
 ('9ulu0g5bcsbpvdxsnf02rdswoum75nqc','.eJxVjMsOwiAQRf-FtSFAGR4u3fsNhIFBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hzuzMJDv9bhjTg9oO8j22W-ept3WZke8KP-jg157peTncv4MaR_3WOmYqmpwk65xIIC1q8BNaUcB6IgvSZZOV0QbBTuiNEAqL8gm8FEjs_QHaIjdZ:1r9S68:_JNsqjh1rEnVVcmn1I_xW4tUgsCApS1KUTzaIftjlfw','2023-12-16 15:40:04.567882'),
 ('1okgr4zdy7oekxr0g2zh4rlxv7r0tbk1','.eJxVjMsOwiAQRf-FtSFAGR4u3fsNhIFBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hzuzMJDv9bhjTg9oO8j22W-ept3WZke8KP-jg157peTncv4MaR_3WOmYqmpwk65xIIC1q8BNaUcB6IgvSZZOV0QbBTuiNEAqL8gm8FEjs_QHaIjdZ:1roULg:GmE0XXYOj1qCfjN1XlGIefu8wsgUKD3XDC612XeIbic','2024-04-07 20:21:44.210863'),
 ('5tdrsyc0yat3g3i2xj6we1879eeop5nw','.eJxVjMsOwiAQRf-FtSFAGR4u3fsNhIFBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hzuzMJDv9bhjTg9oO8j22W-ept3WZke8KP-jg157peTncv4MaR_3WOmYqmpwk65xIIC1q8BNaUcB6IgvSZZOV0QbBTuiNEAqL8gm8FEjs_QHaIjdZ:1rr5to:AXFxDn1YwfJdiPyXOvzuL99FpeoDpqQKgCdLNqcuEjM','2024-04-15 00:51:44.816366'),
 ('frw355rpql2xpqg09wl3m0teb1nsjijq','.eJxVjDEOAiEQRe9CbciAgGBp7xnIDAyyaiBZdivj3XWTLbT9773_EhHXpcZ18BynLM5CicPvRpge3DaQ79huXabelnkiuSlyp0Nee-bnZXf_DiqO-q2PxMaitYwelUJyBArAZWU1lWL9Seli2AAEF1LQHtCGZBjQZQZALd4f2ws3fg:1ru0o5:2A5W8Zwc7fIASX1_5DZkVIPlnyN64XEs677cuUkopoo','2024-04-23 02:01:53.980613'),
 ('gtxkuk7hlevwkvxinhykir8qzbnxs0sj','.eJxVjMEOwiAQRP-FsyHAwko9evcbCMuCrRpISnsy_rtt0oNe5jDvzbxFiOsyhrXnOUwsLsKgOP2WFNMz153wI9Z7k6nVZZ5I7oo8aJe3xvl1Pdy_gzH2cVtD8Uyg0So_mGwVoAaVkCxwiecSSTkuVttMOAw-oQNAk3lL0s4YIz5f8uc3PQ:1rvJNv:e5GUMmHOufjlADqim4eH4nq4RHRiQXDs4i2bOpHu9-s','2024-04-26 16:04:15.482630'),
 ('hvvod3e3ugwmeqgeu7doe6o969u98p4t','.eJxVjDEOAiEQRe9CbciAgGBp7xnIDAyyaiBZdivj3XWTLbT9773_EhHXpcZ18BynLM5CicPvRpge3DaQ79huXabelnkiuSlyp0Nee-bnZXf_DiqO-q2PxMaitYwelUJyBArAZWU1lWL9Seli2AAEF1LQHtCGZBjQZQZALd4f2ws3fg:1rvPlo:Uh44pwEzmbNPCNSe8J5ztQgzEKytPNnaIOx5yW0eXYE','2024-04-26 22:53:20.092556'),
 ('fo3m6tb2g0ex0tgxl95g2r6qv7637nfc','.eJxVjDEOAiEQRe9CbciAgGBp7xnIDAyyaiBZdivj3XWTLbT9773_EhHXpcZ18BynLM5CicPvRpge3DaQ79huXabelnkiuSlyp0Nee-bnZXf_DiqO-q2PxMaitYwelUJyBArAZWU1lWL9Seli2AAEF1LQHtCGZBjQZQZALd4f2ws3fg:1rvzTI:2pw_wn9nonINI1IhljnwW3r9KuqfIIxGj_64vNr6tOc','2024-04-28 13:00:36.374265'),
 ('ebfy0pyd7lyrto6b014ya4fhm065n5hd','.eJxVjEEOwiAURO_C2hDgg4BL9z0D-cBXqgaS0q6Md5cmXehqknlv5s0CbmsJW6clzJldGEh2-i0jpifVneQH1nvjqdV1mSPfFX7QzqeW6XU93L-Dgr2MtUdjSYCVIpNKzmoF7mYzqFF7ANIRVEI5QNZxhHLeiLORLgqH2nv2-QLfFzaZ:1rz2Ga:wpfMWRw9OaWnBb8ol0w6iVMUjCdhejUewoMqNeNuZDY','2024-05-06 22:36:04.993944'),
 ('y6dohpl3tafr3kqpqqxauxagjqkizoak','.eJxVjDsOwjAQRO_iGln-hjUlPWew1t41DiBHipMKcXcSKQWUM-_NvEXEdalx7TzHkcRFWC1Ov2XC_OS2E3pgu08yT22ZxyR3RR60y9tE_Loe7t9BxV63teeC4ApAypRNHrIL7JmTUpocGlCQEloIWwQf2IKyxitbiqYynBnE5wspXjhu:1s2NtY:a7ZIpqyzoW5zrttjaub-BbWOHXYsZ1vAL8xEmu5IeXk','2024-05-16 04:18:08.323403'),
 ('7sgbnb4g5hk9tv9vx32pl15tuh1fsh8m','.eJxVjDsOwjAQRO_iGln-hjUlPWew1t41DiBHipMKcXcSKQWUM-_NvEXEdalx7TzHkcRFWC1Ov2XC_OS2E3pgu08yT22ZxyR3RR60y9tE_Loe7t9BxV63teeC4ApAypRNHrIL7JmTUpocGlCQEloIWwQf2IKyxitbiqYynBnE5wspXjhu:1s2kPU:0u315zOtkfpCxQZEaubK2jfdMPfu7sYXBlW8iktyuwc','2024-05-17 04:20:36.001255'),
 ('zxzkgxbfd48wl1pjc799m518s30y3869','.eJxVjDsOwjAQBe_iGlks8ZeSnjNEu941DiBbipMKcXeIlALaNzPvpUZclzKuXeZxYnVW1qvD70iYHlI3wnest6ZTq8s8kd4UvdOur43ledndv4OCvXxrMh6iTzg4cklCjM6CIWFjnPNDDifORyOAEMgS5ATRIEUmIUc-UlLvDwqROKs:1s6PeS:jUI2QxEy49uuUol0RI5GcQuoR9LVYRWvBIGb-y6_G7Y','2024-05-27 06:59:12.818435'),
 ('5tr47dpc6umpgu6rvaintq00j2cp7ibd','.eJxVjDsOwjAQRO_iGln-hjUlPWew1t41DiBHipMKcXcSKQWUM-_NvEXEdalx7TzHkcRFWC1Ov2XC_OS2E3pgu08yT22ZxyR3RR60y9tE_Loe7t9BxV63teeC4ApAypRNHrIL7JmTUpocGlCQEloIWwQf2IKyxitbiqYynBnE5wspXjhu:1s6gCr:1CQLdabtNkvTJksIbjxLm-LBbmQZOtC33-fEJ54XAC8','2024-05-28 00:39:49.387135'),
 ('lkb2dqyt6an0qg8bslcdtli56yiqmuog','.eJxVjDsOwjAQBe_iGln-xJ-lpOcM1nq9wQHkSHFSIe4OkVJA-2bmvUTCba1p67ykqYizcCBOv2NGenDbSblju82S5rYuU5a7Ig_a5XUu_Lwc7t9BxV6_NXsVgoPsY9TecggDG2U0Bk0jqeIMRj96TWTjANYAWg2W0YKnDE5l8f4A5Bk3Kg:1s8Sjd:-TTc3j5WNOIJhxz-SJUtR8oxeF1-HW6LM0KlxV3zQWg','2024-06-01 22:41:01.409291'),
 ('9v8cx6xdzl3c2qn3jpo7t5qy0xtudp4r','.eJxVjEEOwiAQAP_C2ZCwUFg8evcNZGFXqRqalPZk_Lsh6UGvM5N5q0T7VtPeZU0zq7My6vTLMpWntCH4Qe2-6LK0bZ2zHok-bNfXheV1Odq_QaVex9ZyDIwOTMQy-ZDBWcEQgKLNciuTiYBorSOKxXqHAYJkzoTsQSCqzxe8uDcz:1s8nlh:U_oZBAJEP8Y5AYSJzyMm0y4paJsuksLyXzCq7IY8uCA','2024-06-02 21:08:33.949772'),
 ('c2nwlft5cxfqkinulv5o8pwlr71lji40','.eJxVjEEOwiAQAP_C2ZCwUFg8evcNZGFXqRqalPZk_Lsh6UGvM5N5q0T7VtPeZU0zq7My6vTLMpWntCH4Qe2-6LK0bZ2zHok-bNfXheV1Odq_QaVex9ZyDIwOTMQy-ZDBWcEQgKLNciuTiYBorSOKxXqHAYJkzoTsQSCqzxe8uDcz:1sBhx5:ZUyh0wUUV0i3ak3p1-5PExpCJtt0f4y42Zgg5S5f6nE','2024-06-10 21:32:19.112318');

INSERT INTO "feedback_feedback" ("id","titulo","mensaje","user_id") VALUES (1,'Prueba Feedback','Esto es una prueba de feedback',31),
 (2,'Prueba  2','Este es un msj de feedback',31),
 (3,'prueba 3','Otra prueba de feedback',31),
 (4,'Prueba 5','Vamos a ver si ya puedo enviar feedback',31),
 (5,'Prueba 20','asdDASDASDS',31),
 (6,'Prueba email 1','Descripcion de prueba 1',31),
 (7,'Prueba 2','Descripcion 2',31),
 (8,'Prueba 3','Este es un contenido de prueba 3',31),
 (9,'Prueba 4','descripcion 4',31),
 (10,'Prueba 5','desc 5',31),
 (11,'Prueba 5','Descripcion 5',31),
 (12,'Prueba 6','Descripcion 6',31),
 (13,'Prueba 7','Descripcion 7',31),
 (14,'Prueba 8','Descripcion 8',31),
 (15,'Prueba 20','20 dasdf',31),
 (16,'ASEGURO','ME ASEGURO QUE DEJO TODO ANDANDO',31),
 (17,'Prueba 1','Mensaje de prueba 1',31),
 (18,'Prueba 2','Mensaje de prueba 2',31),
 (19,'Prueba 1.1','Este es otra prueba',1),
 (20,'Nico gato','nico es gato',31),
 (21,'Mauro','Mauro un kpo',31),
 (22,'Prueba ENV','Esto es la prueba del .env',31);

INSERT INTO "cursada_cursada" ("id","fecha_inicio","titulo","materia_id","profesor_id") VALUES (1,'2023-09-08','Backend09082023',1,1),
 (2,'2024-03-18','5to cuatrimestre',1,1),
 (3,'2024-05-02','Cuatrimestre Admin',30,12);

INSERT INTO "materia_materia" ("id","nombre","carrera_id","profesor_id") VALUES (1,'Backend',1,4),
 (10,'Ingenieria de Software',1,1),
 (11,'Frontend',1,3),
 (12,'Técnicas de programación',1,8),
 (13,'Administración de Base de Datos',1,7),
 (14,'Elementos de Análisis Matemático',1,NULL),
 (15,'Desarrollo de Sistemas Orientados a Objetos',1,3),
 (16,'Lógica Computacional',1,6),
 (17,'Modelado y Diseño de Software',1,3),
 (18,'Estadística y Probabilidad para el Desarrollo de Software',1,NULL),
 (19,'Inglés',1,NULL),
 (20,'Práctica Profesional I',1,NULL),
 (22,'Metodología de Prueba de Sistemas',1,16),
 (23,'Tecnologías de la Información y de la Comunicación',1,12),
 (24,'Taller de Comunicación',1,12),
 (25,'PPII: Desarrollo de Sistemas de Información Orientados a la Gestión y Apoyo a las Decisiones',1,10),
 (26,'Programación sobre Redes',1,12),
 (27,'Seminario de Profundización y/o Actualización',1,15),
 (28,'Gestión de Proyectos',1,14),
 (29,'Trabajo, Tecnología y Sociedad',1,13),
 (30,'Proyecto Integrador',1,12);

INSERT INTO "opinion_opinion" ("id","fecha","autor_id","contenido","content_type_id","object_id","titulo","calificacion") VALUES (1,'2024-04-29 18:10:56.574953',31,'Esta es la institucion que me formo como Desarrollador de Software y estoy muy feliz con lo que me pude desarrollar.',13,1,'Mi IFTS',2),
 (4,'2024-05-02 03:34:23.708461',31,'Descripcion de prueba 15',13,1,'Prueba 15',2),
 (5,'2024-05-02 03:38:02.900532',31,'Descripcion de prueba 16',13,1,'Prueba 16',2),
 (6,'2024-05-02 03:38:13.218145',31,'Descripcion de prueba 16',13,1,'Prueba 16',2),
 (12,'2024-05-02 22:53:20.785820',31,'Descripcion de prueba 21',13,1,'Prueba 20',2),
 (13,'2024-05-03 01:50:00.491622',31,'Descripcion de prueba 31',13,1,'Prueba 31',2),
 (14,'2024-05-03 01:50:19.833458',31,'Descripcion de prueba 32',13,1,'Prueba 32',4),
 (15,'2024-05-03 01:50:52.183395',31,'Descripcion de prueba 20',13,1,'Prueba 20',2),
 (16,'2024-05-03 01:51:32.513577',31,'Descripcion de prueba 20',13,1,'Prueba 20',4),
 (18,'2024-05-03 01:51:52.434141',31,'Descripcion de prueba 20',13,1,'Prueba 20',2),
 (19,'2024-05-03 03:16:05.674698',1,'Prueba de admin 3',15,3,'Prueba de admin 3',7),
 (20,'2024-05-03 03:22:48.779592',1,'Descripcion de prueba 200',13,1,'Prueba 200',2),
 (21,'2024-05-03 03:44:29.145653',31,'Descripcion de prueba 40',13,1,'Prueba 40',1),
 (22,'2024-05-03 03:44:48.728229',31,'Descripcion de prueba 41',13,1,'Prueba 41',3),
 (23,'2024-05-03 03:46:13.193481',31,'Descripcion de prueba 1 IFTS 1',13,2,'Prueba 1 de IFTS 1',4),
 (24,'2024-05-03 04:11:20.232914',31,'Descripcion de prueba 20',13,3,'Prueba ifts2',4),
 (25,'2024-05-03 04:20:56.401781',31,'Descripcion de prueba 11',13,1,'Mi IFTS',1),
 (27,'2024-05-15 17:22:37.120598',31,'Descripcion de prueba traba',13,1,'Prueba traba',4),
 (28,'2024-05-20 20:21:09.999646',31,'Descripcion de prueba MEREKETENGUE',13,1,'Prueba mereketengue',5);

INSERT INTO "carrera_carrera" ("id","duracion","institucion_id","nombre","img_perfil") VALUES (1,3600,1,'Técnico Superior en Desarrollo de Software','perfiles/carrera_uploads/DesarrolloSoft.jpg'),
 (2,3600,1,'Técnico Superior en Análisis de Sistemas','perfiles/carrera_uploads/AnalisisSistema2.jpg'),
 (3,3600,1,'Técnico Superior en Ciencia de Datos e Inteligencia Artificial','perfiles/carrera_uploads/CienciaDatos.jpg'),
 (4,2708,2,'Tecnicatura Superior En Seguros','perfiles/carrera_uploads/Abogacia2.jpeg'),
 (5,3600,3,'TÉCNICO SUPERIOR EN EMPRENDIMIENTOS GASTRONÓMICOS','perfiles/carrera_uploads/Gastronomia2.jpeg'),
 (6,3600,4,'Tecnicatura Superior en Administración de Empresas','perfiles/carrera_uploads/AdminEmpresas1.jpeg'),
 (7,3600,5,'Técnico Superior en Desarrollo de Software','perfiles/carrera_uploads/DesarrolloSoft_UrprqCZ.jpg'),
 (8,3600,5,'Técnico Superior en Analisis de Datos','perfiles/carrera_uploads/AnalisisSistema.jpg'),
 (9,3600,6,'Técnico Superior en Desarrollo de Software de Simuladores','perfiles/carrera_uploads/DesarrolloSoftwareSimuladores1.jpeg'),
 (10,3600,7,'Tecnico Superior en  Comercio Internacional y Aduanas','perfiles/carrera_uploads/Aduana1.jpeg'),
 (11,3600,6,'Tecnico Superior en Comercio Internacional','perfiles/carrera_uploads/Aduana3.jpeg'),
 (12,3600,6,'Técnico Superior en Comercialización','perfiles/carrera_uploads/Aduana2.jpeg'),
 (13,3600,6,'Técnico Superior en Analisis de Sistemas','perfiles/carrera_uploads/AnalisisSistema_NMoJSVo.jpg'),
 (14,3600,8,'Técnico Superior en Administración de Empresas','perfiles/carrera_uploads/AdminEmpresas2.jpeg'),
 (15,3600,8,'Técnico Superior en Administración de Servicios de Salud','perfiles/carrera_uploads/AdminEmpresas3.jpeg'),
 (16,3600,8,'Técnico Superior en Guía de Turismo con Especialización en CABA','perfiles/carrera_uploads/AdminEmpresas4.jpeg'),
 (17,3600,9,'Tecnicatura Superior en ADMINISTRACIÓN Y RELACIONES DEL TRABAJO','perfiles/carrera_uploads/AdminEmpresas1_ZJiCgcu.jpeg'),
 (18,3600,9,'Tecnicatura Superior en ADMINISTRACIÓN COMERCIAL','perfiles/carrera_uploads/AdminEmpresas2_duoRH0q.jpeg'),
 (19,3600,10,'Técnico Superior en Administración de Empresas','perfiles/carrera_uploads/AdminEmpresas3_m11dZ9g.jpeg'),
 (20,3600,10,'Técnico Superior en Administración y Relaciones del Trabajo','perfiles/carrera_uploads/AdminEmpresas4_cG6zs9q.jpeg'),
 (21,3600,10,'Técnico Superior en Administración','perfiles/carrera_uploads/AdminEmpresas1_3keq0i7.jpeg');

INSERT INTO "feedback_emaillog" ("id","timestamp","user_id") VALUES (1,'2024-05-16 02:07:32.520080',31),
 (2,'2024-05-16 02:07:56.573048',31),
 (3,'2024-05-16 02:48:52.427300',1),
 (4,'2024-05-19 17:22:38.021095',31),
 (5,'2024-05-19 17:23:33.228165',31),
 (6,'2024-05-27 18:32:11.418261',31);

INSERT INTO "socialaccount_socialapp" ("id","provider","name","client_id","secret","key","provider_id","settings") VALUES (1,'google','Google Auth','1009220251212-nkro9apnh8d27brjpu37sq8v7lhr6cig.apps.googleusercontent.com','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','','','{}');

INSERT INTO "profesor_profesor_carrera" ("id","profesor_id","carrera_id") VALUES (1,12,1),
 (2,1,1),
 (4,3,1),
 (5,4,1),
 (6,5,1),
 (7,6,1),
 (8,7,1),
 (9,8,1),
 (10,9,1),
 (11,10,1),
 (12,11,1),
 (13,11,2),
 (14,13,1),
 (15,14,1),
 (16,15,1),
 (17,16,1);

INSERT INTO "profesor_profesor_institucion" ("id","profesor_id","institucion_id") VALUES (14,13,5),
 (18,1,18),
 (19,3,18),
 (20,4,18),
 (21,5,18),
 (22,6,18),
 (23,7,18),
 (24,8,18),
 (25,9,18),
 (26,10,18),
 (27,11,18),
 (28,12,18),
 (29,13,18),
 (30,14,18),
 (31,15,18),
 (32,16,18);

INSERT INTO "profesor_profesor" ("id","nombre","usuario_id","img_perfil") VALUES (1,'Virginia Russo',46,'perfiles/profesores_uploads/ProfesoraDefault_YuPJ2BL.jpeg'),
 (3,'Eduardo Iberti',10,'perfiles/profesores_uploads/ProfesorDefault_IxVtKRo.jpeg'),
 (4,'Juan Bonini',4,'perfiles/profesores_uploads/ProfesorDefault_tdCCN5A.jpeg'),
 (5,'Maria Ester',47,'perfiles/profesores_uploads/ProfesorDefault_NnESkMR.jpeg'),
 (6,'Alejandro González',48,'perfiles/profesores_uploads/ProfesorDefault_kQJXY0Z.jpeg'),
 (7,'Emanuel Odstrcil',49,'perfiles/profesores_uploads/ProfesorDefault_fYP2i69.jpeg'),
 (8,'Pablo Lencinas',50,'perfiles/Profesores/ProfesorDefault.jpeg'),
 (9,'Maria Laura',51,'perfiles/profesores_uploads/ProfesoraDefault_qpPUhLc.jpeg'),
 (10,'Martin Santoro',52,'perfiles/profesores_uploads/ProfesorDefault_f4w5Qt4.jpeg'),
 (11,'Alejandro Peña',9,'perfiles/profesores_uploads/ProfesorDefault_36Rt29v.jpeg'),
 (12,'Alberto Campagna',53,'perfiles/profesores_uploads/ProfesorDefault_yvoKlUu.jpeg'),
 (13,'Hernan Cunarro',54,'perfiles/Profesores/ProfesorDefault.jpeg'),
 (14,'Virginia Polcan',55,'perfiles/profesores_uploads/ProfesoraDefault_7j7H9H5.jpeg'),
 (15,'Esteban Fassio',56,'perfiles/profesores_uploads/ProfesorDefault_1Q9y2wM.jpeg'),
 (16,'Carlos Quinteros',60,'perfiles/profesores_uploads/ProfesorDefault_WCJB4GV.jpeg');

INSERT INTO "custom_user_customuser" ("id","password","last_login","is_superuser","nombre","email","descripcion","is_active","is_staff","tipo_usuario","genero","institucion","fecha_de_nacimiento","img_perfil") VALUES (1,'pbkdf2_sha256$720000$W2lseZgl8HQJkzDPvgjsrS$o9CT1HAelf/mv4gBCfG/bDUK242nZy5EmVCY6fevgGM=','2024-05-27 21:32:19.102782',1,'admin','admin@gmail.com','El verdadero ADMIN',1,1,'Alumno','M','IFTS N°18','1997-09-04','perfiles/user_uploads/AureWP4K.jpeg'),
 (2,'ifts18','2023-11-10 22:13:17',0,'IFTS 18','dfts_ifts18_de2@bue.edu.ar','Email de la institucion',1,0,'Institución',NULL,NULL,NULL,'perfiles/Captura_de_pantalla_2023-11-10_191621.png'),
 (4,'juanBonini',NULL,0,'Juan Bonini','juanB@gmail.com','Profesor Backend',1,0,'Profesor',NULL,NULL,NULL,''),
 (5,'admin',NULL,0,'IFTS 1','ifts1@gmail.com','IFTS N1',1,0,'Institución',NULL,NULL,NULL,'perfiles/Captura_de_pantalla_2023-11-11_182058.png'),
 (6,'admin',NULL,0,'IFTS 2','ifts2@gmail.com','IFTS N2',1,0,'Institución',NULL,NULL,NULL,'perfiles/Captura_de_pantalla_2023-11-11_185255.png'),
 (7,'admin',NULL,0,'IFTS 3','ifts3@gmail.com','IFTS N3',1,0,'Institución',NULL,NULL,NULL,'perfiles/Captura_de_pantalla_2023-11-11_184124.png'),
 (9,'admin',NULL,0,'Alejandro Peña','alepena@gmail.com','Profesor de Cloud',1,0,'Profesor',NULL,NULL,NULL,''),
 (10,'admin',NULL,0,'Eduardo Iberti','eduIberti@gmail.com','Profesor de Frontend',1,0,'Profesor',NULL,NULL,NULL,''),
 (22,'rengar123',NULL,0,'Rengar','borra@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'perfiles/perfil3.jpg'),
 (23,'kayn123',NULL,0,'Kayn','asdf@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'perfiles/perfil2.jpg'),
 (24,'picapiedra123','2024-04-14 12:58:54.414415',0,'Pedro','borra4@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'perfiles/mecha-galiol.jpg'),
 (25,'riven123','2024-04-09 20:51:42.626464',0,'Riven','borra5@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'perfiles/perfil1.jpg'),
 (26,'jhin123','2024-04-12 18:50:33.695364',0,'Jhin','borra6@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'perfiles/JhinVertical.jpg'),
 (30,'pbkdf2_sha256$720000$g3qjXSW4exANNJpYxQ3lfR$CN0+o3girqFTPpAJdNAA/ePEiR4bdZgeAw2j7TCnASc=','2024-04-18 04:10:19.246033',0,'TesteoFront','borra10@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'perfiles/perfil4_PpBPmKe.jpg'),
 (31,'pbkdf2_sha256$720000$xQPqrgP44aP0HXtYNJ5UOs$SpO3PSdRdFRe59gptUjYOuMbMLwSIS4LrslYcRXp30A=','2024-05-27 20:44:21.648179',0,'Galio','borra01@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'perfiles/user_uploads/mecha-galiol.jpg'),
 (32,'Ifts-n4',NULL,0,'I.F.T.S N°4','bedelesifts4@gmail.com','',1,0,'Institución','O','IFTS N°4',NULL,'perfiles/IFTS-N4.png'),
 (33,'Ifts-n5',NULL,0,'I.F.T.S N°5','ifts5@gmail.com','',1,0,'Institución','O','IFTS N°5',NULL,'perfiles/IFTS-N5.png'),
 (34,'IftsN6',NULL,0,'I.F.T.S N°6','ifts6@gmail.edu.ar','',1,0,'Institución','O','IFTS N°6',NULL,'perfiles/IFTS-N6.png'),
 (35,'IftsN7',NULL,0,'IFTS N°7','ifts7@gmail.edu.ar','',1,0,'Institución','O','IFTS N°7',NULL,'perfiles/IFTS-N7.png'),
 (36,'Ifts-n8',NULL,0,'IFTS N°8','ifts8@gmail.edu.ar','',1,0,'Institución','O','IFTS N°8',NULL,'perfiles/IFTS-N8.png'),
 (37,'Ifts-n9',NULL,0,'IFTS N°9','ifts9@gmail.edu.ar','',1,0,'Institución','O','IFTS N°9',NULL,'perfiles/IFTS-N9.jpeg'),
 (38,'Ifts-n10',NULL,0,'IFTS N°10','ifts10@gmail.edu.ar','',1,0,'Institución','O','IFTS N°10',NULL,'perfiles/IFTS-N10.png'),
 (39,'Ifts-n11',NULL,0,'IFTS N°11','ifts11@gmail.edu.ar','',1,0,'Institución','O','IFTS N°11',NULL,'perfiles/IFTS-N11.jpeg'),
 (40,'Ifts-n12',NULL,0,'IFTS N°12','ifts12@gmail.com','',1,0,'Institución','O','IFTS N°12',NULL,'perfiles/IFTS-N12.jpeg'),
 (41,'Ifts-n13',NULL,0,'IFTS N°13','ifts13@gmail.edu.ar','',1,0,'Institución','O','IFTS N°13',NULL,'perfiles/IFTS-N13.png'),
 (42,'Ifts-n14',NULL,0,'IFTS N°14','bedelia.ifts14@bue.edu.ar','',1,0,'Institución','O','IFTS N°14',NULL,'perfiles/IFTS-N14.png'),
 (43,'Ifts-n15',NULL,0,'IFTS N°15','ifts15@gmail.edu.ar','',1,0,'Institución','O','IFTS N°15',NULL,'perfiles/IFTS-N15.jpg'),
 (44,'Ifts-n16',NULL,0,'IFTS N°16','DFTS_IFTS16_DE21@BUE.EDU.AR','',1,0,'Institución','O','IFTS N°16',NULL,'perfiles/IFTS-N16.png'),
 (45,'Ifts-n17',NULL,0,'IFTS N°17','tecnicatura@agip.gov.ar','',1,0,'Institución','O','IFTS N°17',NULL,'perfiles/IFTS-N17.png'),
 (46,'virgi18',NULL,0,'Virginia Russo','vir_russo18@gmail.com','',1,0,'Profesor','F','IFTS N°18','1980-09-04','UserProfile.png'),
 (47,'Maria18',NULL,0,'Maria Ester','maria.e.18@gmail.com','',1,0,'Profesor','F','IFTS N°18','1970-09-04','UserProfile.png'),
 (48,'alejandro18',NULL,0,'Alejandro Gonzales','ale.gon.18@gmail.com','',1,0,'Profesor','M','IFTS N°18','1970-09-04','UserProfile.png'),
 (49,'Emanuel18',NULL,0,'Emanuel Odstrcil','ema.od.18@gmail.com','',1,0,'Profesor','M','IFTS N°18','1990-09-04','UserProfile.png'),
 (50,'PabloLencinas18',NULL,0,'Pablo Lencinas','pablo.len.18@gmail.com','',1,0,'Profesor','M','IFTS N°18','1990-09-04','UserProfile.png'),
 (51,'MariaLaura18',NULL,0,'Maria Gabrielli','maria.lau.18@gmail.com','',1,0,'Profesor','F','IFTS N°18','1970-09-04','UserProfile.png'),
 (52,'MartinSantoro18',NULL,0,'Martin Santoro','martin.san.18@gmail.com','',1,0,'Profesor','M','IFTS N°18','1980-09-04','UserProfile.png'),
 (53,'Alberto18',NULL,0,'Alberto Campagna','alberto.camp.18@gmail.com','',1,0,'Profesor','M','IFTS N°18','1990-09-04','UserProfile.png'),
 (54,'Hernan18',NULL,0,'Hernan Cunarro','hernan.cun.18@gmail.com','',1,0,'Profesor','M','IFTS N°18','1980-09-04','UserProfile.png'),
 (55,'Virginia18',NULL,0,'Virginia Polcan','virgi.pol@gmail.com','',1,0,'Profesor','F','IFTS N°18','1980-09-04','UserProfile.png'),
 (56,'Esteban18',NULL,0,'Esteban Fassio','esteban.fass@gmail.com','',1,0,'Profesor','M','IFTS N°18','1990-09-04','UserProfile.png'),
 (57,'pbkdf2_sha256$720000$yMJT9GMqksxZgnK6LB48rW$8H6x3zkL+ViqhMJNQ3Z+JqLTSHfiqxh/TvvUYL+2c/E=','2024-05-13 06:59:12.814930',0,'JULIAN YOEL','JUYOELF@GMAIL.COM',NULL,1,0,'Alumno','O',NULL,NULL,'perfiles/Designer_13.jpeg'),
 (58,'pbkdf2_sha256$720000$tYNkn6DLvjAMqJkZ8xWlSL$HuhdQOqyh5C8GnBVoiNK/CQ+ikhlBXquS9ei51jFSuw=','2024-05-17 02:53:58.623923',0,'Mauro Duarte','m.e.b.d.0904@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'user_uploads/perfil3.jpg'),
 (59,'pbkdf2_sha256$720000$4r0873KO38jNA2lS0PdCfV$EUTRpdvXJUQIMyXZGlCxf7l3+tFbLKl0fD0a0zY+VOE=','2024-05-18 22:41:01.409291',0,'Nico','nico.garofalo98@gmail.com',NULL,1,0,'Alumno','O',NULL,NULL,'user_uploads/AureWP4K.jpeg'),
 (60,'Carlos18',NULL,0,'Carlos Quintero','carlos_quintero18@gmail.com','',1,0,'Profesor','M','IFTS N°18',NULL,'user_uploads/ProfesorDefault.jpeg');

INSERT INTO "institucion_institucion" ("id","nombre","url","usuario_id","direccion","coordenadas","img_perfil") VALUES (1,'IFTS N°1','https://www.ifts1.com.ar/',5,'Argentina, San Martín 665','-34.59986456275021, -58.373725936800504','perfiles/ifts_uploads/IFTS-N1.png'),
 (2,'IFTS N°2','https://sites.google.com/bue.edu.ar/ifts-2-de-20/',6,'Argentina, Cañada de Gómez 3850','-34.67556845838067, -58.486664642350334','perfiles/ifts_uploads/IFTS-N2.png'),
 (3,'IFTS N°3','https://aulasvirtuales.bue.edu.ar/course/index.php?categoryid=1423&browse=courses&perpage=20&page=0',7,'Argentina, Carranza 2045','-34.57959687076112, -58.434981757822435','perfiles/ifts_uploads/IFTS-N3.png'),
 (4,'IFTS N°4','https://ifts4buenosaires.blogspot.com/',32,'Argentina,Murguiondo 2105, Mataderos','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N4.png'),
 (5,'IFTS N°5','https://ifts5.com.ar/',33,'Argentina, Dragones 2201, Belgrano, CABA.','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N5.png'),
 (6,'IFTS N°6','http://www.ifts6.edu.ar/',34,'Argentina, Av. Paseo Colón 650 C1063ACT, B1704ACT Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N6.png'),
 (7,'IFTS N°7','http://www.ifts7.com.ar/',35,'Argentina, Av. Gaona 1502, C1406 Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N7.png'),
 (8,'IFTS N°8','https://sites.google.com/a/bue.edu.ar/ifts8-instituto-de-formacion-tecnica-superior',36,'Argentina, Av. Rivadavia 1453 1° piso, C1033 Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N8.png'),
 (9,'IFTS N°9','http://ifts9.com/',37,'Argentina, Rodríguez Peña 747, C1020ADO Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N9.jpeg'),
 (10,'IFTS N°10','http://www.ifts10.com/',38,'Argentina, ABB, Av. Entre Ríos 757, C1080 Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N10.png'),
 (11,'IFTS N°11','https://www.ifts11.com/wp/#page-content',39,'Argentina, Zavaleta 204 - Parque Patricios','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N12.jpeg'),
 (12,'IFTS N°12','https://ifts12online.com.ar/IFTS_12/index.html#home',40,'Argentina, Av. Belgrano 637, CABA','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N12_XiH2I4K.jpeg'),
 (13,'IFTS N°13','http://ifts13.blog/',41,'Argentina, Av. Juan Bautista Alberdi 163, C1424 Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N13.png'),
 (14,'IFTS N°14','https://www.ifts14.com.ar/',42,'Argentina, Juncal 1258, C1062 Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N14.png'),
 (15,'IFTS N°15','https://instituto15.com.ar/',43,'Argentina, Avda. Pte, Av. Pres. Figueroa Alcorta 2977, 1425 Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N15.jpg'),
 (16,'IFTS N°16','https://ifts16.com/',44,'Argentina, Teodoro García 3899, C1427ECG Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N16.png'),
 (17,'IFTS N°17','https://www.ifts17.edu.ar/index.php',45,'Argentina, Viamonte 872 3° Piso, C1053 Cdad. Autónoma de Buenos Aires','-34.603722,-58.381592','perfiles/ifts_uploads/IFTS-N17.png'),
 (18,'IFTS N°18','https://www.ifts18.edu.ar/',2,'Argentina, Mansilla 3643','-34.590623320961, -58.41491043083828','perfiles/ifts_uploads/IFTS-N18.png'),
 (19,'IFTS N°19','https://www.ifts18.edu.ar/',2,'Gral. Lucio Norberto Mansilla 3643, C1425BPW Cdad. Autónoma de Buenos Aires','-34.59071805727445, -58.41488837818409','ifts_uploads/IFTS-N18.png');

CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "custom_user_customuser_groups_customuser_id_group_id_56311c69_uniq" ON "custom_user_customuser_groups" (
	"customuser_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "custom_user_customuser_groups_customuser_id_39e4b4a7" ON "custom_user_customuser_groups" (
	"customuser_id"
);
CREATE INDEX IF NOT EXISTS "custom_user_customuser_groups_group_id_bdb860ae" ON "custom_user_customuser_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "custom_user_customuser_user_permissions_customuser_id_permission_id_797be134_uniq" ON "custom_user_customuser_user_permissions" (
	"customuser_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "custom_user_customuser_user_permissions_customuser_id_e46769ac" ON "custom_user_customuser_user_permissions" (
	"customuser_id"
);
CREATE INDEX IF NOT EXISTS "custom_user_customuser_user_permissions_permission_id_7d0938cd" ON "custom_user_customuser_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "alumno_alumno_fk_id_carrera_id_afed7e2d" ON "alumno_alumno" (
	"fk_id_carrera_id"
);
CREATE INDEX IF NOT EXISTS "alumno_alumno_fk_id_usuario_id_b8748fa3" ON "alumno_alumno" (
	"fk_id_usuario_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "carrera_votacioncarrera_carrera_id_67e72c77" ON "carrera_votacioncarrera" (
	"carrera_id"
);
CREATE INDEX IF NOT EXISTS "carrera_votacioncarrera_usuario_id_4708f886" ON "carrera_votacioncarrera" (
	"usuario_id"
);
CREATE INDEX IF NOT EXISTS "materia_votacionmateria_materia_id_45880b08" ON "materia_votacionmateria" (
	"materia_id"
);
CREATE INDEX IF NOT EXISTS "materia_votacionmateria_usuario_id_ca8959e1" ON "materia_votacionmateria" (
	"usuario_id"
);
CREATE INDEX IF NOT EXISTS "feedback_feedback_user_id_f7dd5014" ON "feedback_feedback" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "cursada_cursada_materia_id_4ea98fd5" ON "cursada_cursada" (
	"materia_id"
);
CREATE INDEX IF NOT EXISTS "cursada_cursada_profesor_id_35ed1f77" ON "cursada_cursada" (
	"profesor_id"
);
CREATE INDEX IF NOT EXISTS "materia_materia_carrera_id_8886d6fd" ON "materia_materia" (
	"carrera_id"
);
CREATE INDEX IF NOT EXISTS "opinion_opinion_autor_id_4dc7eba8" ON "opinion_opinion" (
	"autor_id"
);
CREATE INDEX IF NOT EXISTS "opinion_opinion_content_type_id_6a075048" ON "opinion_opinion" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "carrera_carrera_institucion_id_d0b38696" ON "carrera_carrera" (
	"institucion_id"
);
CREATE INDEX IF NOT EXISTS "feedback_emaillog_user_id_54f85cc5" ON "feedback_emaillog" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "account_emailconfirmation_email_address_id_5b7f8c58" ON "account_emailconfirmation" (
	"email_address_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "account_emailaddress_user_id_email_987c8728_uniq" ON "account_emailaddress" (
	"user_id",
	"email"
);
CREATE UNIQUE INDEX IF NOT EXISTS "unique_verified_email" ON "account_emailaddress" (
	"email"
) WHERE "verified";
CREATE INDEX IF NOT EXISTS "account_emailaddress_user_id_2c513194" ON "account_emailaddress" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "account_emailaddress_upper" ON "account_emailaddress" (
	(UPPER("email"))
);
CREATE UNIQUE INDEX IF NOT EXISTS "socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq" ON "socialaccount_socialtoken" (
	"app_id",
	"account_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialtoken_account_id_951f210e" ON "socialaccount_socialtoken" (
	"account_id"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialtoken_app_id_636a42d7" ON "socialaccount_socialtoken" (
	"app_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "socialaccount_socialaccount_provider_uid_fc810c6e_uniq" ON "socialaccount_socialaccount" (
	"provider",
	"uid"
);
CREATE INDEX IF NOT EXISTS "socialaccount_socialaccount_user_id_8146e70c" ON "socialaccount_socialaccount" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "materia_materia_profesor_id_47a8b1c5" ON "materia_materia" (
	"profesor_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "profesor_profesor_carrera_profesor_id_carrera_id_92006a91_uniq" ON "profesor_profesor_carrera" (
	"profesor_id",
	"carrera_id"
);
CREATE INDEX IF NOT EXISTS "profesor_profesor_carrera_profesor_id_90f4686c" ON "profesor_profesor_carrera" (
	"profesor_id"
);
CREATE INDEX IF NOT EXISTS "profesor_profesor_carrera_carrera_id_ddaa0ba6" ON "profesor_profesor_carrera" (
	"carrera_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "profesor_profesor_institucion_profesor_id_institucion_id_c91b0ea3_uniq" ON "profesor_profesor_institucion" (
	"profesor_id",
	"institucion_id"
);
CREATE INDEX IF NOT EXISTS "profesor_profesor_institucion_profesor_id_7c8fb4a4" ON "profesor_profesor_institucion" (
	"profesor_id"
);
CREATE INDEX IF NOT EXISTS "profesor_profesor_institucion_institucion_id_769516ba" ON "profesor_profesor_institucion" (
	"institucion_id"
);
CREATE INDEX IF NOT EXISTS "profesor_profesor_usuario_id_ac9badb3" ON "profesor_profesor" (
	"usuario_id"
);
CREATE INDEX IF NOT EXISTS "institucion_institucion_usuario_id_432cdb61" ON "institucion_institucion" (
	"usuario_id"
);
COMMIT;
