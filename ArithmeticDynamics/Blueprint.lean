import Lean
open Lean

/-- Registers the `blueprint` tag attribute for theorem mapping to LaTeX files. -/
initialize blueprintAttr : TagAttribute ← registerTagAttribute `blueprint "Blueprint mapping"
