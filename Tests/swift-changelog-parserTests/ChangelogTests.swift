import ArgumentParser
import Markdown
import Testing
@testable import swift_changelog_parser

let changelog = """
# Changelog

## Unreleased

- Added thing
- Fixed thing

## 1.1.0

- Second release

## 1.0.0

- First release
"""

@Suite struct ChangelogTests {

    func section(_ release: Changelog.Release, markdown: String = changelog) throws -> String {
        try Changelog.section(of: Document(parsing: markdown), for: release)
    }

    @Test func unreleased() throws {
        #expect(try section(.unreleased) == "- Added thing\n- Fixed thing")
    }

    @Test func latest() throws {
        #expect(try section(.latest) == "- Second release")
    }

    @Test func specificRelease() throws {
        #expect(try section(.release("1.0.0")) == "- First release")
    }

    @Test func missingSectionThrows() {
        #expect(throws: ValidationError.self) {
            try section(.release("2.0.0"))
        }
    }

    @Test func emptySectionReturnsEmptyString() throws {
        let markdown = """
        # Changelog

        ## Unreleased

        Some prose, but no list.
        """
        #expect(try section(.unreleased, markdown: markdown).isEmpty)
    }
}
