# Change Log

This is the Changelog for the [unicode.vim] plugin

## [Unreleased]

- new command :UnicodeCache to create the cache file for UnicodeData.txt
  manually
- new functions [unicode#Regex()] and [unicode#Search()], this allows for
  better interactively search of unicode characters, try this:
```
    /<CTRL-R>=unicode#Regex(unicode#Search('euro'))<cr>
```
- Add HTML Entity completion using CTRL-X CTRL-B (:h CTRL-X_CTRL-B)

## [0.21] - 2017-09-27

- escape ' properly for [digraph-completion] reported by Konfekt in #4, thanks!
- documentation update by Marco Hinz, thanks!
- remove QuitPre autocommand, that might quit your Vim unintentionally
- Add BOM for Byte Order Mark
- Allow specify, which digraphs are being replaced by the
  g:Unicode_ConvertDigraphSubset variable and some performance improvements for
  [:Digraphs] reported by stepk in #8 thanks!
- Fix some small bugs, regarding digraph generation [PlugMakeDigraph]
- When searching for a digraph or unicode character highlight the search pattern
- when calling [:UnicodeName] make sure, to use the english language
  (makes parsing ga work correctly)
- Make [:UnicodeName] output the search string
- Make [:UnicodeName] optionally output only part of the character output (e.g.
  digraph, html, name, regex or value)
- Fix a parsing error for [:UnicodeName] reported by daveyarwood in
  https://github.com/chrisbra/unicode.vim/issues/9 thanks!)
- always require to match case when completing digraphs (reported by jnd-au in
  https://github.com/chrisbra/unicode.vim/issues/10 thanks!)
- AirlineIntegration of the [:UnicodeTable] command
- call public unicode function always with :Unicode prefix (e.g. rename
  :SearchUnicode to [:UnicodeSearch] and :DownloadUnicode to [:UnicodeDownload]
- fix [:UnicodeSearch] expected a string > 1 char (reported by hseg in
  https://github.com/chrisbra/unicode.vim/issues/15, thanks!)
- new command [:DigraphNew] to define a new digraph (suggested by bpj in
  https://github.com/chrisbra/unicode.vim/issues/14 thanks!)
- only map keys, if not already mapped to (suggested in
  https://github.com/chrisbra/unicode.vim/issues/17)
- Allow register "+", "\*" and "\/" for [:UnicodeName]
- Allow to include glyph directly from [:UnicodeSearch]
- Prevent flickering of Window when opening [:UnicodeTable]
- Update html character entities to those defined by HTML5
- needs vim version 7.4
- [:UnicodeName] also outputs the character to be used in VimScript

## [0.20] - 2015-01-15
- [unicode#Digraph] expects a 2 char string
- Install a [QuitPre] autocommand for [:UnicodeTable]
- Make [:Digraphs!] output the digraph name

## [0.19] - 2014-04-16
- [:UnicodeName] shows all digraphs per character
- [:UnicodeName] shows decimal value for glyph
- :SearchUnicode search unicode character by name or value
- Make functions publicly available ([unicode#Digraph()],
  [unicode#FindUnicodeBy()], [unicode#UnicodeName()])
- cache UnicodeData.txt file in VimL dictionary format (so reading will be
  faster)
- Performance tuning, more comments, better error handling
- All configuration variables have a common g:Unicode... prefix
- document [<Plug>(UnicodeGA)]
- Digraph completion can display unicode name in preview window (if enabled,
  set g:Unicode_ShowDigraphName variable to enable)
- Always display digraph char when completing unicode char (and a digraph is
  available).
- Unicode completion always available using <C-X><C-Z>
- Therefore removed :EnableUnicodeCompletion and :DisableUnicodeCompletion commands
- too slow unicode completions will be stopped after 2 seconds
- fix annoying new line bug, when using digraph generation in visual mode
- new command [:UnicodeTable]
- new command [:DownloadUnicode] (including syntax highlighting)

## [0.18] - 2014-03-27
- include mapping for easier digraph generation
- fix wrong display of :Digraphs 57344
- [:Digraphs] can also search for unicode name

## [0.17] - 2013-08-15
- disable preview window (for completing unicode chars) by default, can be
  enabled by setting the variable g:Unicode_ShowPreviewWindow (patch by Marcin
  Szamotulski, thanks!)

## [0.16] - 2013-02-16
- [:UnicodeName] returns html entity, if possible

## [0.15] - 2013-02-05
- make sure, the returned digraphs list is not empty.

## [0.14] - 2012-12-01
- [:Digraphs] for better display of digraphs

## [0.13] - 2012-09-08
- better output for [:UnicodeName], it did previously hide messages

## [0.12] - 2012-04-12
- [:UnicodeName] shows digraph, if it exists
- better completion of digraphs

## [0.11] - 2012-04-11
- prevent loading of autoload file too early
- Make matching digraph more error-prone
- show all matching digraphs for a char

## [0.10] - 2011-12-15
- enable completing of only the names
- Really disable the 'completefunc' when disabling the function

## [0.09] - 2011-07-07
- [:UnicodeName] checks for existence of UnicodeData.txt
- [:UnicodeName] now also detects combined chars
- [:UnicodeName] now also outputs control chars

## [0.08] - 2010-09-30
- Fix an issue with configuring the plugin (Thanks jgm)
- Code cleanup
- Make use of the preview window, when completing Digraph or Unicode Glyphs
- By default, the Digraph Glyphs will now be enabled using [i_Ctrl-X_CTRL-G]
  instead of using Ctrl-X_Ctrl-C which wouldn't work in a terminal
- [:UnicodeName] now displays the hexadecimal Unicode Codepoint instead of the
  decimal one (as this seems to be the official way to display unicode
  codepoints).

## [0.07] - 2010-09-23
- [:UnicodeName]
- specify g:enableUnicodeCompletion to have unicode completion always enabled.

## [0.06] - 2010-08-26
- many small bugfixes with regard to error-handling and error displaying
- use default netrw_http_cmd (instead of hardwiring wget)
- small documentation update (Inlude a snippet of UnicodeData.txt and get rid
  of Index.txt data)

## [0.05] - 2010-04-19
- Apr 19, 2010:  Created a public repository for this plugin at
  http://github.com/chrisbra/unicode.vim

## [0.04] - 2010-02-01
- Use UnicodeData.txt to generate Data (Index.txt does not contain all glyphs).
- Check for empty file UnicodeData.txt

## [0.03] - 2009-10-27
-  Digraph Completion

## [0.02] - 2009-10-22
-  Enabled GetLatestScripts ([GLVS])

## [0.01] - 2009-10-22
-  First working version

[unicode.vim]:              https://github.com/chrisbra/unicode.vim
[0.21]:                     https://github.com/chrisbra/unicode.vim/compare/v20...v21
[0.20]:                     https://github.com/chrisbra/unicode.vim/compare/v19...v20
[0.19]:                     https://github.com/chrisbra/unicode.vim/compare/76eae4b5cde4360c2bec84f4be232e16f5a7680c..v19
[0.18]:                     https://github.com/chrisbra/unicode.vim/compare/67b231be0d6390e98cac542f6c7b98a8d957f949..76eae4b5cde4360c2bec84f4be232e16f5a7680c
[0.17]:                     https://github.com/chrisbra/unicode.vim/compare/7ec7c15de31160820ac071b50ea7ecc26125a4a4..67b231be0d6390e98cac542f6c7b98a8d957f949
[0.16]:                     https://github.com/chrisbra/unicode.vim/compare/42e2b48c990725108d8de01a5a9346ef61d1160c..7ec7c15de31160820ac071b50ea7ecc26125a4a4
[0.15]:                     https://github.com/chrisbra/unicode.vim/compare/e45f618bc89b75580fe407468b02586b6c08bafa..42e2b48c990725108d8de01a5a9346ef61d1160c
[0.14]:                     https://github.com/chrisbra/unicode.vim/compare/4b79af97205ce44c57bbd5a9b07c0edc2057f3b0..e45f618bc89b75580fe407468b02586b6c08bafa
[0.13]:                     https://github.com/chrisbra/unicode.vim/compare/dfa0453ec9e45f0ecdf916f627dd7fa66424ce34..4b79af97205ce44c57bbd5a9b07c0edc2057f3b0
[0.12]:                     https://github.com/chrisbra/unicode.vim/compare/3039831b6567f59f33ed77e19c0ba1fe0b4df8cf..dfa0453ec9e45f0ecdf916f627dd7fa66424ce34
[0.11]:                     https://github.com/chrisbra/unicode.vim/compare/6ddce2c8ef12740e4eca3f87b7f7618b59c48d99..3039831b6567f59f33ed77e19c0ba1fe0b4df8cf
[0.10]:                     https://github.com/chrisbra/unicode.vim/compare/c820681b4ee63d4f97143ceed428f4301897fac3..6ddce2c8ef12740e4eca3f87b7f7618b59c48d99
[0.09]:                     https://github.com/chrisbra/unicode.vim/compare/c5ef732ef564021742a1940370162ffd20c69f9b..c820681b4ee63d4f97143ceed428f4301897fac3
[0.08]:                     https://github.com/chrisbra/unicode.vim/compare/b3c8faeb6aad8b6dbf3e8a514a0940c154643a84..c5ef732ef564021742a1940370162ffd20c69f9b
[0.07]:                     https://github.com/chrisbra/unicode.vim/compare/de1713dc6df004a04fba01ecf738af391f4b5dae..b3c8faeb6aad8b6dbf3e8a514a0940c154643a84
[0.06]:                     https://github.com/chrisbra/unicode.vim/compare/a34feb3a5b18bba10b73ec3baede9ba369e3cad2..de1713dc6df004a04fba01ecf738af391f4b5dae
[0.05]:                     https://github.com/chrisbra/unicode.vim/compare/7733fc97ef3f652cf2b0c0d45646299226dd54a5..a34feb3a5b18bba10b73ec3baede9ba369e3cad2
[0.04]:                     https://github.com/chrisbra/unicode.vim/compare/f149bb067ff03c9d764cb7b7f8e6141b2a4274cb..7733fc97ef3f652cf2b0c0d45646299226dd54a5
[0.03]:                     https://github.com/chrisbra/unicode.vim/compare/4b93ed8954d3b6ff272aa16028ac2f8d3ab1f5e1..f149bb067ff03c9d764cb7b7f8e6141b2a4274cb
[0.02]:                     https://github.com/chrisbra/unicode.vim/compare/de3cfd99c7b7390ac9dc6960b1d141451460d222..4b93ed8954d3b6ff272aa16028ac2f8d3ab1f5e1
[0.01]:                     https://github.com/chrisbra/unicode.vim/commit/de3cfd99c7b7390ac9dc6960b1d141451460d222
[:DigraphNew]:              https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L181-L225
[:Digraphs]:                https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L125-L153
[:UnicodeDownload]:         https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L175-L177
[:UnicodeName]:             https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L94-L122
[:UnicodeSearch]:           https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L154-L166
[:UnicodeTable]:            https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L169-L171
[PlugMakeDigraph]:          https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L342-L367
[GLVS]:                     http://vimhelp.appspot.com/pi_getscript.txt.html#:GLVS
[QuitPre]:                  http://vimhelp.appspot.com/autocmd.txt.html#QuitPre
[i_Ctrl-X_CTRL-G]:          https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L313-L327
[unicode#Digraph]:          https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L428-L431
[unicode#FindUnicodeBy()]:  https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L389-L407
[digraph-completion]:       https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L313-L327
[<Plug>(UnicodeGA)]:        https://github.com/chrisbra/unicode.vim/blob/b86ed79b7f84805c757f662e05b0e64814fdf105/doc/unicode.txt#L369-L375
[unicode#Regex()]:          https://github.com/chrisbra/unicode.vim/blob/0c94a3812315af21e3e556174c4c4463c32a9495/doc/unicode.txt#L454-L459
[unicode#Search()]:         https://github.com/chrisbra/unicode.vim/blob/0c94a3812315af21e3e556174c4c4463c32a9495/doc/unicode.txt#L446-L449
