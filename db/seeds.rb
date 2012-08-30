Role.find_or_create_by_name('registered', :ordering => 1)
Role.find_or_create_by_name('admin', :ordering => 99)
Role.find_or_create_by_name('super_admin', :ordering => 100)

StaticText.find_or_create_by_path('about', :title => 'About', :enable_route => true)
