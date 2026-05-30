import Lean
open Lean Elab Command

syntax (name := verifyMatrixData) "#verify_matrix_data" str : command

@[command_elab verifyMatrixData]
def elabVerifyMatrixData : CommandElab := fun stx => do
  match stx with
  | `(#verify_matrix_data $path:str) =>
    let pathStr := path.getString
    let content ← IO.FS.readFile pathStr
    match Lean.Json.parse content with
    | Except.ok json =>
      match json.getObjVal? "modulus" with
      | Except.ok modObj =>
        match modObj.getNat? with
        | Except.ok modVal =>
          if modVal != 5 then
            throwError "Validation failed: modulus must be 5"
          logInfo m!"Successfully verified Python-generated JSON data: {json}"
        | Except.error e => throwError "Failed to parse modulus as Nat: {e}"
      | Except.error e => throwError "Failed to get modulus: {e}"
    | Except.error e => throwError "Failed to parse JSON: {e}"
  | _ => throwUnsupportedSyntax
