import Typed from 'typed.js';

export const StoryText = {
    type_out: (arg1) => {
        const options = {
          strings: arg1.split(". "),
          typeSpeed: 50,
          smartBackspace: false,
          shuffle: true
        }
        new Typed(".brunch-dat-ish", options)();
    }
}
