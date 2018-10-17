#!/bin/bash



function print_banner {
    echo -e "\e[33m   ____   __  __ _ _              _____           _        _ _ \e[0m";
    echo -e "\e[33m  / __ \ / _|/ _| (_)            |_   _|         | |      | | |\e[0m";
    echo -e "\e[33m | |  | | |_| |_| |_ _ __   ___    | |  _ __  ___| |_ __ _| | |\e[0m";
    echo -e "\e[33m | |  | |  _|  _| | | '_ \ / _ \   | | | '_ \/ __| __/ _\` | | |\e[0m";
    echo -e "\e[33m | |__| | | | | | | | | | |  __/  _| |_| | | \__ \ || (_| | | |\e[0m";
    echo -e "\e[33m  \____/|_| |_| |_|_|_| |_|\___| |_____|_| |_|___/\__\__,_|_|_|\e[0m";
    echo -e "\e[33m                                                               \e[0m";
}

function colorful_echo {
    RED='\E[31m'
    GREEN='\E[32m'
    YELLOW='\E[33m'
    BLUE='\E[34m'
    WHITE='\E[38m'
    END='\033[0m'

    msg=$1
    color=$2
    case $color in
        "red")
            current_color=$RED
            ;;
        "green")
            current_color=$GREEN
            ;;
        "yellow")
            current_color=$YELLOW
            ;;
        "blue")
            current_color=$BLUE
            ;;
        "*")
            current_color=$WHITE
            ;;
    esac

    echo -e "$current_color$msg$END"

}

function print_stage {
    stage_msg=$1

    # Output border character
    stage_color="green"
    border_char="="
    num='72'
    border=$(printf "%-${num}s" "${border_char}")

    echo ""
    echo ""
    colorful_echo "${border// /${border_char}}" $stage_color
    colorful_echo "${stage_msg}" $stage_color
    colorful_echo "${border// /${border_char}}" $stage_color
}

print_banner
colorful_echo "hello shit" "red"
print_stage "stage 1"