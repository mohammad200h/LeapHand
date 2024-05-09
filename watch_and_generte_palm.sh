printf "palmData.rb\npalm.rb\npalm.xml.erb\nlink.rb" | entr sh -c 'erb palm.xml.erb > palm.xml 2>&1 && xmllint --format palm.xml > tmp.xml && mv tmp.xml palm.xml'

