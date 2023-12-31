#!/bin/bash

# Copyright (C) 2023 Ahmad Ismail
# SPDX-License-Identifier: AGPL-3.0-only

data_file='basics.yml'

# YAML is easier for humans
# JSON is easier for computers
# Write content in YAML, then convert it to JSON once during initialization
# I see this as an absolute win!
data_json="$(yq -Mc '.' "$data_file")"

dialog_out="/tmp/dialog_out.$RANDOM"
SQL_CONNECT='mysql -h localhost -u sql_tutor -D sql_tutor -t'

function int_exit
{
    dialog --erase-on-exit --title "Interrupt" --yesno "Are you sure you want to exit?" 0 0

    if [[ $? -eq 0 ]] ; then
        rm "$dialog_out" 2> /dev/null
        exit 2
    fi
}

# Expects 2 arguments: $1 is the correct command, $2 is the user supplied command
function validate_command
{
    tmp1="$($SQL_CONNECT -e "$1")"
    if [[ "$2" == 'solution' ]]; then

        dialog --backtitle "$i/$total" --no-collapse --colors --title "\Z2 Solution: $1" --msgbox "$tmp1" 0 0
        return 0
    fi

    if [[ "$1" == "$2" ]]; then
        dialog --backtitle "$i/$total" --no-collapse --colors --title '\Z2 Correct!' --msgbox "$tmp1" 0 0
        return 0

    else
        tmp2="$($SQL_CONNECT -e "$2")"
        if [[ "$tmp1" == "$tmp2" ]]; then
            dialog --backtitle "$i/$total" --no-collapse --colors --title '\Z2 Correct!' --msgbox "$tmp1" 0 0
            return 0
        else
            dialog --backtitle "$i/$total" --colors --title '\Z1 Oops' --msgbox 'Try Again' 0 0
        return 1
        fi
    fi
}

i='1'
total=$(awk '/d[[:digit:]]+:/ {++i}; END {print i}' $data_file)
trap 'int_exit' INT

while [[ i -le total ]]; do
    OIFS="$IFS"
    IFS=$'\n'

    # The sed filter removes leading and trailing double quotes, and removes the escape from all other double quotes and literal backslash
    dialog_data=($(jq -M ".d$i.title, .d$i.type, .d$i.content, .d$i.command" <<< "$data_json" | sed -e 's/^"\|"$//g' -e 's/\\"/"/g' -e 's/\\\\/\\/g'))
    IFS="$OIFS"

    title="${dialog_data[0]}"
    dtype="${dialog_data[1]}"
    content="${dialog_data[2]}"
    command="${dialog_data[3]}"

    case "$dtype" in
    "yesno")

        if [[ $content == 'null' ]]; then
            content="$(bash -c "$command")"
        fi

        dialog --backtitle "$i/$total" --colors --no-collapse --title "$title" --yes-label Next --no-label Previous --yesno "$content" 0 0
        ret=$?
        if [[ ret -eq 0 ]]; then
            let ++i
        elif [[ ret -eq 1 ]] && [[ i -gt 1 ]]; then
            let --i
        fi
    ;;



    "inputbox")
        while true; do
            # You have to let something read from the FIFO otherwise dialog will stall forever
            # So background the dialog and start reading from the FIFO
            # Better than writing to a temporary file
            dialog --backtitle "$i/$total" --colors --extra-button --extra-label Solution --no-collapse --cancel-label Previous --title "$title" --inputbox "$content" 0 0 2> "$dialog_out"
            ret=$?

            if [[ ret -eq 1 ]] && [[ i -gt 1 ]]; then
                let --i
                break
            fi

            if [[ ret -eq 3 ]]; then
                validate_command "$command" 'solution'
                let ++i
                break
            fi

            user_input="$(< "$dialog_out")"
            if validate_command "$command" "$user_input"; then
                let ++i
                break
            fi
        done
    ;;
    esac
done

dialog --erase-on-exit --title 'Congratulations' --msgbox "You have completed this module!" 0 0
rm "$dialog_out" 2> /dev/null
