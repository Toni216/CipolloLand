-- Adminer 5.5.0 PostgreSQL 16.14 dump

DROP TABLE IF EXISTS "access_requests";
CREATE TABLE "public"."access_requests" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "user_id" uuid,
    "temporada_id" uuid,
    "tipo_solicitud" character varying(12) DEFAULT 'temporada' NOT NULL,
    "status" character varying(12) DEFAULT 'pendiente' NOT NULL,
    "motivacion" text,
    "how_found" text,
    "recomendado_por" character varying(128),
    "is_adult" boolean,
    "revisado_por" uuid,
    "revisado_en" timestamptz,
    "motivo_rechazo" text,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "updated_at" timestamptz DEFAULT now() NOT NULL,
    "slots_permitidos" smallint DEFAULT '1' NOT NULL,
    CONSTRAINT "access_requests_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "access_requests_tipo_solicitud_check" CHECK ((((tipo_solicitud)::text = ANY ((ARRAY['temporada'::character varying, 'discord'::character varying])::text[])))),
    CONSTRAINT "access_requests_status_check" CHECK ((((status)::text = ANY ((ARRAY['pendiente'::character varying, 'aprobado'::character varying, 'rechazado'::character varying])::text[]))))
)
WITH (oids = false);

CREATE UNIQUE INDEX idx_ar_pendientes ON public.access_requests USING btree (user_id, temporada_id) WHERE ((status)::text = 'pendiente'::text);

CREATE INDEX idx_ar_estado ON public.access_requests USING btree (status);

INSERT INTO "access_requests" ("id", "user_id", "temporada_id", "tipo_solicitud", "status", "motivacion", "how_found", "recomendado_por", "is_adult", "revisado_por", "revisado_en", "motivo_rechazo", "created_at", "updated_at", "slots_permitidos") VALUES
('ddf97290-4f2a-4349-9094-2cc36bb6ab9a',	'c3a9d945-7cf7-4a49-bf80-59fda9c50006',	'72930467-3881-462d-b121-81b491e6c414',	'temporada',	'aprobado',	'Pues me llama mucho la atención saludos.',	'Soy yo',	'Toni joderrrrrrr',	'1',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'2026-07-19 01:06:49.578641+00',	NULL,	'2026-07-19 00:58:12.632806+00',	'2026-07-19 00:58:12.632806+00',	1),
('460dd5cc-ce10-4e7e-9b96-3d99004ba7c5',	'2e14275a-5146-4d84-8a77-b58898c0ef15',	'72930467-3881-462d-b121-81b491e6c414',	'temporada',	'aprobado',	'Porq estoy loco',	'Hola',	'Saludos',	'1',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'2026-07-19 12:26:25.069986+00',	NULL,	'2026-07-19 12:25:32.417477+00',	'2026-07-19 12:25:32.417477+00',	1),
('0693d879-7e65-43b7-8167-074238689f9d',	'8a86faac-9d84-4248-8328-eb939255a719',	'72930467-3881-462d-b121-81b491e6c414',	'temporada',	'aprobado',	'asdasdad',	'azsdasdasd',	'asdasdasd',	'1',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'2026-07-19 15:19:15.463472+00',	NULL,	'2026-07-19 15:18:02.609804+00',	'2026-07-19 15:18:02.609804+00',	1),
('2cd4faff-4171-4eb5-988c-9ca25adb8e5f',	'3c3ede51-7331-469b-b8b5-e75ed8127b4c',	'72930467-3881-462d-b121-81b491e6c414',	'temporada',	'aprobado',	'Soy apco',	'Paco',	'Toni',	'1',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'2026-07-19 15:55:28.490804+00',	NULL,	'2026-07-19 15:53:21.103549+00',	'2026-07-19 15:53:21.103549+00',	1);

DROP TABLE IF EXISTS "anuncios";
CREATE TABLE "public"."anuncios" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "temporada_id" uuid NOT NULL,
    "titulo" character varying(128) NOT NULL,
    "cuerpo" text NOT NULL,
    "autor_id" uuid,
    "pinned" boolean DEFAULT false NOT NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT "anuncios_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE INDEX idx_anuncios_temporada ON public.anuncios USING btree (temporada_id, created_at DESC);


DROP TABLE IF EXISTS "badges";
CREATE TABLE "public"."badges" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "nombre" character varying(64) NOT NULL,
    "descripcion" text,
    "icono" character varying(500),
    "color" character varying(7),
    "grant_access" boolean DEFAULT false NOT NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT "badges_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX badges_nombre_key ON public.badges USING btree (nombre);

INSERT INTO "badges" ("id", "nombre", "descripcion", "icono", "color", "grant_access", "created_at") VALUES
('0ecaa964-4ac5-4fa7-b08d-b2545c78c23b',	'Amiwi',	'Amigo bien guapo',	'🫂',	'#20B2AA',	'1',	'2026-07-18 01:54:17.217553+00'),
('fb9e02b9-da2f-4db9-af70-98bac3c56dc0',	'Admin',	'Admin bien duro',	'⚔️',	'#ff0000',	'1',	'2026-07-18 01:54:17.217553+00'),
('ee15812a-0497-4e03-b5ff-7f6dcaa3a06c',	'Donante',	'Ha donado al servidor',	'🏅',	'#ffd700',	0,	'2026-07-18 01:54:17.217553+00'),
('f56561aa-8bcf-439d-884c-de1400d4cb3c',	'Artista',	'Aporta arte y diseño visual al proyecto',	'🎨',	'#e07bc4',	0,	'2026-07-30 19:11:10.804975+00'),
('cbd03569-72ab-42f0-a367-a42e3b45570c',	'Narrador',	'Dirige tramas y eventos de rol',	'📜',	'#a67c52',	0,	'2026-07-30 19:11:10.804975+00'),
('45f9b2dc-5448-4ca5-b501-5ccdd8ec9fb7',	'Moderador',	'Miembro del equipo de moderación',	'🛡️',	'#5b8fc9',	0,	'2026-07-30 19:11:10.804975+00'),
('54bf1d5c-1438-4abc-9036-ad86de44f9ac',	'Fundador',	'Jugó en la primera temporada, CipolloLand 0',	'🏛️',	'#c9962a',	0,	'2026-07-30 19:11:10.804975+00'),
('f153eec6-b6f6-497a-9942-c2c490b746ce',	'Veterano',	'Ha jugado en 2 o más temporadas',	'⭐',	'#d4af37',	0,	'2026-07-30 19:11:10.804975+00'),
('9426e8c3-6d10-4645-99af-b670b9a2a063',	'Buena Pluma',	'Reconocido por el staff por la calidad de su rol',	'💬',	'#20B2AA',	0,	'2026-07-30 19:11:10.804975+00'),
('084dc9ee-a547-46bf-a64b-1237d769535d',	'Cazabugs',	'Reportó bugs importantes de la web',	'🐛',	'#7cb342',	0,	'2026-07-30 19:11:10.804975+00');

DROP TABLE IF EXISTS "creditos_externos";
CREATE TABLE "public"."creditos_externos" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "temporada_id" uuid NOT NULL,
    "nombre" character varying(64) NOT NULL,
    "rol" character varying(64) NOT NULL,
    "link" text,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT "creditos_externos_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


DROP TABLE IF EXISTS "creditos_temporada";
CREATE TABLE "public"."creditos_temporada" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "temporada_id" uuid NOT NULL,
    "user_id" uuid NOT NULL,
    "rol" character varying(64) NOT NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT "creditos_temporada_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX creditos_temporada_temporada_id_user_id_rol_key ON public.creditos_temporada USING btree (temporada_id, user_id, rol);


DROP TABLE IF EXISTS "estadisticas_jugador";
CREATE TABLE "public"."estadisticas_jugador" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "user_id" uuid,
    "temporada_id" uuid NOT NULL,
    "horas_jugadas" numeric(10,2) DEFAULT '0' NOT NULL,
    "kills" integer DEFAULT '0' NOT NULL,
    "muertes" integer DEFAULT '0' NOT NULL,
    "bloques_colocados" integer DEFAULT '0' NOT NULL,
    "bloques_rotos" integer DEFAULT '0' NOT NULL,
    "distancia_recorrida_km" numeric(10,2) DEFAULT '0' NOT NULL,
    "actualizado_en" timestamptz DEFAULT now() NOT NULL,
    "minecraft_username_pendiente" character varying(32),
    CONSTRAINT "estadisticas_jugador_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX estadisticas_jugador_user_id_temporada_id_key ON public.estadisticas_jugador USING btree (user_id, temporada_id);

CREATE UNIQUE INDEX idx_stats_pendiente_unico ON public.estadisticas_jugador USING btree (minecraft_username_pendiente, temporada_id) WHERE (user_id IS NULL);

