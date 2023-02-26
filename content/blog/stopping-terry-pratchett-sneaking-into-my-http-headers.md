+++
title = "Stopping Terry Pratchett sneaking into my HTTP headers"
date = "2023-02-26"
description = "A post about finding and removing the 'X-Clacks-Overhead' custom HTTP header from my blog's theme."
tags = ["blogging"]
+++

The other day I was testing whether `curl` was installed on my work machine, so I made a simple request to my site.

```
$ curl https://michaelhoward.kiwi
```

To my surprise, the late and prolific author of the Discworld series popped up in the response. 

```html
<!DOCTYPE html>
<html lang="en-NZ">
<head>
  <meta name="generator" content="Hugo 0.106.0">
  <meta http-equiv="X-Clacks-Overhead" content="GNU Terry Pratchett" />
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="shortcut icon" href="https://michaelhoward.kiwi/images/favicon.png" />
  <title>Failing Productively</title>
  <meta name="title" content="Failing Productively" />
  <meta name="description" content="Fail. Learn. Repeat. A personal blog by Michael Howard." />
```

(Just to be clear, I mean Terry Pratchett. At the time of writing I am neither dead nor the author of any Discworld novels.)

Not knowing what `X-Clacks-Overhead` meant, nor what Terry Pratchett had to do with them, I began sleuthing.

## Where did he come from?

This blog uses the [Hugo Bear](https://github.com/janraasch/hugo-bearblog) theme, so that was an obvious place to look. A quick `grep` of the repo later and I'd found the culprit in `hugo-bearblog/layouts/_default/baseof.html`.

However, the Hugo Bear theme is actually just a port of the theme used by the minimalist blogging platform [Bear Blog](https://github.com/HermanMartinus/bearblog). I guessed (rightly) that the first mention of Mr Pratchett would be [there](https://github.com/HermanMartinus/bearblog).

Still, knowing that my theme had inherited a cryptic message about a fantasy author didn't help explain what the message meant.

## Why was he there in the first place?

At last, the interesting bit! It turns out that following the death of Pratchett in 2015, the idea was floated on [Reddit](https://web.archive.org/web/20190406055628id_/https://www.reddit.com/r/discworld/comments/2yt9j6/gnu_terry_pratchett/) of giving him a lasting internet tribute inspired by his novel _Going Postal_.

The book describes an internet-like semaphore system called the Clacks. On losing a son, one of the characters keeps his boy's name alive by sending it back and forth along the network in perpetuity. The protocol used by the Clacks allows you to specify what should be done with a message, similar to HTTP headers. Hence the 'GNU' in 'GNU Terry Pratchett' represents a fictional set of instructions for infinite transmission. 

- G: send the message on
- N: do not log the message
- U: turn the message around at the end of the line and send it back again

By getting people to insert the `X-Clacks-Overhead` message into their headers, Pratchett's name could be memorialised on the modern internet in a similar way.

The idea caught on based the subsequent [GNU Terry Pratchett website](http://www.gnuterrypratchett.com/), and there are lots of ways of sticking the author's name in your HTTP responses besides a blog theme – modifying your Nginx/Apache config, JavaScript etc.

Touching as this tribute is, I don't think Pratchett's name is in any danger of dying out – certainly not while his [41 Discworld novels](https://en.m.wikipedia.org/wiki/Discworld#Bibliography) are still in publication. And I think it's a bit of a strange thing to keep in my blog's theme, now that I know it's there.

## A quick fix

No prizes for guessing how to fix this one. Simply deleting the line in `baseof.html` did the job. I also took this as an opportunity to fork the theme and make a couple of minor changes.