Pod::Spec.new do |s|
  s.name             = "WTCalendarView"
  s.version          = "0.1.2"
  s.summary          = "Date range picker with customizeable components."
  s.homepage         = "https://github.com/witochandra/CalendarView"
  s.license          = 'MIT'
  s.author           = { "Wito Chandra" => "wito.c.91@gmail.com" }
  s.source           = { :git => "https://github.com/witochandra/CalendarView.git", :tag => '0.1.2' }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.swift'
  s.resource_bundle = {
    'CalendarView' => ['Pod/Assets/*.png', 'Pod/Classes/**/*.xib']
  }
end