INSERT INTO "estadisticas_jugador" ("id", "user_id", "temporada_id", "horas_jugadas", "kills", "muertes", "bloques_colocados", "bloques_rotos", "distancia_recorrida_km", "actualizado_en", "minecraft_username_pendiente") VALUES
('ed8ef5cd-04b3-41fd-8998-775723eac903',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'72930467-3881-462d-b121-81b491e6c414',	47.50,	128,	12,	3200,	4100,	18.70,	'2026-07-30 14:09:43.792961+00',	NULL),
('83093e1e-48b4-4d10-b518-7a014447d13b',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	151.00,	3802,	41,	0,	0,	0.00,	'2026-07-30 17:09:43.238142+00',	'Antoniomrm21'),
('40f941b0-a1d0-4e3d-9109-5d86f1ae0577',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	2.00,	17,	13,	0,	0,	0.00,	'2026-07-30 17:10:14.509655+00',	'mooonchisss'),
('da7f420c-7154-472f-8775-3850ef97c5a7',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	2.00,	18,	9,	0,	0,	0.00,	'2026-07-30 17:10:48.430651+00',	'clarajaegerr'),
('e2c2202b-31e2-481c-927d-24b5d0ef5317',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	6.00,	99,	7,	0,	0,	0.00,	'2026-07-30 17:11:16.831303+00',	'ZeZoJoserayo777'),
('5e6fdb16-ad72-4237-9e76-248238034c54',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	7.00,	76,	68,	0,	0,	0.00,	'2026-07-30 17:11:42.117599+00',	'SArdonix'),
('23bff023-f17e-4280-a73e-b21a491c26d4',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	26.00,	1351,	16,	0,	0,	0.00,	'2026-07-30 17:12:20.100586+00',	'dieguu08'),
('f3fdae5b-41b8-44a8-ba74-ed03602073f1',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	30.00,	450,	13,	0,	0,	0.00,	'2026-07-30 17:12:46.676704+00',	'UnFrikiMas'),
('02142c64-b14f-4a3e-aefa-3237d1254f17',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	34.00,	343,	36,	0,	0,	0.00,	'2026-07-30 17:13:11.122422+00',	'olivyts'),
('c04f6d9e-fd52-4d3b-84c2-1fa8bf8e7fb8',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	36.00,	2316,	26,	0,	0,	0.00,	'2026-07-30 17:13:45.473355+00',	'Feesar'),
('dfadcad4-4e38-4674-a45d-6af5cf100b9e',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	39.00,	544,	28,	0,	0,	0.00,	'2026-07-30 17:14:18.74385+00',	'Beja007'),
('f5a20bdb-2198-4a3f-b86f-8a3d31f4a870',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	40.00,	2194,	21,	0,	0,	0.00,	'2026-07-30 17:14:54.130596+00',	'Futuf_'),
('83c9801e-c87e-4370-9eab-bfc1eb2712bf',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	46.00,	971,	25,	0,	0,	0.00,	'2026-07-30 17:15:19.013359+00',	'Moonreah'),
('52323c54-b650-44ec-b1d2-166752d78d41',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	51.00,	2384,	85,	0,	0,	0.00,	'2026-07-30 17:15:41.430512+00',	'Kasuuki'),
('3dc932ad-0c26-4c05-b572-1736b4eb98a9',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	54.00,	3758,	29,	0,	0,	0.00,	'2026-07-30 17:16:38.229037+00',	'carletessky'),
('ad92c84f-2c65-4463-b002-37760ba0d95a',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	57.00,	2835,	17,	0,	0,	0.00,	'2026-07-30 17:17:13.047353+00',	'TheBlazex_05'),
('a05156bf-7325-4b6c-bc3d-b7d45c68e029',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	63.00,	3046,	12,	0,	0,	0.00,	'2026-07-30 17:18:09.499366+00',	'El_Puertas'),
('d0d218c2-6177-4ab6-a49d-6f99f3d03f4c',	NULL,	'52607b66-a0ad-43fc-97be-f684f3e8df4c',	91.00,	3593,	18,	0,	0,	0.00,	'2026-07-30 17:18:43.867736+00',	'MissRoci'),
('46d176c2-5083-4f36-bdbc-0f568b821105',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	57.52,	1062,	31,	32246,	21672,	193.55,	'2026-07-30 17:44:01.169053+00',	'Puneno'),
('a54c5697-7bba-4197-85d5-57e3bebb54d5',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	24.88,	411,	29,	12329,	8282,	152.31,	'2026-07-30 17:44:01.191315+00',	'mooonchisss'),
('f24100bb-88fe-4e99-b120-4562797359ff',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	30.32,	1772,	5,	12103,	8861,	173.80,	'2026-07-30 17:44:01.201945+00',	'Cordis73'),
('e525d8a1-9e67-4620-bdd5-02dcb398c5ea',	'3c3ede51-7331-469b-b8b5-e75ed8127b4c',	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	48.37,	2574,	37,	28433,	32399,	258.45,	'2026-07-30 17:44:01.210119+00',	NULL),
('b4df72c9-8ac6-4498-b7e7-89cb33aa71bb',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	82.50,	830,	99,	101415,	98114,	373.06,	'2026-07-30 17:44:01.218828+00',	'olivyts'),
('d7880941-07fd-42af-b81f-6126462a398b',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	29.28,	974,	30,	30960,	16978,	153.70,	'2026-07-30 17:44:01.225331+00',	'Kasuuki'),
('ce2e0df3-1348-46b8-a66c-8c47eb0d07a2',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	35.66,	740,	57,	18023,	14747,	219.49,	'2026-07-30 17:44:01.230848+00',	'UnFrikiMas'),
('3787f1b3-95ae-4c17-86cd-48ebcd520187',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	65.23,	2195,	71,	32778,	8526,	375.27,	'2026-07-30 17:44:01.235628+00',	'Beja007'),
('2d860e31-15d1-4f39-8881-2f329f75580e',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	39.65,	294,	33,	31689,	18095,	158.81,	'2026-07-30 17:44:01.248466+00',	'FranGarfu'),
('ad617476-b766-4cae-a084-73c81bb11e1c',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	33.40,	168,	70,	9845,	9392,	120.85,	'2026-07-30 17:44:01.257587+00',	'clarajaegerr'),
('37842ed4-bd3e-43f4-8a37-f9f1dd877fa3',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	21.85,	506,	29,	10649,	13795,	91.78,	'2026-07-30 17:44:01.266004+00',	'MissRoci'),
('0208f595-cde2-4d2e-a5f3-54a749d69c5f',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	33.91,	666,	10,	9974,	11829,	129.94,	'2026-07-30 17:44:01.274984+00',	'X_Depredador_X'),
('48192d20-4a72-4fca-945b-0f359fe21d40',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	2.22,	7,	5,	566,	499,	9.17,	'2026-07-30 17:44:01.28325+00',	'SArdonix'),
('702ef464-c3b4-4703-8bf3-15f5b9cf534e',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	36.17,	214,	39,	27552,	17664,	142.11,	'2026-07-30 17:44:01.293034+00',	'AlexFuentescine'),
('64db2d5c-9a07-49fe-8c46-2c71f39fda9c',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	51.96,	2702,	23,	22052,	10730,	357.33,	'2026-07-30 17:44:01.299855+00',	'Futuf_'),
('c8a7c693-9e5a-4e56-beb0-01e16465c41f',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	8.06,	232,	26,	3953,	4005,	33.40,	'2026-07-30 17:44:01.314771+00',	'dieguu08'),
('6f6c9774-2faf-42cc-8bda-732c1840b977',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	44.99,	1917,	55,	35659,	17895,	207.44,	'2026-07-30 17:44:01.31976+00',	'carletessky'),
('f37608f8-d3c2-4789-9969-045e6c012422',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	22.54,	454,	34,	16930,	12816,	93.95,	'2026-07-30 17:44:01.325316+00',	'afradeia'),
('b351b8fc-cbd9-4088-881a-ac898bb21645',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	80.11,	2753,	26,	35721,	16253,	439.43,	'2026-07-30 17:44:01.330635+00',	'El_Puertas'),
('caca98ca-cbf6-4365-8163-a3ac4fff98b2',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	46.55,	3975,	34,	17158,	6981,	225.32,	'2026-07-30 17:44:01.33648+00',	'TheBlazex_05'),
('9431e5b1-4f3d-42d0-8b7f-79bde7bbd984',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	33.00,	7,	0,	86995,	340,	17.11,	'2026-07-30 17:44:01.342094+00',	'Sebilicul'),
('ace505dc-189e-4222-892a-5b1341164ccc',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	23.30,	546,	57,	30870,	21776,	117.55,	'2026-07-30 17:44:01.347729+00',	'Moonreah'),
('805f5a50-b925-4a89-8d3c-091cfa40af83',	NULL,	'6fd8250a-0a1c-49e5-a154-2eb0265dce44',	147.28,	2672,	67,	66015,	46981,	284.15,	'2026-07-30 17:44:01.308673+00',	'Antoniomrm21');

DROP VIEW IF EXISTS "export_whitelist";
CREATE TABLE "export_whitelist" ("name" character varying(100), "season" character varying(16));


DROP TABLE IF EXISTS "perfil_jugador";
CREATE TABLE "public"."perfil_jugador" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "temporada_id" uuid NOT NULL,
    "user_id" uuid,
    "status" character varying(12) DEFAULT 'pendiente' NOT NULL,
    "nombre_pj" character varying(64),
    "edad_pj" smallint,
    "pj_who" text,
    "historia_pj" text,
    "faccion_pj" character varying(64),
    "raza_pj" character varying(64),
    "clase_pj" character varying(64),
    "pregunta_random" text,
    "aprobado_por" uuid,
    "aprobado_en" timestamptz,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "updated_at" timestamptz DEFAULT now() NOT NULL,
    "deleted_at" timestamptz,
    "es_npc" boolean DEFAULT false NOT NULL,
    "objetivos" text,
    "reaccion_peligro" text,
    "comida_favorita" character varying(128),
    "apodo_odiado" character varying(128),
    "detalles_publicos" boolean DEFAULT false NOT NULL,
    CONSTRAINT "perfil_jugador_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "perfil_jugador_status_check" CHECK ((((status)::text = ANY ((ARRAY['pendiente'::character varying, 'aprobado'::character varying, 'rechazado'::character varying])::text[]))))
)
WITH (oids = false);

CREATE INDEX idx_pp_temporada ON public.perfil_jugador USING btree (temporada_id);

CREATE INDEX idx_pp_user ON public.perfil_jugador USING btree (user_id);

CREATE INDEX idx_pp_status ON public.perfil_jugador USING btree (status);

CREATE INDEX idx_pp_user_temporada ON public.perfil_jugador USING btree (user_id, temporada_id) WHERE (deleted_at IS NULL);

