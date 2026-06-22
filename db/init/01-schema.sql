-- Primer esquema de mk1 
-- Compatible con prisma

-- Poder iniciar sesión con discord o con contraseña + contraseña
-- poder exportar whitelist >:D
-- Muchas cosas odio sql watefok

-- *************SEPARADOR*************

-- Extensiones que harán falta 
CREATE EXTENSION IF NOT EXISTS "pgcrypto"; -- con esto tenemos la función gen_random_uuid() para generar ids únicos
CREATE EXTENSION IF NOT EXISTS "citext"; -- con esto tenemos el tipo de dato citext, que es como text pero case insensitive, para los correos

-- *************
-- Tabla de usuario (users)
-- Cuenta en la web, con Rol Global (user/admin/owner)
-- El rol de jugador es un rol por servidor, no global, así que no va aquí saludos
-- Login por discord o con correo + contraseña
-- **************
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username VARCHAR(32) NOT NULL UNIQUE, -- nick visible en la web
  email CITEXT, -- opcional, si se loguea con discord no hace falta
  password_hash TEXT, -- hash de la contraseña, si se loguea con discord no hace falta
  rol VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (rol IN ('user', 'admin', 'owner')),
  minecraft_username VARCHAR(100) UNIQUE,

-- LOGIN por discord
  discord_id VARCHAR(64),
  discord_tag VARCHAR(64),

-- Redes sociales 
instagram VARCHAR(64),
twitter VARCHAR(64),

-- sft delete, no quiero eliminarlo del todo, solo marcarlo como eliminado
deleted_at TIMESTAMPTZ,

created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

-- Un metodo de acceso minimo jeje
CONSTRAINT users_has_login CHECK (email IS NOT NULL OR discord_id IS NOT NULL)
);

CREATE UNIQUE INDEX idx_users_email ON users(email) WHERE email IS NOT NULL;
CREATE UNIQUE INDEX idx_users_discord_id ON users(discord_id) WHERE discord_id IS NOT NULL;
CREATE INDEX idx_users_rol ON users(rol);
CREATE INDEX idx_users_minecraft ON users(minecraft_username);
CREATE INDEX idx_users_deleted_at ON users(deleted_at);

-- *************
-- Tabla de temporadas
-- Una fila por temporada
-- Seria la pagina hub (?) 
-- Solo lo que sea publico
-- **************
CREATE TABLE temporadas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  numero SMALLINT NOT NULL UNIQUE, -- numero de temporada
  nombre VARCHAR(64) NOT NULL, -- nombre de temporada
  subtitulo VARCHAR(128),
  status VARCHAR(12) NOT NULL DEFAULT 'proximamente' CHECK (status IN ('proximamente', 'activa', 'inactiva', 'archivada')), -- status de temporada, proximamente, activa o archivada
  year SMALLINT,
  open_date TIMESTAMPTZ, -- fecha de apertura de temporada
  description TEXT, -- texto cortito introductorio


  requires_character_sheet BOOLEAN NOT NULL DEFAULT FALSE, -- para ver si hace falta ficha de pj

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- *************
-- Tabla de configuración de temporada (season_server_configs)
-- Config técnica 
-- **************
CREATE TABLE season_server_configs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  temporada_id UUID NOT NULL REFERENCES temporadas(id) ON DELETE CASCADE, -- id de temporada, para saber a que temporada pertenece esta config
  server_ip VARCHAR(128), -- ip del servidor bloqueada, pero si el user es jugador, web lo muestra
  server_port SMALLINT DEFAULT 25565, 
  modpack_url TEXT,
  modpack_version VARCHAR(32),
  forge_version VARCHAR(32),

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- *************
-- Tabla de los perfiles de jugador
-- Los jugadores aprobados por temporada
-- Existen si tienen el status en approved 
-- pa algo está el candadito 
-- Se crea al aprobar un acces_request o si tiene badge de amiwi
-- Las temporadas sin ficha de pj tienen perfil igual, la tabla queda vacía
-- los admins pueden crear personajes y vincularlos a un jugador
-- **************
CREATE TABLE perfil_jugador (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  temporada_id UUID NOT NULL REFERENCES temporadas(id) ON DELETE CASCADE, -- id de temporada, para saber a que temporada pertenece este perfil
  user_id UUID REFERENCES users(id) ON DELETE SET NULL, 
  status VARCHAR(12) NOT NULL DEFAULT 'pendiente' CHECK (status IN ('pendiente', 'aprobado', 'rechazado')), 

  -- Ficha de personaje
  nombre_pj VARCHAR(64),
  edad_pj SMALLINT,
  pj_who TEXT,
  historia_pj TEXT,
  faccion_pj VARCHAR(64),
  raza_pj VARCHAR(64),
  clase_pj VARCHAR(64),
  pregunta_random TEXT,

  aprobado_por UUID REFERENCES users(id) ON DELETE SET NULL, -- id del admin que aprobo el perfil
  aprobado_en TIMESTAMPTZ, -- fecha de aprobacion

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  deleted_at TIMESTAMPTZ -- para soft delete, no quiero eliminarlo del todo, solo marcarlo como eliminado
);

