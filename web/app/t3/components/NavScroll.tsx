'use client'

import { useEffect, useState } from 'react'
import Navbar from './Navbar'
import InfoStrip from './InfoStrip'

interface Props {
  jugadores: number
  siempre?: boolean
}

export default function NavScroll({ jugadores, siempre = false }: Props) {
  const [showNav, setShowNav] = useState(siempre)

  useEffect(() => {
    if (siempre) return
    const handleScroll = () => {
      setShowNav(window.scrollY > window.innerHeight * 0.8)
    }
    window.addEventListener('scroll', handleScroll)
    return () => window.removeEventListener('scroll', handleScroll)
  }, [siempre])

  if (!showNav) return null

  return (
    <div style={{
      position: 'fixed', top: 0, left: 0, right: 0,
      zIndex: 500,
      animation: 'navFadeIn 0.3s ease'
    }}>
      <Navbar />
      <InfoStrip jugadores={jugadores} />
    </div>
  )
}