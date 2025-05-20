import birl.{type Time}
import gleam/int
import gleam/option.{Some}
import gleam/pair
import gleam/regexp.{type Regexp, Match}
import gleam/result

pub type ExportPart =
  #(Time, Int)

pub type ParseError {
  FailedToMatchRegexp
  CouldNotParseTimestamp
  CouldNotParseNumber
}

pub fn exported_at(export_part: ExportPart) {
  pair.first(export_part)
}

pub fn number(export_part: ExportPart) {
  pair.second(export_part)
}

const file_name_pattern: String = "^takeout-(\\d{8}T\\d{6}Z)-(\\d+).(?:zip|tar.gz)$"

pub fn parse_filename(filename: String) -> Result(ExportPart, ParseError) {
  let assert Ok(re) = regexp.from_string(file_name_pattern)

  use #(timestamp, number) <- result.try(extract_regex(filename, using: re))
  use timestamp <- result.try(parse_timestamp(timestamp))
  use number <- result.try(parse_int(number))

  Ok(#(timestamp, number))
}

fn parse_(input: a, using fun: fn(a) -> Result(b, Nil), or error: ParseError) {
  input |> fun |> result.replace_error(error)
}

fn parse_timestamp(input: String) {
  input |> parse_(using: birl.parse, or: CouldNotParseTimestamp)
}

fn parse_int(input: String) {
  input |> parse_(using: int.parse, or: CouldNotParseNumber)
}

fn extract_regex(input: String, using re: Regexp) {
  case regexp.scan(re, input) {
    [Match(submatches: [Some(timestamp), Some(number)], ..)] ->
      Ok(#(timestamp, number))
    _ -> Error(FailedToMatchRegexp)
  }
}
