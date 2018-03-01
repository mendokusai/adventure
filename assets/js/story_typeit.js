import TypeIt from 'typeit';

export var StoryText = {
  type: (strings) => {
    let typer = new TypeIt('.type-text', {
      typeSpeed: 0,
      breakLines: true,
      lifeLike: true,
      typeDelay: 3000,
      fadeIn: true
    });
    // type(strings);
    const lines = strings.split(". ");
    for(let line of lines) {
      typer.
      type(indent(line)).
      pause(makeRandom());
    }

    function makeRandom(base = 100, max = 50) {
      return base + (Math.floor(Math.random() * Math.floor(max)));
    }

    function indent(line) {
      const CHANGE = 3
      const num = Math.floor(Math.random() * Math.floor(CHANGE));
      if (num == 1) {
        return `${line}</p><p>   `;
      } else {
        return line;
      }
    }
  }
};
