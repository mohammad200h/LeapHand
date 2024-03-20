printf "fingerData.rb\nfinger.rb\nfinger.xml.erb\nlink.rb" | entr sh -c 'erb finger.xml.erb > finger.xml 2>&1 && xmllint --format finger.xml > tmp.xml && mv tmp.xml finger.xml'

