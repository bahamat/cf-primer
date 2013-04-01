cf-primer
=========

A primer for CFEngine, a mini zero-to-hero introduction to help get you productive.

This is a slide show using [DZSlides](http://paulrouget.com/dzslides/).

You will need [pandoc](http://johnmacfarlane.net/pandoc/) version 1.11.1 or
later (but possibly earlier) to convert `slides.md` into `slides.html`.
(Debian stable is unfortunately 1.5.1.1 and does not have DZSlides support).

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
    cabal install pandoc

`pandoc` will be installed to `~/.cabal/bin/pandoc`. You will need to ensure
that `~/.cabal/bin/pandoc` is in your path.

### On Debian based distributions

Debian wheezy and previous

    sudo apt-get install haskell-platform
    sudo cabal install pandoc

Debian unstable

    sudo apt-get install pandoc

### On RPM based distributions

If `pandoc` 1.11.1 is available:

    sudo yum install pandoc

else:

    sudo yum install haskell-platform
    sudo cabal install pandoc
