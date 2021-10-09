#!/usr/bin/env groovy

pipeline {
  agent { 
    label 'slave-macos'
  }

  options {
    disableConcurrentBuilds()
  }

  stages {
    stage("Initialize") {
      steps {
        sh """
        bundle install 
        bundle exec fastlane run cocoa pods
        """
      }
    }
    stage("Swiftlint") {
      steps {
        sh "bundle exec fastlane swiftlint"
      }
    }
    stage("Danger") {
      steps {
        sh """
        export DANGER_GITHUB_API_TOKEN="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"
        bundle exec run danger
        """
      }
    }
  }
}
