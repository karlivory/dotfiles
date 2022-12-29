" ╔═════════════════════╗
" ║ Settings for JDT.LS ║
" ╚═════════════════════╝
set wildignore+=*/node_modules/*
set wildignore+=*/target/*
set wildignore+=*/.mvn/*
set wildignore+=*/.metadata/*
set wildignore+=*/.settings/*
set wildignore+=*/.idea/*
set wildignore+=*/.vscode/*
set wildignore+=*/out/*

setlocal path+=src/main/java/**,src/test/java/**,**/src/main/java/**,**/src/test/java/**
setlocal include=^\s*import
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
