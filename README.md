sensu-check-splunk
==================

A sensu check for splunk alerts

Features
--------
* Fetches alert count and manages sensu event
* Supports Critical, Warning and OK events

Configuration
-------------
Below is an example configuration for the check.  While the plugin supports passing username/password via the CLI inputs, I suggest modifying the default values in splunk-check.rb and not passing them in.
`/etc/sensu/conf.d/checks/splunk.json`
```
{
  "checks": {
    "splunk": {
      "command": "splunk-check.rb -c 2 -w 1 -h '127.0.0.1' -p 8089 -u user -P password -s true",
      "handlers": [
        "email"
      ],
      "standalone": true,
      "interval": 30,
      "refresh": 1800
    }
  }
}
```


License and Author
==================

Author:: Bryan Brandau <agent462@gmail.com>

Copyright:: 2013, Bryan Brandau

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
