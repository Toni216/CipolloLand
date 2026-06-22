# Base de datos — CipolloLand

PostgreSQL 16 en Docker. **Toda interacción directa con la BD se hace desde esta carpeta.**
Los scripts son envoltorios finos sobre `docker compose`: postgres vive en el contenedor y
cada operación (psql, pg_dump, etc.) se ejecuta **dentro** del contenedor vía `docker compose exec`.
No se instala nada en tu máquina salvo Docker.

## Requisitos

- Docker + Docker Compose v2 (`docker compose`). Funciona también con v1 (`docker-compose`).

## Puesta en marcha

```bash
cp .env.example .env      # linux/macOS   (Windows: copy .env.example .env)
```

Luego según tu SO:

| Acción | Linux/macOS | Windows (PowerShell) | Windows (CMD) |
|---|---|---|---|
| Levantar | `scripts/linux/start.sh` | `scripts\windows\powershell\start.ps1` | `scripts\windows\cmd\start.cmd` |
| Parar (conserva datos) | `stop.sh` | `stop.ps1` | `stop.cmd` |
| Reiniciar | `restart.sh` | `restart.ps1` | `restart.cmd` |
| Reset (BORRA datos) | `reset.sh` | `reset.ps1` | `reset.cmd` |
| Estado | `status.sh` | `status.ps1` | `status.cmd` |
| Logs | `logs.sh` | `logs.ps1` | `logs.cmd` |
| Shell psql | `psql.sh` | `psql.ps1` | `psql.cmd` |
| Backup | `backup.sh` | `backup.ps1` | `backup.cmd` |
| Restore | `restore.sh <f.sql>` | `restore.ps1 <f.sql>` | `restore.cmd <f.sql>` |
| GUI Adminer | `tools.sh` | `tools.ps1` | `tools.cmd` |

> Linux/macOS: dar permisos una vez con `chmod +x scripts/linux/*.sh` (ya vienen marcados en el repo).
> PowerShell: si bloquea la ejecución → `Set-ExecutionPolicy -Scope Process Bypass`.

## Conexión desde la app (Next.js / Prisma)

En el `.env` de la **raíz del proyecto**:

```
DATABASE_URL="postgresql://cipolloland:cipolloland@localhost:5432/cipolloland?schema=public"
```

Ajusta usuario/clave/puerto si los cambiaste en `db/.env`.

## Migraciones (Prisma)

El **esquema** lo gestiona Prisma desde la raíz del proyecto, no estos scripts:

```bash
pnpm prisma migrate dev     # crear/aplicar migraciones en local
pnpm prisma studio          # inspector
```

Estos scripts solo gestionan el **ciclo de vida del contenedor** y el **acceso crudo** (psql,
backup/restore). Tras un `reset`, reaplica migraciones con `pnpm prisma migrate dev`.

## Comandos crudos (sin scripts)

Desde `db/`, equivalente a lo que hacen los scripts:

```bash
docker compose up -d postgres
docker compose exec postgres psql -U cipolloland -d cipolloland
docker compose exec -T postgres pg_dump -U cipolloland -d cipolloland > backups/dump.sql
docker compose down            # parar
docker compose down -v         # parar + BORRAR volumen
```

## Estructura

```
db/
  docker-compose.yml      # servicio postgres (+ adminer opcional, perfil "tools")
  .env.example            # plantilla de configuración
  init/                   # SQL de init (solo 1ª vez, volumen vacío)
  backups/                # volcados (gitignored)
  scripts/
    linux/                # *.sh
    windows/powershell/   # *.ps1
    windows/cmd/          # *.cmd
```

## Notas

- El puerto se publica solo en `127.0.0.1` → no accesible desde la red externa.
- Datos persistidos en el volumen `cipolloland-pgdata` (sobreviven a `stop`/`restart`, no a `reset`).
- Credenciales en `db/.env` (gitignored). Cámbialas antes de cualquier despliegue real.
