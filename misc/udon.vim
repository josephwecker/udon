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

syn match   udonAttrLabel   /\(\s\+\|^\)\zs[^ "':]\+:/
syn match   udonElement     /^\s*|[^ \["'`]\+/
syn match   udonID          /\[\([^\]\\]\|\\.\)*\]/
syn match   udonComment     /#.*$/
syn match   udonColor       /#\x\{1,8\}/
syn region  udonMLComment   start="^\z(\s*\)#" end="^\%(\z1 \| *$\)\@!"


hi def link udonElement     Type
hi def link udonID          Identifier
hi def link udonColor       Constant
hi def link udonMLComment   Comment
hi def link udonComment     Comment
hi def link udonAttrLabel   Label

let b:current_syntax = "udon"
