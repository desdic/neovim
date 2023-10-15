return {
    "numToStr/Comment.nvim",
    event = {"VeryLazy"},
    config = function()
        require('Comment').setup()
        local ft = require("Comment.ft")
        ft.set("vtc", "#%s") -- comment style for varnish test
        ft.set("vcl", "#%s") -- comment style for varnish
    end
}
