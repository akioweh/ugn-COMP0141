#let target = dictionary(std).at("target", default: () => "paged")

// code font is also used in Typst; otherwise this is mainly for HTML output
#let body-font = "STIX Two Text"
#let code-font = "JetBrains Mono"

// Build Google Fonts URL: spaces in family names are encoded as '+'.
#let _gf-family(name, axes) = name.replace(" ", "+") + ":" + axes
#let fonts-url = (
  "https://fonts.googleapis.com/css2?"
    + (
      "family="
        + _gf-family(code-font, "wght@200;400;700")
        + "&family="
        + _gf-family(body-font, "ital,wght@0,400;0,700;1,400;1,700")
        + "&display=swap"
    )
)

#let theme(body) = {
  // set text(
  //   font: "Latin Modern Roman 12",
  //   size: 11pt,
  // )

  // set page(fill: black)
  // set text(fill: rgb(234, 223, 200))
  // show link: set text(fill: rgb(150, 200, 237))

  set text(lang: "en")
  set par(linebreaks: "optimized", justify: true)

  set heading(numbering: "1.1.1.1  ")

  show title: set align(center)
  show title: set block(below: auto, above: auto)
  show title: set text(weight: "light", size: 22pt)

  show heading: set block(below: 10pt, above: auto)
  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 2): set text(size: 12pt)

  show raw: set text(
    font: code-font,
    weight: 200,
    size: 9.5pt,
  )

  show link: set text(fill: purple)

  show math.equation: it => context if target() == "html" {
    if it.block { html.frame(it) } else { box(html.frame(it)) }
  } else {
    it
  }

  context if target() == "html" {
    html.elem("link", attrs: (
      rel: "preconnect",
      href: "https://fonts.gstatic.com",
      crossorigin: "",
    ))[]
    html.elem("link", attrs: (rel: "stylesheet", href: fonts-url))[]
    html.elem("style", ":root{--body-font:\"" + body-font + "\";--code-font:\"" + code-font + "\"}")
    html.elem("style", read("html-style.css"))
    html.elem("details", attrs: (class: "toc"))[
      #html.elem("summary")[Contents]
      #outline(title: none, depth: 4)
    ]
  }

  body
}
