vim.filetype.add({
    extension = {
        timer = "systemd",
        service = "systemd",
        automount = "systemd",
        mount = "systemd",
        target = "systemd",
        path = "systemd",
        rules = "make",
    },
    pattern = {
        [".*/etc/systemd/.*.%.socket"] = "systemd",
        [".*/etc/systemd/.*.%.swap"] = "systemd",
        [".*/etc/systemd/.*.%.conf"] = "systemd",
        [".*/etc/systemd/.*.d/*.%.conf"] = "systemd",
        [".*/etc/systemd/.*.d/.#.*"] = "systemd",
        ["~/.config/systemd/user/.*.%.socket"] = "systemd",
        ["~/.config/systemd/user/.*.%.swap"] = "systemd",
    },
})

vim.filetype.add({
    extension = {
        vs = "glsl",
        fs = "glsl",
        frag = "glsl",
        vert = "glsl",
        vtc = "varnish",
        vlc = "varnish",
        rest = "rest",
    },
})
