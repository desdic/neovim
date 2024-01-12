; find all pytest classes
(decorated_definition
  (decorator
    (attribute
      object:(attribute
               object:(identifier) @pytest (#eq? @pytest "pytest")
               attribute:(identifier))
      attribute:(identifier)))
  definition:(class_definition
               name:(identifier) @agrolens.scope))

; find all pytest decorated functions
(decorated_definition
  (decorator
    (call
      function:(attribute
                 object:(attribute
                          object:(identifier) @pytest (#eq? @pytest "pytest")
                          attribute:(identifier))
                 attribute:(identifier))
      arguments:(argument_list
                  (keyword_argument
                    name:(identifier)
                    value:(string
                            (string_start)
                            (string_content)
                            (string_end))))))
  definition:(function_definition
               name:(identifier) @agrolens.name) @agrolens.scope)
