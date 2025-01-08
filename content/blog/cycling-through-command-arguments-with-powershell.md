+++
title = "Cycling through command arguments with PowerShell"
date = "2025-01-08"
description = "Using SelectCommandArgument to quickly cycle between long command arguments in PowerShell"
tags = ["powershell"]
+++
      
With the holiday season behind us, I'm sure we're all sick of navigating arguments. However, I couldn't resist sharing this neat PowerShell trick I learnt at the end of last year.

PowerShell uses [PSReadLine](https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/using-keyhandlers?view=powershell-7.4) to handle keyboard input. One excellent feature of PSReadLine is the `SelectCommandArgument` key handler. This selects the next argument on the command line and by default is bound to Alt+A.

I've never seen anything like this implemented in another shell (e.g. via [GNU Readline](https://en.wikipedia.org/wiki/GNU_Readline) or [Reedline](https://www.nushell.sh/book/line_editor.html)), but it's super useful when running several long – but similar – commands in a row.

Here's a quick example of `SelectCommandArgument` in action.

{{< video src="/videos/select-command-argument.mp4" type="video/mp4" preload="auto" >}}
