#Unicode plugin
> A Vim plugin for handling unicode and digraphs characters

This plugin aims to make the handling of unicode and digraphs chars in Vim easier. It serves 3 purposes:

1. Complete Characters
2. Identify Characters
3. Ease the use of Digraphs

####Complete Characters
A custom completion function is available to complete characters using their Unicode name or Codepoint. If a digraph exists for that character, it will be displayed in paranthesis. Press `Ctrl-X Ctrl-Z` to trigger this completion from insert mode.
Also a new custom completion for digraph chars is available. Press `Ctrl-X Ctrl-G` to trigger this completion. It will display all digraphs, that are reachable from the previous typed letter.

####Identify Characters
The `:UnicodeName` command can be used to identify the character under the cursor. This works similar to the builtin `ga` command (in fact, the help also states a possibility to map this command to the `ga` builtin command), but it also displays the digraph character (if it exists) and the HTML entity.

The `:SearchUnicode` command can be used to search in the unicode character table to search for a certain unicode character with a given name or value.

The `:UnicodeTable` can be used to generate an Unicode table, including HTML entity names and Digraph chars. The UnicodeTable will be nicely syntax highlighted.

####Ease the use of Digraphs
Use the `:Digraphs` command to search for an digraph with the given name (e.g. `:Digraphs copy` will display all digraphs that will create a character name which contains copy in its name). You can also search for the decimal value.
This plugin also maps the key `<F4>` that will allow to transform 2 given normal chars into their digraph char.

See also the following screencast, that shows several features available:
![screencast of the plugin](https://chrisbra.github.io/vim-screencasts/unicode-screencast.gif "Screencast")

###Installation
Use the plugin manager of your choice. Or download the [stable][] version of the plugin, edit it with Vim (`vim unicode-XXX.vmb`) and simply source it (`:so %`). Restart and take a look at the help (`:h unicode-plugin`)

[stable]: http://www.vim.org/scripts/script.php?script_id=2822

###Usage
Once installed, take a look at the help at `:h unicode-plugin`

Here is a short overview of the functionality provided by the plugin:
####Ex commands:
    :Digraphs        - Search for specific digraph char
    :SearchUnicode   - Search for specific unicode char
    :UnicodeName     - Identify character under cursor (like ga command)
    :UnicodeTable    - Print Unicode Table in new window
    :DownloadUnicode - Download (or update) Unicode data
####Normal mode commands:
    <C-X><C-G>  - Complete Digraph char
    <C-X><C-Z>  - Complete Unicode char
    <F4>        - Combine characters into digraphs
####Scripting Functions:
    unicode#FindUnicodeBy() - Find unicode characters
    unicode#FindDigraphBy() - Find Digraph char
    unicode#Digraph()       - Returns digraph char
    unicode#UnicodeName()   - Identifies unicode character (by value)

####Similar Work
[vim-characterize](https://github.com/tpope/vim-characterize) Only supports identifying characters, no completion, no public functions, until recently did not detect combining chars correctly.

[easydigraph](https://github.com/Rykka/easydigraph.vim) Only supports easier digraph generation.

###License & Copyright

© 2009-2014 by Christian Brabandt. The Vim License applies. See `:h license`

__NO WARRANTY, EXPRESS OR IMPLIED.  USE AT-YOUR-OWN-RISK__
