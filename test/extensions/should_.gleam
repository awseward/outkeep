import birl.{type Time}
import gleam/regexp
import gleam/string
import gleeunit/should

pub fn contain(haystack: String, needle: String) -> Nil {
  case string.contains(does: haystack, contain: needle) {
    True -> Nil
    False ->
      panic as string.concat([
        string.inspect(haystack),
        " should contain ",
        string.inspect(needle),
      ])
  }
}

pub fn equal_iso8601(t t: Time, expected expected: String) -> Nil {
  t
  |> birl.to_iso8601
  |> should.equal(expected)
}

pub fn match_pattern(content: String, pattern pattern: String) -> Nil {
  let assert Ok(re) = regexp.from_string(pattern)
  case regexp.check(with: re, content:) {
    True -> Nil
    False ->
      panic as string.concat([
        string.inspect(content),
        " should match regexp pattern ",
        string.inspect(pattern),
      ])
  }
}

type ToString(a) =
  fn(a) -> String

pub fn match_pattern_map(a: a, f: ToString(a), pattern pattern: String) -> Nil {
  a |> f |> match_pattern(pattern:)
}

pub fn match_iso8601(t: Time, pattern pattern: String) -> Nil {
  t |> match_pattern_map(birl.to_iso8601, pattern:)
}
