function token_exp_time() {
    token_expiration_date=$(ls ~/.aws/sso/cache/ \
        | xargs -I % echo ~/.aws/sso/cache/% \
        | xargs -I % grep -e "startUrl.*region.*accessToken.*expiresAt" % \
        | jq .expiresAt \
        | sed -e 's/"//g')
    token_exp_date_nanoseconds=$(date +%s%N --date $token_expiration_date)
    current_date_nanoseconds=$(date +%s%N)
    difference_nanoseconds=$(echo "scale=2;$(($token_exp_date_nanoseconds-$current_date_nanoseconds))"|bc)
    seconds_remaining=$(echo "scale=2;$difference_nanoseconds/1000000000" | bc)
    minutes_remaining=$(echo "scale=2;$seconds_remaining/60" | bc)
    hours_remaining=$(echo "scale=2;$minutes_remaining/60" | bc)
    JSON_OUT=$(jq -n \
        --arg s "$seconds_remaining" \
        --arg m "$minutes_remaining" \
        --arg h "$hours_remaining" \
        --arg e "$token_expiration_date" \
        '{expiration_date: $e, seconds_remaining: $s, minutes_remaining: $m, hours_remaining: $h}')

    echo $JSON_OUT
}

function format_aws_starship() {
    hours_remaining=$(echo $(token_exp_time) | jq .hours_remaining | sed 's/"//g')
    minutes_remaining=$(echo $(token_exp_time) | jq .minutes_remaining | sed 's/"//g')
    seconds_remaining=$(echo $(token_exp_time) | jq .seconds_remaining | sed 's/"//g')
    formated_string=""
    if [[ $(echo $hours_remaining | awk -F"." '{print $1}') -gt 0 ]];
    then
        formated_string="$formated_string $hours_remaining hours left"
    elif [[ $(echo $minutes_remaining| awk -F"." '{print $1}') -gt 0 ]];
    then
        formated_string="$formated_string $minutes_remaining minutes left"
    elif [[ $(echo $seconds_remaining| awk -F"." '{print $1}') -gt 0 ]];
    then
        formated_string="$formated_string $seconds_remaining seconds left"
    else
        formated_string="$formated_string EXPIRED"
    fi
    printf "%s" "${formated_string}"
}
