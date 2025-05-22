import gleam/dynamic/decode.{type Decoder}

pub type ChecklistItem {
  ChecklistItem(is_checked: Bool, text: String, text_html: String)
}

pub fn decoder() -> Decoder(ChecklistItem) {
  use is_checked <- decode.field("isChecked", decode.bool)
  use text <- decode.field("text", decode.string)
  use text_html <- decode.field("textHtml", decode.string)
  decode.success(ChecklistItem(is_checked:, text:, text_html:))
}

pub fn is_checked(ci: ChecklistItem) -> Bool {
  ci.is_checked
}

pub fn text(ci: ChecklistItem) -> String {
  ci.text
}

pub fn text_html(ci: ChecklistItem) -> String {
  ci.text_html
}
