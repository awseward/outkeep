import birl.{type Time}
import gleam/dynamic/decode.{type Decoder}

pub fn decoder() -> Decoder(Time) {
  decode.int |> decode.map(birl.from_unix_micro)
}
