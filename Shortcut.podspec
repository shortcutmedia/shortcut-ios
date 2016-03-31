Pod::Spec.new do |s|

  shortcut_sdk_version = File.read('Shortcut/Shortcut.h', encoding: Encoding::UTF_8).match(/SDK_VERSION @\"([^\"]+)\"/u)[1]

  s.name         = "Shortcut"
  s.version      = shortcut_sdk_version
  s.summary      = "This is the iOS SDK of Shortcut. Learn more about Shortcut on https://shortcut.sc"

  s.description  = <<-DESC
                    This SDK provides the following features:

                    - Collection of statistics (app usage, deep links).
                    - Support for deferred deep linking.
                    - Creation Shortcuts (short mobile deep links) to share from within your app.
                   DESC

  s.homepage         = "https://shortcut.sc"
  s.social_media_url = "https://twitter.com/ShortcutMedia"


  s.license  = { :type => "MIT", :file => "LICENSE.txt" }

  s.author   = "Shortcut Media AG"

  s.platform = :ios, "6.0"

  s.source              = { :git => "https://github.com/shortcutmedia/shortcut-ios.git", :tag => "v#{shortcut_sdk_version}" }
  s.source_files        = "Shortcut/**/*.{h,m}"
  s.public_header_files = ["Shortcut/Shortcut.h", "Shortcut/SCConfig.h", "Shortcut/SCSession.h"] # TODO: get this from Xcode project file
  s.requires_arc        = true

end
