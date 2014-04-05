#Unicode plugin
==============
> A Vim plugin for handling unicode and digraphs characters

This plugin aims to make the handling of unicode and digraphs chars in Vim easier. It serves 3 purposes:

    1. Complete Characters
    2. Identify Characters
    3. Ease the use of Digraphs

###Complete Characters
    Once you have enabled completing of Unicode Characters (`:EnableUnicodeCompletion`) a custom completion function is available to complete characters using their Unicode name or Codepoint. If a digraph exists for that character, it will be displayed in paranthesis. Press `Ctrl-X Ctrl-U` to trigger this completion from insert mode.
    Also a new custom completion for digraph chars is available. Press `Ctrl-X Ctrl-G` to trigger this completion. It will display all digraphs, that are reachable from the previous typed letter.

###Identify Characters
    The `:UnicodeName` command can be used to identify the character under the cursor. This works similar to the builtin `ga` command (in fact, the help also states a possibility to map this command to the `ga` builtin command), but it also displays the digraph character (if it exists) and the HTML entity.
    The `:SearchUnicode` command can be used to search in the unicode character table to search for a certain unicode character with a given name or value.

###Ease the use of Digraphs
    Use the `:Digraphs` command to search for an digraph with the given name (e.g. `:Digraphs copy` will display all digraphs that will create a character name which contains copy in its name). You can also search for the decimal value.
    This plugin also maps the key `<F4>` that will allow to transform 2 given normal chars into their digraph char.

See also the following screencast, that shows several features available:
![screencast of the plugin](screencast.gif "Screencast")

##Installation
---
Use the plugin manager of your choice. Or download the [stable][] version of the plugin, edit it with Vim (`vim unicode-XXX.vmb`) and simply source it (`:so %`). Restart and take a look at the help (`:h unicode-plugin`)

[stable]: http://www.vim.org/scripts/script.php?script_id=2822

##Usage
---
Once installed, take a look at the help at `:h unicode-plugin`

##License & Copyright
---

The Vim License applies. See `:h license`
© 2009-2014 by Christian Brabandt

__NO WARRANTY, EXPRESS OR IMPLIED.  USE AT-YOUR-OWN-RISK__
