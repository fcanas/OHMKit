#
# Be sure to run `pod spec lint ObjectMapping.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "ObjectMapping"
  s.version      = "0.0.1"
  s.summary      = "Map service responses to objects in Objective-C."
  s.description  = <<-DESC
                    Map service responses to objects.

                    This project is a [mixin](http://en.wikipedia.org/wiki/Mixin) to make any Objective-C class easier to hydrate from a dictionary representation, such as you might get from a RESTful web service.

                    It exists because [RestKit](https://github.com/RestKit/RestKit) (which is awesome by the way), is too big, heavy, and indirect.

                    There is no networking layer. Use [AFNetworking](https://github.com/AFNetworking/AFNetworking).
                   DESC
  s.homepage     = "https://github.com/fcanas/ObjectMapping"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Fabian Canas" => "fcanas@gmail.com" }
  s.source       = { :git => "https://github.com/fcanas/ObjectMapping.git", :tag => "0.0.1-alpha" }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.source_files = 'Core'
  # A list of file patterns which select the header files that should be
  # made available to the application. If the pattern is a directory then the
  # path will automatically have '*.h' appended.
  #
  # If you do not explicitly set the list of public header files,
  # all headers of source_files will be made public.
  #
  # s.public_header_files = 'Classes/**/*.h'
  s.requires_arc = false
end
