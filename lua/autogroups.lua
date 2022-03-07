local cmd = vim.cmd

-- don't continue comments and reload file on external change
-- don't create undo for files located in /boot or /mnt and turn off shada
-- don't like to reload editorconfig since its already loaded but for some reason it doesn't work without it
cmd([[
augroup	_general
	autocmd WinEnter,TabEnter,FocusGained * checktime
	autocmd BufEnter * set formatoptions-=cro
	autocmd BufWritePre /mnt/* setlocal noundofile,setlocal shada="NONE"
	autocmd BufWritePre /boot/* setlocal noundofile,setlocal shada="NONE"
augroup END
]])

cmd([[
augroup	_text
	autocmd FileType text set tw=80 fo+=taw spell
	autocmd FileType text set noexpandtab
	autocmd FileType text set tabstop=4
	autocmd FileType text set shiftwidth=4
augroup END
]])

cmd([[
augroup _mail
	autocmd FileType mail set tw=72 fo+=taw spell
augroup END
]])

cmd([[
augroup _gitcommit
	autocmd FileType gitcommit set spell
augroup END
]])

cmd([[
augroup _markdown
	autocmd FileType markdown set noexpandtab
	autocmd FileType markdown set tabstop=4
	autocmd FileType markdown set shiftwidth=4
augroup END
]])

cmd([[
augroup _yaml
	autocmd FileType yaml set expandtab
	autocmd FileType yaml set tabstop=2
	autocmd FileType yaml set shiftwidth=2
	autocmd FileType yaml set softtabstop=2
augroup END
]])

--  don't show whitespace in help files
cmd([[
augroup _help
	autocmd FileType help setlocal nolist
augroup END
]])

cmd([[
augroup _json
	autocmd FileType json set conceallevel=0
	autocmd FileType json set ft=json
	autocmd FileType json set expandtab
	autocmd FileType json set tabstop=2
	autocmd FileType json set shiftwidth=2
augroup END
]])

cmd([[
augroup _sxhkdrc
	autocmd FileType sxhkdrc set noexpandtab
	autocmd FileType sxhkdrc set tabstop=2
	autocmd FileType sxhkdrc set shiftwidth=2
augroup END
]])

cmd([[
augroup _systemd
	autocmd BufNewFile,BufRead */systemd/*.{automount,mount,path,service,socket,swap,target,timer} setfiletype systemd
	autocmd BufNewFile,BufRead /etc/systemd/system/*.d/*.conf setfiletype systemd
	autocmd BufNewFile,BufRead /etc/systemd/system/*.d/.#* setfiletype systemd
augroup END
]])

cmd([[
augroup _toml
	autocmd FileType toml set expandtab
	autocmd FileType toml set shiftwidth=2
	autocmd FileType toml set softtabstop=2
	autocmd FileType toml set tabstop=2
augroup END
]])

cmd([[
augroup _make
	autocmd FileType make set noexpandtab
	autocmd FileType make set tabstop=2
	autocmd FileType make set shiftwidth=2
augroup END
]])

cmd([[
augroup _sh
	autocmd FileType sh set expandtab
	autocmd FileType sh set tabstop=2
	autocmd FileType sh set shiftwidth=2
augroup END
]])

cmd([[
augroup _python
	autocmd FileType python set expandtab
	autocmd FileType python set tabstop=4
	autocmd FileType python set shiftwidth=4
augroup END
]])

cmd([[
augroup _asm
	autocmd FileType asm set expandtab
	autocmd FileType asm set shiftwidth=4
	autocmd FileType asm set softtabstop=4
	autocmd FileType asm set tabstop=4
augroup END
]])

cmd([[
augroup _c
	autocmd FileType c setlocal expandtab
	autocmd FileType c setlocal shiftwidth=4
	autocmd FileType c setlocal softtabstop=4
	autocmd FileType c setlocal tabstop=4
	autocmd FileType cpp setlocal expandtab
	autocmd FileType cpp setlocal shiftwidth=4
	autocmd FileType cpp setlocal softtabstop=4
	autocmd FileType cpp setlocal tabstop=4
augroup END
]])

cmd([[
augroup _go
	autocmd FileType go set nolist
	autocmd FileType go set noexpandtab
	autocmd FileType go set tabstop=4
	autocmd FileType go set softtabstop=4
	autocmd FileType go set shiftwidth=4
augroup END 
]])

cmd([[
augroup _lua
	autocmd FileType lua set nolist
	autocmd FileType lua set noexpandtab
	autocmd FileType lua set tabstop=4
	autocmd FileType lua set softtabstop=4
	autocmd FileType lua set shiftwidth=4
augroup END 
]])

cmd([[
augroup _ruby
	autocmd FileType ruby set expandtab
	autocmd FileType ruby set shiftwidth=2
	autocmd FileType ruby set softtabstop=2
	autocmd FileType ruby set tabstop=2
	autocmd FileType eruby set expandtab
	autocmd FileType eruby set shiftwidth=2
	autocmd FileType eruby set softtabstop=2
	autocmd FileType eruby set tabstop=2
	autocmd FileType ruby.eruby.chef set expandtab
	autocmd FileType ruby.eruby.chef set shiftwidth=2
	autocmd FileType ruby.eruby.chef set softtabstop=2
	autocmd FileType ruby.eruby.chef set tabstop=2
augroup END
]])

-- Highlight on yank
cmd(
    'au TextYankPost * silent! lua vim.highlight.on_yank {on_visual = false, higroup="IncSearch", timeout=200}')
