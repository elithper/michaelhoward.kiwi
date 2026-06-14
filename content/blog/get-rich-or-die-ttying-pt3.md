+++
title = "Get Rich or Die TTYing – Part 3: The Console Class"
description = "The third part in a series on Python's Rich library, focused on the Console class."
date = "2026-06-14"
tags = ["python", "rich", "grodt"]
+++

This is the third post in a series where I explore everything you can (and
perhaps sometimes shouldn't) do with [Rich][1] – a Python library for styling
terminal output. Oh, and [everyone's favourite mid-2000s rapper][2] is along for
the ride. My last two posts covered [blinging up the REPL][3] and
[console markup][4].

Today's post is all about the `Console` class — the foundation for all the
really interesting things you can do with Rich.

> “People judge you by appearances, the image you project through your actions,
> words, and style.
>
> — 50 Cent, _[The 50th Law][5]_

## Overview

Much like 50 Cent's [limited edition Xbox][6] released alongside his
third-person shooter [50 Cent: Bulletproof][7], the `Console` isn't the main
event, but it underpins all the fun and games you see on screen.

To do this, it detects the size and capabilities of the terminal it’s running in
and generates the necessary ANSI escape sequences to style any output.
Typically, there will only be a single instance of this class.

Your program's output will be made up _renderables_ in Rich's terminology. A
renderable is just that – something that can be rendered for display. It could
be a string, a column, a table, a markdown block, a progress bar, or any other
built-in renderable Rich provides. Moreover, renderables can be nested, meaning
you can do things like put styled text and syntax-highlighted code blocks in a
table. It's the Console object's job to work out how these components fit
together and tell your terminal emulator what to display.

## When is it worth using `Console`?

For one-off scripts and small programs, it may not be necessary to create a
Console object – using Rich’s `print()` function + console markup will probably
be enough. But, as soon as you need anything more complicated – drawing tables,
creating progress bars, justifying text – or you just want to modify the
behaviour of `print()`, you’ll need a Console object.

Since I'll be taking you to the eye-candy shop in future posts, I'll limit the
rest of this discussion to a couple of quality-of-life improvements you get once
you start using a Console object to handle your output.

## Customising `print()`

As alluded to above, sometimes you’ll find overloading Python’s built-in
`print()` function a little limiting. While it’s great that Rich provides a
drop-in replacement with the same function signature, Rich’s `print()` doesn’t
always behave the way you want it to.

For example, Rich will automatically highlight patterns in text like numbers,
booleans and collections. Normally, this is really handy. Sometimes, though,
it’s distracting. Take the following:

```python
from rich import print

print('"In da club" by 50 Cent')
```

Which produces:

![A terminal window displaying the text '"In da club" by 50 Cent' – quoted text is green, the number 50 is blue][unwanted_highlighting]

Both the quoted string and the number in 50's name have been highlighted in
different colours, which is not what we want. Of course, it's possible to
specify the output colour of this line using [console markup][8], but it's a
hassle and you would have to repeat the process every time you invoke this rap
icon's name.

Instead, we can use the `print()` method on our Console object, which allows for
customisation.

```python
from rich.console import Console

console = Console()

console.print('"In da club" by 50 Cent', highlight=False)
```

Output:

![A terminal window displaying the text '"In da club" by 50 Cent' – all text is white on a dark background][disable_highlighting]

In fact, we can go further and disable it globally with
`console = Console(highlight=False)`, so that it needs to be explicitly enabled
when printing.

## Exporting terminal output

The Console object is also capable of exporting everything it prints/logs as
HTML and SVG, which is great for when you want to share fancy terminal output
with your crew. To do so, your Console object first needs to be initialised with
`record=True`. Then, before your program exits, call either `save_html()` or
`save_svg()`.

To demonstrate, I've put together a slightly more involved example. The script
`export_songs.py` queries the [Genius API][9] and prints a page of results[^1]
as a table, before saving the output as an SVG.

```python { linenos=inline }
import json
import os
import requests

from rich.console import Console
from rich.table import Table


def format_featured(featured: list[dict]) -> str | None:
    """Return all featured artists as a comma separated string"""
    if featured:
        artists = [artist.get("name") for artist in featured]
        return ", ".join(artists)
    return None


def main() -> None:
    console = Console(record=True, highlight=False)
    token = os.environ["GENIUS_TOKEN"]

    # '108' is 50 Cent's artist id on Genius
    url = "https://api.genius.com/artists/108/songs?page=10"
    headers = {"Authorization": f"Bearer {token}"}
    console.log("Retrieving song info for [i]50 Cent[/]")
    r = requests.get(url, headers=headers)

    songs = json.loads(r.text).get("response").get("songs")
    table = Table(title="$10 worth of tracks")
    column_names = ["Title", "Primary artist", "Featured artist(s)", "Year"]

    for name in column_names:
        table.add_column(name)

    for song in songs:
        table.add_row(
            song.get("title"),
            song.get("primary_artist_names"),
            format_featured(song.get("featured_artists")),
            song.get("release_date_for_display"),
        )

    console.print(table)
    console.save_svg("ten-dollar-tracks.svg", title="export_songs.py")


if __name__ == "__main__":
    main()
```

Here's the result:

![Terminal output from the script export_songs.py, showing 20 songs featuring 50 Cent in a table. There are four columns: Title, Primary Artist, Featured artist(s), and Year.][ten_dollar_tracks]

(The same script using `save_html()` [produces this][10] instead.)

As you can see, the output from both `console.log()` and `console.print()`
(lines 24 and 42, respectively) made its way into the export. Also note that
`print()` was passed a renderable – the table – instead of a plain old string.

If writing the blog series has taught me anything, it's that generating high
quality visuals of terminal output is surprisingly hard. Screenshots look
terrible and dedicated tools like [freeze][11] and [vhs][12] still require quite
a bit of tweaking. So I'm grateful Rich supports export to multiple formats out
of the box.

## Conclusion

To sum up, a Console object acts as canvas for your application and abstracts
away the weird, low-level details of drawing stuff to the terminal. This gives
you more space to think of ways to [P.I.M.P.][13] up your output with Rich's
renderables. It also gives you complete control of the output itself, which can
then be captured/exported if desired.

For a more detailed look at everything the `Console` class can do, refer to the
[Console API][14] documentation – it's more comprehensive but unfortunately
makes no reference to 50 Cent (or even G-Unit) at all.

[^1]: I picked the tenth page arbitrarily.

[unwanted_highlighting]: /images/unwanted_highlighting.png
[disable_highlighting]: /images/disable_highlighting.png
[ten_dollar_tracks]: /images/ten-dollar-tracks.svg

[1]: https://github.com/Textualize/rich
[2]: https://en.wikipedia.org/wiki/50_Cent
[3]: https://michaelhoward.kiwi/get-rich-or-die-ttying-part-1-the-repl/
[4]: https://michaelhoward.kiwi/get-rich-or-die-ttying-part-2-console-markup/
[5]: https://en.wikipedia.org/wiki/The_50th_Law
[6]: https://www.slashgear.com/1280655/rarest-original-xbox-consoles/
[7]: https://en.wikipedia.org/wiki/50_Cent:_Bulletproof
[8]: https://rich.readthedocs.io/en/stable/markup.html
[9]: https://docs.genius.com/
[10]: https://michaelhoward.kiwi/ten-dollar-tracks/
[11]: https://github.com/charmbracelet/freeze
[12]: https://github.com/charmbracelet/vhs
[13]: https://www.youtube.com/watch?v=Jy1D6caG8nU&list=RDJy1D6caG8nU
[14]: https://rich.readthedocs.io/en/stable/console.html
