// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
	var isCI: Bool {
		return environmentVariable(get: "CI") == "true" ? true : false
	}
	
	func initLane() {
		desc("Run Initial")
		
		// Run 'pod install'
		cocoapods()
	}
	func swiftLintLane() {
		desc("Run SwiftLint")
		
		swiftlint(configFile: ".swiftlint.yml",
				  strict: true,
				  ignoreExitStatus: false,
				  raiseIfSwiftlintError: true,
				  executable: "Pods/SwiftLint/swiftlint"
		)
	}
	
	func dangerLane() {
		desc("Run Danger")
		
		danger(dangerfile: "Dangerfile",
			   githubApiToken: .fastlaneDefault(environmentVariable(get: "DANGER_GITHUB_API_TOKEN")),
			   newComment: .fastlaneDefault(true),
			   removePreviousComments: .fastlaneDefault(true)
		)
	}

	func certificatesLane() {

		desc("Update provisioning profiles and certificates for all build configurations")

		let configurations: [Configuration] = [InternalDebug(), TestFlight(), AppStore()]

		for configuration in configurations {

			match(
				type: configuration.exportMethod,
				readonly: .fastlaneDefault(isCI),
				appIdentifier: [configuration.bundleIdentifier],
				forceForNewDevices: configuration.exportMethod == "development"
			)
		}
	}
	
	func developLane() {
		certificatesLane()
		desc("Create a develop build and export an .ipa file")

		buildApp(workspace: "\(environmentVariable(get: "APP_NAME")).xcworkspace",
				 scheme: .fastlaneDefault("develop"),
				 clean: .fastlaneDefault(true),
				 configuration: .fastlaneDefault("Debug"),
				 skipPackageIpa: .fastlaneDefault(true),
				 exportMethod: .fastlaneDefault("development"),
				 skipArchive: .fastlaneDefault(true),
				 skipCodesigning: .fastlaneDefault(true),
				 derivedDataPath: .fastlaneDefault("./DerivedData"),
				 analyzeBuildTime: .fastlaneDefault(true))
	}
	
	func stagingLane() {
		certificatesLane()
		desc("Create a staging build and export an .ipa file")

		buildProduct(configuration: TestFlight(), exportIpa: true)
	}

	func productionLane() {
		certificatesLane()
		desc("Create a production build and export an .ipa file")

		buildProduct(configuration: AppStore(), exportIpa: true)
	}
	
	private func buildProduct(configuration: Configuration, exportIpa: Bool) {
		
		// Update provisioning profile and certificate for the specified build configuration
		match(
			type: configuration.exportMethod,
			readonly: .fastlaneDefault(isCI),
			appIdentifier: [configuration.bundleIdentifier],
			forceForNewDevices: .fastlaneDefault(configuration.exportMethod == "development")
		)
		
		// Build the product for the specified build configuration
		gym(
			scheme: .fastlaneDefault(configuration.targetSchemeName),
			outputName: .fastlaneDefault("\(configuration.targetSchemeName)-\(configuration.buildConfiguration).ipa"),
			configuration: .fastlaneDefault(configuration.buildConfiguration),
			skipPackageIpa: .fastlaneDefault(!exportIpa),
			exportMethod: .fastlaneDefault(configuration.exportMethod)
		)
	}
}

protocol Configuration {
	var exportMethod: String { get }
	var buildConfiguration: String { get }
	var targetSchemeName: String { get }
	var bundleIdentifier: String { get }
}

struct InternalDebug: Configuration {
	// Configuration for building debug builds on physical devices in-house
	var exportMethod = "development"
	var buildConfiguration = "Debug"
	var targetSchemeName = "develop"
	var bundleIdentifier: String {
		return "\(appIdentifier).develop"
	}
}

struct TestFlight: Configuration {
	// Configuration for building test builds to deploy in Test Flight
	var exportMethod = "adhoc"
	var buildConfiguration = "Release"
	var targetSchemeName = "staging"
	var bundleIdentifier: String {
		return "\(appIdentifier).staging"
	}
}

struct AppStore: Configuration {
	// Configuration for building release builds to deploy in App Store
	var exportMethod = "appstore"
	var buildConfiguration = "Release"
	var targetSchemeName = "production"
	var bundleIdentifier: String {
		return "\(appIdentifier)"
	}
}
