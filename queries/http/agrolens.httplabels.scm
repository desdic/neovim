; show labels
(section
  (request_separator) @agrolens.scope
  (#match? @agrolens.scope "^###[\t ]+[^\s\r\n]"))

((comment) @agrolens.scope
  (#lua-match? @agrolens.scope "^#%s*@name%s+%S"))
