import birl
import gleam/dynamic.{type Dynamic}
import gleam/result

pub fn time_from_usec(dyn: Dynamic) {
  dyn |> dynamic.int |> result.map(birl.from_unix_micro)
}
