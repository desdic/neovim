local autogroups = {
    ["_general"] = {
        [{"WinEnter", "TabEnter", "FocusGained"}] = {[{"*"}] = {"checktime"}},
        [{"BufEnter"}] = {[{"*"}] = {"set formatoptions-=cro"}},
        [{"BufWritePre"}] = {
            [{"/mnt/*", "/boot/*"}] = {
                'setlocal noundofile,setlocal shada="NONE"'
            }
        }
    },
    ["_text"] = {
        [{"FileType"}] = {
            [{"text", "txt"}] = {
                "set tw=80 fo+=taw spell", "set noexpandtab", "set tabstop=4",
                "set shiftwidth=4"
            }
        }
    },
    ["_mail"] = {[{"FileType"}] = {[{"mail"}] = {"set tw=72 fo+=taw spell"}}},
    ["_gitcommit"] = {[{"FileType"}] = {[{"gitcommit"}] = {"set spell"}}},
    ["_markdown"] = {
        [{"FileType"}] = {
            [{"markdown"}] = {
                "set noexpandtab", "set tabstop=4", "set shiftwidth=4"
            }
        }
    },
    ["_yaml"] = {
        [{"FileType"}] = {
            [{"yaml"}] = {
                "set expandtab", "set tabstop=2", "set shiftwidth=2",
                "set softtabstop=2"
            }
        }
    },
    ["_help"] = {[{"FileType"}] = {[{"help"}] = {"setlocal nolist"}}},
    ["_json"] = {
        [{"FileType"}] = {
            [{"json"}] = {
                "set conceallevel=0", "set ft=json", "set expandtab",
                "set tabstop=2", "set shiftwidth=2"
            }
        }
    },
    ["_sxhkdrc"] = {
        [{"FileType"}] = {
            [{"sxhkdrc"}] = {
                "sxhkdrc set noexpandtab", "sxhkdrc set tabstop=2",
                "sxhkdrc set shiftwidth=2"
            }
        }
    },
    ["_toml"] = {
        [{"FileType"}] = {
            [{"_toml"}] = {
                "set expandtab", "set shiftwidth=2", "set softtabstop=2",
                "set tabstop=2"
            }
        }
    },
    ["_make"] = {
        [{"FileType"}] = {
            [{"make"}] = {
                "set noexpandtab", "set tabstop=2", "set shiftwidth=2"
            }
        }
    },
    ["_sh"] = {
        [{"FileType"}] = {
            [{"sh"}] = {"set expandtab", "set tabstop=2", "set shiftwidth=2"}
        }
    },
    ["_python"] = {
        [{"FileType"}] = {
            [{"python"}] = {
                "set expandtab", "set tabstop=4", "set shiftwidth=4"
            }
        }
    },
    ["_asm"] = {
        [{"FileType"}] = {
            [{"asm"}] = {
                "set expandtab", "set shiftwidth=4", "set softtabstop=4",
                "set tabstop=4"
            }
        }
    },
    ["_c"] = {
        [{"FileType"}] = {
            [{"c", "cpp"}] = {
                "setlocal expandtab", "setlocal shiftwidth=4",
                "setlocal softtabstop=4", "setlocal tabstop=4"
            }
        }
    },
    ["_go"] = {
        [{"FileType"}] = {
            [{"go"}] = {
                "set nolist", "set noexpandtab", "set tabstop=4",
                "set softtabstop=4", "set shiftwidth=4"
            }
        }
    },
    ["_lua"] = {
        [{"FileType"}] = {
            [{"lua"}] = {
                "set nolist", "set noexpandtab", "set tabstop=4",
                "set softtabstop=4", "set shiftwidth=4"
            }
        }
    },
    ["_ruby"] = {
        [{"FileType"}] = {
            [{"ruby", "eruby", "ruby.eruby.chef"}] = {
                "set expandtab", "set shiftwidth=2", "set softtabstop=2",
                "set tabstop=2"
            }
        }
    },
}

for autogrp, autovalues in pairs(autogroups) do
    for autotypes, autosettings in pairs(autovalues) do
        local augroup = vim.api.nvim_create_augroup(autogrp, {clear = true})

        for typelist, commands in pairs(autosettings) do
            for _, command in ipairs(commands) do
                vim.api.nvim_create_autocmd(autotypes, {
                    pattern = typelist,
                    command = command,
                    group = augroup
                })
            end
        end
    end
end

vim.api.nvim_create_autocmd({"TextYankPost"}, {callback = function() vim.highlight.on_yank ({on_visual = false, higroup='IncSearch', timeout=200}) end})
