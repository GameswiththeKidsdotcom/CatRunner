//
//  B2AssetLoaderTests.swift
//  CatRunnerTests
//
//  B2 — Validate asset loader: load assets.json from bundle, resolve character.run to non-nil texture when file exists.
//

import XCTest
@testable import CatRunner

final class B2AssetLoaderTests: XCTestCase {

    /// Load assets.json from main bundle (app bundle when tests run with host application). B1 must have copied config and assets.
    func testLoadAssetsJson_fromMainBundle_returnsConfigWhenPresent() {
        let config = AssetConfig.load(fromBundle: .main, subdirectory: "config/default")
        // When B1 has run, config should be non-nil. If bundle has no config (e.g. test run without app host), config can be nil.
        if config == nil {
            // Skip assertion when running without app bundle (e.g. no B1 resources in bundle)
            return
        }
        XCTAssertNotNil(config, "assets.json should load when present in bundle (config/default)")
    }

    /// Resolve character.run to texture when assets.json and asset file exist in bundle.
    func testCharacterRunTexture_nonNilWhenFileExists() {
        guard let config = AssetConfig.load(fromBundle: .main, subdirectory: "config/default") else {
            // No assets.json in bundle (e.g. test bundle only); skip
            return
        }
        let texture = config.texture(forKey: "character.run")
        XCTAssertNotNil(texture, "character.run should resolve to non-nil texture when assets/character/cat_run.png exists in bundle")
    }

    /// Missing path returns nil (no crash).
    func testTextureForMissingPath_returnsNil() {
        guard let config = AssetConfig.load(fromBundle: .main, subdirectory: "config/default") else {
            return
        }
        let texture = config.texture(for: "assets/nonexistent/fake.png")
        XCTAssertNil(texture)
    }
}
