# Weather API
[ -f ~/.sherpa/basecamp.sh ] && . ~/.sherpa/basecamp.sh
use "std/fmt"

api="https://api.weatherapi.com/v1"
key="dcf12bd1f0584c71b01163151242611"

if [ -z $city ] && [ -n $city_default ]; then
    city=$city_default
elif [ -n $city ]; then
    city=$city
fi

meteoNow="${api}/current.json?key=${key}&q=${city}&aqi=no"

w_temp_c="$(fetch $meteoNow | jq .current.temp_c)"
w_location="$(fetch $meteoNow | jq .location.name)"
