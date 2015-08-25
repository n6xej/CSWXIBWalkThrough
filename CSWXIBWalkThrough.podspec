Pod::Spec.new do |s|
  s.name            = 'CSWXIBWalkThrough'
  s.version         = '0.1.0'
  s.license         = { :type => 'MIT' }
  s.platform        = :ios, '6.0'

  s.summary         = 'Walk through'
  s.homepage        = 'https://github.com/n6xej/CSWXIBWalkThrough'
  s.author          = { 'Christopher Worley' => 'n6xej@yahoo.com'}
  s.source          = { :git => 'https://github.com/n6xej/CSWXIBWalkThrough.git', :tag => '0.1.0' }

  s.source_files    = 'CSWXIBWalkThrough'

  s.requires_arc    = true

  s.frameworks      = 'QuartzCore'
end
