Pod::Spec.new do |s|
  s.name         = "RealmSwiftNYTStories"
  s.version      = "1.3"
  s.summary      = "Ready-to-go JSON parsing of New York Times Top Stories API into Realm Swift models"
  s.description  = <<-DESC
Loads data from New York Times Top Stories API and parses the JSON into provided Realm Swift models.
                   DESC
  s.homepage     = "https://github.com/bigfish24/RealmNYTStories"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Adam Fish" => "af@realm.io" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/bigfish24/RealmNYTStories.git", :tag => "v#{s.version}" }
  s.source_files  = "swift/*.{swift}"
  s.requires_arc = true
  s.dependency "RealmSwift", ">= 0.100.0"

end
