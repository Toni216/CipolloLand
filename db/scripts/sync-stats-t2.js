const fs = require('fs')
const path = require('path')

// Carpeta donde tengas los archivos <uuid>.json de stats de T2
// (la carpeta "stats" que descomprimiste, tal cual)
const STATS_DIR = 'D:/Escritorio/stats-t2'

const API_URL = 'http://localhost:3000/api/t3/estadisticas/sync'
const SECRET = process.env.STATS_SYNC_SECRET // el mismo valor que pusiste en .env.local
const TEMPORADA_SLUG = 't2'

function metrosACm(valorCm) {
  return valorCm / 100000
}

// Pequeña pausa entre peticiones para no pasarnos del límite de la API de Mojang
function esperar(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

async function resolverNick(uuid) {
  try {
    const res = await fetch(`https://sessionserver.mojang.com/session/minecraft/profile/${uuid}`)
    if (!res.ok) return null
    const data = await res.json()
    return data.name ?? null
  } catch {
    return null
  }
}

async function main() {
  const archivos = fs.readdirSync(STATS_DIR).filter(f => f.endsWith('.json'))
  const jugadores = []

  console.log(`Encontrados ${archivos.length} archivos de stats. Resolviendo nicks...\n`)

  for (const archivo of archivos) {
    const uuid = archivo.replace('.json', '').replace(/-/g, '')

    const nick = await resolverNick(uuid)
    await esperar(350) // pequeña pausa de cortesía entre llamadas a la API de Mojang

    if (!nick) {
      console.log(`  ⚠ No se pudo resolver el nick de ${uuid}, se omite.`)
      continue
    }

    const data = JSON.parse(fs.readFileSync(path.join(STATS_DIR, archivo), 'utf-8'))
    const stats = data.stats ?? {}
    const custom = stats['minecraft:custom'] ?? {}
    const mined = stats['minecraft:mined'] ?? {}
    const used = stats['minecraft:used'] ?? {}

    const bloquesRotos = Object.values(mined).reduce((a, b) => a + b, 0)
    const bloquesColocados = Object.values(used).reduce((a, b) => a + b, 0)

    const distanciaCm =
      (custom['minecraft:walk_one_cm'] ?? 0) +
      (custom['minecraft:sprint_one_cm'] ?? 0) +
      (custom['minecraft:swim_one_cm'] ?? 0) +
      (custom['minecraft:boat_one_cm'] ?? 0) +
      (custom['minecraft:horse_one_cm'] ?? 0)

    const horasJugadas = Math.round(((custom['minecraft:play_time'] ?? 0) / 20 / 3600) * 100) / 100
    const kills = custom['minecraft:mob_kills'] ?? 0
    const muertes = custom['minecraft:deaths'] ?? 0

    jugadores.push({
      minecraft_username: nick,
      horas_jugadas: horasJugadas,
      kills,
      muertes,
      bloques_colocados: bloquesColocados,
      bloques_rotos: bloquesRotos,
      distancia_recorrida_km: metrosACm(distanciaCm),
    })

    console.log(`  ✓ ${nick}: ${horasJugadas}h, ${kills} kills, ${muertes} muertes, ${bloquesColocados} colocados, ${bloquesRotos} rotos, ${(distanciaCm/100000).toFixed(1)}km`)
  }

  console.log(`\nProcesados ${jugadores.length} jugadores. Enviando a la API...`)

  const res = await fetch(API_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'x-stats-secret': SECRET },
    body: JSON.stringify({ jugadores, temporada_slug: TEMPORADA_SLUG }),
  })
  const resultado = await res.json()
  console.log('\nResultado de la sincronización:', resultado)
}

main().catch(err => {
  console.error('Error en la sincronización:', err)
  process.exit(1)
})