+++
title = "YubiKey CLI setup with ykman"
date = "2022-11-13"
description = "How to use the YubiKey Manager CLI (ykman) to set up a primary and backup YubiKey."
tags = ["linux", "yubikey"]
+++

I spent yesterday afternoon setting up a pair of YubiKeys – a primary key and a spare. Although I had to link them with a couple of dozen accounts, the process was surprisingly painless. Mostly thanks to their great CLI tool [yubikey-manager](https://docs.yubico.com/software/yubikey/tools/ykman/index.html).

Below are some notes on the process, mainly for my own reference. Even though setup is relatively simple, I find the acronym salad of two-factor hardware tokens overwhelming at the best of times, so this is also to remind myself that it isn't rocket science.

## Installation

On Debian/Ubuntu systems, the package can be found under the name `yubikey-manager` (though the `ykman` command is used to call the application).

`sudo apt install yubikey-manager`

You will also need the PC/SC Smart Card Daemon `pcscd`. In my case, this was already installed but the service needed to be enabled.

`sudo systemctl enable pcscd.service`
`sudo systemctl start pcscd.service`

## Setting a FIDO pin

Set a pin with the following command.

`ykman fido access change-pin`

This is seldom used, but some services require one to be set. Make sure you use the same pin on your primary key and your backup.

## Configuring TOTP slots

While many sites support WebAuthn (i.e. the fancy standard that lets your browser talk directly to the key), 6–8 digit, time-based one time passwords (TOTP) are more common.

To set these up, you need a secret provided by the site you're logging into. Often, these are given in the form of a QR code, but an alphanumeric string or URI will also be available. URIs look something like this:

`otpauth://...`

The format for adding an account via a secret is `ykman oath accounts add [OPTIONS] <name> <secret>. For example:

`ykman oath accounts add geocities JBSWY3DPEHPK3PXP`

However, if using a URI, `add` is replaced by `uri` and the name field is omitted:

`ykman oath accounts uri otpauth://totp/Yahoo:michael@geocities.com?secret=JBSWY3DPEHPK3PXP&issuer=Yahoo`

> **Important:** Your backup key needs the same secret as your primary one. After adding the account to your primary key, remove the device and plug in the backup key. Then run the same command again.

## Listing current TOTP slots

You can see a list of accounts you have set up TOTP authentication for with `ykman oath accounts list`.

```
$ ykman oath accounts list
geocities
ask-jeeves
alta-vista
napster
myspace
```

## Generating TOTP codes

Codes can be generated with `ykman oath accounts code <name>`.

I found this a bit clunky, so I wrote a short Bash function which runs the command and copies the resulting code to the clipboard.

``` shell
function yktotp () {
    ykman oath accounts code $1 | awk '{printf $NF}' | xclip -selection clipboard
}
```

The function is aliased to `2fa` to help me remember. This lets me get TOTP codes with a simple `2fa <name>`.
