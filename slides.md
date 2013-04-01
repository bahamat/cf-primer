# CFEngine: Zero to Hero

# Intro

Welcome!

**CFEngine** is a powerful language for controling all aspects of a system.
CFEngine runs primarily on UNIX and UNIX like operating systems, but can
also run on Windows.

CFEngine is very extensive and powerful. Today you will learn only a subset
of what CFEngine can do. A mere tip of the iceburg, but this will represent
the bulk of what you do with CFEngine.

In other words, you'll learn the 20% of CFEngine that will do 80% of the work.
Want to know more? Take Vertical Sysadmin's four day CFEngine course, or
just read the reference manual.

# Components of CFEngine

These are the major components of CFEngine that you will encounter on a day
to day basis. There are others, but you will rarely (if ever) use them.

* cf-agent
* cf-monitord
* cf-execd
* cf-serverd

However, you will almost always use only `cf-agent`.

# cf-agent

`cf-agent` is the command you will use most often. It is the command that
is used to apply policies to your system. If you are running any CFEngine
command from the command line, there's a greater than 99% chance that this
is it.

# cf-monitord

`cf-monitord` monitors various statistics about the running system. This
information is made available in the form of **classes**.

You'll almost never use `cf-monitord` directly. However the classes provided
by `cf-monitord` are available to `cf-agent`.

# cf-execd

`cf-execd` is a periodic task scheduler. You can think of it like `cron` on
sterroids.

By default CFEngine runs and enforces policies every *five minutes*. `cf-execd`
is resposible for making that happen.

# cf-serverd

`cf-serverd` runs on the CFEngine server, as well as all clients.

* On servers it is responsible for serving files to clients.
* On clients it accepts `cf-runagent` requests

What is `cf-runagent`? Look it up in the manual. You will probably never use
it.

# Imperative vs. Declarative

It is very likely that you have only ever used **imperative** languages.
Examples of imperative languages include C, Perl, Ruby, Python, shell
scripting, etc. Name a language. It's probably imperative.

CFEngine is a **declarative** language. The CFEngine language is merely
a *description* of the final state. CFEngine uses **convergence** to
arrive at the described state.

# Imperative is Sequential

Imperative languages execute step by step in *sequence*.

Because it is sequential must go in order from start to finish. If a sequential
program is interrupted in the middle the state is *inconsistent*. Neither at
starting point nor at the finish. Executing the program again will repeat
tasks that have already been done, possibly causing damage in doing so.

E.g., FIXME

# Declarative is Descriptive

Declarative moves from chaos to order. From any state to converged.
Declarative
Sequential cant solve a Rubik's cube, declarative can.

• attribute a, attribute b (descriptive)

# Promise Theory

# Anatomy of a Promise

# Bundles

Bundles are collections of promises.

# Bodies

Bodies are a collection of *attributes*.

# file copying

# file editing

# using classes to control flow and/or promise selection

# setting up/organizing a client server environment

# keeping services running

# installing packages

# deleting old log files

# Administratively:

- keeping track of what repairs were done and which failed
- debugging (using verbose mode)
