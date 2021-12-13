# Day 13

It's [OCaml](https://ocaml.org/) day today! Another language I have experience in because of
CS 442, except I wrote this one a lot more compared to the others.

Honestly, not too hard in terms of the problem, the longest part was remembering
how to set up OCaml's build system (opam and dune were "fun" to set up), and some boilerplate
(mostly input processing and stuff). I didn't use as many features of the language as I should
(just take a look at that partition function...), but after that, it was all good.

---

To run, install OCaml, then [`opam`](https://opam.ocaml.org/), then install core
(this is unironically probably the hardest part; I'm skipping over the OCaml install because
it's really annoying, just Google it):

```bash
opam install core
```

You might also want to install `dune` via opam as well, which helps a lot, as you can set it
to watch your OCaml code continuously and give errors, or just having a pretty sane compile command:

```bash
opam install dune
```

Alternatively, you can use `ocamlfind`, `ocamlc`, `ocamlbuild`, or whatever, but I used `dune`.

Therefore, to actually run it, in this directory, with `input.txt` in it, I just did:

```bash
dune exec ./day_13.exe
```

Note that even on Unix-based systems, the compiled file is of the `.exe` format.
