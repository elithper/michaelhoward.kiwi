+++
title = "Logitech MX Master tweaks for an e-ink setup"
date = "2022-11-27"
description = "Reprogramming an MX Master 3 to help control e-ink displays."
tags = ["linux", "e-ink"]
+++

While I prefer to use the keyboard where possible, I often find myself falling back on a mouse when browsing the web and reading articles/documentation. My mouse is an MX Master 3 which I _love_. However, one of it big drawcards – its buttery smooth scrollwheel – isn't as useful with e-ink displays. Sure, you can scroll quickly, and your display will do its best to keep up, but it doesn't look smooth and creates a lot of ghosting.

On the other hand, another great feature of the mouse is its reprogrammability. All of its additional buttons can be remapped[^1]. This makes it simple to replace scrolling with paging – Forward and Back become Page Up and Page Down.

Remapping the buttons is made possible on Linux with the [logiops](https://github.com/PixlOne/logiops) userspace driver. With this tool, you can customise the behaviour of Logitech [devices] using a (reasonably) straightforward config file.

In addition to mapping the Forward/Back buttons to Page Up/Page Down, I also set the thumb button to Alt+Shift+R – a shortcut I use to manually refresh my e-ink displays (a topic covered [previously](https://michaelhoward.kiwi/refreshing-multiple-e-ink-displays-on-linux-using-python/)).

I did run into a small problem in writing my config though. Although the example in the repo sets the name as "Wireless Mouse MX Master", my device didn't like being called that, and refused to play ball until I changed the name to "Wireless Mouse MX Master 3". Apart from that, and the squinting over braces and parentheses, setup was painless.

My `/etc/logid.cfg` can be found below.

```
devices: (
{
    name: "Wireless Mouse MX Master 3";

    smartshift:
    {
        on: true;
        threshold: 30;
    };

    hiresscroll:
    {
        hires: true;
        invert: false;
        target: false;
    };

    dpi: 1500;

    buttons: (
        // 'Forward' button
        {
            cid: 0x56;
            action =
            {
                type: "Keypress";
                keys: ["KEY_PAGEUP"];
            };
        },
        // 'Back' button
        {
            cid: 0x53;
            action =
            {
                type: "Keypress";
                keys: ["KEY_PAGEDOWN"];
            };
        },
        // Thumb button
        {
            cid: 0xc3;
            action = 
            {
                type: "Keypress";
                keys: [ "KEY_LEFTALT", "KEY_LEFTSHIFT", "KEY_R" ];
            };
        }
    );
}
);
```

[^1]: What's more, these can combined with mouse movements to create 'gestures'.
