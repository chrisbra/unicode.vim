Unicode plugin
==============
> A Vim plugin for handling unicode and digraphs characters

This plugin aims to make the handling of unicode and digraphs chars in Vim easier. It serves 3 purposes:

    1. Provide the possibility to complete characters using their Unicode name or Unicode Codepoint using `<C-X><C-U>` using user defined completion function (to enable use the command `:EnableUnicodeCompletion`
    2. Provide the possibility to identify the character under the cursor using the `:UnicodeName` command that works similar to the builtin `ga` command (but also displays the HTML entity name and Digraph to create that character if possible).
    3. Ease the use of Digraphs (e.g. search Digraphs using the `:Digraphs` command or modify characters into their digraph chars).

See also the following screencast, that shows several features available:
![screencast of the plugin](screencast.gif "Screencast")

Installation
---
Use the plugin manager of your choice. Or download the [stable][] version of the plugin, edit it with Vim (`vim unicode-XXX.vmb`) and simply source it (`:so %`). Restart and take a look at the help (`:h unicode-plugin`)

[stable]: http://www.vim.org/scripts/script.php?script_id=2822

Usage
---
Once installed, take a look at the help at `:h unicode-plugin`

License & Copyright
---

The Vim License applies. See `:h license`

© 2009-2014 by Christian Brabandt

__NO WARRANTY, EXPRESS OR IMPLIED.  USE AT-YOUR-OWN-RISK__
