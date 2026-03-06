import './App.css';

function App() {
  return (
    <>
      <div class="landing">
        <h1 class="titulo nombre">CipolloLand</h1>
        <h1 class="titulo numero">2</h1>
        <h2 class="titulo edicion">Apocalipsis Edition</h2>
      </div>
      <nav class="nav">
        <div class="menu lore">Lore</div>{' '}
        <div class="menu personajes">Personajes</div>{' '}
        <div class="menu jugadores">Jugadores</div>
      </nav>
      <footer>
        <div>CipolloLand 2026</div>
        <div>
          <p>Términos y Condiciones</p>
          <p>Política de privacidad</p>
          <p>About</p>
        </div>
        <div>
          <p>GitHub</p>
          <p>Discord</p>
        </div>
      </footer>
    </>
  );
}

export default App;
