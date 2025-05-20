import gleam/dynamic/decode.{type Decoder}
import gleam/string
import gleam/uri.{type Uri}

pub type Annotation {
  Annotation(description: String, source: Source, title: String, url: Uri)
}

pub type Source {
  Weblink
}

pub fn source_decoder() -> Decoder(Source) {
  use source <- decode.then(decode.string)

  case string.lowercase(source) {
    "weblink" -> decode.success(Weblink)
    _ -> decode.failure(Weblink, "Source")
  }
}

pub fn decoder() -> Decoder(Annotation) {
  use description <- decode.field("description", decode.string)
  use source <- decode.field("source", source_decoder())
  use title <- decode.field("title", decode.string)
  use url <- decode.then({
    use url_string <- decode.field("url", decode.string)
    case uri.parse(url_string) {
      Ok(url) -> decode.success(url)
      _ -> decode.failure(uri.empty, "Uri")
    }
  })

  decode.success(Annotation(description:, source:, title:, url:))
}
