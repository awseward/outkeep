import extensions/should_
import gleeunit/should
import outkeep/export/export_part.{type ExportPart, FailedToMatchRegexp}

pub fn parse_happy_path_zip_test() {
  "takeout-20250508T023908Z-001.zip"
  |> export_part.parse_filename
  |> should.be_ok
  |> should_match(exported_at: "2025-05-08T02:39:08.000Z", number: 1)
}

pub fn parse_happy_path_targz_test() {
  "takeout-20250508T023908Z-001.tar.gz"
  |> export_part.parse_filename
  |> should.be_ok
  |> should_match(exported_at: "2025-05-08T02:39:08.000Z", number: 1)
}

pub fn parse_no_regex_match_test() {
  "some_junk.zip"
  |> export_part.parse_filename
  |> should.be_error
  |> should.equal(FailedToMatchRegexp)
}

fn should_match(
  export export: ExportPart,
  exported_at exported_at: String,
  number number: Int,
) {
  export
  |> export_part.exported_at
  |> should_.equal_iso8601(exported_at)
  export |> export_part.number |> should.equal(number)
}
