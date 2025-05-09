import extensions/should_
import gleeunit/should
import outkeep/export.{NoRegexMatch}

pub fn parse_happy_path_zip_test() {
  "takeout-20250508T023908Z-001.zip"
  |> export.parse
  |> should.be_ok
  |> should_match(iso8601_timestamp: "2025-05-08T02:39:08.000Z", number: 1)
}

pub fn parse_happy_path_targz_test() {
  "takeout-20250508T023908Z-001.tar.gz"
  |> export.parse
  |> should.be_ok
  |> should_match(iso8601_timestamp: "2025-05-08T02:39:08.000Z", number: 1)
}

pub fn parse_no_regex_match_test() {
  "some_junk.zip"
  |> export.parse
  |> should.be_error
  |> should.equal(NoRegexMatch)
}

fn should_match(
  export export: export.ExportPart,
  iso8601_timestamp iso8601_timestamp: String,
  number number: Int,
) {
  export.timestamp |> should_.equal_iso8601(iso8601_timestamp)
  export.number |> should.equal(number)
}
