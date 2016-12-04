Pod::Spec.new do |s|

s.name         = "KZSegmentedPageView"
s.version      = "1.0.1"
s.summary      = "Subclass that combines the functionality of UISegmentedControl and UIPageViewController"
s.homepage     = "https://github.com/kuyazee/KZSegmentedPageView"
s.license      = { :type => "MIT", :file => "LICENSE" }

s.author             = { "Zonily Jame Pesquera" => "zonilyjame@gmail.com" }
s.social_media_url   = "http://twitter.com/kuyazee"

s.platform     = :ios, "8.0"
s.requires_arc = true
s.source       = { :git => "https://github.com/kuyazee/KZSegmentedPageView.git", :tag => "#{s.version}" }
s.source_files  = "KZSegmentedPageView", "KZSegmentedPageView/**/*.{h,swift}"


end
