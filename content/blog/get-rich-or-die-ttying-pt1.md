+++
title = "Get Rich or Die TTYing – Part 1: The REPL"
description = "The first part in a series on Python's Rich library, focused on styling the REPL."
date = "2026-01-07"
tags = ["python", "rich", "grotd"]
+++

This is the first post in a series where I explore everything you can (and
perhaps sometimes shouldn't) do with [Rich][1] – a Python library for styling
terminal output. Oh, and [everyone's favourite mid-2000s rapper][2] is along
for the ride.

Today's post focuses on the REPL.

> "Go ahead, switch the style up."
>
> — 50 Cent, _In da Club_

Rich offers a number of quality of life improvements for Python's interactive
interpreter, or REPL. Namely, pretty printed – and stylable – output, along
with a helpful tool for inspecting objects.

## Syntax highlighted data structures

While [Python 3.14][3] introduced syntax highlighting in the REPL, this only
applies to input – output remains unstyled.

The `rich.pretty` class can be used prettify output by invoking the
`install()` method. For example:

{{< video src="/videos/pretty.mp4" type="video/mp4" preload="auto" >}}

IPython users can skip the `pretty` import and `install()` invocation and run
the following command instead.

```
In [1]: %load_ext rich
```

Note that the styling provided by `rich.pretty` doesn't apply to `print()`
calls. For this you need `rich.print`.

## Pretty printing

Rich can overload Python's native `print()` function with its own. Not only
does this allow you to pretty print syntax-aware objects, you can also use
Rich's [console markup][4] to add colour, bold, italics, emoji and more to your
print statements.

I'll be covering console markup in depth in a future post, but for now I'll
leave you with this tasteful example.

{{< video src="/videos/rich-print.mp4" type="video/mp4" preload="auto" >}}

## Nicely formatted object inspection

The `inspect()` function prints a tidy summary of an object to the console.
It's useful for getting a quick overview of an object's attributes (and
methods, if needed).

Say you're debugging and want to know more about `gunit`, an instance of the
`GUnit` class. After importing `inspect`, a simple `inspect(gunit,
methods=True)` should give you enough info to get started.

{{< video src="/videos/rich-inspect.mp4" type="video/mp4" preload="auto" >}}

## Like My Style?

If any of this bling appeals, I'd suggest adding Rich as a dev dependency to
each of your projects.

```
uv add --dev rich
```

Then to ensure Rich is always imported in the REPL, create a `~/.startup.py` file,
e.g.:

```python
from rich import pretty, print, inspect

pretty.install()
```

And point your `PYTHONSTARTUP` environment variable at it.

```bash
# in Bash
export PYTHONSTARTUP="$HOME/.startup.py"
```

```fish
# in Fish
set PYTHONSTARTUP "$HOME/.startup.py"
```

## Conclusion

Hopefully this overview of Rich in the REPL has sparked your cursiosity and got
you asking [21 Questions][5] about what else the library can do. In future
posts I'll be exploring other features of Rich like logging, tables, live
display, markdown and more. Until then, I'll leave you [Patiently Waiting][6].

[1]: https://github.com/Textualize/rich
[2]: https://en.wikipedia.org/wiki/50_Cent
[3]: https://docs.python.org/3/whatsnew/3.14.html
[4]: https://rich.readthedocs.io/en/stable/markup.html
[5]: https://www.youtube.com/watch?v=cDMhlvbOFaM
[6]: https://www.youtube.com/watch?v=BFPmu10joSE
