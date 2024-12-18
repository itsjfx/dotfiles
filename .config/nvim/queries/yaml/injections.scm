(block_node
    (block_scalar
        (comment) @injection.language
        (#gsub! @injection.language "^#%s*(%S+)%s*" "%1")
    ) @injection.content
    (#set! injection.include-children 1)
    (#set-offset! @injection.content 1 "+1") ; next row
    (#set-offset! @injection.content 2 0) ; first column
)
