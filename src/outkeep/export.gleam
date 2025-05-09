import birl
import gleam/int
import gleam/option.{Some}
import gleam/regex
import gleam/result

pub type ExportPart {
  ExportPart(timestamp: birl.Time, number: Int)
}

pub type ExportParseError {
  NoRegexMatch
  TooManyRegexMatches
  InvalidSubmatches
  CouldNotParseTimestamp
  CouldNotParseNumber
}

pub fn parse(filename: String) -> Result(ExportPart, ExportParseError) {
  let assert Ok(re) = regex.from_string("^takeout-(\\d{8}T\\d{6}Z)-(\\d+).zip$")

  use match <- result.try({
    case regex.scan(re, filename) {
      [match] -> Ok(match)
      [] -> Error(NoRegexMatch)
      // NOTE: The way the regex is written, I don't even think this is
      // possible, but I am not sure of how to prove that to the type system
      [_, ..] -> Error(TooManyRegexMatches)
    }
  })
  use #(raw_timestamp, raw_number) <- result.try({
    case match.submatches {
      [Some(ts), Some(num)] -> Ok(#(ts, num))
      // NOTE: The way the regex is written, I don't even think this is
      // possible, but I am not sure of how to prove that to the type system
      _ -> Error(InvalidSubmatches)
    }
  })
  use timestamp <- result.try(
    raw_timestamp |> birl.parse |> result.replace_error(CouldNotParseTimestamp),
  )
  use number <- result.try(
    raw_number |> int.parse |> result.replace_error(CouldNotParseNumber),
  )

  ExportPart(timestamp:, number:) |> Ok
}
