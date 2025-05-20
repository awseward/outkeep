import gleam/json
import gleeunit/should
import outkeep/annotation

pub fn decoder_given_invalid_url_test() {
  "{\"description\":\"\",\"source\":\"WEBLINK\",\"title\":\"\",\"url\":\"definitely not a url\"}"
  |> json.parse(using: annotation.decoder())
  |> should.be_error
}

pub fn decoder_given_invalid_source_test() {
  "{\"description\":\"\",\"source\":\"not a valid source\",\"title\":\"\",\"url\":\"https://example.com/\"}"
  |> json.parse(using: annotation.decoder())
  |> should.be_error
}
