import Typed from 'typed.js';

export var StoryText = {
  typed: (arg1) => {
    var typed = new Typed(".brunch-dat-ish", {
      strings: arg1.split(", "),
      typeSpeed: 50,
      shuffle: true,
    });
    typed;
  }
};
