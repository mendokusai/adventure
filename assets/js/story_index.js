import Typed from 'typed.js';

export var PlaceHolder = {
  type: () => {
    var type = new Typed('#typed4', {
      strings: [
        'What type of adventure do you want?',
        'Slay some dragons',
        'Obama and Trump vs the ghost of democracy',
        'Swim in bubblegum with Al Green',
        'Burnanate the countryside - Trogdor!',
        'Dive for pearls in Japan',
        'John Lennon slamdancing for money',
        'Anything you want!',
        'What type of adventure do you want?'
      ],
      typeSpeed: 10,
      backSpeed: 3,
      attr: 'placeholder',
      bindInputFocusEvents: true,
      loop: false
    });
    type;
  }
};
