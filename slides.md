% CF-Primer: Zero to Hero
% Brian Bennett <bahamat@digitalelf.net>, @bahamat
% 2013-04-13

# Welcome!

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

**CFEngine** is a powerful language for controlling all aspects of a system.  CFEngine runs primarily on UNIX and UNIX like operating systems, but can also run on Windows.

CFEngine is very extensive and powerful. Today you will learn only a subset of what CFEngine can do. A mere tip of the iceberg, but this will represent the bulk of what you do with CFEngine. In other words, you'll learn the 20% of CFEngine that will do 80% of the work.

After today you won't be a *ninja*. But you will be a *hero*. Want to know more? Take Vertical Sysadmin's four day CFEngine course, or just read the reference manual.

# Fork Me on Github!

You can get a copy of this presentation any time on Github.

<http://github.com/bahamat/cf-primer>

This presentation will be updated in the future, but you can find the exact version used today tagged with today's date.

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
* To create a directory instead, use a `files:` promise and append a `.` to the directory name (e.g., `"/tmp/hello/."`)

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
      attribute1 => "$(param)";
    }

The parameter `param` is accessed as a variable by `$(param)`. You can name your parameters anything you like.

# The CFEngine Standard Library

The **CFEngine Standard Library** comes bundled with CFEngine in the file `cfengine_stdlib.cf`.

The standard library contains ready to use bundles and bodies that you can include in your promises and is growing with every version of CFEngine. Get to know the standard library well, it will save you much time.

# Putting it All together

These are the building blocks. You now know what they all are.

### Congratulations!

You'll now be walked through some example bundles (and accompanying bodies) that will  each accomplish a single atomic task.

<!-- In each example that includes a complete bundle, try running it on your virtual machine. Save all of the files for future ~~cannibalization~~ reference.

To execute a policy run the following command:

    $ cf-agent --file ./test.cf --bundle bundlename -->

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

# Introduction to Classes

A **class** is like a tag (like tagging a photo). Classes are used to give a promise *context*. There are two types of classes.

1. **Hard classes**. These are classes that CFEngine will create automatically. Hard classes are determined based on the system attributes. For example a server running Linux will have the class `linux`.
2. **Soft classes**. These are classes that are defined by you. You can create them based on the outcome of a promise, based on the existence of other classes, or for no reason.

# Example Classes From a Live System

Here is a list of hard classes defined on an actual system running CFEngine.

    cf3>  -> Hard classes = { 127_0_0_2 2_cpus 32_bit April Day23 Evening GMT_Hr3
    Hr20 Hr20_Q3 Lcycle_0 Min30_35 Min31 PK_MD5_1a66e41f5cca80e636636702476cf925 Q3
    Tuesday Yr2013 any cfengine cfengine_3 cfengine_3_4 cfengine_3_4_3 common
    community_edition compiled_on_linux_gnu debian debian_6 debian_6_0 have_aptitude
    i686 ipv4_127 ipv4_127_0 ipv4_127_0_0 ipv4_127_0_0_2 linux linux_2_6_18_pony6_3
    linux_i686 linux_i686_2_6_18_pony6_3
    linux_i686_2_6_18_pony6_3__1_SMP_Tue_Mar_13_07_31_44_PDT_2012
    mac_00_00_00_00_00_00 net_iface_eth0 verbose_mode } 

# Use Classes to Control Promise Selection

    bundle agent apache_config {
      files:
        
        debian::
          "/etc/apache2/apache2.conf"
            copy_from => remote_cp("/cfengine/repo/debian/apache2.conf","$(sys.policy_hub)");
        redhat::
          "/etc/httpd/conf/httpd.conf"
            copy_from => remote_cp("/cfengine/repo/redhat/httpd.conf","$(sys.policy_hub)");
        solaris::
          "/etc/apache2/2.2/httpd.conf"
            copy_from => remote_cp("/cfengine/repo/solaris/httpd.conf","$(sys.policy_hub)");
    
    }

This set of promises will copy the appropriate apache config file depending on the type of server. Notice that each file promise is prefixed by a *class*. The promise will be skipped unless that class is defined on the system.

Thus, only Debian systems will run the `debian::` context promise, only Red Hat will run `redhat::` and only Solaris will run `solaris::`.

# A Note About Classes and Distributions Based on Other Distributions

I said that only Debian systems will run `debian::` and only Red Hat will run `redhat::`. This isn't exactly true.

* Ubuntu is based on Debian, and so will have both `ubuntu` and `debian` defined as a hard classes.
* Likewise, CentOS is based on Red Hat and so will have both `centos` and `redhat` defined as hard classes.

This goes for any distro that is based on another distro. The "parent" classes will be also defined.

