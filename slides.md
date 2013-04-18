% CF-Primer: Zero to Hero
% Brian Bennett <bahamat@digitalelf.net>, @bahamat
% 2013-04-13

<!-- 
Copyright 2013 Brian Bennett

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

# Welcome!

**CFEngine** is a powerful language for controlling all aspects of a system.  CFEngine runs primarily on UNIX and UNIX like operating systems, but can also run on Windows.

CFEngine is very extensive and powerful. Today you will learn only a subset of what CFEngine can do. A mere tip of the iceberg, but this will represent the bulk of what you do with CFEngine. In other words, you'll learn the 20% of CFEngine that will do 80% of the work.

After today you won't be a *ninja*. But you will be a *hero*. Want to know more? Take Vertical Sysadmin's four day CFEngine course, or just read the reference manual.

# Fork Me on Github!

You can get a copy of this presentation any time on Github.

<http://github.com/bahamat/cf-primer>



# Components of CFEngine

These are the major components of CFEngine that you will encounter on a day to day basis. There are others, but you will rarely (if ever) use them.

* cf-agent
* cf-monitord
* cf-execd
* cf-serverd

However, you will almost always use only `cf-agent`.

# cf-agent

`cf-agent` is the command you will use most often. It is the command that is used to apply policies to your system. If you are running any CFEngine command from the command line, there's a greater than 99% chance that this is it.

# cf-monitord

`cf-monitord` monitors various statistics about the running system. This information is made available in the form of **classes**.

You'll almost never use `cf-monitord` directly. However the classes provided by `cf-monitord` are available to `cf-agent`.

# cf-execd

`cf-execd` is a periodic task scheduler. You can think of it like `cron` on sterroids.

By default CFEngine runs and enforces policies every *five minutes*. `cf-execd` is resposible for making that happen.

# cf-serverd

`cf-serverd` runs on the CFEngine server, as well as all clients.

* On servers it is responsible for serving files to clients.
* On clients it accepts `cf-runagent` requests

What is `cf-runagent`? Look it up in the manual. You will probably never use it.

# Imperative vs. Declarative

It is very likely that you have only ever used **imperative** languages.  Examples of imperative languages include C, Perl, Ruby, Python, shell scripting, etc. Name a language. It's probably imperative.

CFEngine is a **declarative** language. The CFEngine language is merely a *description* of the final state. CFEngine uses **convergence** to arrive at the described state.

# Imperative is Sequential

Imperative languages execute step by step in *sequence*.

Because it is sequential must go in order from start to finish. If a sequential program is interrupted in the middle the state is *inconsistent*. Neither at starting point nor at the finish. Executing the program again will repeat tasks that have already been done, possibly causing damage in doing so.

E.g., a script that appends a line to a file then restarts a daemon. If the line is appended but the daemon not restarted, running the script again will result in that line in the file twice. This will likely cause the daemon to fail when restarted.

Imperative starts at known state A and transforms to known state B.

# Declarative is Descriptive

Declarative moves from chaos to order. It is not a list of steps to arrive at a state but merely a **description** of the desired state. Because of this any deviation from the desired state can be detected and corrected.

In other words, a declarative system can begin in *any* state, not simply a known state, and transform into the desired state.

Declarative states a list of things which must be true. It does not state how to make them true.

When a system as reached the desired state it is said to have reached **convergence**.

# Promise Theory

Promise theory is a model of voluntary cooperation between individual, autonomous actors or agents who publish their intentions to one another in the form of promises.

A file (e.g., `/etc/apache2/httpd.conf`) can make promises about it's own contents, attributes, etc. But it does not make any promises about a process.

A process (e.g., `httpd`) can make a promise that it will be running. But it does not make any promises about its configuration.

Each of the configuration file and the process are *autonomous*. Each makes promises about itself which cooperates toward an end. Promise theory is the fundamental underlying philosophy that drives CFEngine.

# Anatomy of a Promise

    type:
      context::
        "promiser" -> "promisee"
          attribute1 => "value",
          attribute2 => "value";

* **type** is the type of promise being made (e.g., files, commands, etc.).
* **context** is an optional context. Promises with a context will only apply if the given context is true.
* **promiser** is what is making the promise. (e.g., a file or a process).
* **promisee** is an optional recipient or beneficiary of the promise.

# Anatomy of a Promise

    type:
      context::
        "promiser" -> "promisee"
          attribute1 => "value",
          attribute2 => "value";

Each promise has a list of attributes that describe the parameters of the promise.  Every attribute is optional, but the available attributes will vary depending on the *promise type*.

The value can be either a text string (which must be quoted) or another object (which must not be quoted). All of the attributes together are called the **body** of the promise (as in "the body of an e-mail").

Attributes are separated by *commas*. Each promise ends with a *semi-colon*.

