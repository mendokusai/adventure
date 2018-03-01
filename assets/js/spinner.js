export var Load = {
  spinner: () => {
    window.captureEvents(Event.TRIGGER);
    window.onsubmit = () => {
      const inp = document.getElementsByTagName("input")[2].value;
      if (inp.length > 0) {
        let spinner = document.getElementById('adventure-spinner');
        let elem = document.createElement("img");
        elem.setAttribute("src", "images/sm_loading.gif");
        elem.setAttribute("height", "400");
        elem.setAttribute("width", "49");
        elem.setAttribute("alt", "loading");
        spinner.appendChild(elem);
      }
    }
  }
}
