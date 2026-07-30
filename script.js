#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

// --- CONFIGURACIÓN ---
const CONNECTION_STRING =
  process.env.DATABASE_URL ||
  'postgresql://neondb_owner:npg_owLG4hWan0Od@ep-broad-mouse-zafr33sg.c-2.eu-west-2.aws.neon.tech/neondb?sslmode=require';

async function main() {
  const sqlFilePath = process.argv[2];

  if (!sqlFilePath) {
    console.error('❌ Debes indicar la ruta del archivo .sql');
    console.error('   Uso: node run-sql-neon.js ./archivo.sql');
    process.exit(1);
  }

  const fullPath = path.resolve(sqlFilePath);

  if (!fs.existsSync(fullPath)) {
    console.error(`❌ No se encontró el archivo: ${fullPath}`);
    process.exit(1);
  }

  console.log(`📄 Leyendo archivo: ${fullPath}`);
  const sql = fs.readFileSync(fullPath, 'utf8');
  console.log(`   Tamaño: ${(sql.length / 1024 / 1024).toFixed(2)} MB`);

  const client = new Client({
    connectionString: CONNECTION_STRING,
    ssl: { rejectUnauthorized: false }, // Neon requiere SSL
  });

  console.log('🔌 Conectando a Neon...');
  await client.connect();
  console.log('✅ Conectado.');

  const start = Date.now();

  try {
    console.log('🚀 Ejecutando script SQL (puede tardar si es grande)...');

    // node-postgres soporta múltiples sentencias separadas por ";"
    // en una sola llamada a query() usando el protocolo "simple query".
    await client.query(sql);

    const seconds = ((Date.now() - start) / 1000).toFixed(2);
    console.log(`✅ Script ejecutado correctamente en ${seconds}s.`);
  } catch (err) {
    console.error('❌ Error ejecutando el script SQL:');
    console.error(err.message);
    // Info útil para localizar el problema en archivos grandes
    if (err.position) {
      const pos = parseInt(err.position, 10);
      const snippet = sql.slice(Math.max(0, pos - 100), pos + 100);
      console.error('\n--- Contexto alrededor del error ---');
      console.error(snippet);
      console.error('-------------------------------------');
    }
    process.exitCode = 1;
  } finally {
    await client.end();
    console.log('🔌 Conexión cerrada.');
  }
}

main().catch((err) => {
  console.error('❌ Error inesperado:', err);
  process.exit(1);
});