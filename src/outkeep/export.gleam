import birl
import gleam/int
import gleam/option.{Some}
import gleam/regex.{type Match}
import gleam/result

pub type ExportPart {
  ExportPart(timestamp: birl.Time, number: Int)
}

pub fn parse(filename: String) -> Result(ExportPart, Nil) {
  use match <- result.try(scan(filename))
  use #(raw_timestamp, raw_number) <- result.try(unpack_submatches(match))
  use timestamp <- result.try(birl.parse(raw_timestamp))
  use number <- result.try(int.parse(raw_number))

  Ok(ExportPart(timestamp:, number:))
}

fn scan(filename: String) {
  let assert Ok(re) = regex.from_string("takeout-(\\d{8}T\\d{6}Z)-(\\d+).zip")

  case regex.scan(re, filename) {
    [match] -> Ok(match)
    // No match — FIXME: Add a specific error
    [] -> Error(Nil)
    // Multiple matches — FIXME: Add a specific error
    [_, ..] -> Error(Nil)
  }
}

fn unpack_submatches(match: Match) {
  case match.submatches {
    [Some(raw_timestamp), Some(raw_number)] -> Ok(#(raw_timestamp, raw_number))
    _ -> Error(Nil)
  }
}
