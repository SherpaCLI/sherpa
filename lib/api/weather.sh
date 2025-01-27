# Weather API
[ -f ~/.sherpa/basecamp.sh ] && . ~/.sherpa/basecamp.sh
use "std/fmt"

api="https://api.weatherapi.com/v1"
key="$(env "WEATERAPI_KEY")"
city="Berlin" # Try with yours instead

meteoNow="${api}/current.json?key=${key}&q=${city}&aqi=no"

w_temp_c="$(fetch $meteoNow | jq .current.temp_c)"
w_location="$(fetch $meteoNow | jq .location.name)"

# --- Usage --- #

# 1.Place your free API key in "$SCD/env.sh"
# 2.In some BashBox print the temperature outside
#
# use "api/wheater"
#
# main() {
#   p "We have ${w_temp_c}°C in ${w_location}"
# }
