+++
title = "Miryoku layout on the Glove80"
description = "An overview of how I build and use the Miryoku layout for the Glove80 keyboard"
date = "2025-12-31"
tags = ["keyboards"]
+++

[![Both halves of a white Glove80 split keyboard sitting on a grey deskmat](/images/glove80-scaled.jpeg)](https://assets.michaelhoward.kiwi/glove80.jpeg)

I’ve been using the Glove80 as a daily driver in my home office for the past 8 months. It’s a fantastic board and very, very comfortable. When I received it, I toyed with the idea of [learning a new layout][1] and making use of all the extra keys, but thought better of it, since I still regularly use 36-key boards when going into the office/travelling.

Instead, I went with the tried and true [Miryoku layout][2].

## Physical layout

[![A Glove80 keyboard with the keys used by the Miryoku layout outlined in purple](/images/glove80-miryoku-scaled.jpeg)](https://assets.michaelhoward.kiwi/glove80-miryoku.jpeg)

Overall, the keys used by the Miryoku layout on the Glove80 are sensible. Of course, 46 of them go to waste, but that’s unavoidable.

My one complaint is that the innermost thumb key is slightly too much of a stretch.

[![Standard thumb key layout on the Glove80, using all three bottom-row keys in the thumb cluster](/images/miryoku-thumb-keys-standard-scaled.jpeg)](https://assets.michaelhoward.kiwi/miryoku-thumb-keys-standard.jpeg)

To get around this, I shifted the two innermost thumb cluster keys outwards and moved the outermost thumb key to the top row.

[![Standard thumb key layout on the Glove80, with arrows showing an outward/topward shift](/images/miryoku-thumb-key-movement-scaled.jpeg)](https://assets.michaelhoward.kiwi/miryoku-thumb-key-movement.jpeg)

The resulting triangular cluster is much more comfortable.

[![Modified thumb key layout on the Glove80, with Delete on the top row, Backspace beneath it and Enter to the left](/images/miryoku-thumb-keys-modified-scaled.jpeg)](https://assets.michaelhoward.kiwi/miryoku-thumb-keys-modified.jpeg)

I achieved this by making a small change to `miryoku/mapping/80/glove80.h` (you can see the thumb clusters in the centre of the bottom two lines), which leads me on to the next section…

```c {hl_lines={[11,12]}
#define MIRYOKU_LAYOUTMAPPING_GLOVE80( \
     K00, K01, K02, K03, K04,                                    K05, K06, K07, K08, K09, \
     K10, K11, K12, K13, K14,                                    K15, K16, K17, K18, K19, \
     K20, K21, K22, K23, K24,                                    K25, K26, K27, K28, K29, \
     N30, N31, K32, K33, K34,                                    K35, K36, K37, N38, N39 \
) \
XXX  XXX  XXX  XXX  XXX                                               XXX  XXX  XXX  XXX  XXX \
XXX  XXX  XXX  XXX  XXX  XXX                                     XXX  XXX  XXX  XXX  XXX  XXX \
XXX  K00  K01  K02  K03  K04                                     K05  K06  K07  K08  K09  XXX \
XXX  K10  K11  K12  K13  K14                                     K15  K16  K17  K18  K19  XXX \
XXX  K20  K21  K22  K23  K24  K32  XXX  XXX       XXX  XXX  K37  K25  K26  K27  K28  K29  XXX \
XXX  XXX  XXX  XXX  XXX       K33  K34  XXX       XXX  K35  K36       XXX  XXX  XXX  XXX  XXX
```

## Building the firmware

Since the Glove80 is one of the Miryoku project’s supported keyboards, building the firmware is simple:

1. Fork the [manna-harbour/miryoku_zmk](https://github.com/manna-harbour/miryoku_zmk) repo.

2. Make any customisations necessary, like altering the layout file above. (Optional)

3. Build via the ‘Build Inputs’ workflow in the GitHub Actions tab. Because the Glove80 is a split board, you need to use the name `glove80_lh,glove80_rh` as the ‘board’ name to produce a firmware file for each half. I also specify some additional configuration in the ‘kconfig’ field (see below).

### Important variables to set

- `CONFIG_ZMK_HID_CONSUMER_REPORT_USAGES_BASIC=y`: disables some consumer keycodes, but improves OS compatibility. Useful when connecting the board to macOS/iOS/iPadOS.
- `CONFIG_ZMK_POINTING=y`: enables mouse emulation.
- `CONFIG_ZMK_SLEEP=y`: allows the board to go into a deep sleep state during periods of inactivity. Without enabling this, battery life is extremely short (no more than a day).

Each variable needs to be separated by a newline character, e.g. `CONFIG_ZMK_HID_CONSUMER_REPORT_USAGES_BASIC=y\nCONFIG_ZMK_POINTING=y\nCONFIG_ZMK_SLEEP=y`.

[1]: https://github.com/sunaku/glove80-keymaps
[2]: https://github.com/manna-harbour/miryoku
