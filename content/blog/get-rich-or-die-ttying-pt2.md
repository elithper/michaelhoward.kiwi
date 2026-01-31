+++
title = "Get Rich or Die TTYing – Part 2: Console markup"
description = "The second part in a series on Python's Rich library, focused on console markup."
date = "2026-01-31"
tags = ["python", "rich", "grotd"]
+++

This is the second instalment in a series exploring everything you can (and
perhaps sometimes shouldn't) do with [Rich][1] – a Python library for styling
terminal output. Oh, and [everyone's favourite mid-2000s rapper][2] is along
for the ride. My [last post covered the blinging up the REPL][3].

Today's topic is Rich's [console markup][4].

So, taking inspiration from the words of Fiddy himself:

> It ain't my fault, I just reach for style  
> I'm hot, I breaks it down  
> It ain't my fault, you can't break it down  
> The way I break it down
>
> — 50 Cent, _God Gave Me Style_

## Overview

Rich uses a simple markup language for quickly annotating input passed to
`print()`, `log()`, or anywhere else Rich accepts strings, e.g.:

```python
from rich import print

print("[bold]G-Unit[/bold]")
```

The first set of square brackets contains the style (or styles) to be applied
to all text until the closing set (`[/bold]` in this case).

Styled text can also be closed without specifying the style again, i.e. just
with `[/]`. Further, you can omit the closing syntax entirely if you'd like the
style to be applied until the end of the line. Therefore all of the following
print statements produce the same output.

```python
print("[underline]Get Rich or Die Tryin'[/underline]")
print("[underline]Get Rich or Die Tryin'[/]")
print("[underline]Get Rich or Die Tryin'")
# there's even a short name for this style
print("[u]Get Rich or Die Tryin'")
```

![Get Rich or Die Tryin', underlined][grotd_underline]

["Don't care, didn't ask,"][5] I hear your atrophied attention span say.

I get it. We'd all rather be in da club, bottle full of bub'. But when you
consider the alternative to the previous example relies on wrapping your string
in [ANSI escape sequences][6], i.e.

```python
print("\x1b[4mGet Rich Die Tryin'\x1b[24m")
``` 

I think we can all agree Rich is a real timesaver for the modern hustler.

As an aside, I was interested to see that the markup language is loosely based
on [BBCode][7] ("Bulletin Board Code"), since a similar markup language is also
used by [Spectre.Console][8], a dotnet package with close functionality to
Rich.

## Colour

Colour can be added to text in one of two ways:

1) Specifying one of the [256 named colours][9], either by name (`magenta`), or
number (`color(5)`)
2) Supplying a hex value, e.g. `#bb2a25`.

So,

```python
print("[magenta]Go, shawty, it's your birthday[/]")
print("[color(6)]We gon' party like it's your birthday[/]")
print("[#e28cf8]We gon' sip Bacardí like it's your birthday[/]")
```

Produces:

![3 lines of 'In da Club', each a different colour][colours]

It's worth noting that the first 16 named colours, e.g. `color(1)`/`red`, are
generally defined by a terminal's colour scheme, rather than being an exact
colour like `#d70000`. This is a good thing. With terminal-defined colours,
although you lose precise control of the output, you know they'll fit with the
user's theme and have reasonable contrast.

## Styled text

Beyond colour, Rich can add styles like bold, underline and italics to your
text. To illustrate, I've styled some heartfelt lines from [21 Questions][10].

| Style                 | Result                                            |
|-----------------------|---------------------------------------------------|
| `[bold]`/`[b]`        | ![Monospace text printed in bold][bold]           |
| `[italic]`/`[i]`      | ![Monospace text printed in italic][italic]       |
| `[dim]`/`[d]`         | ![Monospace text printed dimly][dim]              |
| `[underline]`/`[u]`   | ![Monospace text printed with underline][u]       |
| `[underline2]`/`[uu]` | ![Monospace text printed with two underlines][uu] |
| `[strike]`/`[s]`      | ![Monospace text printed with strikethrough][s]   |
| `[reverse]`/`[r]`     | ![Monospace text printed in inverted colours][r]  |

The table above contains common styles supported by many – but not all – modern
terminals like Ghostty, Kitty, WezTerm, Konsole and the like. On the left is
the style (and abbreviated form); on the right is its corresponding output.

## Weird stuff your terminal probably won't support

Rich also allows for styles which are very seldom supported by modern
terminals. I haven't included images of output in this section, since all
except `[overline]` are difficult to display.

- `[frame]`: I have no idea what this is supposed to look like.
- `[encircle]`: Same here.
- `[overline]`: Like underline, but, you know, _over_.
- `[conceal]`: Blanks out the text. Actually, this one is quite widely
supported. I just don't know why you would use it instead of, say, not
printing.
- `[blink]`: A slow blink (under 150 times per minute). 
- `[blink2]`: A fast blink (more than 150 times per minute). Of the handful of
terminals I experimented with, only WezTerm supported both kinds of blinks.

## Combining styles

Styles can be combined and nested within each other. To demonstrate,

```python
print("[underline green on white]God give me style, God give me grace[/]")
print("[italic magenta]God put a [yellow]smile[/] on my face[/]")
```

Becomes:

![God give me style, God give me grace, God put a smile on my face][combined]

**Remember:** `blue`, `white` and `magenta` are part of the 16 colours defined
by your terminal's theme (here, Rosé Pine Moon), so the snippet above will
probably look different if you run it yourself.

## Emoji

Emoji can be referred to via their name surrounded by colons:

```python
print(":heavy_dollar_sign: :heavy_division_sign: :two:")

# is the equivalent of
print("💲 ➗ 2⃣")
```

For a complete list of available emoji names + examples, run `python -m
rich.emoji` in your terminal.

## Links

Lastly, you can add interactive links to your output too.

```python
url = "https://web.archive.org/web/20060116005724/http://www.50cent.com/"
print(f"Here's 50's [link={url}]website back in 2006.[/]")
```

![Here's 50's website back in 2006, with last four words underlined][link]

The caveat here is, again, as long as your terminal supports them.

There's no real standard around how they'll be displayed either. Some terminals
will underline them. Some won't. Others will only underline them on hover.
Typically, you will need to Ctrl+Click to follow them too.

## Conclusion

That's a (w)rap! I encourage you to start adding some console markup to your
scripts, new or existing. With minimal effort, you can add some swag to your
`print()` and `log()` statements and generally make the terminal a more
interesting place. Just don't overdo it (or do!), and keep in mind that not all
terminals are created equal.

[grotd_underline]: /images/rich_underline.png
[colours]: /images/markup_colours.png
[bold]: /images/rich_print_bold.png
[italic]: /images/rich_print_italic.png
[dim]: /images/rich_print_dim.png
[u]: /images/rich_print_underline.png
[uu]: /images/rich_print_underline2.png
[s]: /images/rich_print_strike.png
[r]: /images/rich_print_reverse.png
[combined]: /images/rich_combined_styles.png
[link]: /images/rich_links.png

[1]: https://github.com/Textualize/rich
[2]: https://en.wikipedia.org/wiki/50_Cent
[3]: https://michaelhoward.kiwi/get-rich-or-die-ttying-part-1-the-repl/
[4]: https://rich.readthedocs.io/en/stable/markup.html
[5]: https://knowyourmeme.com/memes/dont-care-didnt-ask-50-cent-middle-finger
[6]: https://en.wikipedia.org/wiki/ANSI_escape_code
[7]: https://en.wikipedia.org/wiki/BBCode
[8]: https://spectreconsole.net/console/reference/markup-reference
[9]: https://rich.readthedocs.io/en/stable/appendix/colors.html
[10]: https://www.youtube.com/watch?v=cDMhlvbOFaM
