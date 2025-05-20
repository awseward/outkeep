//// This package is for handling exports, not creating them

import gleam/dict.{type Dict}
import outkeep/export/export_part.{type ExportPart}
import outkeep/export/note_file.{type NoteFileDict}

pub type Export =
  Dict(ExportPart, NoteFileDict)