# Use Classes to Control Flow

    bundle agent apache_config {
      files:
        
        "/etc/apache2/apache2.conf"
          copy_from => remote_cp("/cfengine/repo/debian/apache2.conf","$(sys.policy_hub)")
            classes => if_repaired("RestartApache");

      commands:
      
        RestartApache::
          "/usr/sbin/apache2ctl graceful";
    }

This set of promises will first copy the Apache configuration file. Once the Apache configuration file is updated, Apache must be restarted. In order to make sure that Apache gets restarted when necessary a class will be defined when the configuration file is updated.

When CFEngine reaches the commands section, if the `RestartApache` class is defined (which only happens if the config file is updated) then Apache will be restarted.

# Use Classes to Control Flow

    bundle agent apache_config {
      files:
        
        "/etc/apache2/apache2.conf"
          copy_from => remote_cp("/cfengine/repo/debian/apache2.conf","$(sys.policy_hub)"),
            classes => if_repaired("RestartApache");

      commands:
      
        RestartApache::
          "/usr/sbin/apache2ctl graceful";
    }

So, the workflow then is:

1. Perform promise 1
2. Define a class if repaired
3. Perform promise 2 if the class has been set

I use this ALL. THE. TIME. If this class is to teach you 20% that accomplishes 80%, *this slide* is the 5% that accomplishes 95%.

# Compound Classes

    ...
      commands:
        RestartApache.debian::
          "/usr/sbin/apache2ctl graceful";
        RestartApache.redhat::
          "/usr/sbin/apachectl graceful";
    }

This example is similar to the last one, except that Debian and Redhat each have different commands used to restart Apache. Therefore, we use a compound boolean class context. The expression `RestartApache.debian` means "RestartApache *and* debian".

# Compound Classes

    ...
      commands:
        RestartApache.debian::
          "/usr/sbin/apache2ctl graceful";
        RestartApache.redhat::
          "/usr/sbin/apachectl graceful";
    }

  Operator       Meaning            Example
-------------    -----------        --------
  `.` and `&`       boolean *and*      `debian.Tuesday::`
  `|` and `||`      boolean *or*       `Tuesday|Wednesday::`
  `!`            boolean *not*      `!Monday::`
  `( )`          Explicit grouping  `(debian|redhat).!ubuntu.!centos::`

# Keep Services Running: Using Processes

    bundle agent apache {
    
    processes:
    
      "apache2"
        restart_class => "StartApache";
    
    commands:
      StartApache::
        "/etc/init.d/apache2 start";
      
    }

This policy uses a `processes` promise to check the process table (with `ps`) for the regular expression `.*apache2.*`. If it is not found then the class `StartApache` will get defined.

When CFEngine executes `commands` promises Apache will be started.

# Ensuring Processes are Not Running: Using Processes and Commands

    bundle agent stop_cups {
    
      processes:
   
        "bluetoothd"
          process_stop => "/etc/init.d/cups stop";
    }

This policy uses a `processes` promise to check the process table (with `ps`) for the regular expression `.*bluetoothd.*`. If it is found the `process_stop` command is executed.

# Ensuring Processes are Not Running: Using Processes and Signals

    bundle agent stop_cups {
    
      processes:
   
        "bluetoothd"
          signals => { "term", "kill" };
    }

This policy uses a `processes` promise to check the process table (with `ps`) for the regular expression `.*bluetoothd.*`. Any matching process is sent the `term` signal, then sent the `kill` signal.

**Note:** The promise `"bluetoothd"` becomes the *regular expression*, `.*bluetoothd.*` that is matched against the output of `ps`. This means that it can match *anywhere* on the line, not just the process name field. *Caveat emptor!*

# Keep Services Running: Using Services

    bundle agent apache {
      services:
    
        "www"
          service_policy => "start";
    }

This uses the `services` promise type to ensure that Apache is always running. This only works for services that are defined under `standard_services` in `cfengine_stdlib.cf` and requires cfengine 3.4.0 or higher.

`services` promises currently only work Linux are distro intelligent. That is, this promise example above works equally well on Debian/Ubuntu, Red Hat/CentOS or SUSE (and derived distros).

If you're not using one of these distros, or if you're using a Solaris or BSD based system you'll need to use processes promises.

# Ensuring Processes are Not Running: Using Services

    bundle agent stop_bluetoothd {
      services:
    
        "bluetoothd"
          service_policy => "stop";
    }

This policy uses a `services` promise type to ensure that Bluetooth services are not running. Again, this only works for services that are defined under `standard_services` in `cfengine_stdlib.cf` and requires cfengine 3.4.0 or higher.

The same restrictions about distros apply to stoping services promises.

# Package Management

    bundle agent install {
      packages:
        "zsh"
          package_policy  => "addupdate",
          package_method  => apt,
          package_select  => ">=",
          package_version => "4.3.10-14";
    }

