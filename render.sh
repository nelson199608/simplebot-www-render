#!/bin/bash

# configure the bot
python3 -m simplebot init "$ADDR" "$PASSWORD"
python3 -m simplebot -a "$ADDR" set_name "$BOT_NAME"
python3 -m simplebot -a "$ADDR" db -s "simplebot_instantview/max_size" "15728640"  # 15MB
python3 -m simplebot -a "$ADDR" db -s "simplebot_downloader/mode" "command"
python3 -m simplebot -a "$ADDR" db -s "simplebot_downloader/max_size" "1073741824"  # 1GB
python3 -m simplebot -a "$ADDR" db -s "simplebot_downloader/delay" $DELAY
python3 -m simplebot -a "$ADDR" db -s "simplebot_translator/filter_enabled" "no"
python3 ./restore_keys.py

# add the web_comress plugin
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/web_compress.py'); open('web_compress.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./web_compress.py

# add simple web server for service healthy 
python3 -m simplebot -a "$ADDR" plugin --add ./simplebot_render.py

# add the youtube plugin
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/youtube.py'); open('youtube.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./youtube.py

# add the web2pdf plugin
sudo apt-get install wkhtmltopdf
python3 -c "import requests; r=requests.get('https://github.com/nelson9608/simplebot-scripts/raw/master/scripts/web2pdf.py'); open('web2pdf.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./web2pdf.py

# add the web_screenshot plugin
sudo sysctl -w kernel.unprivileged_userns_clone 
= 1
python3 -c "import requests; r=requests.get('https://github.com/nelson9608/simplebot-scripts/raw/master/scripts/web_screenshot.py'); open('web_screenshot.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./web_screenshot.py


# add the encryption_error plugin to leverage key changes
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/encryption_error.py'); open('encryption_error.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./encryption_error.py

# add the misc search plugin
python3 -c "import requests; r=requests.get('https://github.com/nelson9608/simplebot-scripts/raw/master/scripts/misc.py'); open('misc.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./misc.py

# add the wiki plugin
python3 -c "import requests; r=requests.get('https://github.com/nelson9608/simplebot-scripts/raw/master/scripts/wikip.py'); open('wikip.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./wikip.py


# add admin plugin
if [ -n "$ADMIN" ]; then
    python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/admin.py'); open('admin.py', 'wb').write(r.content)"
    python3 -m simplebot -a "$ADDR" plugin --add ./admin.py
    python3 -m simplebot -a "$ADDR" admin --add "$ADMIN"
fi

# start the bot
python3 -m simplebot -a "$ADDR" serve
