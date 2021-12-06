# Day 6

This was a fun one - let's do a AoC solution in a language specifically designed for creating websites,
[Elm](https://elm-lang.org/)!

I've been meaning to try Elm for a long time, and this seemed like a good (actually it's a terrible reason) excuse to
try it.

---

To run, I [installed Elm](https://guide.elm-lang.org/install/elm.html), and also installed
[elm-live](https://github.com/wking-io/elm-live). The second is a nice tool that served a
static HTTP server for me to pass in my `input.txt` file, along with hot-reloading functionality as I made
my changes.

So all I needed to do was:

```bash
elm-live src/Main.elm --open
```

And you'll get a hot-reloading browser page to display your answers:

![Demo](./demo.png)
