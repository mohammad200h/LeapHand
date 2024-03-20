printf "thumbData.rb\nthumb.rb\nthumb.xml.erb\nlink.rb" | entr sh -c 'erb thumb.xml.erb > thumb.xml 2>&1 && xmllint --format thumb.xml > tmp.xml && mv tmp.xml thumb.xml'

