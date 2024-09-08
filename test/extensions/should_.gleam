import birl.{type Time}
import gleam/regex
import gleam/string
import gleeunit/should

pub fn contain(haystack: String, needle: String) -> Nil {
  case string.contains(does: haystack, contain: needle) {
    True -> Nil
    False ->
      panic as string.concat([
        "\n\t",
        string.inspect(haystack),
        "\n\tshould contain \n\t",
        string.inspect(needle),
      ])
  }
}

pub fn equal_iso8601(t t: Time, expected expected: String) -> Nil {
  t
  |> birl.to_iso8601
  |> should.equal(expected)
}

pub fn match_iso8601(t t: Time, pattern pattern: String) -> Nil {
  let assert Ok(re) = regex.from_string(pattern)
  let t_iso8601 = birl.to_iso8601(t)

  case regex.check(with: re, content: t_iso8601) {
    True -> Nil
    False ->
      panic as string.concat([
        "\n\t",
        string.inspect(t_iso8601),
        "\n\tshould match regex pattern \n\t",
        string.inspect(pattern),
      ])
  }
}
