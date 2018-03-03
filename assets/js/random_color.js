// Comes up with random hex color
export const Hex = {
  color: (elem) => {
    const hex = '#'+Math.floor(Math.random()*16777215).toString(16);
    elem.style.color = hex;
  }
}
