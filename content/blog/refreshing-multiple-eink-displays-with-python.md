+++
title = "Refreshing multiple e-ink displays on Linux using Python"
date = "2022-10-28"
description = "Using a pair of Python scripts and keyboard shortcuts to refresh e-ink/e-paper monitors on Linux."
tags = ["linux", "e-ink", "python"]
+++

At my desk at home, I have a pair of e-ink displays – a Dasung Paperlike 253 and a Boox Mira 13.3".

[![A picture of my desk setup](/images/my-desk.jpg)](https://assets.michaelhoward.kiwi/my-desk-fullsize.jpg)

In a [previous post](https://michaelhoward.kiwi/refreshing-e-ink-displays-on-windows/) I covered a how I refresh these on the Windows machine I use for work. While a bit of a hack, it works in a pinch.

When using my own laptop, on the other hand, I have much greater freedom. A pair of Python scripts allow me to control either or both of the monitors.

## Boox Mira

Boox have written their own Electron app for controlling Boox Mira and Boox Mira Pro displays. It's hot garbage.

Fortunately, a simpler, less bloated alternative exists. [ipodnerd3019](https://github.com/ipodnerd3019) had the bright idea of inspecting the Javascript used by the app to send opcodes to the device. They then turned this into a neat CLI Javascript utility – [mira-js](https://github.com/ipodnerd3019/mira-js).

Not being big on JS, I decided to reimplement some of this functionality in Python using `pyusb`. For now it's just a couple of scripts: one for refreshing the display, the other for turning off the frontlight. I've created [a repo](https://git.sr.ht/~elithper/mira-utils), which I'll be adding to when I get the time.

## Dasung Paperlike 253

While communicating with the Paperlike is slightly more involved, the work had already been done for me. Philip Metzler has written a great [Python script](https://github.com/cpmetz/dasung253), which makes use of `pyserial` to control the monitor.

Unfortunately, getting the script to run for the first time was a learning experience, to say the least.

The script needs the monitor's device file. Something like `/dev/ttyUSB*`, e.g.:

`python ./dasung253.py --port /dev/ttyUSB0 --clear`

Although I quickly identified the monitor could be found at `/dev/ttyUSB0` when connected via USB, it would disconnect shortly after. Running `sudo dmesg | grep tty` confirmed this.

```
[ 2553.808793] usb 1-1.4.1: ch341-uart converter now attached to ttyUSB0
[ 2556.138673] ch341-uart ttyUSB0: ch341-uart converter now disconnected from ttyUSB0
```

After some very confused googling, I discovered the package `brltty` was interfering. Although it's a package for driving refreshable braille displays, the daemon it runs in the background was (mis)identifying the Paperlike from the CH340 serial converter chip it uses. Based on [this thread](https://stackoverflow.com/questions/70123431/why-would-ch341-uart-is-disconnected-from-ttyusb), it appears the CH340 is used by a specific Braille eReader and `brltty` therefore has conflicting udev rules for this device.

To solve this I had two options:

1) Remove the package completely with a simple `sudo apt remove brltty`.
2) Change the udev rules.

Since I'm not planning on using any braille screens anytime soon, I opted for the former.

As a final hurdle, I also hit a permissions error trying to access `/dev/ttyUSB0`. To access this device my user had to be added to the `dialout` group: `sudo adduser cyclist dialout`.

However, once I'd done that and rebooted, the script worked like a charm!

## Bringing it all together 

To refresh both displays (near) simultaneously. I call them both with a Bash script.

``` shell
#!/usr/bin/env bash

/home/cyclist/scripts/mira-refresh.py
python /home/cyclist/scripts/dasung253.py --port /dev/ttyUSB0 --clear
```

I then bind this to a shortcut in Gnome Settings: _Settings > Keyboard > Keyboard Shortcuts > View and customise shortcuts_. I've chosen to bind this to Shift+Alt+R (for refresh)

## Calling the scripts individually

There are also times where I only want to refresh one of the displays. After all, I generally don't have the same windows open on both screens and therefore I may only want to clear ghosting/sharpen the image on one of them.

For this, I've used the same technique as above, but this time each shortcut calls its respective refresh script.

- Paperlike 253 = Shift+Alt+P
- Boox Mira = Shift+Alt+B

Notice that I've used the initial letter from each monitor's name to help me remember the shortcut.

Conveniently, because I use the [Miryoku layout](https://github.com/manna-harbour/miryoku) on all my keyboards, P and B are right next to each other. They're also in the same configuration as my physical monitors – Paperlike on the left, Boox Mira on the right.

[![A picture of my Corne keyboard in the Miryoku layout](/images/wireless-corne.jpg)](https://assets.michaelhoward.kiwi/wireless-corne-fullsize.jpg)

## Conclusion

I'm pretty stoked at how simple it is to control these displays with just a few lines of Python! Having these shortcuts set up has made a world of difference in usability. Next up I'd like to expand what my scripts can do with the Boox Mira (i.e. controlling contrast, refresh rate, etc.) and making my Bash script a little smarter, so that it can handle when new monitors are plugged in/unplugged and the device files change.