# Anatomy of a Promise

    files:
      linux::
        "/tmp/hello/world" -> "Student"
          create => "true";

This is an example promise.

* This is a promise of **type** `files`.
* This promise has a **class context** of `linux` (it will only apply if running a Linux kernel).
* The **promiser** is the POSIX path `/tmp/hello/world`.
* This promise has only one **attribute**, specifying that the file should be created if it does not exist.
* The **promisee** is *you!*

# Bundles

A **bundle** is a collection of **promises**. It is a logical grouping of any number of promises, usually for a common purpose. E.g., a bundle to configure everything necessary for Apache to function properly.

For example, a bundle to configure Apache might:

* install the apache2 package
* edit the configuration file
* copy the web server content
* configure filesystem permissions
* ensure the `httpd` process is running
* restart the `httpd` process when necessary

# Anatomy of a Bundle

    bundle type name {

      type:
        context::
          "promiser" -> "promisee"
            attribute1 => "value",
            attribute2 => "value";

      type:
        context::
          "promiser" -> "promisee"
            attribute1 => "value",
            attribute2 => "value";

    }

Bundles apply to the binary that executes them. E.g., `agent` bundles apply to `cf-agent` while `server` bundles apply to `cf-serverd`.

Bundles of type `common` apply to any CFEngine binary.

For now you will only create `agent` or `common` bundles.

# Bodies

I stated before that the attributes of a promise are called the body. The value of an attribute can also be another **body**.

A **body** is a collection of *attributes*. These are attributes that supplement the promise.

# Anatomy of a Body

    body type name {
      attribute1 => "value";
      attribute2 => "value";
    }

The major difference between a *bundle* and a *body* is that a bundle contains *promises* while a *body* contains only *attributes*.

Take a moment to let this sink in.

* A **bundle** is a collection of *promises*.
* A **body** is a collection of *attributes* that is applied to a promise.

The distinction is subtle, especially at first and many people are tripped up by this.

In a body each attribute ends with a *semi-colon*.

# Bundles & Bodies

Bundles and bodies can be created as reusable objects. In other words you can define one and then call it like a function, even passing in parameters which will implicitly become variables.

Here's an example:

    body type name (param) {
      attribute1 => "$param";
    }

The parameter `param` is accessed as a variable by `$param`. You can name your parameters anything you like.

# The Community Open Promise Body Library

TODO: `cfengine_stdlib.cf`

# Putting it all together

These are the building blocks. You now know what they all are.

### Congratulations!

You'll now be walked through some example bundles (and accompanying bodies) that will  each accomplish a single atomic task.

|      Let's see it in practice.

# Set File Permissions

    bundle agent example {
      files:
        "/etc/shadow"     perms => root_shadow;
        "/etc/gshadow"    perms => root_shadow;
    }

    body perms root_shadow {
      owners => { "root" };
      groups => { "shadow" };
      mode   => "0640";
    }

* This is an **agent** bundle (meaning that it is processed by `cf-agent`).
* Its purpose is to set the permissions on `/etc/shadow` and `/etc/gshadow`.
* It uses an external body named `root_shadow`.
* The body only needs to be defined once and can be reused for any number of promises.

Note: The values for `owners` and `groups` is enclosed in curly braces. This is because these attributes take a list (`slist`).

# Copy an Entire File

    bundle agent example {
      files:
        "/etc/motd"     copy_from => cp("/repo/motd");
    }

    body copy_from cp (from) {
      servers     => { "$(sys.policy_hub)" };
      source      => "$(from)";
      compare     => "digest";
    }

* The purpose of this bundle is to copy `/etc/motd` from the CFEngine server
* `$(sys.policy_hub)` is an automatic variable which contains the CFEngine server's address.
* The path `/repo/motd` is on the *server's* filesystem.
* The `compare` type tells CFEngine how to know when the file needs updating.

# Edit a File

    bundle agent example {
      files:
        "/etc/ssh/sshd_config"     edit_line => deny_root_ssh;
    }

    bundle edit_line deny_root_ssh {
      delete_lines:
        "^PermitRootLogin.*"
      insert_lines:
        "PermitRootLogin no"
    }

* This will delete any line matching the regular expression `^PermitRootLogin.*`.
* This also inserts the line `PermitRootLogin no` *at the end of the file*.
* CFEngine is smart enough to know not to edit the file if the end result is already **converged**.
* This is an overly simplistic example. When editing configuration files you probably want to copy the whole file or use `set_config_values()` from `cfengine_stdlib.cf`.

# Use classes to control flow and/or promise selection

# setting up/organizing a client server environment

# keeping services running

# installing packages

# deleting old log files

# Check a Filesystem for Low Disk Space

# Administratively:

- keeping track of what repairs were done and which failed
- debugging (using verbose mode)

# Pro Tips

TODO: list