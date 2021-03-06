Pod::Spec.new do |s|
  s.name             = "WTCalendarView"
  s.version          = "0.3.0"
  s.summary          = "Date range picker with customizeable components."
  s.homepage         = "https://github.com/witochandra/CalendarView"
  s.license          = 'MIT'
  s.author           = { "Wito Chandra" => "wito.c.91@gmail.com" }
  s.source           = { :git => "https://github.com/witochandra/CalendarView.git", :tag => '0.3.0' }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/Classes/**/*.swift'
  s.resources = ['Source/Assets/*.png', 'Pod/Classes/**/*.xib']
end
