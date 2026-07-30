-- Los datos que sabemos >:D
INSERT INTO temporadas (numero, slug, nombre, subtitulo, status, year, open_date, description, requires_character_sheet) VALUES
  (1, 't1', 'CipolloLand 0', 'Random Bullshit Go',              'archivada',    2024, '2024-07-14 00:00:00+02', 'La primera temporada de CipolloLand, donde todo empezó',                FALSE),
  (2, 't2', 'CipolloLand 1', 'Medieval Edition',                'archivada',    2025, '2025-07-27 00:00:00+02', 'El próspero reino de Cipollo, donde la magia florece o conoce su fin', FALSE),
  (3, 't3', 'CipolloLand 2', 'Apocalypse Edition',              'activa',       2026, '2026-08-01 17:30:00+02', 'El mundo ha caido, los zombies son la criatura dominante.',              FALSE),
  (4, 't4', 'CipolloLand 4', 'Por decidir',                     'proximamente', 2027, NULL,                     NULL,                                                                    FALSE);

INSERT INTO badges (nombre, descripcion, icono, color, grant_access) VALUES
  ('Amiwi',   'Amigo bien guapo',          '🫂', '#20B2AA', true),
  ('Admin',   'Admin bien duro',           '⚔️', '#ff0000', true),
  ('Donante', 'Ha donado al servidor',     '🏅', '#ffd700', false);