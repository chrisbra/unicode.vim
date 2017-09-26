# Change Log

This is the Changelog for the [unicode.vim] plugin

## [Unreleased]

## [0.21] - 2017-09-27

- escape ' properly for |digraph-completion| (reported by Konfekt in
  [https://github.com/chrisbra/unicode.vim/issues/4] thanks!)
- documentation update by Marco Hinz, thanks!
- remove QuitPre autocommand, that might quit your Vim unintentionally
- Add BOM for Byte Order Mark
- Allow specify, which digraphs are being replaced by the
  g:Unicode_ConvertDigraphSubset variable and some performance improvements for
  |:Digraphs| (reported by stepk in [https://github.com/chrisbra/unicode.vim/issues/8] thanks!)
- Fix some small bugs, regarding digraph generation |<Plug>(MakeDigraph)|
- When searching for a digraph or unicode character highlight the search pattern
- when calling |:UnicodeName| make sure, to use the english language
  (makes parsing ga work correctly)
- Make |:UnicodeName| output the search string
- Make |:UnicodeName| optionally output only part of the character output (e.g.
  digraph, html, name, regex or value)
- Fix a parsing error for |:UnicodeName| reported by daveyarwood in
  https://github.com/chrisbra/unicode.vim/issues/9 thanks!)
- always require to match case when completing digraphs (reported by jnd-au in
  https://github.com/chrisbra/unicode.vim/issues/10 thanks!)
- AirlineIntegration of the |:UnicodeTable| command
- call public unicode function always with :Unicode prefix (e.g. rename
  :SearchUnicode to |:UnicodeSearch| and :DownloadUnicode to :UnicodeDownload|
- fix |:UnicodeSearch| expected a string > 1 char (reported by hseg in
  https://github.com/chrisbra/unicode.vim/issues/15, thanks!)
- new command |:DigraphNew| to define a new digraph (suggested by bpj in
  https://github.com/chrisbra/unicode.vim/issues/14 thanks!)
- only map keys, if not already mapped to (suggested in
  https://github.com/chrisbra/unicode.vim/issues/17)
- Allow register "+", "\*" and "\/" for |:UnicodeName|
- Allow to include glyph directly from |:UnicodeSearch|
- Prevent flickering of Window when opening |:UnicodeTable|
- Update html character entities to those defined by HTML5
- needs vim version 7.4

## [0.20] - 2015-01-15
- |unicode#Digraph| expects a 2 char string
- Install a |QuitPre| autocommand for |:UnicodeTable|
- Make |:Digraphs!| output the digraph name

## [0.19] - 2014-04-16
- |:UnicodeName| shows all digraphs per character
- |:UnicodeName| shows decimal value for glyph
- |:SearchUnicode| search unicode character by name or value
- Make functions publicly available (|unicode#Digraphs()|, |unicode#Digraph()|,
  |unicode#FindUnicodeBy()|, |unicode#UnicodeName()|)
- cache UnicodeData.txt file in VimL dictionary format (so reading will be
  faster)
- Performance tuning, more comments, better error handling
- All configuration variables have a common g:Unicode... prefix
- document |<Plug>(UnicodeGA)|
- Digraph completion can display unicode name in preview window (if enabled,
  set g:Unicode_ShowDigraphName variable to enable)
- Always display digraph char when completing unicode char (and a digraph is
  available).
- Unicode completion always available using <C-X><C-Z>
- Therefore removed |:EnableUnicodeCompletion| and
  |:DisableUnicodeCompletion| commands
- too slow unicode completions will be stopped after 2 seconds
- fix annoying new line bug, when using digraph generation in visual mode
- new command |:UnicodeTable|
- new command |:DownloadUnicode| (including syntax highlighting)

## 0.18 - 2014-03-27
- include mapping for easier digraph generation
- fix wrong display of :Digraphs 57344
- |:Digraphs| can also search for unicode name

## 0.17 - 2013-08-15
- disable preview window (for completing unicode chars) by default, can be
  enabled by setting the variable g:Unicode_ShowPreviewWindow (patch by Marcin
  Szamotulski, thanks!)

## 0.16 - 2013-02-16
- |:UnicodeName| returns html entity, if possible

## 0.15 - 2013-02-05
- make sure, the returned digraphs list is not empty.

## 0.14 - 2012-12-01
- |:Digraphs| for better display of digraphs

## 0.13 - 2012-09-08
- better output for |UnicodeName| (did previously hide messages)

## 0.12 - 2012-04-12
- |UnicodeName| shows digraph, if it exists
- better completion of digraphs

## 0.11 - 2012-04-11
- prevent loading of autoload file too early
- Make matching digraph more error-prone
- show all matching digraphs for a char

## 0.10 - 2011-12-15
- enable completing of only the names
- Really disable the 'completefunc' when disabling the function

## 0.09 - 2011-07-07
- |:UnicodeName| checks for existence of UnicodeData.txt
- |:UnicodeName| now also detects combined chars
- |:UnicodeName| now also outputs control chars

## 0.08 - 2010-09-30
- Fix an issue with configuring the plugin (Thanks jgm)
- Code cleanup
- Make use of the preview window, when completing Digraph or Unicode Glyphs
- By default, the Digraph Glyphs will now be enabled using |i_Ctrl-X_CTRL-G|
  instead of using Ctrl-X_Ctrl-C which wouldn't work in a terminal
- |:UnicodeName| now displays the hexadecimal Unicode Codepoint instead of the
  decimal one (as this seems to be the official way to display unicode
  codepoints).

## 0.07 - 2010-09-23
- |:UnicodeName|
- specify g:enableUnicodeCompletion to have unicode completion always enabled.

## 0.06 - 2010-08-26
- many small bugfixes with regard to error-handling and error displaying
- use default netrw_http_cmd (instead of hardwiring wget)
- small documentation update (Inlude a snippet of UnicodeData.txt and get rid
  of Index.txt data)

## 0.05 - 2010-04-19
- Apr 19, 2010:  Created a public repository for this plugin at
  http://github.com/chrisbra/unicode.vim

## 0.04 - 2010-02-01
- Use UnicodeData.txt to generate Data (Index.txt does not
  contain all glyphs).
- Check for empty file UnicodeData.txt

## 0.03 - 2009-10-27
-  Digraph Completion

## 0.02 - 2009-10-22
-  Enabled GetLatestScripts (|GLVS|)

## 0.01 - 2009-10-22
-  First working version

[unicode.vim]: https://github.com/chrisbra/unicode.vim
[0.21]: https://github.com/chrisbra/unicode.vim/compare/v20...v21
[0.20]: https://github.com/chrisbra/unicode.vim/compare/v19...v20
