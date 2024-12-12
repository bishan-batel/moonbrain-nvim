import XCTest
import SwiftTreeSitter
import TreeSitterMoonbrain

final class TreeSitterMoonbrainTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_moonbrain())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading Moonbrain grammar")
    }
}
