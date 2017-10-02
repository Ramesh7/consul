name             "consul"
maintainer       "Example Software Inc."
maintainer_email "operations-team+chef@example.com"
license          "All rights reserved"
description      "Installs/Configures consul"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{ centos }.each do |os|
  supports os
end

depends 'coupa-base', '~> 1.6.0'
