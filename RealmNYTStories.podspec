Pod::Spec.new do |s|
  s.name         = "RealmNYTStories"
  s.version      = "1.3"
  s.summary      = "Ready-to-go JSON parsing of New York Times Top Stories API into Realm models"
  s.description  = <<-DESC
Loads data from New York Times Top Stories API and parses the JSON into provided Realm models.
                   DESC
  s.homepage     = "https://github.com/bigfish24/RealmNYTStories"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Adam Fish" => "af@realm.io" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/bigfish24/RealmNYTStories.git", :tag => "v#{s.version}" }
  s.source_files  = "objective-c/*.{h,m}"
  s.requires_arc = true
  s.dependency "Realm", ">= 0.100.0"

end