CREATE INDEX idx_pp_temporada ON perfil_jugador(temporada_id);
CREATE INDEX idx_pp_user ON perfil_jugador(user_id);
CREATE INDEX idx_pp_status ON perfil_jugador(status);
CREATE INDEX idx_pp_minecraft ON perfil_jugador(minecraft_username);
CREATE UNIQUE INDEX idx_pp_unico_activo ON perfil_jugador(temporada_id, user_id) WHERE deleted_at IS NULL;

-- *************
-- Tabla de solicitudes de acceso (access_requests)
-- Bandeja de solicitudes god
-- Al aprobarse el backend crea un perfil de jugador, si la temporada tiene ficha de pj
-- **************
CREATE TABLE access_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  temporada_id UUID REFERENCES temporadas(id) ON DELETE CASCADE, 
  tipo_solicitud VARCHAR(12) NOT NULL DEFAULT 'temporada' CHECK (tipo_solicitud IN ('temporada', 'discord')),
  status VARCHAR(12) NOT NULL DEFAULT 'pendiente' CHECK (status IN ('pendiente', 'aprobado', 'rechazado')), 

-- Datos del solicitante
  motivacion TEXT,
  how_found TEXT,
  recomendado_por VARCHAR(128),
  is_adult BOOLEAN, -- si es menor, pa queeeeeeeeee (no se guarda la edad por dios)

-- Admin
  revisado_por UUID REFERENCES users(id) ON DELETE SET NULL, 
  revisado_en TIMESTAMPTZ, 
  motivo_rechazo TEXT,

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_ar_pendientes ON access_requests(user_id, temporada_id) WHERE status = 'pendiente';
CREATE INDEX idx_ar_estado ON access_requests(status);

-- *************
-- Tabla de las badges y badges de usuario >:D
-- Las badges son medallitas como logros y cosas chulis
-- Amiwi tiene grant_access=true y se salta la bandeja de solicitudes
-- pero no la de pjs
-- **************
CREATE TABLE badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre VARCHAR(64) NOT NULL UNIQUE,
  descripcion TEXT,
  icono VARCHAR(500),
  color VARCHAR(7),

  grant_access BOOLEAN NOT NULL DEFAULT false, 
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW() 
);

CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
  granted_by UUID REFERENCES users(id) ON DELETE SET NULL, 
  granted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  UNIQUE(user_id, badge_id)
);

CREATE INDEX idx_ub_user ON user_badges(user_id);
CREATE INDEX idx_ub_badge ON user_badges(badge_id);

-- Que asco dan las bases de datos estoy al limite ya joder

-- *************
-- Tabla de los creditos por temporada y creditos externos
-- Apartado equipo god
-- **************
CREATE TABLE creditos_temporada (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  temporada_id UUID NOT NULL REFERENCES temporadas(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  rol VARCHAR(64) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE(temporada_id, user_id, rol)
);

CREATE TABLE creditos_externos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  temporada_id UUID NOT NULL REFERENCES temporadas(id) ON DELETE CASCADE,
  nombre VARCHAR(64) NOT NULL,
  rol VARCHAR(64) NOT NULL,
  link TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- *************
-- Funcion: check_season_access
-- Puede ver IP + modpack de la temporada?
-- si es admin, owner o player profile si, el resto la mama
-- **************
CREATE OR REPLACE FUNCTION check_season_access(p_user_id UUID, p_temporada_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  v_rol VARCHAR(20);
BEGIN
 SELECT rol INTO v_rol FROM users WHERE id = p_user_id AND deleted_at IS NULL;
  IF v_rol IS NULL THEN
    RETURN FALSE; -- Usuario no encontrado o eliminado
    END IF;

  IF v_rol IN ('admin', 'owner') THEN
    RETURN TRUE; -- Admins y owners tienen acceso
  END IF;

  RETURN EXISTS (
    SELECT 1
    FROM perfil_jugador
    WHERE user_id = p_user_id 
      AND temporada_id = p_temporada_id 
      AND status = 'aprobado'
      AND deleted_at IS NULL
  );

END;
$$ LANGUAGE plpgsql;

-- *************
-- Vista para exportar la whitelist de la temporada
-- **************
CREATE VIEW export_whitelist AS
SELECT u.minecraft_username AS name, s.slug AS season
FROM perfil_jugador pj
JOIN users u ON u.id = pj.user_id
JOIN temporadas s ON s.id = pj.temporada_id
WHERE pj.status = 'aprobado'
 AND s.status = 'activa'
 AND u.minecraft_username IS NOT NULL
 AND u.deleted_at IS NULL
 AND pj.deleted_at IS NULL;