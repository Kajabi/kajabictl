# Contributing

`kajabictl` is currently implemented using https://github.com/basecamp/sub, though as it grows in complexity, it may need to be translated to something more robust such as https://oclif.io.

Each subcommand maps to a separate, standalone executable program. Sub programs are laid out like so:

    .
    ├── bin               # contains the main executable for your program
    ├── completions       # (optional) bash/zsh completions
    ├── libexec           # where the subcommand executables are
    └── share             # static data storage

## Subcommands

Each subcommand executable does not necessarily need to be in bash. It can be any program, shell script, or even a symlink. It just needs to run.

Here's an example of adding a new subcommand. Run:

    touch libexec/kajabictl-who
    chmod a+x libexec/kajabictl-who

Now open up your editor, and dump in:

``` bash
#!/usr/bin/env bash
set -e

who
```

Of course, this is a simple example...but now `kajabictl who` should work!

    $ kajabictl who
    qrush     console  Sep 14 17:15 

You can run *any* executable in the `libexec` directly, as long as it follows the `NAME-SUBCOMMAND` convention. Try out a Ruby script or your favorite language!

## What's on your sub

You get a few commands that come with your sub:

* `commands`: Prints out every subcommand available
* `completions`: Helps kick off subcommand autocompletion.
* `help`: Document how to use each subcommand
* `init`: Shows how to load your sub with autocompletions, based on your shell.
* `shell`: Helps with calling subcommands that might be named the same as builtin/executables.

If you ever need to reference files inside of your sub's installation, say to access a file in the `share` directory, your sub exposes the directory path in the environment, based on your sub name. For a sub named `kajabictl`, the variable name will be `_KAJABICTL_ROOT`.

Here's an example subcommand you could drop into your `libexec` directory to show this in action: (make sure to correct the name!)

``` bash
#!/usr/bin/env bash
set -e

echo $_KAJABICTL_ROOT
```

You can also use this environment variable to call other commands inside of your `libexec` directly. Composition of this type very much encourages reuse of small scripts, and keeps scripts doing *one* thing simply.

## Self-documenting subcommands

Each subcommand can opt into self-documentation, which allows the subcommand to provide information when `kajabictl` and `kajabictl help [SUBCOMMAND]` is run.

This is all done by adding a few magic comments. Here's an example from `kajabictl who` (also see `kajabictl commands` for another example):

``` bash
#!/usr/bin/env bash
# Usage: kajabictl who
# Summary: Check who's logged in
# Help: This will print out when you run `kajabictl help who`.
# You can have multiple lines even!
#
#    Show off an example indented
#
# And maybe start off another one?

set -e

who
```

Now, when you run `kajabictl`, the "Summary" magic comment will now show up:

    usage: kajabictl <command> [<args>]

    Some useful kajabictl commands are:
       commands               List all kajabictl commands
       who                    Check who's logged in

And running `kajabictl help who` will show the "Usage" magic comment, and then the "Help" comment block:

    Usage: kajabictl who

    This will print out when you run `kajabictl help who`.
    You can have multiple lines even!

       Show off an example indented

    And maybe start off another one?

That's not all you get by convention with sub...

## Autocompletion

Your sub loves autocompletion. It's the mustard, mayo, or whatever topping you'd like that day for your commands. Just like real toppings, you have to opt into them! Sub provides two kinds of autocompletion:

1. Automatic autocompletion to find subcommands (What can this sub do?)
2. Opt-in autocompletion of potential arguments for your subcommands (What can this subcommand do?)

Opting into autocompletion of subcommands requires that you add a magic comment of:

    # Provide KAJABICTL completions

and then your script must support parsing of a flag: `--complete`. Here's an example from rbenv, namely `rbenv whence`:

``` bash
#!/usr/bin/env bash
set -e
[ -n "$RBENV_DEBUG" ] && set -x

# Provide rbenv completions
if [ "$1" = "--complete" ]; then
  echo --path
  exec rbenv shims --short
fi

# lots more bash...
```

Passing the `--complete` flag to this subcommand short circuits the real command, and then runs another subcommand instead. The output from your subcommand's `--complete` run is sent to your shell's autocompletion handler for you, and you don't ever have to once worry about how any of that works!

Run the `init` subcommand after you've prepared your sub to get your sub loading automatically in your shell.

## Shortcuts

Creating shortcuts for commands is easy, just symlink the shorter version you'd like to run inside of your `libexec` directory.

Let's say we want to shorten up our `kajabictl who` to `kajabictl w`. Just make a symlink!

    cd libexec
    ln -s kajabictl-who kajabictl-w

Now, `kajabictl w` should run `libexec/kajabictl-who`, and save you mere milliseconds of typing every day!
