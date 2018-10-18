Pod::Spec.new do |s|
  s.name = "GraphQLicious"
  s.version = "1.1.1"
  s.summary = "A swift component with a DSL to declare GraphQL queries and to get string representations out of them"
  s.description = <<-DESC
  GraphQLicious is a leightweight framework for conveniently creating queries that can be read and interpreted by GraphQL.
  DESC

  s.homepage = "https://github.com/WeltN24/GraphQLicious"
  s.license = 'MIT'
  s.author = { "Felix Dietz" => "felix.dietz@weltn24.de" }
  s.source = { :git => "https://github.com/WeltN24/GraphQLicious.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*.swift', 'Sources/GraphQlicious.h'
end
