# [Choose-dat-adventure](http://choose-dat-adventure.herokuapp.com/begin)

👋 Hiya! This is a xmas 2017 holiday messaround.

Goal was to create a story-building app fed by user input. This uses Google's Natural Language API to break down input, then searches `fanfiction.net` and `wikipedia.org` for resources, and stitches it up in a markov chain to spit out something inhumane.

### Why?
Goal is to play with Elixir, explore new things, leverage some existing knowledge. Enjoying holidays. Learned a little about myself, my tolerance, and elixir async tasks. 🎅🏼 🍻

TODO:
- Make this a proper CYOA.
- Fix wikipedia scraping (get too many glyphs and dates)
- Gameify!
- Profit

### Boilerplate, but useful.
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).
