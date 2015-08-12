Pod::Spec.new do |s|
  s.name         = "OHMKit"
  s.version      = "0.2.1"
  s.summary      = "Map data to objects in Objective-C."
  s.description  = <<-DESC
                    Map service responses to objects.

                    OHMKit is a mixin to make any Objective-C class easier to hydrate from a dictionary representation, such as you might get from a RESTful web service.

                    It exists because RestKit encompasses far too many concerns, and Mantle likewise takes on too much.

                    There is no networking layer. There is no entity relationship management. There are other tools for that.
                   DESC
  s.homepage     = "https://github.com/fcanas/OHMKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Fabian Canas" => "fcanas@gmail.com" }
  s.source       = { :git => "https://github.com/fcanas/OHMKit.git", :tag => "v0.2.1" }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.source_files = 'Core'
  s.requires_arc = true
end
