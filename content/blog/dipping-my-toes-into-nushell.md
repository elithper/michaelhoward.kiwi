+++
title = "Dipping my toes into Nushell"
date = "2022-04-11"
description = "My first experiment writing a simple function in Nushell."
tags = ["nushell"]
+++

Nushell came to my attention a couple of weeks back, following its [0.6 release](https://www.nushell.sh/blog/2022-03-22-nushell_0_60.html) and immediately piqued my interest. 'What's so nu about this shell?' I thought.

Simply, Nushell is a Unix-style shell that works with structured data instead of raw text. In this way, it bears a lot of similarity with PowerShell, which I use heavily at my current job. Since I'm already used to working with an object-based shell for work, I thought it would be interesting to try one out on my personal machine.

To be honest, I don't do much shell scripting for personal projects. Yes, it would make my life easier. Yes, being familiar enough with Bash/Fish/Zsh to pull out sick one-liners is cool. But I'm lazy and generally can't convince myself it's worth the effort.

Enter Nushell! Something cool enough to get me started, but familiar enough that it doesn't feel like too much work to learn.

Starting slow, I decided to rewrite the small Fish function I mentioned in my [last post](https://michaelhoward.kiwi/how-this-blog-works/). To recap, I wanted a function that takes a path to a local file, uploads that file to Linode object storage and then copies the resulting URL to the clipboard.

The original:

``` fish
function send2obj
    linode-cli obj put --acl-public $argv michaelhoward
    set filename (basename $argv)
    echo -n "https://michaelhoward.ap-south-1.linodeobjects.com/$filename" | tee /dev/tty | xclip -selection clipboard
```

And in Nushell:

``` shell
# A command to send a file to Linode object storage, copying the resulting URL to the clipboard
def send-to-object-storage [
    filepath # The local path of the file to upload, e.g. ~/images/screenshot.png
] {
    if ($filepath | path exists) {
        linode-cli obj put --acl-public $filepath michaelhoward
        echo $"https://michaelhoward.ap-south-1.linodeobjects.com/($filepath | path basename)" | tee /dev/tty | xclip -selection clipboard
    } else {
         echo "File not found. Please check the path is correct."
    }

}

## Aliases ##

alias s2o = send-to-object-storage
```

As you can see, I got a little carried away. But essetially it does the same thing. Just better.

On a practical level, it's an improvement in that it checks the path to the file is valid before doing anything else. Though what I really prefer about the rewrite is the help message it displays.

I can now type `send-to-object-storage --help` or `s2o -h` to see the following.

```
A command to send a file to Linode object storage, copying the resulting URL to the clipboard

Usage:
  > send-to-object-storage <filepath> 

Flags:
  -h, --help
      Display this help message

Parameters:
  filepath: The local path of the file to upload, e.g. ~/images/screenshot.png
```

While this example doesn't show off any of Nushell's killer features, it was simple to put together and has me excited about experimenting further. Time to hit the docs!
