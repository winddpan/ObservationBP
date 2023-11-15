import Foundation
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct ObservationBPMacroPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    ObservableMacro.self,
    ObservationTrackedMacro.self,
    ObservationIgnoredMacro.self,
  ]
}
