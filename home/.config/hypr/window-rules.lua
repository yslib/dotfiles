-- App-specific compositor styling.

hl.window_rule({
    name = "style-l3afpad",
    match = { class = "^l3afpad$" },

    opacity = "0.96 0.90 1.0",
    rounding = 10,
    border_size = 2,
    float = true,
    center = true,
    size = "900 650",
})

 hl.window_rule({
     name = "style-chrome",
     match = { class = "^(Google-chrome|google-chrome)$" },
     opacity = "1.00 0.96 1.00",
     rounding = 10,
     border_size = 1,
 })

