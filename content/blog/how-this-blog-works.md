+++
title = "How this blog works"
date = "2022-02-19"
description = "An explanation of how I built this blog using Hugo, Sourcehut Pages and Linode Object Storage."
tags = ["blogging", "fish shell", "sourcehut pages", "hugo"]
+++

## Intro

As is customary for websites like this, the following post details how I run my blog.

There are three main components:

- [Hugo](https://gohugo.io/), a static site generator
- [Sourcehut Pages](https://srht.site/), a tool for hosting static sites
- [Linode Object Storage](https://www.linode.com/products/object-storage/), S3-compatible object storage (used here for hosting images)

## Hugo

Hugo is my go-to static site generator. It's fast, intuitive and there are lots of great themes out there. I've used it for several sites now and I'm always amazed at just how quickly I can get something up and running.

For this blog, I decided to go with a barebones theme – [Hugo Bear Blog](https://github.com/janraasch/hugo-bearblog/). Bearbones, if you will.

## Sourcehut Pages

The blog is hosted using Sourcehut Pages. Those of you who have used GitHub/GitLab Pages will be familiar with the idea – create a Git repo with all the files for your static site and it will be built and served automatically. Every time you make a commit (like adding a new post), the site will be rebuilt.

## Linode Object Storage

While Sourcehut Pages is an excellent, straightforward way to host a blog, there is one downside – the repo can't be larger than 1GB. Although this isn't a huge problem, it does mean that it isn't wise to keep lots of large images inside the repo.

To get around this restriction, I've chosen to host my full size images using Linode's object storage[^1]. This gives me a massive 250GB for $5 USD per month. That's overkill, of course, but does let me upload as many high quality photos of my projects as I like. No doubt I'll find other uses for all this storage as time goes on.

Object storage is ideal for a couple of reasons. Firstly, I don't need to set up an Nginx server (at which point I may as well be hosting my own blog). And secondly, it means I can use Linode's CLI tool to upload my images.

Uploading an image is a single command.

`linode-cli obj put --acl-public /path/to/image.png mybucketname`

Once uploaded, the image can be found at a simply structured URL.

`https://mybucketname.serverregion.linodeobjects.com/filename.png`

So that I don't have to remember this pattern each time, I wrote a Fish shell function to upload the image and send the resulting URL to the clipboard.

``` fish
function send2obj
    linode-cli obj put --acl-public $argv michaelhoward
    set filename (basename $argv)
    echo -n "https://michaelhoward.ap-south-1.linodeobjects.com/$filename" | tee /dev/tty | xclip -selection clipboard
```

That way I can add unnecessary images to posts in seconds!

[![Screenshot of the blog post in Emacs.](/images/how-i-blog-screenshot-scaled.png "A scaled screenshot of this post in Emacs")](https://michaelhoward.ap-south-1.linodeobjects.com/how-i-blog-screenshot.png)

## Conclusion

All in all, I'm really satisfied with the workflow for this blog. My goal was to keep things simple and completely manageable from within Emacs or a terminal. Something I think I've achieved tidily. 

Now time to write some more posts!

[^1]: In fact, if I wanted to, I could host my entire blog this way. Linode has a great [guide](https://www.linode.com/docs/guides/host-static-site-object-storage/) on this. However, I like managing my site through a Git repo and enjoy the convenience of automatic builds.
