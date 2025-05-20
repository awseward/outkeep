import gleam/dynamic/decode.{type Decoder}
import gleam/string

pub type Color {
  Default
  // --- The options below may not be exhaustive…
  Blue
  Gray
  Green
  Orange
  Pink
  Purple
  Red
  Teal
  Yellow
}

pub fn decoder() -> Decoder(Color) {
  use color <- decode.then(decode.string)
  case string.lowercase(color) {
    "default" -> decode.success(Default)

    "blue" -> decode.success(Blue)
    "gray" -> decode.success(Gray)
    "green" -> decode.success(Green)
    "orange" -> decode.success(Orange)
    "pink" -> decode.success(Pink)
    "purple" -> decode.success(Purple)
    "red" -> decode.success(Red)
    "teal" -> decode.success(Teal)
    "yellow" -> decode.success(Yellow)

    _ -> decode.failure(Default, "Color")
  }
}
