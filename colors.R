
height = 40

cssTd <- sprintf("td { height: %spx; padding: 0px !important;}", height)
cssBullet <- "input[type='radio'] { left: -999em; position: absolute; }"
cssColors <- ".colourpicker-panel {display: block !important;}"

# cssColors <- ".colors{ width: 30px; height: 30px; margin-left: -20px; border: 2px solid black;}"

css <- paste(cssTd, cssBullet, cssColors)

#colors <- list("#ee4035", "#f37736", "#fdf498", "#7bc043", "#0392cf")

# choiceNames <- lapply(choiceValues, function(color) {
#   div("", style = sprintf("background-color:%s;", color), class = "colors")
# })

colors <- list(
  "#0004E5", "#FFFFFF", "#EEFFFF", "#F2F2F2",
  "#f0f0ee", "#E0F2DA", "#EAE5E3", "#FFD8CC",
  "#DDD8D7", "#B8D8AD", "#98F279", "#DDBBDD",
  "#FFB199", "#CCAADD", "#AA8888", "#449922",
  "#507F3F", "#E53700", "#775577", "#338811",
  "#A82800", "#883311", "#4C403D", "#661188",
  "#662200", "#2B2B2B", "#002200", "#101110"
)
