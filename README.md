cf-primer
=========

A primer for CFEngine, a mini zero-to-hero introduction to help get you productive.

This is a slide show using [Slidy2](http://www.w3.org/Talks/Tools/Slidy2).

You will need [pandoc](http://johnmacfarlane.net/pandoc/) version 1.9.1.1
or later (but possibly earlier) to convert `slides.md` into `slides.html`.
(Debian stable is unfortunately 1.5.1.1 and does not have support for some
of the options I use).

You will also need [graphviz](http://www.graphviz.org).

## Getting Started.

1. Once you have `pandoc` installed simply run `make` to build `slides.html`.
2. Open `slides.html` in any modern web browser, preferably in full screen.

## Installing pandoc

Note: at current I have only tested installing on Mac OS X using Homebrew.
Let me know how it goes!

### On Mac OS X using Homebrew

Using Homebrew is workable, although not as simple or straightforward as I
would like.

    brew install haskell-platform
    cabal update
    cabal install cabal-install
    cabal install pandoc

`pandoc` will be installed to `~/.cabal/bin/pandoc`. You will need to ensure
that `~/.cabal/bin/pandoc` is in your path.

### On Debian based distributions

If `pandoc` 1.9.1.1 or later is available:

    sudo apt-get install pandoc

else:

    sudo apt-get install haskell-platform
    sudo cabal install pandoc

### On RPM based distributions

Use the [justhub](http://www.justhub.org/download) Haskell distribution then
install `pandoc` via cabal.

    sudo cabal install pandoc

### On any other Unix like system

Try the community supported
[Haskell platform](http://www.haskell.org/platform/linux.html) packages.
Then, you guessed it, install `pandoc` via cabal.

    sudo cabal install pandoc
