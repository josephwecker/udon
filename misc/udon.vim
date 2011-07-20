" Vim syntax file
" Language:        udon
" Maintainer:      Joseph Wecker
" Latest Revision: 2011-7-19
" License:         None, Public Domain
"
" udon mode for (g)vim, more or less from scratch.
"
" 

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn match   udonComment     /#.*$/
syn region  udonMLComment   start="^\z(\s*\)#" end="^\%(\z1 \| *$\)\@!" skipempty


syn match   udonType        /\({\||\)[^ \t\["{}]*/ contained contains=udonDelimiter
syn match   udonAttrLabel   /\(\s\+\|^\)\zs[^ "':]\+:/ contained contains=udonDelimiter
syn match   udonID          /\[\([^\]\\]\|\\.\)*\]/ contained contains=udonDelimiter,@udonBlock

syn match   udonColor       /#\x\{1,8\}/ contained
syn match   udonInt         "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+\%(_\x\+\)*\(\w*\|%\)*" contained contains=udonMVType
syn match   udonInt         "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0[dD]\)\=\%(0\|[1-9]\d*\%(_\d\+\)*\)\(\w*\|%\)*" contained contains=udonMVType
syn match   udonInt         "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[oO]\=\o\+\%(_\o\+\)*\(\w*\|%\)*" contained contains=udonMVType
syn match   udonInt         "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[bB][01]\+\%(_[01]\+\)*\(\w*\|%\)*" contained contains=udonMVType
syn match   udonFloat       "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\.\d\+\%(_\d\+\)*\(\w*\|%\)*" contained contains=udonMVType
syn match   udonFloat       "\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\%(\.\d\+\%(_\d\+\)*\)\=\%([eE][-+]\=\d\+\%(_\d\+\)*\)\(\)\(\w*\|%\)*" contained contains=udonMVType
syn match   udonMVType      /[^-[:digit:].[:blank:][:cntrl:]]\+\d\@!/ contained
syn cluster udonValueTypes  contains=udonColor,udonFloat,udonMiscVal,udonInt

syn cluster udonBlockParts  contains=udonType,udonID,@udonValueTypes,udonAttrLabel,udonComment,udonMLComment

syn region  udonBoundBlock  start="{" end="}" contains=@udonBlockParts,@udonBlock,udonDelimeter
syn region  udonStructBlock start="^\z(\s*\)|" end="^\%(\z1 \| *$\)\@!" contains=@udonBlockParts,@udonBlock
syn cluster udonBlock       contains=udonBoundBlock,udonStructBlock


"syn match   udonMLElement   /^\s*|"\([^"\\]\|\\.\)*"/ contains=udonDelimiter

syn match   udonDelimiter   /[:\[\]|{}]/ contained

hi def link udonBoundBlock  Special
hi def link udonStructBlock Special
hi def link udonType        Type
hi def link udonMLElement   Type
hi def link udonID          Identifier
hi def link udonColor       Constant
hi def link udonMiscVal     Float
hi def link udonMVType      Structure
hi def link udonFloat       Float
hi def link udonInt         Number
hi def link udonMLComment   Comment
hi def link udonComment     Comment
hi def link udonAttrLabel   Label
hi def link udonDelimiter   Delimiter

let b:current_syntax = "udon"
