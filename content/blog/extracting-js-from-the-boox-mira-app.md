+++
title = "Extracting and de-minifying JavaScript from the Boox Mira AppImage"
date = "2023-03-05"
description = "How to extract and de-minify the JavaScript used in the Onyx Boox Mira Electron app."
tags = ["e-ink"]
+++

Boox have written an Electron [app](https://help.boox.com/hc/en-us/articles/4408324394772-Mira-Software-Download) for controlling their Boox Mira and Boox Mira Pro displays. As mentioned in a previous [post](https://michaelhoward.kiwi/refreshing-multiple-e-ink-displays-on-linux-using-python/), I'm not a huge fan and have been working on reproducing its behaviour in a simple Python script - [miractl](https://git.sr.ht/~elithper/miractl).

Both miractl and its inspiration [mira-js](https://github.com/ipodnerd3019/mira-js) are made possible because the JavaScript from the manufacturer's app can be extracted and inspected. What follows is a quick summary of how to do the same for yourself.

## Getting the Boox Mira app

First, download the AppImage via Boox's website.

```
wget https://static.send2boox.com/monitor-pc/linux/Mira-latest.AppImage
```

Then make it executable.

```
chmod +x ./Mira-latest.AppImage
```

## Extracting content from the AppImage

Before continuing, it's probably worth creating a directory to keep all the extracted files. Once created, move the AppImage inside and use this as your working directory for the `./Mira-latest.AppImage --appimage-extract` command.

```
mkdir ~/boox-mira
mv Mira-latest.AppImage ~/boox-mira
cd ~/boox-mira && ./Mira-latest.AppImage --appimage-extract
```

This will create the folder `~/boox-mira/squashfs-root`. Inside the `resources` folder is an archive file called `app.asar`, which contains the concatenated, minified source files for the app.

## Getting to the JavaScript

Install `asar`.

```
npm install asar -g
```

Again, it'll keep things tidier if you create a destination folder before extracting the contents of `app.asar`.

```
mkdir ~/boox-mira/app
```

Then extract the file into your newly created directory.

```
asar extract squashfs-root/resources/app.asar app/
```

Almost there! All that remains is de-minifying the JS to make it readable for mere mortals.

## De-minifying

Inside `app/js` is the minified JS and its source map - `app.5a0cfb40.js.map`.

I used a tool (creatively) called [source-map-unpack](https://github.com/pavloko/source-map-unpack), but there are multiple ways of unpacking source maps.

```
npm install source-map-unpack -g
unpack unpacked app/js/app.5a0cfb40.js.map
```

This creates a folder called `unpacked` in your working directory and unpacks the JS there. And that's it!

Your sweet JS prize awaits in `unpacked/src`.

