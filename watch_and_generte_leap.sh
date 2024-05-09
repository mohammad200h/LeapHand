printf "palmData.rb\nfingerData.rb\nthumbData.rb\nleap.rb\npalm.rb\nfinger.rb\nthumb.rb\nleap.xml.erb\nlink.rb" | entr sh -c 'erb leap.xml.erb > leap.xml 2>&1 && xmllint --format leap.xml > tmp.xml && mv tmp.xml leap.xml'

