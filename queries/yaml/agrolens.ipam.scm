(block_mapping_pair
 key:(flow_node
  (plain_scalar
   (string_scalar))) @agrolens.scope
 value:(block_node
  (block_mapping
   (block_mapping_pair
    key:(flow_node
     (plain_scalar
      (string_scalar)))
    value:(flow_node
     (plain_scalar
      (string_scalar) @assignment (#eq? @assignment "assignment"))))
   (block_mapping_pair
    key:(flow_node
     (plain_scalar
      (string_scalar) @desclabel(#eq? @desclabel "description")))) @description (#contains? @description "brand") )))