INSERT INTO "perfil_jugador" ("id", "temporada_id", "user_id", "status", "nombre_pj", "edad_pj", "pj_who", "historia_pj", "faccion_pj", "raza_pj", "clase_pj", "pregunta_random", "aprobado_por", "aprobado_en", "created_at", "updated_at", "deleted_at", "es_npc", "objetivos", "reaccion_peligro", "comida_favorita", "apodo_odiado", "detalles_publicos") VALUES
('82c2bcd9-8fbb-43d9-89e0-2e57a09553bc',	'72930467-3881-462d-b121-81b491e6c414',	'c3a9d945-7cf7-4a49-bf80-59fda9c50006',	'aprobado',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-19 01:06:49.591296+00',	'2026-07-19 01:06:49.591296+00',	NULL,	0,	NULL,	NULL,	NULL,	NULL,	0),
('ddd33414-ffeb-40c0-9598-00fe73fbe46e',	'72930467-3881-462d-b121-81b491e6c414',	'2e14275a-5146-4d84-8a77-b58898c0ef15',	'aprobado',	'Paco',	26,	NULL,	NULL,	NULL,	'Gitana',	NULL,	NULL,	NULL,	NULL,	'2026-07-19 12:44:16.511012+00',	'2026-07-19 12:44:16.511012+00',	NULL,	0,	NULL,	NULL,	NULL,	NULL,	0),
('20ae1445-33f6-4de1-854b-07e9f2754607',	'72930467-3881-462d-b121-81b491e6c414',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'aprobado',	'gfhgh',	NULL,	'fhhfhfhfghfhf',	'asd',	'Protocolo Lázaro',	'Alien',	'Quimera',	NULL,	NULL,	NULL,	'2026-07-29 22:53:59.811466+00',	'2026-07-29 22:53:59.811466+00',	'2026-07-29 23:13:32.824577+00',	0,	NULL,	NULL,	NULL,	NULL,	0),
('eb45bf6e-73e4-4821-a88d-560d6bc3e334',	'72930467-3881-462d-b121-81b491e6c414',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'aprobado',	'Mauricio Pitoño',	NULL,	'asd',	'asd',	'Las Cucarachas',	'asd',	NULL,	NULL,	NULL,	NULL,	'2026-07-29 13:38:16.850082+00',	'2026-07-29 13:38:16.850082+00',	'2026-07-29 23:30:48.940112+00',	0,	'asd',	NULL,	NULL,	NULL,	0),
('7b51939e-c3eb-41a2-b7d0-06280e29f835',	'72930467-3881-462d-b121-81b491e6c414',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'aprobado',	'Mauricio Pitoño',	47,	'Soy el dueño de un casino, al que le apasiona el dinero y las mujeres. Quiero dinero, dadme vuestro dinero.',	'Antes del apocalipsis era un crupier fracasado, la gente me insultaba porq no ganaban los pringaos. Cuando pasó el incidente, a los pocos meses me secuestraron, no sabía quiénes eran, hasta que me quitaron la bolsa de la cabeza, estuve en experimentos muy dolorosos donde me implantaban partes de otros animales. Antes moverme era un suplicio, en uno de los experimentos pensaron que había muerto y me tiraron al mar, conseguí despertar en la cosa e irme a una zona segura, Puerto Payo. Actualmente soy el dueño de un casino, soy la polla. Me encanta ganar dinero y hay gente muy maja, ojalá no les pase nada en las incursiones... Pero ojalá sigamos en este apocalipsis. Por culpa de los experimentos, de vez en cuando pongo huevos :(',	'Las Cucarachas',	'Elfo',	'Quimera',	NULL,	NULL,	NULL,	'2026-07-29 22:43:47.861948+00',	'2026-07-29 22:43:47.861948+00',	NULL,	0,	'Ganar dinero, conocer gente y follar.',	'Huye, a no ser que se motive.',	'Lata de atún',	'Estafador',	0),
('8c75f3e9-df07-4b5d-b46a-0fe774d5e3a6',	'72930467-3881-462d-b121-81b491e6c414',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'aprobado',	'sdfsd',	45,	NULL,	NULL,	'Protocolo Lázaro',	'Alien',	'Quimera',	NULL,	NULL,	NULL,	'2026-07-30 14:45:53.979823+00',	'2026-07-30 14:45:53.979823+00',	'2026-07-30 14:46:04.206578+00',	0,	NULL,	NULL,	NULL,	NULL,	0),
('1e90fa85-06eb-4f9a-8d72-e83f5d1aad02',	'72930467-3881-462d-b121-81b491e6c414',	'3c3ede51-7331-469b-b8b5-e75ed8127b4c',	'aprobado',	'Rajoy',	145,	'asd',	NULL,	'Las Cucarachas',	'asd',	'asd',	NULL,	NULL,	NULL,	'2026-07-29 11:33:31.014869+00',	'2026-07-29 11:33:31.014869+00',	'2026-07-30 19:32:31.996761+00',	0,	NULL,	NULL,	NULL,	NULL,	0),
('467b5283-0978-4c5c-9c15-dae46f829199',	'72930467-3881-462d-b121-81b491e6c414',	'3c3ede51-7331-469b-b8b5-e75ed8127b4c',	'aprobado',	'Paco',	45,	NULL,	NULL,	'Las Cucarachas',	'Alien',	'Quimera',	NULL,	NULL,	NULL,	'2026-07-30 19:32:49.160782+00',	'2026-07-30 19:32:49.160782+00',	'2026-07-30 19:33:14.58233+00',	0,	NULL,	NULL,	NULL,	NULL,	0);

DROP TABLE IF EXISTS "season_mods";
CREATE TABLE "public"."season_mods" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "temporada_id" uuid NOT NULL,
    "nombre" character varying(128) NOT NULL,
    "descripcion" text,
    "categoria" text[],
    "icono_url" text,
    "modrinth_id" character varying(64),
    "modrinth_url" text,
    "curseforge_url" text,
    "github_url" text,
    "version" character varying(32),
    "sort_order" integer DEFAULT '0',
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "updated_at" timestamptz DEFAULT now() NOT NULL,
    "origen" character varying(20) DEFAULT 'manual' NOT NULL,
    "archivo_jar" character varying(255),
    CONSTRAINT "season_mods_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE INDEX idx_season_mods_temporada ON public.season_mods USING btree (temporada_id, sort_order);

CREATE UNIQUE INDEX unique_mod_por_temporada ON public.season_mods USING btree (temporada_id, modrinth_id);

CREATE UNIQUE INDEX idx_season_mods_archivo ON public.season_mods USING btree (temporada_id, archivo_jar) WHERE (archivo_jar IS NOT NULL);

INSERT INTO "season_mods" ("id", "temporada_id", "nombre", "descripcion", "categoria", "icono_url", "modrinth_id", "modrinth_url", "curseforge_url", "github_url", "version", "sort_order", "created_at", "updated_at", "origen", "archivo_jar") VALUES
('0ce40899-27f0-43cb-b0bb-869764dcbe6f',	'72930467-3881-462d-b121-81b491e6c414',	'Architectury API',	'An intermediary api aimed to ease developing multiplatform mods.',	'{Librería}',	'https://cdn.modrinth.com/data/lhGA9TYQ/05fe3a61c28faaccaec3533b92e1b321edde7bf6_96.webp',	'lhGA9TYQ',	'https://modrinth.com/mod/architectury-api',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.985747+00',	'2026-07-28 23:09:11.852393+00',	'modrinth',	NULL),
('e5b9ba95-9340-479e-95c4-0abc09f2be7f',	'72930467-3881-462d-b121-81b491e6c414',	'Tab Stats',	'A tab list to show player stats',	'{Utilidad}',	'https://cdn.modrinth.com/data/zWtYC4e6/c2a3cf8252fe058bb1dccd25fc15eb78d5ddce4c_96.webp',	'zWtYC4e6',	'https://modrinth.com/mod/tab-stats',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.006461+00',	'2026-07-28 23:09:11.874491+00',	'modrinth',	NULL),
('4605f081-1fb8-4ff6-aa15-5b44ac06b6d7',	'72930467-3881-462d-b121-81b491e6c414',	'FerriteCore',	'Memory usage optimizations',	'{Optimización,Utilidad}',	'https://cdn.modrinth.com/data/uXXizFIs/222a126f26f8f9ae1eb339f3b767677f18bff31f_96.webp',	'uXXizFIs',	'https://modrinth.com/mod/ferrite-core',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.964903+00',	'2026-07-28 23:09:11.876416+00',	'modrinth',	NULL),
('b722a5d3-9630-44e7-bd92-45cc17d03ff9',	'72930467-3881-462d-b121-81b491e6c414',	'ModernFix',	'All-in-one mod that improves performance, reduces memory usage, and fixes many bugs. Compatible with all your favorite performance mods!',	'{Optimización,Utilidad}',	'https://cdn.modrinth.com/data/nmDcB62a/2af94de5e08ae54567ee86b968fc7ce076d9fee5_96.webp',	'nmDcB62a',	'https://modrinth.com/mod/modernfix',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.999696+00',	'2026-07-28 23:09:11.881092+00',	'modrinth',	NULL),
('ab14507c-c4a8-4ef1-96b2-0a803c1a68b2',	'72930467-3881-462d-b121-81b491e6c414',	'ImmediatelyFast',	'Speed up immediate mode rendering in Minecraft',	'{Optimización}',	'https://cdn.modrinth.com/data/5ZwdcRci/e57b6b451425692ac17ad322d5e14bea686a383a_96.webp',	'5ZwdcRci',	'https://modrinth.com/mod/immediatelyfast',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.995674+00',	'2026-07-28 23:09:11.883026+00',	'modrinth',	NULL),
('75339597-058e-4eba-bde5-0f2532fa007c',	'72930467-3881-462d-b121-81b491e6c414',	'Zombie Awareness',	'Smarter more aware zombies (and others), they track you down via blood scent, sound, and light source awareness',	'{Aventura,"Mecánicas de juego",Criaturas}',	'https://cdn.modrinth.com/data/mMTOWOaA/a05ff0c2146142ba350fe458c6a9d0691cdfd0a8_96.webp',	'mMTOWOaA',	'https://modrinth.com/mod/zombie-awareness',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.969109+00',	'2026-07-28 23:09:11.9039+00',	'modrinth',	NULL),
('969f7a05-6bf7-4de8-b16d-2ae9ce592346',	'72930467-3881-462d-b121-81b491e6c414',	'Apocalypse Now',	'Apocalypse Now is a mod totally focused on an apocalyptic world that was taken over by creatures that only live to attack and eat anything alive in the world, Explore the world to find a insane amount of melee weapons and new custom armor!',	'{Decoración,Equipamiento,Criaturas}',	'https://cdn.modrinth.com/data/itxv4X52/b1373b6a42eabbe147574b662ba38bd0530ba39a.png',	'itxv4X52',	'https://modrinth.com/mod/apocalypse-now',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.982657+00',	'2026-07-28 23:09:11.937153+00',	'modrinth',	NULL),
('24cc748a-81a5-4e1a-a665-5cb6c351f55b',	'72930467-3881-462d-b121-81b491e6c414',	'Balm',	'Abstraction Layer for Multi-Loader Mods',	'{Librería}',	'https://cdn.modrinth.com/data/MBAkmtvl/285b7bcfd6e525c043e640b08f3efc0cde90f7dd_96.webp',	'MBAkmtvl',	'https://modrinth.com/mod/balm',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.974973+00',	'2026-07-28 23:09:11.944583+00',	'modrinth',	NULL),
('36864dd9-b0ee-4a05-ad31-bb8ea5e650b8',	'72930467-3881-462d-b121-81b491e6c414',	'Chat Heads',	'See who you''re chatting with!',	'{Decoración,Social}',	'https://cdn.modrinth.com/data/Wb5oqrBJ/icon.png',	'Wb5oqrBJ',	'https://modrinth.com/mod/chat-heads',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.0148+00',	'2026-07-28 23:09:11.955394+00',	'modrinth',	NULL),
('bd2587b3-30b8-4128-a1a8-dda6339308fc',	'72930467-3881-462d-b121-81b491e6c414',	'Resourceful Lib',	'Resourceful Lib',	'{Librería}',	'https://cdn.modrinth.com/data/G1hIVOrD/52130f41d05162ce6d7d1832a47d3c238d102632_96.webp',	'G1hIVOrD',	'https://modrinth.com/mod/resourceful-lib',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.954061+00',	'2026-07-28 23:09:11.984506+00',	'modrinth',	NULL),
('ed4fe09b-5cf4-44fc-8a41-0d11104bc4af',	'72930467-3881-462d-b121-81b491e6c414',	'Puzzles Lib',	'Why is it called Puzzles? That''s the puzzle.',	'{Librería}',	'https://cdn.modrinth.com/data/QAGBst4M/c78216c61f65b6ce82593e4e92e9c358402bb524_96.webp',	'QAGBst4M',	'https://modrinth.com/mod/puzzles-lib',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.972037+00',	'2026-07-28 23:09:11.986673+00',	'modrinth',	NULL),
('533a9636-facb-4094-9e04-a86e37f885b0',	'72930467-3881-462d-b121-81b491e6c414',	'Embeddium',	'A powerful, mod-friendly, FOSS client performance mod for NeoForge',	'{Optimización}',	'https://cdn.modrinth.com/data/sk9rgfiA/55f9c50284f8abbbe2a485abfd6a16209201e451_96.webp',	'sk9rgfiA',	'https://modrinth.com/mod/embeddium',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.941934+00',	'2026-07-28 23:09:11.990524+00',	'modrinth',	NULL),
('a9ed9252-d466-43e0-a9b1-1fc6447ef322',	'72930467-3881-462d-b121-81b491e6c414',	'Get It Together, Drops!',	'Adds tags and configuration options for defining how dropped items should combine.',	'{Optimización}',	'https://cdn.modrinth.com/data/T0OUgf8P/0db08b635bd5ad7eea705f5e8640e8757fa5c556_96.webp',	'T0OUgf8P',	'https://modrinth.com/mod/get-it-together-drops',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.933762+00',	'2026-07-28 23:09:11.996251+00',	'modrinth',	NULL),
('2d2217b6-0e22-42f9-b229-b55c6dd91427',	'72930467-3881-462d-b121-81b491e6c414',	'AppleSkin',	'Food/hunger-related HUD improvements',	'{Comida,Utilidad}',	'https://cdn.modrinth.com/data/EsAfCjCV/icon.png',	'EsAfCjCV',	'https://modrinth.com/mod/appleskin',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.97891+00',	'2026-07-28 23:09:11.998201+00',	'modrinth',	NULL),
('a80e17e0-76f4-4738-b39c-97b3af23cddc',	'72930467-3881-462d-b121-81b491e6c414',	'Just Enough Items (JEI)',	'View Items and Recipes',	'{Librería,Utilidad}',	'https://cdn.modrinth.com/data/u6dRKJwZ/4a3f18ac0d096c9f8e9176984c44be4e58f94c89_96.webp',	'u6dRKJwZ',	'https://modrinth.com/mod/jei',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.991854+00',	'2026-07-28 23:09:12.008369+00',	'modrinth',	NULL),
('01e35feb-8f68-490f-a17b-a49effb083f0',	'72930467-3881-462d-b121-81b491e6c414',	'Cyberware: Reforged',	'Unofficial 1.20.1 port of Cyberware by Flaxbeard and Robotic Parts by An_Sar',	'{Aventura,Tecnología,Utilidad}',	'https://cdn.modrinth.com/data/FJab88SV/ca5a918f6043c4cb004e627a38b567f19e41f366_96.webp',	'FJab88SV',	'https://modrinth.com/mod/cyberware-reforged',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.021045+00',	'2026-07-28 23:09:12.012428+00',	'modrinth',	NULL),
('d1287275-34da-40fe-bd18-cf6b9a895b64',	'72930467-3881-462d-b121-81b491e6c414',	'Botarium',	'A crossplatform API for devs that makes transfer and storage of items, fluids and energy easier, as well as some other helpful things',	'{Librería}',	'https://cdn.modrinth.com/data/2u6LRnMa/5770647ce9e78a5db4c75c5cd9c92f6436aeea11_96.webp',	'2u6LRnMa',	'https://modrinth.com/mod/botarium',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.959634+00',	'2026-07-28 23:09:12.017132+00',	'modrinth',	NULL),
('36590a37-4e21-4ea5-b9d4-33602b459d1b',	'72930467-3881-462d-b121-81b491e6c414',	'Geckolib',	'A 3D animation library for entities, blocks, items, armor, and more!',	'{"Mecánicas de juego",Librería,Utilidad}',	'https://cdn.modrinth.com/data/8BmcQJ2H/012d1aadbc754995de66e8c149a56aa10b63fe05_96.webp',	'8BmcQJ2H',	'https://modrinth.com/mod/geckolib',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.948324+00',	'2026-07-28 23:09:12.025069+00',	'modrinth',	NULL),
('56c49363-0c95-443b-a64b-2416f182bfb5',	'72930467-3881-462d-b121-81b491e6c414',	'Simple Voice Chat',	'A working voice chat in Minecraft!',	'{Aventura,Social,Utilidad}',	'https://cdn.modrinth.com/data/9eGKb6K1/icon.png',	'9eGKb6K1',	'https://modrinth.com/mod/simple-voice-chat',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.017996+00',	'2026-07-28 23:09:12.026923+00',	'modrinth',	NULL),
('4463e9ca-aa6a-447d-83cf-0320d685b016',	'72930467-3881-462d-b121-81b491e6c414',	'Krypton Reno',	'Provides powerful network optimization capabilities for all mainstream systems.',	'{Optimización,Utilidad}',	'https://cdn.modrinth.com/data/JkxWVYwU/62f7dda76bbadad7433688ca1d0a8270c275416e_96.webp',	'JkxWVYwU',	'https://modrinth.com/mod/krypton-fnp',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.922131+00',	'2026-07-28 23:09:12.050003+00',	'modrinth',	NULL),
('37d90b75-1524-440e-85f8-5bcde5d07aa0',	'72930467-3881-462d-b121-81b491e6c414',	'Durability Tooltip',	'Durability Tooltip shows you the durability of an item!',	'{Utilidad}',	'https://cdn.modrinth.com/data/smUP7V3r/icon.png',	'smUP7V3r',	'https://modrinth.com/mod/durability-tooltip',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.090911+00',	'2026-07-28 23:09:11.856022+00',	'modrinth',	NULL),
('0cabf572-bf0f-4ff6-b82f-b63172ec4d87',	'72930467-3881-462d-b121-81b491e6c414',	'Better Compatibility Checker',	'Changes the default server compatibility check to compare modpack versions',	'{"Mecánicas de juego",Gestión,Utilidad}',	'https://cdn.modrinth.com/data/KJhXPbHQ/bac6efc73281fab7a07ddca978800a5e9172b529.png',	'KJhXPbHQ',	'https://modrinth.com/mod/better-compatibility-checker',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.084506+00',	'2026-07-28 23:09:11.900182+00',	'modrinth',	NULL),
('2227ad6b-f912-4d1d-9b79-8a86a8e87241',	'72930467-3881-462d-b121-81b491e6c414',	'Berezkas library',	'a library that has loot-tables that are required for berezkas mods',	'{Librería}',	'https://cdn.modrinth.com/data/hOq8z2B6/65e13fe09302d8ba60ac3af33716fbf820f24b06_96.webp',	'hOq8z2B6',	'https://modrinth.com/mod/berezkas-library',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.030467+00',	'2026-07-28 23:09:11.902008+00',	'modrinth',	NULL),
('abe455fe-b443-49ed-a5d0-34d415cf94e9',	'72930467-3881-462d-b121-81b491e6c414',	'Oculus',	'Unofficial Fork of "Iris", made to work with FML',	'{Decoración,Optimización}',	'https://cdn.modrinth.com/data/GchcoXML/09ef853cdfd3d467dead4faef37102535a2185d5_96.webp',	'GchcoXML',	'https://modrinth.com/mod/oculus',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.069139+00',	'2026-07-28 23:09:11.915869+00',	'modrinth',	NULL),
('c62ec073-604b-4c0c-9d64-8efad1c11413',	'72930467-3881-462d-b121-81b491e6c414',	'Curios API',	'A flexible and expandable accessory/equipment API for users and developers.',	'{Equipamiento,Librería,Utilidad}',	'https://cdn.modrinth.com/data/vvuO3ImH/2a7323ca80849de0bcb50299e18acdf8bf394682.png',	'vvuO3ImH',	'https://modrinth.com/mod/curios',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.0591+00',	'2026-07-28 23:09:11.917943+00',	'modrinth',	NULL),
('ba72b21d-5c6c-4bb9-b079-27bfce9a05a5',	'72930467-3881-462d-b121-81b491e6c414',	'Zeta',	'Comprehensive Load-Bearing Library for Modular Mods',	'{"Sin categoría"}',	'https://cdn.modrinth.com/data/MVARlG2f/d09aff2a1c134defab38a19db7c7431df8173a14_96.webp',	'MVARlG2f',	'https://modrinth.com/mod/zeta',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.08151+00',	'2026-07-28 23:09:11.919861+00',	'modrinth',	NULL),
('52e07cc2-6d70-4095-9560-c720fb20c627',	'72930467-3881-462d-b121-81b491e6c414',	'CorgiLib',	'A library mod containing code used across Corgi Taco''s mods.',	'{Librería}',	'https://cdn.modrinth.com/data/ziOp6EO8/46be0599bd15d6eff8c6da814b28700dc53a3eb7_96.webp',	'ziOp6EO8',	'https://modrinth.com/mod/corgilib',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.062413+00',	'2026-07-28 23:09:11.925687+00',	'modrinth',	NULL),
('d6573c34-f12e-42b3-81c4-2a753c396edb',	'72930467-3881-462d-b121-81b491e6c414',	'KubeJS',	'Edit recipes, add new custom items, script world events, all in JavaScript!',	'{Librería,Utilidad}',	'https://cdn.modrinth.com/data/umyGl7zF/ced768ee05e293837a24eacf00838061e02964a0_96.webp',	'umyGl7zF',	'https://modrinth.com/mod/kubejs',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.046194+00',	'2026-07-28 23:09:11.959211+00',	'modrinth',	NULL),
('f5581ba2-5714-499a-b536-50ac52087955',	'72930467-3881-462d-b121-81b491e6c414',	'Citadel',	'A Lightweight Library',	'{Librería}',	'https://cdn.modrinth.com/data/jJfV67b1/0aa5d9f63754fa9a39b9d3deff95e5819fa5b721_96.webp',	'jJfV67b1',	'https://modrinth.com/mod/citadel',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.033597+00',	'2026-07-28 23:09:11.961104+00',	'modrinth',	NULL),
('c5a0b9a6-2228-4fd9-8a45-eac7556bd547',	'72930467-3881-462d-b121-81b491e6c414',	'Nature''s Compass',	'Allows you to locate biomes anywhere in the world.',	'{Aventura,Equipamiento,Utilidad}',	'https://cdn.modrinth.com/data/fPetb5Kh/95e4110a4cf600843c4ba9d545cc1b60e2c00eaa.png',	'fPetb5Kh',	'https://modrinth.com/mod/natures-compass',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.024179+00',	'2026-07-28 23:09:11.965003+00',	'modrinth',	NULL),
('d3aa74e1-2206-4c99-9601-3b8b41d94290',	'72930467-3881-462d-b121-81b491e6c414',	'GraveStone Mod',	'Places a gravestone with your inventory items inside when you die',	'{Aventura,Tecnología,Utilidad}',	'https://cdn.modrinth.com/data/RYtXKJPr/ee9d4610b3892547c20ac61bcdb2517d1b3a4649_96.webp',	'RYtXKJPr',	'https://modrinth.com/mod/gravestone-mod',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.066042+00',	'2026-07-28 23:09:11.971913+00',	'modrinth',	NULL),
('cbcaa09b-6832-483e-bb89-d4e73d4f59ac',	'72930467-3881-462d-b121-81b491e6c414',	'No Chat Reports',	'Makes chat unreportable (where possible)',	'{Social,Utilidad}',	'https://cdn.modrinth.com/data/qQyHxfxd/icon.png',	'qQyHxfxd',	'https://modrinth.com/mod/no-chat-reports',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.039769+00',	'2026-07-28 23:09:11.974759+00',	'modrinth',	NULL),
('4c7affdc-d70e-4771-9d0f-a00cef17710d',	'72930467-3881-462d-b121-81b491e6c414',	'Structures Tweaker',	'Take complete control over how players interact with structures in your Minecraft world.',	'{"Sin categoría"}',	'https://cdn.modrinth.com/data/KsN9btiw/6fb11bc091d2b26df1c66a544f16c9e208dde3a4.webp',	'KsN9btiw',	'https://modrinth.com/mod/structures-tweaker',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.052576+00',	'2026-07-28 23:09:11.977033+00',	'modrinth',	NULL),
('3b06cd49-0c51-49f5-81a4-6236b4ba62c2',	'72930467-3881-462d-b121-81b491e6c414',	'NukaCraft: Fallout mod',	'Mod based on Fallout universe',	'{Aventura,Criaturas,"Generación de mundo"}',	'https://cdn.modrinth.com/data/wxnA5ydI/a840be8fe325c7b135e0c0e3258018a47e19bbee_96.webp',	'wxnA5ydI',	'https://modrinth.com/mod/thenukacraft',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.027206+00',	'2026-07-28 23:09:11.982411+00',	'modrinth',	NULL),
('12dfe2e1-72e7-437b-b993-ce35650bb1ee',	'72930467-3881-462d-b121-81b491e6c414',	'Origins (Forge)',	'This is an unofficial forge port of the Origins mod for fabric',	'{Aventura}',	'https://cdn.modrinth.com/data/jl3m2lR9/43857dfa07470eac6c3151e7c60e9689c64b4da4_96.webp',	'jl3m2lR9',	'https://modrinth.com/mod/origins-forge',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.07857+00',	'2026-07-28 23:09:11.994227+00',	'modrinth',	NULL),
('c3ab6c79-170f-4682-93b1-bc90efcc5024',	'72930467-3881-462d-b121-81b491e6c414',	'FastWorkbench',	'A major optimization for the Crafting Table!',	'{Optimización}',	'https://cdn.modrinth.com/data/5NYPwQRn/70ab92df539e20898489cbbf126605df581bf90d_96.webp',	'5NYPwQRn',	'https://modrinth.com/mod/fastworkbench',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.049583+00',	'2026-07-28 23:09:12.004496+00',	'modrinth',	NULL),
('462fefb1-7aeb-4482-b091-42c9d1055f38',	'72930467-3881-462d-b121-81b491e6c414',	'Just Enough Resources (JER)',	'JEI integration that adds info on mobs, world gen, villagers and many more!',	'{Utilidad}',	'https://cdn.modrinth.com/data/uEfK2CXF/ca8130fd80167a798d6bfa489dd87fbb871dce94_96.webp',	'uEfK2CXF',	'https://modrinth.com/mod/just-enough-resources-jer',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.055793+00',	'2026-07-28 23:09:12.034953+00',	'modrinth',	NULL),
('dfc4f449-7485-40dc-86d9-8303dab034b8',	'72930467-3881-462d-b121-81b491e6c414',	'Searchables',	'Searchables is a library mod that adds helper methods that allow for searching and filtering elements based on components, as well as offering built in auto-complete functionality.',	'{Librería,Utilidad}',	'https://cdn.modrinth.com/data/fuuu3xnx/206971d54b37b30a2e728b1c194f7f096963d05a_96.webp',	'fuuu3xnx',	'https://modrinth.com/mod/searchables',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.087876+00',	'2026-07-28 23:09:12.036856+00',	'modrinth',	NULL),
('ebc8884a-9880-4c30-8ef4-599029d071eb',	'72930467-3881-462d-b121-81b491e6c414',	'Legendary Survival Overhaul',	'Temperature, thirst, limbs management, health overhaul for Survival game!',	'{Aventura,"Mecánicas de juego"}',	'https://cdn.modrinth.com/data/TQr3t8Sb/fded157d76cfbe1200a4cb0f22f5460e92bcd9e3.gif',	'TQr3t8Sb',	'https://modrinth.com/mod/legendary-survival-overhaul',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.075601+00',	'2026-07-28 23:09:12.044489+00',	'modrinth',	NULL),
('49df1c77-3924-4724-8e8b-82b546ea8879',	'72930467-3881-462d-b121-81b491e6c414',	'Jade 🔍',	'Shows information about what you are looking at. (Hwyla/Waila fork for Minecraft 1.16+)',	'{Utilidad}',	'https://cdn.modrinth.com/data/nvQzSEkH/b04217bc2b7dc524c4d12f81ff42cc1cefb9b0fc_96.webp',	'nvQzSEkH',	'https://modrinth.com/mod/jade',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.036531+00',	'2026-07-28 23:09:12.047486+00',	'modrinth',	NULL),
('bf6259fa-8cd7-45b2-9076-3acb5002fa50',	'72930467-3881-462d-b121-81b491e6c414',	'Rhino',	'A fork of Mozilla''s Rhino library, modified for use in mods',	'{Librería,Utilidad}',	'https://cdn.modrinth.com/data/sk9knFPE/fd4ab05472a7e28fbd62054e5640ef61308cc4a6_96.webp',	'sk9knFPE',	'https://modrinth.com/mod/rhino',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.152916+00',	'2026-07-28 23:09:11.850523+00',	'modrinth',	NULL),
('6339ec7e-701e-4d03-8b7b-6992efd3a28d',	'72930467-3881-462d-b121-81b491e6c414',	'Enhanced Celestials',	'A mod adding new Lunar Events like blood moons and harvest moons!',	'{Aventura}',	'https://cdn.modrinth.com/data/2rL16t1O/e2d4d70baba696b30bafc484b87afcddc8ecd554_96.webp',	'2rL16t1O',	'https://modrinth.com/mod/enhanced-celestials',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.156336+00',	'2026-07-28 23:09:11.857971+00',	'modrinth',	NULL),
('4da0b4fb-0cdc-4e6b-852e-0f4d579fd582',	'72930467-3881-462d-b121-81b491e6c414',	'Terralith',	'Explore almost 100 new biomes consisting of both realism and light fantasy, using just Vanilla blocks. Complete with several immersive structures to compliment the overhauled terrain.',	'{"Generación de mundo"}',	'https://cdn.modrinth.com/data/8oi3bsk5/1959d924a1088944bbf07a06ba523726112d7e7a_96.webp',	'8oi3bsk5',	'https://modrinth.com/mod/terralith',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.105873+00',	'2026-07-28 23:09:11.860307+00',	'modrinth',	NULL),
('71984d6e-2592-487e-a588-8c3552e723c4',	'72930467-3881-462d-b121-81b491e6c414',	'Cut Through',	'Cleanly swing through transparent blocks like tall grass to hit mobs without breaking said block.',	'{"Mecánicas de juego"}',	'https://cdn.modrinth.com/data/Dk6su9JN/7d3394c6c15bf9bdfe04fd25b317e237feac6c55_96.webp',	'Dk6su9JN',	'https://modrinth.com/mod/cut-through',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.149964+00',	'2026-07-28 23:09:11.87028+00',	'modrinth',	NULL),
('face0a5e-ca46-4146-8e98-7927266db515',	'72930467-3881-462d-b121-81b491e6c414',	'Create',	'Aesthetic Technology that empowers the Player',	'{Decoración,Tecnología,Utilidad}',	'https://cdn.modrinth.com/data/LNytGWDc/61d716699bcf1ec42ed4926a9e1c7311be6087e2_96.webp',	'LNytGWDc',	'https://modrinth.com/mod/create',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.1405+00',	'2026-07-28 23:09:11.885049+00',	'modrinth',	NULL),
('5e8ff925-a09f-41ab-b3ed-85e9a5c2f015',	'72930467-3881-462d-b121-81b491e6c414',	'YUNG''s Menu Tweaks',	'A small, lightweight mod that makes browsing menus a lot easier',	'{Utilidad}',	'https://cdn.modrinth.com/data/Hcy2DFKF/c54579d92c958af4066dd4c2a67b4b5fa423d7b2_96.webp',	'Hcy2DFKF',	'https://modrinth.com/mod/yungs-menu-tweaks',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.111983+00',	'2026-07-28 23:09:11.892914+00',	'modrinth',	NULL),
('9033fd29-9d1b-4b32-929e-9ae32015056b',	'72930467-3881-462d-b121-81b491e6c414',	'spark',	'spark is a performance profiler for Minecraft clients, servers and proxies.',	'{Utilidad}',	'https://cdn.modrinth.com/data/l6YH9Als/61a777dd08a8447ac93e8b6372e6d27d48cd1e1a_96.webp',	'l6YH9Als',	'https://modrinth.com/mod/spark',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.093737+00',	'2026-07-28 23:09:11.895328+00',	'modrinth',	NULL),
('9121c501-c7b9-4cdf-9b6c-774e779997fb',	'72930467-3881-462d-b121-81b491e6c414',	'Clumps',	'Clumps XP orbs together to reduce lag',	'{Almacenamiento,Utilidad}',	'https://cdn.modrinth.com/data/Wnxd13zP/6a965bb7974c3e759a53a1c89c35de4acd4cf86a_96.webp',	'Wnxd13zP',	'https://modrinth.com/mod/clumps',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.102982+00',	'2026-07-28 23:09:11.898067+00',	'modrinth',	NULL),
('de123cd1-f8df-403a-9dd6-f8e2dae1b304',	'72930467-3881-462d-b121-81b491e6c414',	'Easy NPC: Config UI',	'Provides a configuration UI for the Easy NPC mod, allowing players to customize NPC settings easily.',	'{Utilidad}',	'https://cdn.modrinth.com/data/uTGjf7vA/f86a6e2d735af107f38d60a6623d74e5b15c9af8_96.webp',	'uTGjf7vA',	'https://modrinth.com/mod/easy-npc-config-ui',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.130301+00',	'2026-07-28 23:09:11.913413+00',	'modrinth',	NULL),
('b5a5ecf4-9832-4840-b6f6-42705085b828',	'72930467-3881-462d-b121-81b491e6c414',	'SuperMartijn642''s Config Lib',	'Config Lib makes dealing with config files just a bit easier.',	'{Librería}',	'https://cdn.modrinth.com/data/LN9BxssP/ad25597dd1b10b49cdfbc97c70d401e3158000f7_96.webp',	'LN9BxssP',	'https://modrinth.com/mod/supermartijn642s-config-lib',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.121683+00',	'2026-07-28 23:09:11.923582+00',	'modrinth',	NULL),
('de197f52-9cac-4e84-9be5-735d5c895409',	'72930467-3881-462d-b121-81b491e6c414',	'FastFurnace',	'Performance optimizations for the furnace',	'{Optimización}',	'https://cdn.modrinth.com/data/9X0318ev/8f3f68b3fa6495c068b5a70fd104ecbf90bb0d0a_96.webp',	'9X0318ev',	'https://modrinth.com/mod/fastfurnace',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.146815+00',	'2026-07-28 23:09:11.929961+00',	'modrinth',	NULL),
('a8880083-09c4-4e86-b9aa-4d87759509d0',	'72930467-3881-462d-b121-81b491e6c414',	'Mutants Plus',	'This mod buffs mutants from Mutant Monster, add special items, and enchantments!',	'{Aventura,Criaturas,Optimización}',	'https://cdn.modrinth.com/data/U1U9D7xk/fd8c8c8b9b0c0e7cf5f6a85e4e66105c630d3042_96.webp',	'U1U9D7xk',	'https://modrinth.com/mod/mutants-plus',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.118821+00',	'2026-07-28 23:09:11.940881+00',	'modrinth',	NULL),
('6bee4eea-2f39-42c2-b330-36256a01e848',	'72930467-3881-462d-b121-81b491e6c414',	'Almanac',	'Almanac is a library used by my mods with mostly loader independent shared code between multiple mods to avoid duplication of code.',	'{Librería,Utilidad}',	'https://cdn.modrinth.com/data/Gi02250Z/f0bb3148fcb735bb989ef5723d199114e1f24542.png',	'Gi02250Z',	'https://modrinth.com/mod/almanac',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.137378+00',	'2026-07-28 23:09:11.979746+00',	'modrinth',	NULL),
('7609e8e3-ca59-40d7-b23b-a0c5161bdba6',	'72930467-3881-462d-b121-81b491e6c414',	'Entity Culling',	'Using async path-tracing to hide Block-/Entities that are not visible',	'{Optimización}',	'https://cdn.modrinth.com/data/NNAgCjsB/7873452d6cede4daed12da3d7d8c193ab88b4fd6_96.webp',	'NNAgCjsB',	'https://modrinth.com/mod/entityculling',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.096791+00',	'2026-07-28 23:09:11.992411+00',	'modrinth',	NULL),
('028c7fab-4872-49fb-9e6f-df4fc9de9c1e',	'72930467-3881-462d-b121-81b491e6c414',	'AI Improvements',	'Performance improvements for vanilla AI, with  the ability to turn off certain AI behaviors',	'{Optimización}',	'https://cdn.modrinth.com/data/DSVgwcji/819dbaeb9b0dac8250a1403d1db7e7646f9a9b8f.png',	'DSVgwcji',	'https://modrinth.com/mod/ai-improvements',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.126972+00',	'2026-07-28 23:09:12.000203+00',	'modrinth',	NULL),
('c2ce9f15-52cb-4248-a440-319bfebd50f8',	'72930467-3881-462d-b121-81b491e6c414',	'[NTGL] NukaTeam''s Gun Lib',	'Allows you to add animated weapons to the game',	'{Equipamiento,Librería,Utilidad}',	'https://cdn.modrinth.com/data/5m2kV8xK/e169a08ad425b5a37fe922c8f4ea4806979d4d54.png',	'5m2kV8xK',	'https://modrinth.com/mod/ntgl',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.124322+00',	'2026-07-28 23:09:12.010298+00',	'modrinth',	NULL),
('75d51ccd-2606-413d-8bb1-dfa88d450817',	'72930467-3881-462d-b121-81b491e6c414',	'Mouse Tweaks',	'Enhances inventory management by adding various functions to the mouse buttons. ',	'{Almacenamiento,Utilidad}',	'https://cdn.modrinth.com/data/aC3cM3Vq/6c0eaa4e60a9c87f4766f222ff63286f09da32c0_96.webp',	'aC3cM3Vq',	'https://modrinth.com/mod/mouse-tweaks',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.108776+00',	'2026-07-28 23:09:12.014868+00',	'modrinth',	NULL),
('5357f18c-5477-45c3-b08d-7318ed5c167a',	'72930467-3881-462d-b121-81b491e6c414',	'Crash Utilities',	'Crash Utilities adds a number of tools for finding and fixing common server problems.',	'{"Sin categoría"}',	NULL,	'nbg22QFg',	'https://modrinth.com/mod/crash-utilities',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.143486+00',	'2026-07-28 23:09:12.02317+00',	'modrinth',	NULL),
('df71a8b8-e815-4de7-bf2a-7c1e9a0d3ab3',	'72930467-3881-462d-b121-81b491e6c414',	'Alex''s Mobs',	'85+ New mobs with stylistic quality above the default game.',	'{Equipamiento,Criaturas}',	'https://cdn.modrinth.com/data/2cMuAZAp/fbe04602fb0fb336be05e7c40378156b49d50156_96.webp',	'2cMuAZAp',	'https://modrinth.com/mod/alexs-mobs',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.099806+00',	'2026-07-28 23:09:12.028894+00',	'modrinth',	NULL),
('eed7ec5f-6169-4cc3-a8ac-4c57fb5e5ebc',	'72930467-3881-462d-b121-81b491e6c414',	'Big Lost City',	'A new abandoned cities mod! Discover many abandoned structures!',	'{Aventura,Criaturas,"Generación de mundo"}',	'https://cdn.modrinth.com/data/lMtLn3EL/33018320a646ec52dbd8cd9dc96387c1f54dba04_96.webp',	'lMtLn3EL',	'https://modrinth.com/mod/big-lost-city',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.204195+00',	'2026-07-28 23:09:11.839227+00',	'modrinth',	NULL),
('d096d78f-24af-44df-b972-be513830e152',	'72930467-3881-462d-b121-81b491e6c414',	'Placebo',	'Placebo is a library used by most of my mods.
It does not provide any game-relevant features on its own (save for maybe a couple debug commands).',	'{Librería}',	'https://cdn.modrinth.com/data/tCkE8p2N/f5a71de378c2cc940efaa812da151c480cfdbbb6_96.webp',	'tCkE8p2N',	'https://modrinth.com/mod/placebo',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.222293+00',	'2026-07-28 23:09:11.841102+00',	'modrinth',	NULL),
('53658d0f-7b81-4ab1-9b61-d50c509fcf23',	'72930467-3881-462d-b121-81b491e6c414',	'Abandoned Urban remaster',	'This mod ports abandoned urban to other versions and adds support of Utils from Berezka''s Library to Abandoned Urban.',	'{"Generación de mundo"}',	'https://cdn.modrinth.com/data/Rs9QYg83/a744d24d096807df6c8fba2898d981fb0f55fd02_96.webp',	'Rs9QYg83',	'https://modrinth.com/mod/abandoned-urban-remaster',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.167676+00',	'2026-07-28 23:09:11.84832+00',	'modrinth',	NULL),
('55d6220f-fb86-47ba-9ab7-f02898093d8b',	'72930467-3881-462d-b121-81b491e6c414',	'Coinverse Gearcoins (Create Economy)',	'Economy Mod for Create SMP’s',	'{Economía,Social,Utilidad}',	'https://cdn.modrinth.com/data/7rsNWNL9/b35649701a3e2dc2e47dc1c65dc778c574647842_96.webp',	'7rsNWNL9',	'https://modrinth.com/mod/cv-gearcoins',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.191635+00',	'2026-07-28 23:09:11.872616+00',	'modrinth',	NULL),
('a07933f0-5b0b-45d2-b636-c53c0ed191af',	'72930467-3881-462d-b121-81b491e6c414',	'Immersive Vehicles',	'Library for realistic cars, planes, decor, and guns for Minecraft!',	'{Decoración,Tecnología,Transporte}',	'https://cdn.modrinth.com/data/BCzBuhJ5/46b075dd39cd6d6164ca23069cda321d9c1ac367_96.webp',	'BCzBuhJ5',	'https://modrinth.com/mod/immersive-vehicles',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.174207+00',	'2026-07-28 23:09:11.878611+00',	'modrinth',	NULL),
('77412f45-36ec-4c1f-879a-7bc9680fa122',	'72930467-3881-462d-b121-81b491e6c414',	'YUNG''s API',	'Library mod for YUNG''s mods.',	'{Librería,"Generación de mundo"}',	'https://cdn.modrinth.com/data/Ua7DFN59/0fab1c351bf00926a8e1c91dc64b7c88832c3e1f_96.webp',	'Ua7DFN59',	'https://modrinth.com/mod/yungs-api',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.188298+00',	'2026-07-28 23:09:11.88698+00',	'modrinth',	NULL),
('03f9ea80-de20-4121-93a7-f2f6940ff840',	'72930467-3881-462d-b121-81b491e6c414',	'AttributeFix',	'Removes arbitrary limits on Minecraft''s attribute system. Fixes MANY mods!',	'{Utilidad}',	'https://cdn.modrinth.com/data/lOOpEntO/68a2de475417c87817e11f49beaa903e4774ca20_96.webp',	'lOOpEntO',	'https://modrinth.com/mod/attributefix',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.18511+00',	'2026-07-28 23:09:11.890864+00',	'modrinth',	NULL),
('697780a9-4476-4857-b4eb-0579a43dbddf',	'72930467-3881-462d-b121-81b491e6c414',	'Multi Summon (Multisummon command)',	'Adds an alternative /summon command taking in a number of entities to spawn, plus allowing for spreading',	'{"Mecánicas de juego",Criaturas,Utilidad}',	'https://cdn.modrinth.com/data/JqPKxACJ/ea709a8853d38b674800da1b0ffa0b48e816c6ea_96.webp',	'JqPKxACJ',	'https://modrinth.com/mod/multisummon',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.163884+00',	'2026-07-28 23:09:11.92791+00',	'modrinth',	NULL),
('6c1a3044-f583-43c4-b3cc-ceafebc44517',	'72930467-3881-462d-b121-81b491e6c414',	'Alex''s Caves',	'Explore six new rare cave biomes hidden under the surface of the Overworld...',	'{Aventura,Criaturas,"Generación de mundo"}',	'https://cdn.modrinth.com/data/U6GY0xp0/4165eef78a7efa0f5acda964dd094c08ee0e5680.png',	'U6GY0xp0',	'https://modrinth.com/mod/alexs-caves',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.171104+00',	'2026-07-28 23:09:11.949439+00',	'modrinth',	NULL),
('a8167153-f347-4c63-b3d8-a5f9e100c29b',	'72930467-3881-462d-b121-81b491e6c414',	'GriefLogger',	'A fast mod that uses SQLite or MySQL to log player interactions. Like CoreProtect but for modded.',	'{Gestión,Utilidad}',	'https://cdn.modrinth.com/data/8oGVUFuX/5dc422f635650c74f157ccf0f8870828c6228cfd_96.webp',	'8oGVUFuX',	'https://modrinth.com/mod/grieflogger',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.198337+00',	'2026-07-28 23:09:11.953321+00',	'modrinth',	NULL),
('a511c029-7749-4f0b-b977-73d086f1f534',	'72930467-3881-462d-b121-81b491e6c414',	'Easy NPC: Core',	'Provides the core functionallity for the Easy NPC mod.',	'{Aventura}',	'https://cdn.modrinth.com/data/Epm6R3P2/c1216d7e782dd9333e44159504f52778d0fa7efd_96.webp',	'Epm6R3P2',	'https://modrinth.com/mod/easy-npc-core',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.207889+00',	'2026-07-28 23:09:11.95741+00',	'modrinth',	NULL),
('6d83061b-4e3c-427d-8046-6c7b2dbc4c18',	'72930467-3881-462d-b121-81b491e6c414',	'Quark',	'A Quark is a very small thing. This mod is a collection of small things...',	'{"Mecánicas de juego",Tecnología,Utilidad}',	'https://cdn.modrinth.com/data/qnQsVE2z/aef2119751d026421b9e9dc83d4470eec9f91a16_96.webp',	'qnQsVE2z',	'https://modrinth.com/mod/quark',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.216304+00',	'2026-07-28 23:09:11.962996+00',	'modrinth',	NULL),
('a24ee223-5d47-4a17-9d2e-e7c191d04f8c',	'72930467-3881-462d-b121-81b491e6c414',	'[TaCZ] Timeless and Classics Zero',	'The most Immersive and Customizable modern FPS experience in Minecraft - A complete Remaster of the TaC gun mod by the original team.',	'{Aventura,Equipamiento}',	'https://cdn.modrinth.com/data/SzzJttH8/fd27766d2bb8390d284696b1dbd358f87e081439_96.webp',	'SzzJttH8',	'https://modrinth.com/mod/timeless-and-classics-zero',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.195132+00',	'2026-07-28 23:09:11.967082+00',	'modrinth',	NULL),
('4ab9bf4f-2b0b-4d42-bba2-615404eb9649',	'72930467-3881-462d-b121-81b491e6c414',	'Controlling',	'Adds a search bar to the Key-Bindings menu',	'{Utilidad}',	'https://cdn.modrinth.com/data/xv94TkTM/bdb6feb3d04ca37da4ed5aa73fef062a39d8b3e5_96.webp',	'xv94TkTM',	'https://modrinth.com/mod/controlling',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.219393+00',	'2026-07-28 23:09:12.002454+00',	'modrinth',	NULL),
('6c7ea8cd-1d6e-4b6c-a70a-552c41e17e9e',	'72930467-3881-462d-b121-81b491e6c414',	'Chunky',	'Pre-generates chunks, quickly and efficiently',	'{Optimización,Utilidad,"Generación de mundo"}',	'https://cdn.modrinth.com/data/fALzjamp/e1954413665e57b7bae1feef44eda530270c7d47_96.webp',	'fALzjamp',	'https://modrinth.com/mod/chunky',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.212685+00',	'2026-07-28 23:09:12.006466+00',	'modrinth',	NULL),
('23adba00-1073-40fd-a004-417115e1dde1',	'72930467-3881-462d-b121-81b491e6c414',	'Infectious - Zombie Apocalypse',	'Adding epic new zombies, infections, new items and structures to the game!',	'{Aventura,Criaturas,"Generación de mundo"}',	'https://cdn.modrinth.com/data/Nwf9JJEL/151f73524088c873adbd1639bd3236701d1a286d_96.webp',	'Nwf9JJEL',	'https://modrinth.com/mod/infectious-zombie-apocalypse',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.160161+00',	'2026-07-28 23:09:12.030967+00',	'modrinth',	NULL),
('e6afe3a7-95e6-47e7-8bfd-4ba0e709cac2',	'72930467-3881-462d-b121-81b491e6c414',	'NetherPortalFix',	'Ensures correct destinations when travelling back and forth through Nether Portals in Multiplayer.',	'{"Mecánicas de juego",Utilidad}',	'https://cdn.modrinth.com/data/nPZr02ET/1496de70af297897258b7520aafc0886fa0ad918_96.webp',	'nPZr02ET',	'https://modrinth.com/mod/netherportalfix',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.177346+00',	'2026-07-28 23:09:12.038843+00',	'modrinth',	NULL),
('d97d299f-acb5-472e-899f-e9de00ee54f1',	'72930467-3881-462d-b121-81b491e6c414',	'Mutant Monsters',	'The mutants are back! Face scary creatures and powerful beasts like never before.',	'{Criaturas}',	'https://cdn.modrinth.com/data/derP0ten/56c47fb666da324d4c094465b6544fe970e0e064_96.webp',	'derP0ten',	'https://modrinth.com/mod/mutant-monsters',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.201223+00',	'2026-07-28 23:09:12.042619+00',	'modrinth',	NULL),
('943fb393-ab45-4312-9be3-3789019c2297',	'72930467-3881-462d-b121-81b491e6c414',	'Analog Audio',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	0,	'2026-07-28 22:13:48.401696+00',	'2026-07-28 23:04:43.816007+00',	'manual',	'analogaudio-1.20.1+0.1.0-beta.1.jar'),
('7a47735e-ac0f-470a-b9e6-b79bbcae8193',	'72930467-3881-462d-b121-81b491e6c414',	'Vic''s Point Blank',	'High quality gun mod focused on streamlined design and community contributions',	'{Equipamiento}',	'https://cdn.modrinth.com/data/og4KPYmA/6a979744a1ba5be8a911f6ae7ccc77ccfb357e9d_96.webp',	'og4KPYmA',	'https://modrinth.com/mod/vics-point-blank',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.115672+00',	'2026-07-28 23:09:11.831649+00',	'modrinth',	NULL),
('80248294-acfc-4f8f-aa97-cd14d8a83340',	'72930467-3881-462d-b121-81b491e6c414',	'Polymorph',	'No more recipe conflicts! Adds an option to choose the crafting result if more than one is available.',	'{Utilidad}',	'https://cdn.modrinth.com/data/tagwiZkJ/ed244c5829bde539763c7fffb55cb3194a349d66.png',	'tagwiZkJ',	'https://modrinth.com/mod/polymorph',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.250102+00',	'2026-07-28 23:09:11.835339+00',	'modrinth',	NULL),
('6c84b146-b325-43b4-bb8e-71f42982d78f',	'72930467-3881-462d-b121-81b491e6c414',	'Survival Instinct',	'The best addition to your apocalyptic modpack',	'{Aventura,Equipamiento,Comida}',	'https://cdn.modrinth.com/data/qs326NDd/2d3d2a1d81c1b8a1b62996f0a9b379bb85bf86aa.png',	'qs326NDd',	'https://modrinth.com/mod/survival-instinct',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.181325+00',	'2026-07-28 23:09:11.837356+00',	'modrinth',	NULL),
('91862ac7-7aac-46e7-9aa1-13808f2e18b9',	'72930467-3881-462d-b121-81b491e6c414',	'Easy NPC',	'Create easily NPCs with dialogs for your world or for your mods.',	'{Aventura}',	'https://cdn.modrinth.com/data/CgGEe1h3/1b98ef83f41e2ad561bbc516d6db7567b06f3d70_96.webp',	'CgGEe1h3',	'https://modrinth.com/mod/easy-npc',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:07.988686+00',	'2026-07-28 23:09:11.843105+00',	'modrinth',	NULL),
('3b955728-cf5e-40d0-b876-71ed6a1ebe93',	'72930467-3881-462d-b121-81b491e6c414',	'Max Health Fix',	'Fixes a bug with max health in Minecraft.',	'{Aventura,Equipamiento,Utilidad}',	'https://cdn.modrinth.com/data/mH8wdmqr/fdea4e7ae92a45f6f9742865d260a284a8585e35_96.webp',	'mH8wdmqr',	'https://modrinth.com/mod/max-health-fix',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.04273+00',	'2026-07-28 23:09:11.84558+00',	'modrinth',	NULL),
('249cd04f-1bac-4cd7-9e48-50bad3fb276f',	'72930467-3881-462d-b121-81b491e6c414',	'Data Anchor',	'Simple mod with helpful data attaching and networking utilities including attaching data to entities, chunks, players, and worlds with low boilerplate code. Its own system built from the ground up for multiloader support.',	'{"Sin categoría"}',	'https://cdn.modrinth.com/data/z2XEADmE/5dc6ca415537540bbe4f75e324aebb4e327148bc.png',	'z2XEADmE',	'https://modrinth.com/mod/data-anchor',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.225378+00',	'2026-07-28 23:09:11.854233+00',	'modrinth',	NULL),
('5448d818-7ae0-4bff-a8c5-a274103731d9',	'72930467-3881-462d-b121-81b491e6c414',	'Caelus API',	'A coremod and API to provide developers access to elytra flight mechanics through an entity attribute.',	'{"Mecánicas de juego",Librería,Transporte}',	'https://cdn.modrinth.com/data/40FYwb4z/ae837cab4b8a4d17989b2462bfcd62e8c0451a0f.png',	'40FYwb4z',	'https://modrinth.com/mod/caelus',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.23414+00',	'2026-07-28 23:09:11.862495+00',	'modrinth',	NULL),
('b454b14e-c3e5-4188-8cf0-613048aa37c7',	'72930467-3881-462d-b121-81b491e6c414',	'JourneyMap',	'Real-time map used for mapping in-game or your browser as you explore.',	'{Aventura,Utilidad}',	'https://cdn.modrinth.com/data/lfHFW1mp/a1c571a21a88f6fa59eab67829f216f65ab393ee_96.webp',	'lfHFW1mp',	'https://modrinth.com/mod/journeymap',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.268318+00',	'2026-07-28 23:09:11.905952+00',	'modrinth',	NULL),
('39fcc9f3-70f3-45a1-a18b-c63095d3b788',	'72930467-3881-462d-b121-81b491e6c414',	'Ad Astra',	'Live long and prosper, Ad Astra!',	'{Aventura,Tecnología,"Generación de mundo"}',	'https://cdn.modrinth.com/data/3ufwT9JF/2e903114b7d89b5e1adc7e15dcfd1ba7a1c59505_96.webp',	'3ufwT9JF',	'https://modrinth.com/mod/ad-astra',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.244013+00',	'2026-07-28 23:09:11.921719+00',	'modrinth',	NULL),
('4b5bf5cd-db81-47fe-a70b-2933263d3593',	'72930467-3881-462d-b121-81b491e6c414',	'Let Me Despawn',	'Improves performance by tweaking mob despawn rules. Say bye to pesky unintentional persistent mobs.',	'{Optimización}',	'https://cdn.modrinth.com/data/vE2FN5qn/2609f745e46bd92e57a67e1da07319eb2154c6f7.png',	'vE2FN5qn',	'https://modrinth.com/mod/lmd',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.265333+00',	'2026-07-28 23:09:11.931861+00',	'modrinth',	NULL),
('5dccd11d-439b-49e9-8287-99902706a0a3',	'72930467-3881-462d-b121-81b491e6c414',	'Resourceful Config',	'Resourceful Config is a mod that allows for developers to make cross-platform configs',	'{Librería}',	'https://cdn.modrinth.com/data/M1953qlQ/cadcab644905f7e9ee92220d29f5c27113eb167b_96.webp',	'M1953qlQ',	'https://modrinth.com/mod/resourceful-config',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.259092+00',	'2026-07-28 23:09:11.933965+00',	'modrinth',	NULL),
('fed0a700-ca65-4a42-b9ca-20fb56d3d90e',	'72930467-3881-462d-b121-81b491e6c414',	'Mobtimizations - Entity Performance Fixes',	'Optimizes a lot of tasks that Entity AI wastefully performs, minimal effect on gameplay.',	'{Criaturas,Optimización,Utilidad}',	'https://cdn.modrinth.com/data/Kbz7UydC/6ef8ae21687609aef7d58b564445961153c47faa_96.webp',	'Kbz7UydC',	'https://modrinth.com/mod/mobtimizations',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.256111+00',	'2026-07-28 23:09:11.947434+00',	'modrinth',	NULL),
('8028e6de-6ef4-4a79-90de-d833032e1358',	'72930467-3881-462d-b121-81b491e6c414',	'Immersive Vehicles - Official Content Pack [OCP] - Planes & Cars',	'Official Content Pack with planes, cars, tanks, helicopters and trucks for the Immersive Vehicles mod!',	'{Tecnología,Transporte,Utilidad}',	'https://cdn.modrinth.com/data/C7TiPPJz/f988e76b9d31daae0b2b3a8fcafd37cb220f4bb3_96.webp',	'C7TiPPJz',	'https://modrinth.com/mod/immersive-vehicles-official-content-pack',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.240676+00',	'2026-07-28 23:09:11.951271+00',	'modrinth',	NULL),
('4a657cad-f946-4573-a6ff-393cff0d9e50',	'72930467-3881-462d-b121-81b491e6c414',	'Starlight (Forge)',	'Rewrites the light engine to fix lighting performance and lighting errors',	'{Optimización}',	'https://cdn.modrinth.com/data/iRfIGC1s/aa11bf788b9893370ff1e26af1c275dfd7590c59_96.webp',	'iRfIGC1s',	'https://modrinth.com/mod/starlight-forge',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.247082+00',	'2026-07-28 23:09:11.969238+00',	'modrinth',	NULL),
('5faeedf4-b1ab-4cab-a176-5cae1bd73416',	'72930467-3881-462d-b121-81b491e6c414',	'Farmer''s Delight',	'A cozy expansion to farming and cooking!',	'{Decoración,Equipamiento,Comida}',	'https://cdn.modrinth.com/data/R2OftAxM/8e7aa38ab94d94bb0a2894a218b69beb49002b34.png',	'R2OftAxM',	'https://modrinth.com/mod/farmers-delight',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.253099+00',	'2026-07-28 23:09:11.988689+00',	'modrinth',	NULL),
('76c34487-ecb7-4d50-ba0b-9cea7ad9660d',	'72930467-3881-462d-b121-81b491e6c414',	'Immersive Engineering',	'Retrofuturism, industry and multiblocks!',	'{Equipamiento,Tecnología}',	'https://cdn.modrinth.com/data/tIm2nV03/icon.png',	'tIm2nV03',	'https://modrinth.com/mod/immersiveengineering',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.23715+00',	'2026-07-28 23:09:12.019202+00',	'modrinth',	NULL),
('b454fbea-62ac-4171-a6d4-07e3f226658f',	'72930467-3881-462d-b121-81b491e6c414',	'Pehkui',	'Lets you change the size of most entities, shrinking their scale smaller or growing them larger',	'{"Mecánicas de juego",Librería}',	'https://cdn.modrinth.com/data/t5W7Jfwy/icon.png',	't5W7Jfwy',	'https://modrinth.com/mod/pehkui',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.228296+00',	'2026-07-28 23:09:12.033037+00',	'modrinth',	NULL),
('fe39b6ae-fce5-48b2-bb1b-4b95f9a459a1',	'72930467-3881-462d-b121-81b491e6c414',	'AntiXray',	'A lightweight mod that allows server owners to combat xrayers.',	'{Gestión,Tecnología,Utilidad}',	'https://cdn.modrinth.com/data/sml2FMaA/icon.png',	'sml2FMaA',	'https://modrinth.com/mod/anti-xray',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.262219+00',	'2026-07-28 23:09:12.04075+00',	'modrinth',	NULL),
('12e04bc5-1aef-4c54-9156-be8225f5a95d',	'72930467-3881-462d-b121-81b491e6c414',	'CoroUtil',	'Shared library mod for Corosus''s mods',	'{Librería}',	'https://cdn.modrinth.com/data/rLLJ1OZM/7c7b819ec62d311533db06f6674ce4ebeb867a9d_96.webp',	'rLLJ1OZM',	'https://modrinth.com/mod/coroutil',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.231264+00',	'2026-07-28 23:09:12.052119+00',	'modrinth',	NULL),
('9e4a3200-a55a-47f9-95a3-edfb70ba69b6',	'72930467-3881-462d-b121-81b491e6c414',	'BaguetteLib',	'Ever tried to make a mod that needs proper death handling or inventory tracking? Yeah, NeoForge events suck for that.',	'{"Sin categoría"}',	'https://cdn.modrinth.com/data/OfKzpbRU/d007c3afd229b8e796f41174ceacd7c8f0f436cc_96.webp',	'OfKzpbRU',	'https://modrinth.com/mod/baguettelib',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.003368+00',	'2026-07-28 23:09:11.86581+00',	'modrinth',	NULL),
('5954de4e-0440-4648-a1af-e165f6eb4e02',	'72930467-3881-462d-b121-81b491e6c414',	'Mekanism',	'High-tech machinery, powerful energy generation, fancy gadgets and more. Now on Modrinth!',	'{Equipamiento,Almacenamiento,Tecnología}',	'https://cdn.modrinth.com/data/Ce6I4WUE/ea185eb1300a64867f89101d4798e71a54ef6bed_96.webp',	'Ce6I4WUE',	'https://modrinth.com/mod/mekanism',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.072534+00',	'2026-07-28 23:09:11.888937+00',	'modrinth',	NULL),
('975a988a-35a4-4177-abbb-8ab0e4844bec',	'72930467-3881-462d-b121-81b491e6c414',	'Horror Element Mod',	'This mod adds gore and horror themed blocks for your horror maps as well as horror themed structures spawning naturally for your survival worlds',	'{Aventura,Decoración,"Mecánicas de juego"}',	'https://cdn.modrinth.com/data/x9UbUYtK/042f459148ea818065762725afc848e49bd633f2_96.webp',	'x9UbUYtK',	'https://modrinth.com/mod/horror-element-mod',	NULL,	NULL,	NULL,	0,	'2026-07-28 23:09:08.134018+00',	'2026-07-28 23:09:12.021172+00',	'modrinth',	NULL);

DROP TABLE IF EXISTS "season_server_configs";
CREATE TABLE "public"."season_server_configs" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "temporada_id" uuid NOT NULL,
    "server_ip" character varying(128),
    "server_port" smallint DEFAULT '25565',
    "modpack_url" character varying(255),
    "modpack_version" character varying(255),
    "forge_version" character varying(50),
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "updated_at" timestamptz DEFAULT now() NOT NULL,
    "mods_count" integer,
    CONSTRAINT "season_server_configs_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

INSERT INTO "season_server_configs" ("id", "temporada_id", "server_ip", "server_port", "modpack_url", "modpack_version", "forge_version", "created_at", "updated_at", "mods_count") VALUES
('f550086e-2db2-4d36-9c54-8a7bea347fed',	'72930467-3881-462d-b121-81b491e6c414',	'cipollo2apocalypse.mcserver.us',	25565,	NULL,	NULL,	'1.20.1',	'2026-07-18 03:36:25.106651+00',	'2026-07-18 03:36:25.106651+00',	100);

DROP TABLE IF EXISTS "temporadas";
CREATE TABLE "public"."temporadas" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "numero" smallint NOT NULL,
    "slug" character varying(16) NOT NULL,
    "nombre" character varying(64) NOT NULL,
    "subtitulo" character varying(128),
    "status" character varying(12) DEFAULT 'proximamente' NOT NULL,
    "year" smallint,
    "open_date" timestamptz,
    "description" text,
    "requires_character_sheet" boolean DEFAULT false NOT NULL,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "updated_at" timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT "temporadas_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "temporadas_status_check" CHECK ((((status)::text = ANY ((ARRAY['proximamente'::character varying, 'activa'::character varying, 'inactiva'::character varying, 'archivada'::character varying])::text[]))))
)
WITH (oids = false);

CREATE UNIQUE INDEX temporadas_numero_key ON public.temporadas USING btree (numero);

CREATE UNIQUE INDEX temporadas_slug_key ON public.temporadas USING btree (slug);

INSERT INTO "temporadas" ("id", "numero", "slug", "nombre", "subtitulo", "status", "year", "open_date", "description", "requires_character_sheet", "created_at", "updated_at") VALUES
('52607b66-a0ad-43fc-97be-f684f3e8df4c',	1,	't1',	'CipolloLand 0',	'Random Bullshit Go',	'archivada',	2024,	'2024-07-13 22:00:00+00',	'La primera temporada de CipolloLand, donde todo empezó',	0,	'2026-07-18 01:54:17.213531+00',	'2026-07-18 01:54:17.213531+00'),
('6fd8250a-0a1c-49e5-a154-2eb0265dce44',	2,	't2',	'CipolloLand 1',	'Medieval Edition',	'archivada',	2025,	'2025-07-26 22:00:00+00',	'El próspero reino de Cipollo, donde la magia florece o conoce su fin',	0,	'2026-07-18 01:54:17.213531+00',	'2026-07-18 01:54:17.213531+00'),
('72930467-3881-462d-b121-81b491e6c414',	3,	't3',	'CipolloLand 2',	'Apocalypse Edition',	'activa',	2026,	'2026-08-01 15:30:00+00',	'El mundo ha caido, los zombies son la criatura dominante.',	0,	'2026-07-18 01:54:17.213531+00',	'2026-07-18 01:54:17.213531+00'),
('603e10d3-f66b-4bd4-b49e-c7bb72090f24',	4,	't4',	'CipolloLand 4',	'Por decidir',	'proximamente',	2027,	NULL,	NULL,	0,	'2026-07-18 01:54:17.213531+00',	'2026-07-18 01:54:17.213531+00');

DROP TABLE IF EXISTS "user_badges";
CREATE TABLE "public"."user_badges" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "user_id" uuid NOT NULL,
    "badge_id" uuid NOT NULL,
    "granted_by" uuid,
    "granted_at" timestamptz DEFAULT now() NOT NULL,
    "destacada" boolean DEFAULT false NOT NULL,
    CONSTRAINT "user_badges_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX user_badges_user_id_badge_id_key ON public.user_badges USING btree (user_id, badge_id);

CREATE INDEX idx_ub_user ON public.user_badges USING btree (user_id);

CREATE INDEX idx_ub_badge ON public.user_badges USING btree (badge_id);

INSERT INTO "user_badges" ("id", "user_id", "badge_id", "granted_by", "granted_at", "destacada") VALUES
('5c3f0f43-2429-477d-8acf-9ab4e0f307b2',	'dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'fb9e02b9-da2f-4db9-af70-98bac3c56dc0',	NULL,	'2026-07-30 11:19:54.444174+00',	'1');

DROP TABLE IF EXISTS "users";
CREATE TABLE "public"."users" (
    "id" uuid DEFAULT gen_random_uuid() NOT NULL,
    "username" character varying(32) NOT NULL,
    "email" citext,
    "password_hash" text,
    "rol" character varying(20) DEFAULT 'user' NOT NULL,
    "minecraft_username" character varying(100),
    "discord_id" character varying(64),
    "discord_tag" character varying(64),
    "instagram" character varying(64),
    "twitter" character varying(64),
    "deleted_at" timestamptz,
    "created_at" timestamptz DEFAULT now() NOT NULL,
    "updated_at" timestamptz DEFAULT now() NOT NULL,
    "bio" character varying(160),
    "discord_username" character varying(50),
    CONSTRAINT "users_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "users_has_login" CHECK ((((email IS NOT NULL) OR (discord_id IS NOT NULL)))),
    CONSTRAINT "users_rol_check" CHECK ((((rol)::text = ANY ((ARRAY['user'::character varying, 'moderador'::character varying, 'admin'::character varying, 'owner'::character varying])::text[]))))
)
WITH (oids = false);

CREATE UNIQUE INDEX users_username_key ON public.users USING btree (username);

CREATE UNIQUE INDEX users_minecraft_username_key ON public.users USING btree (minecraft_username);

CREATE UNIQUE INDEX idx_users_email ON public.users USING btree (email) WHERE (email IS NOT NULL);

CREATE UNIQUE INDEX idx_users_discord_id ON public.users USING btree (discord_id) WHERE (discord_id IS NOT NULL);

CREATE INDEX idx_users_rol ON public.users USING btree (rol);

CREATE INDEX idx_users_minecraft ON public.users USING btree (minecraft_username);

CREATE INDEX idx_users_deleted_at ON public.users USING btree (deleted_at);

INSERT INTO "users" ("id", "username", "email", "password_hash", "rol", "minecraft_username", "discord_id", "discord_tag", "instagram", "twitter", "deleted_at", "created_at", "updated_at", "bio", "discord_username") VALUES
('9cc1be90-2d9a-4b22-8d71-a5f72c6fca4f',	'Paco',	'test@test.com',	'$2b$12$Y2chQJT8838OoZF1dumHQuPTLUNXuMLl7l.WxB.UOcZFly5mx2TsK',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-18 17:53:49.321824+00',	'2026-07-18 17:53:49.321824+00',	NULL,	NULL),
('c3a9d945-7cf7-4a49-bf80-59fda9c50006',	'UserTest',	'usertestrajoy@gmail.com',	'$2b$12$zv0KDAKI5j65.F3hX9o1xe8lYLpKwbJYVHvTq3tPqn20mYjJElNFa',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-18 20:21:35.198965+00',	'2026-07-18 20:21:35.198965+00',	NULL,	NULL),
('2e14275a-5146-4d84-8a77-b58898c0ef15',	'Pacoo',	'asdas@g.com',	'$2b$12$f1r3VD5KvUhDPuxrUBcYduKlVpIpWix/xQe2gJ4A2nxXQ2heqLtcy',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-19 12:24:44.405357+00',	'2026-07-19 12:24:44.405357+00',	NULL,	NULL),
('8a86faac-9d84-4248-8328-eb939255a719',	'Paco2',	'aaaa@aaa.com',	'$2b$12$t4u27qDWK6TDgQZNNOaU7eNN.qPDpbkpV6v.bkB/BThZzRu5DA/Ra',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-19 15:16:22.576506+00',	'2026-07-19 15:16:22.576506+00',	NULL,	NULL),
('58f8d7fa-b684-4d72-b472-5432970cb896',	'asd',	'asdasdas@asdas',	'$2b$12$nE/ttiWqshPh9W9YnkkpMeWPay8MJPuBnlSw8YXaCZKe/wuHL1jky',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-19 19:30:20.328869+00',	'2026-07-19 19:30:20.328869+00',	NULL,	NULL),
('752c609a-3a2d-44f3-8f76-f3bb23ac38f6',	'NoAprobado',	'noAprobado@a',	'$2b$12$symMZwFT6glT.w6nG6b8be2JSJSrA61HFYLcytBhfDiVYozJac2SW',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-19 19:48:51.033455+00',	'2026-07-19 19:48:51.033455+00',	NULL,	NULL),
('8cbb8546-b791-46d9-a0c0-4aeacf5145aa',	'userAprobado',	'userAprobado@g',	'$2b$12$gtcZwz24AA0vNGSKSVfGVenAd6Jqw6Xe9WE0ntWaZNI8gcU9ui8Mm',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-29 12:15:38.739591+00',	'2026-07-29 12:15:38.739591+00',	NULL,	NULL),
('dcc38e63-d7aa-4dc5-af76-825b88691c8b',	'AdminTest',	'rajoyafiliado@gmail.com',	'$2b$12$4mUfa7bIi5r4wTmIbIz7T.HztICPmfmscKDvnH5v6Si2bSI0yorp2',	'admin',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-18 20:21:02.383094+00',	'2026-07-30 17:44:50.630782+00',	'Estoy MUY LOCO',	'antonio_216'),
('3c3ede51-7331-469b-b8b5-e75ed8127b4c',	'Paquito el chocolatero',	'asdasd@asdasd.com',	'$2b$12$CLpsjJxfnYILzDYfBW8aAOBB4hUSeZD8GbKBDbPMfGFNaTVABXqIe',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-19 15:51:52.764672+00',	'2026-07-30 19:33:51.984335+00',	'Estoy loco',	'asdasd'),
('888df486-8fb5-4eba-b7d0-d262bbf594ff',	'Paco213123123',	'olasaluso@asd',	'$2b$12$Ov0mrd/zb46TwOkbr10D8ObsU.ene1Sg1hwepZxoyYtJCBp5Egobu',	'user',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	'2026-07-30 19:36:07.895406+00',	'2026-07-30 19:36:07.895406+00',	NULL,	NULL);

ALTER TABLE ONLY "public"."access_requests" ADD CONSTRAINT "access_requests_revisado_por_fkey" FOREIGN KEY (revisado_por) REFERENCES "public".users(id) ON DELETE SET NULL;
ALTER TABLE ONLY "public"."access_requests" ADD CONSTRAINT "access_requests_temporada_id_fkey" FOREIGN KEY (temporada_id) REFERENCES "public".temporadas(id) ON DELETE CASCADE;
ALTER TABLE ONLY "public"."access_requests" ADD CONSTRAINT "access_requests_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "public".users(id) ON DELETE SET NULL;

ALTER TABLE ONLY "public"."anuncios" ADD CONSTRAINT "anuncios_autor_id_fkey" FOREIGN KEY (autor_id) REFERENCES "public".users(id) ON DELETE SET NULL;
ALTER TABLE ONLY "public"."anuncios" ADD CONSTRAINT "anuncios_temporada_id_fkey" FOREIGN KEY (temporada_id) REFERENCES "public".temporadas(id) ON DELETE CASCADE;

ALTER TABLE ONLY "public"."creditos_externos" ADD CONSTRAINT "creditos_externos_temporada_id_fkey" FOREIGN KEY (temporada_id) REFERENCES "public".temporadas(id) ON DELETE CASCADE;

ALTER TABLE ONLY "public"."creditos_temporada" ADD CONSTRAINT "creditos_temporada_temporada_id_fkey" FOREIGN KEY (temporada_id) REFERENCES "public".temporadas(id) ON DELETE CASCADE;
ALTER TABLE ONLY "public"."creditos_temporada" ADD CONSTRAINT "creditos_temporada_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "public".users(id) ON DELETE CASCADE;

ALTER TABLE ONLY "public"."estadisticas_jugador" ADD CONSTRAINT "estadisticas_jugador_temporada_id_fkey" FOREIGN KEY (temporada_id) REFERENCES "public".temporadas(id) ON DELETE CASCADE;
ALTER TABLE ONLY "public"."estadisticas_jugador" ADD CONSTRAINT "estadisticas_jugador_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "public".users(id) ON DELETE CASCADE;

ALTER TABLE ONLY "public"."perfil_jugador" ADD CONSTRAINT "perfil_jugador_aprobado_por_fkey" FOREIGN KEY (aprobado_por) REFERENCES "public".users(id) ON DELETE SET NULL;
ALTER TABLE ONLY "public"."perfil_jugador" ADD CONSTRAINT "perfil_jugador_temporada_id_fkey" FOREIGN KEY (temporada_id) REFERENCES "public".temporadas(id) ON DELETE CASCADE;
ALTER TABLE ONLY "public"."perfil_jugador" ADD CONSTRAINT "perfil_jugador_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "public".users(id) ON DELETE SET NULL;

ALTER TABLE ONLY "public"."season_mods" ADD CONSTRAINT "season_mods_temporada_id_fkey" FOREIGN KEY (temporada_id) REFERENCES "public".temporadas(id) ON DELETE CASCADE;

ALTER TABLE ONLY "public"."season_server_configs" ADD CONSTRAINT "season_server_configs_temporada_id_fkey" FOREIGN KEY (temporada_id) REFERENCES "public".temporadas(id) ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_badges" ADD CONSTRAINT "user_badges_badge_id_fkey" FOREIGN KEY (badge_id) REFERENCES "public".badges(id) ON DELETE CASCADE;
ALTER TABLE ONLY "public"."user_badges" ADD CONSTRAINT "user_badges_granted_by_fkey" FOREIGN KEY (granted_by) REFERENCES "public".users(id) ON DELETE SET NULL;
ALTER TABLE ONLY "public"."user_badges" ADD CONSTRAINT "user_badges_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "public".users(id) ON DELETE CASCADE;

DROP TABLE IF EXISTS "export_whitelist";
CREATE VIEW "public"."export_whitelist" AS SELECT u.minecraft_username AS name,
    s.slug AS season
   FROM ((perfil_jugador pj
     JOIN users u ON ((u.id = pj.user_id)))
     JOIN temporadas s ON ((s.id = pj.temporada_id)))
  WHERE (((pj.status)::text = 'aprobado'::text) AND ((s.status)::text = 'activa'::text) AND (u.minecraft_username IS NOT NULL) AND (u.deleted_at IS NULL) AND (pj.deleted_at IS NULL));

-- 2026-07-30 19:54:12 UTC