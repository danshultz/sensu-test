name             'sensu-test'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures sensu-test'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# TODO Add version numbers
%w(
  sensu
  ohai
).each { |dep| depends(dep) }