* The `package_policy` of `"add update"` will install or upgrade. Using `add` will only install, ever upgrade, `upgrade` will upgrade only and `delete` will uninstall.
* The `package_method` of `apt` is in `cfengine_stdlib.cf`, look there for other package methods (e.g., rpm, ips, etc.).
* The `package_select` of `">="` means the installed version must be equal to or newer than the specified version or it will be replaced. Using `"<="` would downgrade, if the `package_method` supports downgrading and `"=="` will require the exact version.

# Deleting Old Files

    bundle agent tidy {
      files:
        "/var/log/.*"
          file_select => days_old("7"),
          delete => tidy;
    }

This policy will delete any files in `/var/log/` older than 7 days. The `days_old()` and `tidy` bodies are included in `cfengine_stdlib.cf`.

To delete a file indiscriminately, omit the `file_select`.

Look up `file_select` and `tidy` in the CFEngine Reference Manual to find more ways to use this.

# Bootstrap a client/server environment

Before starting you need to install cfengine manually on the server and the client and the server FQDN must be set properly in DNS (or use the IP addresses). The server policy files are in `/var/cfengine/masterfiles` and are copied to `/var/cfengine/inputs` on all clients (including itself).

#### Server Side

Edit `/var/cfengine/masterfiles/def.cf` to set the `"acl"` list, then run:

<!-- -->

    cf-agent --bootstrap -s $(hostname --fqdn)
    cf-agent -KI

#### Client Side

Simply run: 
<!-- -->

    cfagent --bootstrap -s server.fqdn.example.com

Now edit the policy in `/var/cfengine/masterfiles` on the server and watch for it to happen on the client.

# Keep Track of Promises Repaired and Promises Not Repaired

CFEngine logs to `/var/cfengine/promise_summary.log`. Here's an example log message:

    1366956065,1366956068: Outcome of version Community Promises.cf 1.0.0 (agent-0):
      Promises observed to be kept 100%, Promises repaired 0%, Promises not repaired 0%

**Note:** The timestamp is a Unix epoch.

CFEngine will also send an email to the configured address in `promises.cf` any time there is output from an agent run.

And finally you can use the `-I` flag to have CFEngine *inform* you of repairs. (Shown here along with the `-K` flag which ignores any lock timers).

    cf-agent -KI

# Debugging: Using Verbose Mode

Inevitably, something will go wrong. Lucky for you, CFEngine has fantastic debugging output. Use the `-v` flag to turn on verbose output. Again, using `-K` to disable locks is useful

    $ cf-agent -Kv

When viewing debug output, look for `BUNDLE <name>` of the bundle that you suspect is having trouble.

    cf3> *****************************************************************
    cf3> BUNDLE main
    cf3> *****************************************************************

CFEngine will tell you exactly what is going on with each promise.

    cf3>     Promise made by: "/var/spool/cron/crontabs/sys"
    cf3> 
    cf3>  -> Using literal pathtype for /var/spool/cron/crontabs/sys
    cf3>  -> File "/var/spool/cron/crontabs/sys" exists as promised

# Debugging: Using Comments

CFEngine supports **comments** as part of its data structure. Every promise can have a `comment` attribute whose value is a quoted text string.

    "/etc/bind/named.cache"
      copy_from => scp("$(def.files)/bind/named.cache"),
      comment   => "More recent copy of named.cache than shipped with bind";

Comments show up in the verbose output.

    cf3>     Promise made by: "/etc/bind/named.cache"
    cf3>     Comment:  More recent copy of named.cache than shipped with bind

The comment should always be *why* the promise is being made. Up until now none of the examples have used comments to save space on the slide. When writing your policies for real *every* promise should have a meaningful comment.

You'll thank me when this saves the day.

# Debugging: Using Promise Handles

Something else that is useful when debugging are promise **handles**. Again, every promise can have a `handle` attribute whose value is a quoted canonical string.

    "/etc/bind/named.cache"
      copy_from => scp("$(def.files)/bind/named.cache"),
      handle    => "update_etc_bind_named_cache",
      comment   => "More recent copy of named.cache than shipped with bind";

CFEngine will tell you the handle of each promise in the debug output.

    cf3>     Promise's handle: update_etc_bind_named_cache
    cf3>     Promise made by: "/etc/bind/db.root"
    cf3>     Comment:  More recent copy of named.cache than shipped with bind

By giving each promise a unique handle you can swiftly jump back and forth between your debug output and your policy file. When writing your policies for real *every* promise should have a unique handle.

You'll thank me when this saves the day.

# Pro Tips

* Don't edit `cfengine_stdlib.cf`. Create a `site_lib.cf` and add your custom library bundles and bodies there. This helps with upgrading because you won't have to patch your changes into the new version. When you feel a bundle or body is ready you can submit it to CFEngine by opening a pull request on [Github][cfengine].

[cfengine]: http://github.com/cfengine/core
