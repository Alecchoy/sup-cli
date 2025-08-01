#!/bin/zsh

# Support CLI for Support Engineer Workflow
# skips okta, jpms, jenkins, supportlogs

############## YOU WILL NEED TO ADD THE FOLLOWING PARAMETERS :) ##############

CONFIG_DIR="$HOME/.supportMT"
CONFIG_FILE="$CONFIG_DIR/supportMT.conf"

# Create the configuration directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Load the configuration from the config file
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    # Default configuration
    SOURCE_DIR="${HOME}/Downloads"
    BASE_DEST_DIR="${HOME}/cases"
    JFROG_TOKEN="your_default_token_here"
    JENKINS_USER="your_default_username_here"
    JENKINS_API_TOKEN="your_default_api_token_here"
fi

# Function to prepend $HOME if the input is a relative path
prepend_home_if_needed() {
    local input_path="$1"
    if [[ "$input_path" != /* ]]; then
        echo "$HOME/$input_path"
    else
        echo "$input_path"
    fi
}

# Function to prompt user for configuration changes
prompt_for_changes() {
    
    echo 
    echo "\033[1;37m\033[43mif you are having trouble with the configuration, please read the help page with 'sup --help'\033[0m"
    sleep 1
    echo -e "\033[1;32m"
    echo "Would you like to change the current configuration? (y/n): \c"
    read -r change_config

    if [[ "$change_config" == "y" || "$change_config" == "Y" ]]; then
        echo
        echo "(1/5) Current Downloads Folder: $SOURCE_DIR"
        echo "(1/5) Enter your Downloads Folder (leave blank to keep current): \c"
        read -r new_source_dir
    
        if [[ -n "$new_source_dir" ]]; then
            SOURCE_DIR=$(prepend_home_if_needed "$new_source_dir")
        fi
        echo
        
        echo "(2/5) Current BASE_DEST_DIR: $BASE_DEST_DIR"
        echo
        sleep 1
        echo "**this folder must be created in HOME directory first**"
        sleep 1
        echo
        echo "(2/5) Define Case directory (leave blank to keep current): \c"
        read -r new_base_dest_dir
        if [[ -n "$new_base_dest_dir" ]]; then
            BASE_DEST_DIR=$(prepend_home_if_needed "$new_base_dest_dir")
        fi
        echo
        echo "(3/5) Current JFROG_TOKEN: $JFROG_TOKEN"
        echo "(3/5) Enter new JFROG_TOKEN (leave blank to keep current): \c"
        read -r new_jfrog_token
        if [[ -n "$new_jfrog_token" ]]; then
            JFROG_TOKEN="$new_jfrog_token"
        fi
        echo
        echo "(4/5) Current JENKINS_USER: $JENKINS_USER"
        echo "(4/5) Enter new JENKINS_USER (leave blank to keep current): \c"
        read -r new_jenkins_user
        if [[ -n "$new_jenkins_user" ]]; then
            JENKINS_USER="$new_jenkins_user"
        fi
        echo
        echo "(5/5) Current JENKINS_API_TOKEN: $JENKINS_API_TOKEN"
        echo "(5/5) Enter new JENKINS_API_TOKEN (leave blank to keep current): \c"
        read -r new_jenkins_api_token
        if [[ -n "$new_jenkins_api_token" ]]; then
            JENKINS_API_TOKEN="$new_jenkins_api_token"
        fi

        # Save the updated configuration to the config file
        save_config_to_file
    fi
}

# Function to save configuration to the config file
save_config_to_file() {
    cat > "$CONFIG_FILE" <<EOF
SOURCE_DIR="$SOURCE_DIR"
BASE_DEST_DIR="$BASE_DEST_DIR"
JFROG_TOKEN="$JFROG_TOKEN"
JENKINS_USER="$JENKINS_USER"
JENKINS_API_TOKEN="$JENKINS_API_TOKEN"
EOF
    echo "Configuration saved to $CONFIG_FILE."
}

# Function to display the current configuration
show_current_config() {
    echo -e "\033[1;32m"
    echo "Current Configuration:"
    echo "SOURCE_DIR: $SOURCE_DIR"
    echo "BASE_DEST_DIR: $BASE_DEST_DIR"
    echo "JFROG_TOKEN: $JFROG_TOKEN"
    echo "JENKINS_USER: $JENKINS_USER"
    echo "JENKINS_API_TOKEN: $JENKINS_API_TOKEN"
}

# Check if --config or --config-show was passed as an argument
#if [[ "$1" == "--config" ]]; then
#    prompt_for_changes
#elif [[ "$1" == "--config-show" ]]; then
#    show_current_config
#    exit 0
#fi 

if [[ "$1" == "--help" ]]; then
    echo 
    echo -e "\033[1;32m╔═════════════════════════════╗\033[0m"
    echo -e "\033[1;32m║           HELP PAGE         ║\033[0m"
    echo -e "\033[1;32m╚═════════════════════════════╝\033[0m"
    echo -e "\033[1;32m"

    echo -e "\033[1;32mRunning the script from the main menu is just running the script as usual.\033[0m"
    echo -e "\033[1;32mUse the secondary method by passing a command and case number to trigger specific functions.\033[0m"
    echo 
    echo -e "\033[1;32mMAIN-MENU"
    echo -e "Usage: sup "
    echo -e "      "
    echo -e "\033[1;92m  Commands:\033[0m"
    echo -e "\033[1;92m    \033[4munpack-from-downloads\033[0m           \033[0m- \033[0;92mUnpack files locally or from Downloads folder.\033[0m"
    echo -e "\033[1;92m    \033[4munpack-from-supportlogs\033[0m     \033[0m- \033[0;92mDownload and unpack bundles from the SaaS server.\033[0m"
    echo -e "\033[1;92m    \033[4mproduction-bundle\033[0m        \033[0m- \033[0;92mTrigger and download production bundle from Jenkins.\033[0m"
    echo -e "\033[1;92m    \033[4mget-application-detail\033[0m   \033[0m- \033[0;92mTrigger a get-app-detail job from Jenkins.\033[0m"
    echo -e "\033[1;92m    \033[4menable-debug-loggers\033[0m     \033[0m- \033[0;92mEnable debug loggers for various services.\033[0m"
      echo -e "\033[1;92m    \033[4madd-artifactory-system-properties\033[0m     \033[0m- \033[0;92mView:Add:Delete artifactory system properties.\033[0m"
      echo -e "\033[1;92m    \033[4mget-artifactory-config\033[0m     \033[0m- \033[0;92mRetreive Artifactory config files.\033[0m"
      echo -e "\033[1;92m    \033[4mredeploy-artifactory-server\033[0m     \033[0m- \033[0;92mTrigger Immediate or Scheduled Redeploy.\033[0m"
      echo -e "\033[1;92m    \033[4mupgrade-artifactory-server\033[0m     \033[0m- \033[0;92mTrigger Immediate or Scheduled Upgrade.\033[0m"
      echo -e "\033[1;92m    \033[4mgenerate-bofa-token\033[0m     \033[0m- \033[0;92mGenerate a BOFA token for Support Bundle\033[0m"
      echo -e "\033[1;92m    \033[4mcot-saas-to-saas\033[0m     \033[0m- \033[0;92mConfigure COT between SAAS and SAAS.\033[0m"
      echo -e "\033[1;92m    \033[4mcot-saas-to-onprem\033[0m     \033[0m- \033[0;92mConfigure COT between SAAS and On-Prem.\033[0m"
    echo
    
    echo -e "\033[1;32mSHORT-FORM:\033[0m"
    echo -e "\033[1;32mUsage: sup [command] [case-number]\033[0m"
    echo -e "\033[1;32m      "
    echo -e "\033[1;92m  Commands:\033[0m"
    echo -e "  \033[1;92m  \033[4mdownload\033[0m          \033[0m- \033[0;92mUnpack files locally or from Downloads folder.\033[0m"
    echo -e "  \033[1;92m  \033[4msaas\033[0m                   \033[0m- \033[0;92mTriggers unpack-from-supportlogs function.\033[0m"
    echo -e "  \033[1;92m  \033[4mprod\033[0m                   \033[0m- \033[0;92mTriggers production-bundle function.\033[0m"
    echo -e "  \033[1;92m  \033[4mdetail\033[0m                 \033[0m- \033[0;92mTriggers get-application-detail function.\033[0m"
    echo -e "  \033[1;92m  \033[4mlogger\033[0m                \033[0m- \033[0;92mTriggers enable-debug-loggers function.\033[0m"
    echo -e "  \033[1;92m  \033[4mproperties\033[0m                \033[0m- \033[0;92mTriggers add-artifactory-system-properties function.\033[0m"
    echo -e "  \033[1;92m  \033[4mgetconfig\033[0m                \033[0m- \033[0;92mTriggers get-artifactory-config  function.\033[0m"
echo -e "  \033[1;92m  \033[4mredeploy\033[0m                \033[0m- \033[0;92mTriggers redeploy-artifactory-server function.\033[0m"
echo -e "  \033[1;92m  \033[4mupgrade\033[0m                \033[0m- \033[0;92mTriggers upgrade-artifactory-server function.\033[0m"
echo -e "  \033[1;92m  \033[4mbofa\033[0m                \033[0m- \033[0;92mTriggers generate-bofa-token function.\033[0m"
echo -e "  \033[1;92m  \033[4mcotsaas\033[0m                \033[0m- \033[0;92mTriggers cot-saas-to-saas function.\033[0m"
echo -e "  \033[1;92m  \033[4mcotonprem\033[0m                \033[0m- \033[0;92mTriggers cot-saas-to-onprem function.\033[0m"
    echo
    echo -e "\033[1;92m    Examples:\033[0m"
    echo -e "\033[1;92m    sup <file-name-from-DOWNLOAD-FOLDER> <case-number>\033[0m"
    echo -e "\033[1;92m    sup saas <case-number>\033[0m"
    echo -e "\033[1;92m    sup prod <case-number>\033[0m"
    echo -e "\033[1;92m    sup detail\033[0m"
    echo -e "\033[1;92m    sup loggers\033[0m"
       echo -e "\033[1;92m    sup properties\033[0m"
    echo -e "\033[1;92m    sup getconfig\033[0m"
         echo -e "\033[1;92m    sup redeploy\033[0m"
         echo -e "\033[1;92m    sup upgrade\033[0m"
       echo -e "\033[1;92m    sup bofa\033[0m"  
       echo -e "\033[1;92m    sup cotsaas\033[0m"
   echo -e "\033[1;92m    sup cotonprem\033[0m"
    echo
    echo -e "\033[1;92mNote: Replace <case-number> with the actual case number.\033[0m"
    echo
    echo -e "\033[1;92mFor more information or feature requests, check the script comments or reach out to alec :D.\033[0m"
    exit 0
fi


# Function to extract based on file type with user prompt
extract_file() {
    local file="$1"
    local dir_path=$(dirname "$file")

    if [[ ! -f "$file" ]]; then
        echo "File $(basename "$file") not found in $SOURCE_DIR."
        return 1
    fi

    if [[ $file == *.zip ]]; then
        echo "Unzipping $file in $dir_path..."
        unzip -o -d "$dir_path" "$file" && rm "$file"
    elif [[ $file == *.tar.gz ]]; then
        echo "Extracting $file in $dir_path..."
        tar -zxvf "$file" -C "$dir_path" && rm "$file"
    elif [[ $file == *.gz && $file != *.tar.gz ]]; then
        echo "Decompressing $file in $dir_path..."
        gunzip -k "$file" && rm "$file"
    else
        echo "Unsupported file type: $file"
        return 1
    fi
}

# Function to recursively unzip, extract, and decompress files
process_files_recursively() {
    local bundle_dir=$1
    
    find "$bundle_dir" -type f \( -name '*.zip' -o -name '*.tar.gz' -o -name '*.gz' ! -name '*.tar.gz' \) | while read file; do
        extract_file "$file"
    done

    # Find directories named "archived" and decompress .log.gz files within
    find "$bundle_dir" -type d -name "archived" | while read archived_dir; do
        find "$archived_dir" -type f -name '*.log.gz' | while read logfile; do
            gunzip -k "$logfile" && rm "$logfile"
        done
    done
     echo -e "\033[1;32m"
        echo -e "\033[1;32m╔═════════════════════════════════════════════╗\033[0m"
        echo -e "\033[1;32m║  Nice! The Support bundle is now unzipped.  ║\033[0m"
        echo -e "\033[1;32m╚═════════════════════════════════════════════╝\033[0m"
    echo
    echo -e "\033[1;32mCOMPLETED PROCESSING ALL FILES INSIDE:                       \033[0m"
    echo -e "\033[1;95m$DEST_DIR/$NEW_BUNDLE_FOLDER\033[0m"
    exit 0 
}

# Function to download file from SaaS server
download_from_saas() {
    echo -e "\033[1;32m"
    local case_number=$CASE_ID
    local response
    local options
    local last_modified

    # Run the curl command to list the options and capture the response
    response=$(curl -s -H "Authorization: Bearer $JFROG_TOKEN" -H "Accept: application/json" "https://<REDACTED_URL>/api/storage/logs/$case_number?list&deep=1")

    # Parse the response to extract file URIs and last modified dates
    options=("${(@f)$(echo "$response" | jq -r '.files[] | select(.uri != null and .uri != "") | .uri' 2>/dev/null)}")
    last_modified=("${(@f)$(echo "$response" | jq -r '.files[] | select(.uri != null and .uri != "") | .lastModified' 2>/dev/null)}")

    # Check if the options array is not empty
    if [[ ${#options[@]} -eq 0 ]]; then
        echo "No files found for case number $case_number, or there was an error parsing the response."
        return 1
    fi

    # Determine the new bundle number and directory
    NEW_BUNDLE_FOLDER="support_bundle${NEW_NUMBER}"
    NEW_BUNDLE_DIR="$DEST_DIR/$NEW_BUNDLE_FOLDER"
    mkdir -p "$NEW_BUNDLE_DIR"

    # Display the available options in a numbered menu
    echo "Starting Process for Unpacking Bundle from Support Logs :D"
    echo
    echo "Available options:"
    for i in {1..${#options[@]}}; do
        if [[ -n "${options[$i]}" ]]; then
            echo "$i: Last Modified: ${last_modified[$i]}"
            echo "   ${options[$i]}"
        fi
    done

    # Ask the user to choose options by number (comma-separated)
    echo
    echo "Enter the numbers of the files you want to download (multiple files must be comma-separated): "
    read option_numbers

    # Split the option_numbers into an array
    IFS=',' read -r -A option_numbers_array <<< "$option_numbers"

    # Validate and download the chosen options
    for option_number in "${option_numbers_array[@]}"; do
        if ((option_number >= 1 && option_number <= ${#options[@]})); then
            chosen_option="${options[option_number]}"
            echo "You chose: $chosen_option"
            chosen_file="${chosen_option##*/}" # Extract the filename from the chosen option
            download_url="https://<REDACTED_URL>/logs/$case_number$chosen_option"

            # Create subdirectory for the chosen file
            sub_dir_name="${chosen_file%.*}" # Remove file extension
            file_sub_dir="$NEW_BUNDLE_DIR/$sub_dir_name"
            mkdir -p "$file_sub_dir"

            # Run the curl command to download the chosen file into its subdirectory
            echo "Downloading $chosen_file..."
            curl -# -H "Authorization: Bearer $JFROG_TOKEN" -L -o "$file_sub_dir/$chosen_file" "$download_url"

            echo "File $chosen_file downloaded successfully."

            # Unzip or extract the file in the subdirectory
            extract_file "$file_sub_dir/$chosen_file"
        else
            echo "Invalid choice: $option_number. Please enter a valid option number."
            return 1 # Exit the function with an error
        fi
    done

    # Recursively process files in the bundle directory
    process_files_recursively "$NEW_BUNDLE_DIR"
}

# Function to trigger Jenkins job and download the production bundle
download_production_bundle() {
    echo -e "\033[1;32m"
    # Jenkins job details
    JENKINS_URL="https://<REDACTED-JENKINS-URL>"
    JOB_PATH="/job/production/job/utils/job/production-bundles/job/master"
    echo "Enter customer server name: "
    read CUSTOMER_SERVER_NAME

    if [[ "$CUSTOMER_SERVER_NAME" =~ \  ]]; then
        echo "Customer server name contains spaces. Please enter a valid name without spaces."
        exit 1
    fi
    echo
    echo "Checking for technical server name..."
    sleep 1
    dig_output=$(dig "$CUSTOMER_SERVER_NAME.jfrog.io")
    cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

    if [[ "$cname_entry" == endpoint* ]]; then
        TECHNICAL_SERVER_NAME="$CUSTOMER_SERVER_NAME"
        echo "No technical server name found. Using customer server name: $CUSTOMER_SERVER_NAME.jfrog.io"
    else
        TECHNICAL_SERVER_NAME="${cname_entry%%.*}"
        echo "Technical server name found: $TECHNICAL_SERVER_NAME.jfrog.io"
        echo "CNAME ENTRY: $cname_entry"
    fi
    echo
    PS3="Please choose an option (1 or 2): "
    echo "Enter control artifactory thread (Default or Control): "
    select CONTROL_ARTIFACTORY_THREAD in "Default" "Control"; do
        if [[ -n $CONTROL_ARTIFACTORY_THREAD ]]; then
            break
        else
            echo "Invalid option $REPLY"
        fi
    done

    if [[ "$CONTROL_ARTIFACTORY_THREAD" == "Control" ]]; then
        while true; do
            echo "Enter artifactory thread (1-10): "
            read ARTIFACTORY_THREAD
            if [[ "$ARTIFACTORY_THREAD" -ge 1 && "$ARTIFACTORY_THREAD" -le 10 ]]; then
                break
            else
                echo "Invalid artifactory thread option. Please enter a number between 1 and 10."
            fi
        done
    else
        ARTIFACTORY_THREAD="Default"
    fi
    echo 
    echo "Customer server name: $TECHNICAL_SERVER_NAME"
    echo "Artifactory thread: $ARTIFACTORY_THREAD"
    echo "$JENKINS_USER"
    echo "$JENKINS_API_TOKEN"
    TRIGGER_URL="$JENKINS_URL$JOB_PATH/buildWithParameters"
    echo "$TRIGGER_URL"
    QUEUE_ID=$(curl -i -u $JENKINS_USER:$JENKINS_API_TOKEN \
    -X POST "$TRIGGER_URL" \
    --data-urlencode "CUSTOMER_SERVER_NAME=$TECHNICAL_SERVER_NAME" \
    --data-urlencode "ENVIRONMENT=production" \
    --data-urlencode "APPLICATION=artifactory" \
    --data-urlencode "CONTROL_ARTIFACTORY_THREAD=$CONTROL_ARTIFACTORY_THREAD" \
    --data-urlencode "ARTIFACTORY_THREAD=$ARTIFACTORY_THREAD" \
    --data-urlencode "CONTROL_ARTIFACTORY_HEAP=Default" \
    --data-urlencode "ARTIFACTORY_HEAP=Default" \
    | grep -i "Location:" | awk '{print $2}' | tr -d '\r' | awk -F'/' '{print $6}')

    echo "Queue ID: $QUEUE_ID"

    sleep 10

    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ]; do
      BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$JENKINS_URL/queue/item/$QUEUE_ID/api/json" | jq -r '.executable.number // empty')
      sleep 2
    done

    echo "Triggered build number: $BUILD_NUMBER"

    LOG_URL="$JENKINS_URL$JOB_PATH/$BUILD_NUMBER/logText/progressiveText"
    START=0
    BUNDLE_URL=""
    echo -e "\033[0m"
    while : ; do
      RESPONSE=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$LOG_URL?start=$START")
      echo -n "$RESPONSE"
      START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)
      
      if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
        echo -e "\033[1;32m"
        echo -e "\033[1;32m╔═══════════════════════════════════════╗\033[0m"
        echo -e "\033[1;32m║     Job has finished successfully     ║\033[0m"
        echo -e "\033[1;32m╚═══════════════════════════════════════╝\033[0m"
        if echo "$RESPONSE" | grep -q "Successfully uploaded bundle to "; then
          BUNDLE_URL=$(echo "$RESPONSE" | awk '/Successfully uploaded bundle to / {print $NF}')
          BUNDLE_URL=$(echo "$BUNDLE_URL" | tr -d '\r')
          echo "Extracted bundle URL: $BUNDLE_URL"
        fi
        break
      elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
        echo "Job failed."
        break
      fi

      sleep 2
    done

    if [ -n "$BUNDLE_URL" ]; then
      echo "Downloading bundle from $BUNDLE_URL"
      curl -H "Authorization: Bearer $JFROG_TOKEN" -L -O "$BUNDLE_URL"
    fi
    
    echo -e "\033[1;32m"
    NEW_BUNDLE_FOLDER="support_bundle${NEW_NUMBER}"
    NEW_BUNDLE_DIR="$DEST_DIR/$NEW_BUNDLE_FOLDER"
    mkdir -p "$NEW_BUNDLE_DIR"

    BUNDLE_FILE="${BUNDLE_URL##*/}"
    mv "$BUNDLE_FILE" "$NEW_BUNDLE_DIR/$BUNDLE_FILE"

    extract_file "$NEW_BUNDLE_DIR/$BUNDLE_FILE"

    # Recursively process files in the bundle directory
    process_files_recursively "$NEW_BUNDLE_DIR"

    exit 0
}

# Function to trigger Jenkins job and capture the application detail output

run_get_application_detail() {
    BG_YELLOW='\033[1;33m'
    NC='\033[0m'

    echo -e "\033[1;32m"
    # Jenkins job details
    JENKINS_URL="https://<REDACTED-URL>"
    JOB_PATH="/job/support/job/utils/job/get-application-detail"

    echo "Enter customer server name: "
    read CUSTOMER_SERVER_NAME

    if [[ "$CUSTOMER_SERVER_NAME" =~ \  ]]; then
        echo "Customer server name contains spaces. Please enter a valid name without spaces."
        exit 1
    fi

    echo
    echo "Checking for technical server name..."
    sleep 1
    dig_output=$(dig "$CUSTOMER_SERVER_NAME.jfrog.io")
    cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

    if [[ "$cname_entry" == endpoint* ]]; then
        TECHNICAL_SERVER_NAME="$CUSTOMER_SERVER_NAME"
        echo "No technical server name found. Using customer server name: $CUSTOMER_SERVER_NAME.jfrog.io"
    else
        TECHNICAL_SERVER_NAME="${cname_entry%%.*}"
        echo "Technical server name found: $TECHNICAL_SERVER_NAME.jfrog.io"
        echo "CNAME ENTRY: $cname_entry"
    fi
    echo

    echo "Select GET_API option:"
    PS3="Please choose an option:"
    select GET_API in "system_status" "get_system_info" "get_config_xml" "list_users" "list_repos" "storage_info" "storage_summary" "list_permissions" "list_plugins" "get_eplus_topology" "all_projects" "get_realms_list" "access_http_sso" "get_ldap_setting" "get_group_setting" "get_permissions" "get_all_repos_conf" "get_access_version" "disable_api_key_creation"; do
        if [[ -n $GET_API ]]; then
            echo "You have selected: $GET_API"
            echo
            echo "...Retrieving info now..."
            echo
            break
        else
            echo "Invalid option $REPLY. Please try again."
        fi
    done

    TRIGGER_URL="$JENKINS_URL$JOB_PATH/buildWithParameters"
    
    queue_id=$(curl -i -u $JENKINS_USER:$JENKINS_API_TOKEN \
    -X POST "$TRIGGER_URL" \
    --data-urlencode "ENVIRONMENT=production" \
    --data-urlencode "CUSTOMER_SERVER_NAME=$TECHNICAL_SERVER_NAME" \
    --data-urlencode "GET_API=$GET_API" | grep -i "location:" | awk -F'/' '{print $(NF-1)}' | tr -d '\r')

    if [ -z "$queue_id" ]; then
        echo "Failed to retrieve Queue ID. Check the Jenkins response."
        exit 1
    fi

    echo "Jenkins job triggered. Queue ID: $queue_id"

    # Set a maximum number of retries to avoid infinite loop
    MAX_RETRIES=30
    RETRY_COUNT=0
    sleep 10

    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
      BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$JENKINS_URL/queue/item/$queue_id/api/json" | jq -r '.executable.number // empty')
      sleep 2
      RETRY_COUNT=$((RETRY_COUNT + 1))
    done

    if [ -z "$BUILD_NUMBER" ]; then
        echo "Failed to retrieve build number after $MAX_RETRIES retries."
        return 1
    fi

    echo "Triggered build number: $BUILD_NUMBER"
    echo -e "${NC}"
    LOG_URL="$JENKINS_URL$JOB_PATH/$BUILD_NUMBER/logText/progressiveText"
    START=0
    OUTPUT_RESULT=""
    HIGHLIGHT_MODE=0
    
    while : ; do
      RESPONSE=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$LOG_URL?start=$START")

      while IFS= read -r line; do

        if echo "$line" | grep -q "+ jfrog_super_aol_cli\|+ jfrog_cloudadmin_cli"; then
            HIGHLIGHT_MODE=1
        fi
        
        if [[ "$line" == *"Pipeline"* ]]; then
            HIGHLIGHT_MODE=0
        fi

        if [ $HIGHLIGHT_MODE -eq 1 ]; then
            echo -e "${BG_YELLOW}${line}${NC}"
            # Stop highlighting after the command output ends
            #if [[ "$line" == *"[Pipeline]" ]]; then
            #if [[ "$line" == *"}"* || "$line" == *"Pipeline" ]]; then
            #    HIGHLIGHT_MODE=0
            #fi
        else
            echo "\033[0m$line"
        fi
      done <<< "$RESPONSE"

      # Calculate the new start position for the next iteration
      START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

      if echo "$RESPONSE" | grep -q "Result:"; then
          OUTPUT_RESULT=$(echo "$RESPONSE" | awk '/Result:/ {print $NF}')
          OUTPUT_RESULT=$(echo "$OUTPUT_RESULT" | tr -d '\r')
          echo "Extracted result: $OUTPUT_RESULT"
      fi

      if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
         echo -e "\033[1;32m"
        echo -e "\033[1;32m╔═══════════════════════════════════════╗\033[0m"
        echo -e "\033[1;32m║     Job has finished successfully     ║\033[0m"
        echo -e "\033[1;32m╚═══════════════════════════════════════╝\033[0m"
        break
      elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
        echo "Job failed."
        break
      fi

      sleep 2
    done

    if [ -n "$OUTPUT_RESULT" ]; then
      echo "Result: $OUTPUT_RESULT"
    fi
    exit 0
}


# Function to enable debug loggers
enable_debug_loggers() {
   
    #echo -e "\033[1;32m"
    JENKINS_URL="https://<REDACTED-URL>"
    APPLICATION="artifactory"
     
    echo "\033[1;32mEnter customer server name: "
    read CUSTOMER_SERVER_NAME

    if [[ "$CUSTOMER_SERVER_NAME" =~ \  ]]; then
        echo "Error: Customer server name contains spaces."
        exit 1
    fi
    echo
    echo "Checking for technical server name..."
    sleep 1
    dig_output=$(dig "$CUSTOMER_SERVER_NAME.jfrog.io")
    cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

    if [[ "$cname_entry" == endpoint* ]]; then
        TECHNICAL_SERVER_NAME="$CUSTOMER_SERVER_NAME"
    else
        TECHNICAL_SERVER_NAME="${cname_entry%%.*}"
        echo "Technical server name found: $TECHNICAL_SERVER_NAME.jfrog.io"
        echo "CNAME ENTRY: $cname_entry"
    fi

    echo 

    sleep 1

    # Ask if the user wants to append to a specific log or the service log
    echo "Do you want the logs to be appended to the service log? (yes/no)"
    echo "**If you like to look at corologix for logs, pressing yes would be the best option"
    read append_to_service_log
    
    sleep 1

    if [[ "$append_to_service_log" == "yes" ]]; then
        # Modify the logger destination to artifactory-service.log
        
    fi
echo -e "\033[0;91m"
    PS3="Please select a logger category: "
    echo -e "\033[1;32m" 
    echo "---\033[4mLOGGER CATEGORIES\033[0m\033[1;32m---"
    echo -e "\033[1;32m"

    select CATEGORY in "Auth" "Packages" "Core" "Custom Logger" "Exit"; do
        case $CATEGORY in
            "Auth")
                PS3="Select an Auth logger: "
                select LOGGER_NAME in Access_LDAP ACCESS SCIM SAML_SSO OAUTH HTTP_SSO Access_Federation OIDC TOKEN; do
                    if [[ -n $LOGGER_NAME ]]; then
                        # Use the already predefined variable:
			LOGGER_SYNTAX="${(P)LOGGER_NAME}"
                        echo
                        echo "Selected logger: $LOGGER_NAME"
                        echo "Logger syntax: $LOGGER_SYNTAX"
                        break
                    else
                        echo "Invalid selection."
                    fi
                done
                break
                ;;
            "Packages")
                PS3="Select a Packages logger: "
                select LOGGER_NAME in Pypi Maven Docker NuGet NPM RPM_Yum Advanced_RPM_Debug_Logger Debian Cran Conan RubyGems Conda Go_GoLang Cocoapods_Pod Puppet Huggingface PHP_Composer Helm Terraform; do
                    if [[ -n $LOGGER_NAME ]]; then
                        # Use the already predefined variable:
			LOGGER_SYNTAX="${(P)LOGGER_NAME}"
			echo
                        echo "Selected logger: $LOGGER_NAME"
                        echo "Logger syntax: $LOGGER_SYNTAX"
                        break
                    else
                        echo "Invalid selection."
                    fi
                done
                break
                ;;
            "Core")
                PS3="Select a Core logger: "
                select LOGGER_NAME in Build_Promotions Federated_Repositories Projects_Artifactory High_Availability_HA Push_Pull_Replication JFConnect Sharding_Filestore Cloud_Storage_Debug_Loggers_S3_Gcloud_Azure_Blob Leak_Detector Test_Button_in_Remote_Repository_Menu Import_Export HTTP_Outgoing_Connection_Pool_Parameters JDBC_Diagnosis Hikari Support_Bundle Heartbeat Sharding_Cluster_Filestore Tasks SumoLogic AQL Cache_FS NFS_Filestore General_Search File_System_Locks Derby_DB_Transaction_Logging Artifactory_Watch_Email_Events Garbage_Collector User_Plugins; do
                    if [[ -n $LOGGER_NAME ]]; then
                        # Use the already predefined variable:
			LOGGER_SYNTAX="${(P)LOGGER_NAME}"
                        echo
                        echo "Selected logger: $LOGGER_NAME"
                        echo "Logger syntax: $LOGGER_SYNTAX"
                        break
                    else
                        echo "Invalid selection."
                    fi
                done
                break
                ;;
            "Custom Logger")
                echo "Enter the custom logger string (e.g., org.custom.logger=DEBUG:custom-log):"
                read custom_logger_string
                LOGGER_SYNTAX="$custom_logger_string"
                echo
                echo "Custom logger added:"
                echo "Logger syntax: $LOGGER_SYNTAX"
                break
                ;;
            "Exit")
                echo "Exiting logger selection."
                exit 0
                ;;
            *)
                echo "Invalid category selection."
                ;;
        esac
    done

    echo
       echo "1 hour = $((1 * 3600)) seconds"
echo "6 hours = $((6 * 3600)) seconds"
echo "12 hours = $((12 * 3600)) seconds"
echo "1 day = $((1 * 86400)) seconds"
echo "2 days = $((2 * 86400)) seconds"
    echo "Enter time for change in seconds: "
    
    read TIME_FOR_CHANGE

    SURVIVE_REDEPLOY="False"
    CONCATENATE="False"
    MICROSERVICE="artifactory"
    APP_LOG_LEVEL=""
     
    echo "\033[0m"

    TRIGGER_URL="$JENKINS_URL/job/support/job/utils/job/change-application-log-level/job/master/buildWithParameters"
    queue_id=$(curl -i -u $JENKINS_USER:$JENKINS_API_TOKEN \
    -X POST "$TRIGGER_URL" \
    --data-urlencode "CUSTOMER_SERVER_NAME=$TECHNICAL_SERVER_NAME" \
    --data-urlencode "ENVIRONMENT=production" \
    --data-urlencode "APPLICATION=$APPLICATION" \
    --data-urlencode "PERMANENT=False" \
    --data-urlencode "LOGGER_LEVEL=$LOGGER_SYNTAX" \
    --data-urlencode "TIME_FOR_CHANGE=$TIME_FOR_CHANGE" \
    --data-urlencode "APP_LOG_LEVEL=NOT SUPPORTED" \
    --data-urlencode "MICROSERVICE=$MICROSERVICE" \
    --data-urlencode "RESET_FLAGS=False" \
    --data-urlencode "SURVIVE_REDEPLOY=$SURVIVE_REDEPLOY" \
    --data-urlencode "CONCATENATE=$CONCATENATE" | grep -i "location:" | awk -F'/' '{print $(NF-1)}' | tr -d '\r')

    if [ -z "$queue_id" ]; then
        echo "Failed to retrieve Queue ID. Check the Jenkins response."
        exit 1
    fi

    echo "Jenkins job triggered. Queue ID: $queue_id"

    sleep 10

    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ]; do
        BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$JENKINS_URL/queue/item/$queue_id/api/json" | jq -r '.executable.number // empty')
        sleep 2
    done

    echo "Triggered build number: $BUILD_NUMBER"

    LOG_URL="$JENKINS_URL/job/support/job/utils/job/change-application-log-level/job/master/$BUILD_NUMBER/logText/progressiveText"
    START=0

    OUTPUT_RESULT=""

    while : ; do
        RESPONSE=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$LOG_URL?start=$START")
        echo -n "$RESPONSE"
        START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

        if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
             echo "Finished: SUCCESS"
             if echo "$RESPONSE" | grep -q "Result:"; then
                OUTPUT_RESULT=$(echo "$RESPONSE" | awk '/Result:/ {print $NF}'| tr -d '\r')
                OUTPUT_RESULT=$(echo "$OUTPUT_RESULT" | tr -d '\r')
                echo "Extracted result: $OUTPUT_RESULT"
            fi
            break
        elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
            echo "Job failed."
            break
        fi

        sleep 2
    done
      echo -e "\033[1;32m"
     echo -e "\033[1;32m╔═══════════════════════════════════════╗\033[0m"
     echo -e "\033[1;32m║     Job has finished successfully     ║\033[0m"
     echo -e "\033[1;32m╚═══════════════════════════════════════╝\033[0m"

    if [ -n "$OUTPUT_RESULT" ]; then
        echo "Processing result: $OUTPUT_RESULT"
    fi
    exit 0
}   
    

update_artifactory_special_properties() {
    echo -e "\033[1;32mStarting Artifactory Special Properties Job..."

    # Ask the user for the customer server name
    echo
    echo "Enter customer server name (without spaces): "
    read CUSTOMER_SERVER_NAME

    # Validate that the server name has no spaces
    if [[ "$CUSTOMER_SERVER_NAME" =~ \  ]]; then
        echo "Customer server name contains spaces. Please enter a valid name without spaces."
        exit 1
    fi
    echo
    # Perform the technical server name check using dig
    echo "Checking for technical server name..."
    sleep 1
    dig_output=$(dig "$CUSTOMER_SERVER_NAME.jfrog.io")
    cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

    if [[ "$cname_entry" == endpoint* ]]; then
        TECHNICAL_SERVER_NAME="$CUSTOMER_SERVER_NAME"
        echo "No technical server name found. Using customer server name: $CUSTOMER_SERVER_NAME.jfrog.io"
    else
        TECHNICAL_SERVER_NAME="${cname_entry%%.*}"
        echo "Technical server name found: $TECHNICAL_SERVER_NAME.jfrog.io"
        echo "CNAME ENTRY: $cname_entry"
    fi
    echo
    # Ask the user to select an action: Get, Update, or Delete properties
    echo "Select an action:"
    PS3="Please select an option (1, 2, or 3): "
    select ACTION in "Get Properties" "Update Properties" "Delete Properties"; do
        if [[ -n $ACTION ]]; then
            echo "You selected: $ACTION"
            break
        else
            echo "Invalid option $REPLY. Please try again."
        fi
    done

    # Define variables for GET, UPDATE, DELETE values
    GET_PROPERTIES="False"
    UPDATE_PROPERTIES=""
    DELETE_PROPERTIES=""
    echo
    # Prompt the user for values based on the selected action
    if [[ "$ACTION" == "Get Properties" ]]; then
        GET_PROPERTIES="True"
        echo "You selected: Get Properties"
    elif [[ "$ACTION" == "Update Properties" ]]; then
        echo "Enter the property you want to update (e.g., artifactory.security.maxLoginBlockDelay=0):"
        read UPDATE_PROPERTIES
    elif [[ "$ACTION" == "Delete Properties" ]]; then
        echo "Enter the property you want to delete (e.g., artifactory.security.maxLoginBlockDelay):"
        read DELETE_PROPERTIES
    fi
    echo
    # Prompt the user for the SF Ticket number
    echo "Enter the SF Ticket number:"
    read SF_TICKET
    
    # Trigger the Jenkins job
    TRIGGER_URL="https://<REDACTED_URL>/job/production/job/utils/job/update-artifactory-special-properties/job/master/buildWithParameters"
    queue_id=$(curl -i -u $JENKINS_USER:$JENKINS_API_TOKEN \
    -X POST "$TRIGGER_URL" \
    --data-urlencode "CUSTOMER=$TECHNICAL_SERVER_NAME" \
    --data-urlencode "GET_PROPERTIES=$GET_PROPERTIES" \
    --data-urlencode "UPDATE_PROPERTIES=$UPDATE_PROPERTIES" \
    --data-urlencode "DELETE_PROPERTIES=$DELETE_PROPERTIES" \
    --data-urlencode "SF_TICKET=$SF_TICKET" | grep -i "location:" | awk -F'/' '{print $(NF-1)}' | tr -d '\r')

    if [ -z "$queue_id" ]; then
        echo "Failed to retrieve Queue ID. Check the Jenkins response."
        exit 1
    fi

    echo "Jenkins job triggered. Queue ID: $queue_id"
    sleep 10

    # Poll for the build number
    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ]; do
        BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "https://<REDACTED_URL>/queue/item/$queue_id/api/json" | jq -r '.executable.number // empty')
        sleep 2
    done

    echo "Triggered build number: $BUILD_NUMBER"

    # Tail the build output
    LOG_URL="https://<REDACTED-URL>/job/production/job/utils/job/update-artifactory-special-properties/job/master/$BUILD_NUMBER/logText/progressiveText"
    START=0

    while : ; do
        RESPONSE=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$LOG_URL?start=$START")
        echo -n "$RESPONSE"
        START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

        if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
            echo "Finished: SUCCESS"
            if echo "$RESPONSE" | grep -q "Result:"; then
                OUTPUT_RESULT=$(echo "$RESPONSE" | awk '/Result:/ {print $NF}' | tr -d '\r')
                echo "Extracted result: $OUTPUT_RESULT"
            fi
            break
        elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
            echo "Job failed."
            break
        fi

        sleep 2
    done

    # Success message
    echo -e "\033[1;32m╔═══════════════════════════════════════╗\033[0m"
    echo -e "\033[1;32m║     Job has finished successfully     ║\033[0m"
    echo -e "\033[1;32m╚═══════════════════════════════════════╝\033[0m"

    if [ -n "$OUTPUT_RESULT" ]; then
        echo "Processing result: $OUTPUT_RESULT"
    fi

    exit 0
}

redeploy_artifactory_server() {
    echo -e "\033[1;32mStarting Artifactory Redeploy Job..."
    echo
    # Ask the user for the customer server name
    echo "Enter customer server name (without spaces): "
    read CUSTOMER_SERVER_NAME
    echo
    # Validate that the server name has no spaces
    if [[ "$CUSTOMER_SERVER_NAME" =~ \  ]]; then
        echo "Customer server name contains spaces. Please enter a valid name without spaces."
        exit 1
    fi

    # Perform the technical server name check using dig
    echo "Checking for technical server name..."
    sleep 1
    dig_output=$(dig "$CUSTOMER_SERVER_NAME.jfrog.io")
    cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

    if [[ "$cname_entry" == endpoint* ]]; then
        TECHNICAL_SERVER_NAME="$CUSTOMER_SERVER_NAME"
        echo "No technical server name found. Using customer server name: $CUSTOMER_SERVER_NAME.jfrog.io"
    else
        TECHNICAL_SERVER_NAME="${cname_entry%%.*}"
        echo "Technical server name found: $TECHNICAL_SERVER_NAME.jfrog.io"
        echo "CNAME ENTRY: $cname_entry"
    fi
    echo
    # Ask the user to select between immediate or scheduled redeploy
    echo "Select redeploy type:"
    PS3="Please select an option (1 for Immediate, 2 for Scheduled): "

    select REDEPLOY_TYPE in "Immediate" "Scheduled"; do
        if [[ -n "$REDEPLOY_TYPE" ]]; then
            echo "You selected: $REDEPLOY_TYPE"
            break
        else
            echo "Invalid option $REPLY. Please try again."
        fi
    done
    echo
    DEPLOY_NOW="false"

    if [[ "$REDEPLOY_TYPE" == "Immediate" ]]; then
    DEPLOY_NOW="true"
    echo "You selected immediate redeploy."
elif [[ "$REDEPLOY_TYPE" == "Scheduled" ]]; then
    # Display local and UTC times
    echo "Current time in local: $(date +'%d/%m/%y %H:%M')"
    echo "Current time in UTC: $(date -u +'%d/%m/%y %H:%M')"
    echo
    # Get the UTC offset in hours (e.g., +0200, -0700)
    utc_offset=$(date +%z)

    # Extract the hour part from the offset (first three characters)
    utc_offset_hours=${utc_offset:0:3}
    utc_offset_hours=$((10#$utc_offset_hours))  # Convert to integer

    # Determine if UTC is ahead or behind local time
    if [[ $utc_offset_hours -lt 0 ]]; then
        utc_ahead=$(( -utc_offset_hours ))
        echo "UTC is $utc_ahead hours ahead of your local time."
    elif [[ $utc_offset_hours -gt 0 ]]; then
        echo "UTC is $utc_offset_hours hours behind your local time."
    else
        echo "UTC is in the same time zone as your local time."
    fi
    echo
    # Prompt user for deployment start and end time windows
    echo "Enter the deployment start time window in format \"dd/mm/yy HH:MM\" (UTC): "
    read DEPLOYMENT_START_TIME_WINDOW
    echo
    echo "Enter the deployment end time window in format \"dd/mm/yy HH:MM\" (UTC): "
    read DEPLOYMENT_END_TIME_WINDOW
fi

 
    # Prompt the user for the SF Ticket number
    echo "Enter the SF Ticket number:"
    read SF_TICKET_NUMBER
    
    JENKINS_URL="https://<REDACTED-URL>"
    # Trigger the Jenkins job
    TRIGGER_URL="$JENKINS_URL/job/production/job/utils/job/handle-customer-special-terms/job/master/buildWithParameters"

    queue_id=$(curl -i -u $JENKINS_USER:$JENKINS_API_TOKEN \
    -X POST "$TRIGGER_URL" \
    --data-urlencode "CUSTOMER_NAME=$TECHNICAL_SERVER_NAME" \
    --data-urlencode "ENVIRONMENT=production" \
    --data-urlencode "SF_TICKET_NUMBER=$SF_TICKET_NUMBER" \
    --data-urlencode "APPLICATION=customer" \
    --data-urlencode "CONFIGURE_VERSION=false" \
    --data-urlencode "ARTIFACTORY=latestRelease" \
    --data-urlencode "XRAY=latestRelease" \
    --data-urlencode "PIPELINES=latestRelease" \
    --data-urlencode "MISSION_CONTROL=latestRelease" \
    --data-urlencode "DISTRIBUTION=latestRelease" \
    --data-urlencode "CORE_SERVICES=latestRelease" \
    --data-urlencode "INSIGHT=latestRelease" \
    --data-urlencode "RESET_VERSION=false" \
    --data-urlencode "DEPLOY_NOW=$DEPLOY_NOW" \
    --data-urlencode "DEPLOYMENT_START_TIME_WINDOW=${DEPLOYMENT_START_TIME_WINDOW:-}" \
    --data-urlencode "DEPLOYMENT_END_TIME_WINDOW=${DEPLOYMENT_END_TIME_WINDOW:-}" \
    --data-urlencode "RESET_DEPLOYMENT_WINDOW_TIME=false" \
    --data-urlencode "AUTO_ACTION=redeploy" \
    --data-urlencode "VALIDATE_SPECIAL_CUSTOMER=true" | grep -i "location:" | awk -F'/' '{print $(NF-1)}' | tr -d '\r')

    if [ -z "$queue_id" ]; then
        echo "Failed to retrieve Queue ID. Check the Jenkins response."
        exit 1
    fi

    echo "Jenkins job triggered. Queue ID: $queue_id"
    sleep 10

    # Retrieve the build number
    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ]; do
        BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$JENKINS_URL/queue/item/$queue_id/api/json" | jq -r '.executable.number // empty')
        sleep 2
    done

    echo "Triggered build number: $BUILD_NUMBER"

    # Tail the build output
    LOG_URL="$JENKINS_URL/job/production/job/utils/job/handle-customer-special-terms/job/master/$BUILD_NUMBER/logText/progressiveText"
    START=0

    OUTPUT_RESULT=""
    while : ; do
        RESPONSE=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$LOG_URL?start=$START")
        echo -n "$RESPONSE"
        START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

        if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
            echo "Finished: SUCCESS"
            if echo "$RESPONSE" | grep -q "Result:"; then
                OUTPUT_RESULT=$(echo "$RESPONSE" | awk '/Result:/ {print $NF}' | tr -d '\r')
                OUTPUT_RESULT=$(echo "$OUTPUT_RESULT" | tr -d '\r')
                echo "Extracted result: $OUTPUT_RESULT"
            fi
            break
        elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
            echo "Job failed."
            break
        fi

        sleep 2
    done

    echo -e "\033[1;32m"
    echo -e "Job has finished successfully."
    if [ -n "$OUTPUT_RESULT" ]; then
        echo "Processing result: $OUTPUT_RESULT"
    fi
    exit 0
}

cot_saas_to_saas() {
    echo -e "\033[1;32mStarting Circle of Trust Process..."

    # Confirm customer approval
    echo "We must get the customer's approval to perform the Circle Of Trust."
    echo
    sleep 1
    echo "Please confirm that you have shared the following statement with the customer:"
    sleep 1
    echo
    echo "\"[We/I] confirm that [we are/I am] requesting a Circle of Trust between [Environment A] and [Environment B] and that [we are/I am] authorized to make such a request on behalf of [Customer]. [We/I] confirm that Customer’s use, as facilitated by the Circle of Trust, will be governed by JFrog's Terms and Conditions for both Self Hosted and Cloud subscriptions.\""
    echo
    # Get customer's approval
    echo -n "Have you obtained the customer’s approval? (yes/no): "
    read approval
    if [[ "$approval" != "yes" ]]; then
        echo "Operation aborted. Please confirm with the customer before proceeding."
        return 1
    fi
    echo
    # Get customer server names from the user
    echo -n "Enter the customer server name(s) (comma separated if multiple): "
    read customer_server_names

    # Ensure customer_server_names isn't empty
    if [[ -z "$customer_server_names" ]]; then
        echo "Error: No server names provided."
        return 1
    fi

    # Initialize array to store technical server names
    technical_server_names=()
    
    # Split server names by comma and handle them one by one
    for server_name in $(echo "$customer_server_names" | sed "s/,/ /g"); do
        if [[ -n "$server_name" ]]; then
            echo
            echo "Checking for technical server name for $server_name..."

            # Perform the technical server name check using dig
            dig_output=$(dig "$server_name.jfrog.io")
            cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

            if [[ "$cname_entry" == endpoint* ]]; then
                technical_server_names+=("$server_name")
                echo "No technical server name found. Using customer server name: $server_name.jfrog.io"
            else
                technical_name="${cname_entry%%.*}"
                technical_server_names+=("$technical_name")
                echo "Technical server name found: $technical_name.jfrog.io"
                echo "CNAME ENTRY: $cname_entry"
            fi
        else
            echo "Warning: Empty server name found."
        fi
    done
    echo
    # Join technical server names into a single string
    customer=$(IFS=','; echo "${technical_server_names[*]}")
    echo "customer = $customer"
    # Ensure customer isn't empty before proceeding
    if [[ -z "$customer" ]]; then
        echo "Error: No valid server names were provided."
        return 1
    fi

    # Trigger the Circle of Trust request with the updated technical names
    TRIGGER_URL="https://<REDACTED>/job/support/job/utils/job/configure-circle-of-trust/job/master/buildWithParameters"
    echo "Sending Circle of Trust request..."
    queue_id=$(curl -i -u "$JENKINS_USER:$JENKINS_API_TOKEN" \
        -X POST "$TRIGGER_URL" \
        --data-urlencode "ENVIRONMENT=production" \
        --data-urlencode "CUSTOMER_NAMES=$customer" | grep -i "location:" | awk -F'/' '{print $(NF-1)}' | tr -d '\r')

    if [[ -z "$queue_id" ]]; then
        echo "Failed to retrieve Queue ID. Check the response."
        return 1
    fi

    echo "Circle of Trust request queued with ID: $queue_id. Polling for the build number..."

    # Set a maximum number of retries to avoid infinite loop
    MAX_RETRIES=30
    RETRY_COUNT=0
    sleep 10

    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ]; do
        BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "https://<REDACTED>.org/queue/item/$queue_id/api/json" | jq -r '.executable.number // empty')
        sleep 2
    done
    if [ -z "$BUILD_NUMBER" ]; then
        echo "Failed to retrieve build number after $MAX_RETRIES retries."
        return 1
    fi

    echo "Triggered build number: $BUILD_NUMBER"
    LOG_URL="https://<REDACTED>/job/support/job/utils/job/configure-circle-of-trust/job/master/$BUILD_NUMBER/logText/progressiveText"
    START=0

    while true; do
        RESPONSE=$(curl -s -u "$JENKINS_USER:$JENKINS_API_TOKEN" "$LOG_URL?start=$START")

        while IFS= read -r line; do
            echo "$line"
        done <<< "$RESPONSE"

        # Calculate the new start position for the next iteration
        START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

        # Check for build completion
        if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
            echo -e "\033[1;32mJob has finished successfully.\033[0m"
            break
        elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
            echo -e "\033[1;31mJob failed.\033[0m"
            break
        fi

        sleep 2
    done
}

upgrade_artifactory_server() {
    echo -e "\033[1;32mStarting Artifactory Upgrade Job..."
    echo
    # Ask the user for the customer server name
    echo "Enter customer server name (without spaces): "
    read CUSTOMER_SERVER_NAME
    echo
    # Validate that the server name has no spaces
    if [[ "$CUSTOMER_SERVER_NAME" =~ \  ]]; then
        echo "Customer server name contains spaces. Please enter a valid name without spaces."
        exit 1
    fi

    # Perform the technical server name check using dig
    echo "Checking for technical server name..."
    sleep 1
    dig_output=$(dig "$CUSTOMER_SERVER_NAME.jfrog.io")
    cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

    if [[ "$cname_entry" == endpoint* ]]; then
        TECHNICAL_SERVER_NAME="$CUSTOMER_SERVER_NAME"
        echo "No technical server name found. Using customer server name: $CUSTOMER_SERVER_NAME.jfrog.io"
    else
        TECHNICAL_SERVER_NAME="${cname_entry%%.*}"
        echo "Technical server name found: $TECHNICAL_SERVER_NAME.jfrog.io"
        echo "CNAME ENTRY: $cname_entry"
    fi
    echo
    # Ask the user to select between immediate or scheduled redeploy
    echo "Select upgrade type:"
    PS3="Please select an option (1 for Immediate, 2 for Scheduled): "

    select REDEPLOY_TYPE in "Immediate" "Scheduled"; do
        if [[ -n "$REDEPLOY_TYPE" ]]; then
            echo "You selected: $REDEPLOY_TYPE"
            break
        else
            echo "Invalid option $REPLY. Please try again."
        fi
    done
    echo
    DEPLOY_NOW="false"

    if [[ "$REDEPLOY_TYPE" == "Immediate" ]]; then
    DEPLOY_NOW="true"
    echo "You selected immediate redeploy."
elif [[ "$REDEPLOY_TYPE" == "Scheduled" ]]; then
    # Display local and UTC times
    echo "Current time in local: $(date +'%d/%m/%y %H:%M')"
    echo "Current time in UTC: $(date -u +'%d/%m/%y %H:%M')"
    echo
    # Get the UTC offset in hours (e.g., +0200, -0700)
    utc_offset=$(date +%z)

    # Extract the hour part from the offset (first three characters)
    utc_offset_hours=${utc_offset:0:3}
    utc_offset_hours=$((10#$utc_offset_hours))  # Convert to integer

    # Determine if UTC is ahead or behind local time
    if [[ $utc_offset_hours -lt 0 ]]; then
        utc_ahead=$(( -utc_offset_hours ))
        echo "UTC is $utc_ahead hours ahead of your local time."
    elif [[ $utc_offset_hours -gt 0 ]]; then
        echo "UTC is $utc_offset_hours hours behind your local time."
    else
        echo "UTC is in the same time zone as your local time."
    fi
    echo
    # Prompt user for deployment start and end time windows
    echo "Enter the deployment start time window in format \"dd/mm/yy HH:MM\" (UTC): "
    read DEPLOYMENT_START_TIME_WINDOW
    echo
    echo "Enter the deployment end time window in format \"dd/mm/yy HH:MM\" (UTC): "
    read DEPLOYMENT_END_TIME_WINDOW
fi
    #Prompt user for the Artifactory version to upggrade
    echo "Enter the Artifactory version to upgrade to or type 'latestRelease'"
    read ARTIFACTORY_VERSION_NUMBER

    # Prompt the user for the SF Ticket number
    echo "Enter the SF Ticket number:"
    read SF_TICKET_NUMBER

    JENKINS_URL="https://<REDACTED>"
    # Trigger the Jenkins job
    TRIGGER_URL="$JENKINS_URL/job/production/job/utils/job/handle-customer-special-terms/job/master/buildWithParameters"

    queue_id=$(curl -i -u $JENKINS_USER:$JENKINS_API_TOKEN \
    -X POST "$TRIGGER_URL" \
    --data-urlencode "CUSTOMER_NAME=$TECHNICAL_SERVER_NAME" \
    --data-urlencode "ENVIRONMENT=production" \
    --data-urlencode "SF_TICKET_NUMBER=$SF_TICKET_NUMBER" \
    --data-urlencode "APPLICATION=customer" \
    --data-urlencode "CONFIGURE_VERSION=true" \
    --data-urlencode "ARTIFACTORY=$ARTIFACTORY_VERSION_NUMBER" \
    --data-urlencode "XRAY=latestRelease" \
    --data-urlencode "PIPELINES=latestRelease" \
    --data-urlencode "MISSION_CONTROL=latestRelease" \
    --data-urlencode "DISTRIBUTION=latestRelease" \
    --data-urlencode "CORE_SERVICES=latestRelease" \
    --data-urlencode "INSIGHT=latestRelease" \
    --data-urlencode "RESET_VERSION=false" \
    --data-urlencode "DEPLOY_NOW=$DEPLOY_NOW" \
    --data-urlencode "DEPLOYMENT_START_TIME_WINDOW=${DEPLOYMENT_START_TIME_WINDOW:-}" \
    --data-urlencode "DEPLOYMENT_END_TIME_WINDOW=${DEPLOYMENT_END_TIME_WINDOW:-}" \
    --data-urlencode "RESET_DEPLOYMENT_WINDOW_TIME=false" \
    --data-urlencode "AUTO_ACTION=upgrade" \
    --data-urlencode "VALIDATE_SPECIAL_CUSTOMER=true" | grep -i "location:" | awk -F'/' '{print $(NF-1)}' | tr -d '\r')

    if [ -z "$queue_id" ]; then
        echo "Failed to retrieve Queue ID. Check the Jenkins response."
        exit 1
    fi

    echo "Jenkins job triggered. Queue ID: $queue_id"
    sleep 10

    # Retrieve the build number
    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ]; do
        BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$JENKINS_URL/queue/item/$queue_id/api/json" | jq -r '.executable.number // empty')
        sleep 2
    done

    echo "Triggered build number: $BUILD_NUMBER"

    # Tail the build output
    LOG_URL="$JENKINS_URL/job/production/job/utils/job/handle-customer-special-terms/job/master/$BUILD_NUMBER/logText/progressiveText"
    START=0

    OUTPUT_RESULT=""
    while : ; do
        RESPONSE=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$LOG_URL?start=$START")
        echo -n "$RESPONSE"
        START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

        if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
            echo "Finished: SUCCESS"
            if echo "$RESPONSE" | grep -q "Result:"; then
                OUTPUT_RESULT=$(echo "$RESPONSE" | awk '/Result:/ {print $NF}' | tr -d '\r')
                OUTPUT_RESULT=$(echo "$OUTPUT_RESULT" | tr -d '\r')
                echo "Extracted result: $OUTPUT_RESULT"
            fi
            break
        elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
            echo "Job failed."
            break
        fi

        sleep 2
    done

    echo -e "\033[1;32m"
    echo -e "Job has finished successfully."
    if [ -n "$OUTPUT_RESULT" ]; then
        echo "Processing result: $OUTPUT_RESULT"
    fi
    exit 0
}


cot_saas_to_onprem() {
    echo -e "\033[1;32mStarting Circle of Trust Process for SaaS to OnPrem..."

    # Confirm customer approval
    echo "We must get the customer's approval to perform the Circle Of Trust."
    echo
    sleep 1
    echo "Please confirm that you have shared the following statement with the customer:"
    echo
    sleep 1
    echo "\"[We/I] confirm that [we are/I am] requesting a Circle of Trust between [SaaS Environment] and [OnPrem Environment] and that [we are/I am] authorized to make such a request on behalf of [Customer]. [We/I] confirm that Customer’s use, as facilitated by the Circle of Trust, will be governed by JFrog's Terms and Conditions for both Self Hosted and Cloud subscriptions.\""
    echo
    # Get customer's approval
    sleep 1
    echo -n "Have you obtained the customer’s approval? (yes/no): "
    read approval
    if [[ "$approval" != "yes" ]]; then
        echo "Operation aborted. Please confirm with the customer before proceeding."
        return 1
    fi
    echo
    # Get customer server names from the user
    echo -n "Enter the customer server name(s) (comma separated if multiple): "
    read customer_server_names

    # Ensure customer_server_names isn't empty
    if [[ -z "$customer_server_names" ]]; then
        echo "Error: No server names provided."
        return 1
    fi
    echo
    # Get OnPrem server name
    echo -n "Enter the OnPrem server name: "
    read ONPREM_SERVER_NAME

    if [[ -z "$ONPREM_SERVER_NAME" ]]; then
        echo "Error: No OnPrem server name provided."
        return 1
    fi
    echo
    echo "Please paste the OnPrem Root Certificate. When finished, press ENTER to start a new line and then type 'EOF' on a new line to stop:"
    ONPREM_ROOT_CERT=""
    while IFS= read -r line; do
        #trying to remove eof
        if [[ -z "$line" ]]; then

       # if [[ "$line" == "EOF" ]]; then
            break
        fi
        ONPREM_ROOT_CERT+="$line"$'\n'
    done

    if [[ -z "$ONPREM_ROOT_CERT" ]]; then
        echo "Error: No OnPrem root certificate provided."
        return 1
    fi
    # Initialize array to store technical server names
    technical_server_names=()

    # Split server names by comma and handle them one by one
    for server_name in $(echo "$customer_server_names" | sed "s/,/ /g"); do
        if [[ -n "$server_name" ]]; then
            echo
            echo "Checking for technical server name for $server_name..."

            # Perform the technical server name check using dig
            dig_output=$(dig "$server_name.jfrog.io")
            cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

            if [[ "$cname_entry" == endpoint* ]]; then
                technical_server_names+=("$server_name")
                echo "No technical server name found. Using customer server name: $server_name.jfrog.io"
            else
                technical_name="${cname_entry%%.*}"
                technical_server_names+=("$technical_name")
                echo "Technical server name found: $technical_name.jfrog.io"
                echo "CNAME ENTRY: $cname_entry"
            fi
        else
            echo "Warning: Empty server name found."
        fi
    done

    # Join technical server names into a single string
    customer=$(IFS=','; echo "${technical_server_names[*]}")
    echo "customer = $customer"
    # Ensure customer isn't empty before proceeding
    if [[ -z "$customer" ]]; then
        echo "Error: No valid server names were provided."
        return 1
    fi

    # Trigger the Circle of Trust request with the updated technical names and additional parameters
    TRIGGER_URL="https://<REDACTED>/job/support/job/utils/job/configure-circle-of-trust-with-onprem/job/master/buildWithParameters"
    echo "Sending Circle of Trust request..."
    queue_id=$(curl -i -u "$JENKINS_USER:$JENKINS_API_TOKEN" \
        -X POST "$TRIGGER_URL" \
        --data-urlencode "ENVIRONMENT=production" \
        --data-urlencode "CUSTOMER_NAMES=$customer" \
        --data-urlencode "ONPREM_SERVER_NAME=$ONPREM_SERVER_NAME" \
        --data-urlencode "ONPREM_ROOT_CERT=$ONPREM_ROOT_CERT" | grep -i "location:" | awk -F'/' '{print $(NF-1)}' | tr -d '\r')

    if [[ -z "$queue_id" ]]; then
        echo "Failed to retrieve Queue ID. Check the response."
        return 1
    fi

    echo "Circle of Trust request queued with ID: $queue_id. Polling for the build number..."

    # Set a maximum number of retries to avoid infinite loop
    MAX_RETRIES=30
    RETRY_COUNT=0
    sleep 10

    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ]; do
        BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "https://<REDACTED>/queue/item/$queue_id/api/json" | jq -r '.executable.number // empty')
        sleep 2
    done
    if [ -z "$BUILD_NUMBER" ]; then
        echo "Failed to retrieve build number after $MAX_RETRIES retries."
        return 1
    fi

    echo "Triggered build number: $BUILD_NUMBER"
    LOG_URL="<REDACTED>/job/support/job/utils/job/configure-circle-of-trust-with-onprem/job/master/$BUILD_NUMBER/logText/progressiveText"
    START=0

    while true; do
        RESPONSE=$(curl -s -u "$JENKINS_USER:$JENKINS_API_TOKEN" "$LOG_URL?start=$START")

        while IFS= read -r line; do
            echo "$line"
        done <<< "$RESPONSE"

        # Calculate the new start position for the next iteration
        START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

        # Check for build completion
        if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
            echo -e "\033[1;32mJob has finished successfully.\033[0m"
            break
        elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
            echo -e "\033[1;31mJob failed.\033[0m"
            break
        elif echo "$RESPONSE" | grep -q "Finished: ABORTED"; then
            echo -e "\033[1;31mJob aborted.\033[0m"
            exit
            break
        elif echo "$RESPONSE" | grep -q "Aborted by"; then
            echo -e "\033[1;31mJob aborted.\033[0m"
            exit
            break
        fi

        sleep 2
    done
}

generate_bofa_token() {
    echo -e "\033[1;32mSGenerating BOFA token..."
    echo
    
    # Prompt the user for the SF Ticket number
    echo "Enter the Case ID number:"
    read SF_TICKET_NUMBER

    JENKINS_URL="<REDACTED>"
    # Trigger the Jenkins job
    TRIGGER_URL="$JENKINS_URL/job/support/job/utils/job/bofa-logs-token/buildWithParameters"

    queue_id=$(curl -i -u $JENKINS_USER:$JENKINS_API_TOKEN \
    -X POST "$TRIGGER_URL" \
    --data-urlencode "CASE_ID=$SF_TICKET_NUMBER" | grep -i "location:" | awk -F'/' '{print $(NF-1)}' | tr -d '\r')

    if [ -z "$queue_id" ]; then
        echo "Failed to retrieve Queue ID. Check the Jenkins response."
        exit 1
    fi

    echo "Jenkins job triggered. Queue ID: $queue_id"
    sleep 10

    # Retrieve the build number
    BUILD_NUMBER=""
    while [ -z "$BUILD_NUMBER" ]; do
        BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$JENKINS_URL/queue/item/$queue_id/api/json" | jq -r '.executable.number // empty')
        sleep 2
    done

    echo "Triggered build number: $BUILD_NUMBER"

    # Tail the build output
    LOG_URL="$JENKINS_URL/job/support/job/utils/job/bofa-logs-token/$BUILD_NUMBER/logText/progressiveText"
    START=0

    OUTPUT_RESULT=""
    while : ; do
        RESPONSE=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$LOG_URL?start=$START")
        echo -n "$RESPONSE"
        START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

        if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
            echo "Finished: SUCCESS"
            if echo "$RESPONSE" | grep -q "Result:"; then
                OUTPUT_RESULT=$(echo "$RESPONSE" | awk '/Result:/ {print $NF}' | tr -d '\r')
                OUTPUT_RESULT=$(echo "$OUTPUT_RESULT" | tr -d '\r')
                echo "Extracted result: $OUTPUT_RESULT"
            fi
            break
        elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
            echo "Job failed."
            break
        fi

        sleep 2
    done

    echo -e "\033[1;32m"
    echo -e "Job has finished successfully."
    if [ -n "$OUTPUT_RESULT" ]; then
        echo "Processing result: $OUTPUT_RESULT"
    fi
    exit 0
}


get_artifactory_config_file() {
    echo -e "\033[1;32mStarting process to retrieve Artifactory Config File...\033[0m"

    # Ask the user for the customer server name
    echo "Enter customer server name (without spaces): "
    read CUSTOMER_SERVER_NAME

    # Validate that the server name has no spaces
    if [[ "$CUSTOMER_SERVER_NAME" =~ \  ]]; then
        echo "Error: Customer server name contains spaces."
        return 1
    fi

    # Perform the technical server name check using dig
    echo "Checking for technical server name..."
    sleep 1
    dig_output=$(dig "$CUSTOMER_SERVER_NAME.jfrog.io")
    cname_entry=$(echo "$dig_output" | grep 'CNAME' | awk '{print $5}' | head -n 1)

    if [[ "$cname_entry" == endpoint* ]]; then
        TECHNICAL_SERVER_NAME="$CUSTOMER_SERVER_NAME"
        echo "No technical server name found. Using customer server name: $CUSTOMER_SERVER_NAME.jfrog.io"
    else
        TECHNICAL_SERVER_NAME="${cname_entry%%.*}"
        echo "Technical server name found: $TECHNICAL_SERVER_NAME.jfrog.io"
        echo "CNAME ENTRY: $cname_entry"
    fi
    echo

    # Provide examples of common file paths for the user
    echo "Please enter the full path to the configuration file you want to retrieve."
    echo "Here are a couple of common examples:"
    echo "1. /opt/jfrog/artifactory/var/etc/system.yaml"
    echo "2. /opt/jfrog/artifactory/var/etc/artifactory/artifactory.system.properties"
    echo "3. /opt/jfrog/artifactory/var/etc/artifactory/artifactory.repository.config.latest.json"
    echo "4. /opt/jfrog/artifactory/var/etc/artifactory/binarystore.xml"
    echo "5. /opt/jfrog/artifactory/var/etc/artifactory/logback.xml (Artifactory logs)"
    echo "6. /opt/jfrog/artifactory/var/etc/access/logback.xml (Access logs)"
    echo "7. /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.latest.xml"
    echo

    # Get the full path from the user
    echo "Enter the full file path: "
    read FILE_PATH

    # Jenkins job details
    JENKINS_URL="https://<REDACTED>"
    JOB_PATH="/job/support/job/utils/job/get-artifactory-config-file/job/master"
    TRIGGER_URL="$JENKINS_URL$JOB_PATH/buildWithParameters"

    # Trigger the Jenkins job with the provided file path
    echo "Triggering Jenkins job to retrieve the file from Artifactory..."
    curl -i -u $JENKINS_USER:$JENKINS_API_TOKEN \
    -X POST "$TRIGGER_URL" \
    --data-urlencode "CUSTOMER_SERVER_NAME=$TECHNICAL_SERVER_NAME" \
    --data-urlencode "ENVIRONMENT=production" \
    --data-urlencode "APPLICATION=artifactory" \
    --data-urlencode "FILE_NAME=$FILE_PATH"

    sleep 10

    # Initialize BUILD_NUMBER variable
    BUILD_NUMBER=""
    
    # Wait for the build number to be assigned
    while [ -z "$BUILD_NUMBER" ]; do
        sleep 2
        BUILD_NUMBER=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$JENKINS_URL/job/support/job/utils/job/get-artifactory-config-file/job/master/api/json" | jq -r '.lastBuild.number')
    done

    echo "Triggered build number: $BUILD_NUMBER"

    LOG_URL="$JENKINS_URL/job/support/job/utils/job/get-artifactory-config-file/job/master/$BUILD_NUMBER/logText/progressiveText"
    START=0
    OUTPUT_RESULT=""
    HIGHLIGHT_MODE=0

    # Tail the build output with highlighting
    while : ; do
        RESPONSE=$(curl -s -u $JENKINS_USER:$JENKINS_API_TOKEN "$LOG_URL?start=$START")

        while IFS= read -r line; do

            # Start highlighting if the specific commands are detected
            if echo "$line" | grep -q "INFO:root:Func name: get_customer_configuration"; then
                HIGHLIGHT_MODE=1
            fi

            # Stop highlighting when the "Pipeline" keyword is found
            if [[ "$line" == *"Pipeline"* ]]; then
                HIGHLIGHT_MODE=0
            fi

            # Apply highlighting if in HIGHLIGHT_MODE
            if [ $HIGHLIGHT_MODE -eq 1 ]; then
                echo -e "\033[1;33m$line\033[0m"  # Highlight the line in green
            else
                echo "$line"
            fi

        done <<< "$RESPONSE"

        # Calculate the new start position for the next iteration
        START=$(echo "$START + $(echo -n "$RESPONSE" | wc -c)" | bc)

        # Check for "Result:" line to extract output result
        if echo "$RESPONSE" | grep -q "Result:"; then
            OUTPUT_RESULT=$(echo "$RESPONSE" | awk '/Result:/ {print $NF}' | tr -d '\r')
            echo "Extracted result: $OUTPUT_RESULT"
        fi

        # Check for success or failure in the log output
        if echo "$RESPONSE" | grep -q "Finished: SUCCESS"; then
            echo "Finished: SUCCESS"
            break
        elif echo "$RESPONSE" | grep -q "Finished: FAILURE"; then
            echo "Job failed."
            break
        fi

        sleep 2
    done

    # Job completion message
    echo -e "\033[1;32m"
    echo -e "\033[1;32m╔═══════════════════════════════════════╗\033[0m"
    echo -e "\033[1;32m║     Job has finished successfully     ║\033[0m"
    echo -e "\033[1;32m╚═══════════════════════════════════════╝\033[0m"

    if [ -n "$OUTPUT_RESULT" ]; then
        echo "Processing result: $OUTPUT_RESULT"
    fi

    exit 0
}




#####ALECTESTING###

if [ ! -z "$3" ]; then
    echo "Error: Too many arguments provided."
    exit 1
fi

# If arguments are passed, execute the script in non-interactive mode
if [ $# -gt 0 ]; then
    SOURCE=$1
    if [ $# -eq 2 ]; then
        INPUTTED_CASE_NUMBER=$2
    fi
else
    # Use bold green text

# Print the ASCII art
echo -e "\033[1;32m╔════════════════════════════════════════╗\033[0m"
echo -e "\033[1;32m║        SUPPORT TEAM MULTI-TOOL         ║\033[0m"
echo -e "\033[1;32m╚════════════════════════════════════════╝\033[0m"
echo
echo
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⢀⣾⡛⠋⠙⠳⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⢀⣠⣤⡤⠶⠟⠃⠀⣀⣀⣤⣽⡦⠤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ⠀⠀⠀\033[0m"
echo -e "\033[1;32m⣴⠟⠉⠀⠀⠀⠀⠀⢚⣽⡶⣶⣬⡹⣦⠀⠋⠙⠳⢦⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⢿⣄⠀⠀⠀⠀⠀⠀⣿⣇  ⢹⣷⢸⣧⡀⠀⠀ ⠁⠉⠉⠙⠛⠛⠳⠶⢦⣤⣀⡀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠈⠛⣷⠦⣤⡀⠀⠀⠻⣿⣿⣿⠿⣋⣾⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠘⠳⢦⣍⡛⠲⢦⣌⡙⠛⠛⢻⡃⠾⠽⣏⠛⠛⢿⣿⣷⣄⡀⠀(>\")> ⠈⠛⣷⣄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠙⢿⡗⠢⢤⡉⠓⠤⢼⣷⣤⡴⠋⠀⠀⠀⠈⠻⢿⣿⣷⣶⣤⡀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣷⣆⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠈⢿⣄⠀⠈⠑⠢⠤⠤⠌⠁⠐⠒⠤⠀⠀⠀⠀⠉⠛⠻⢿⣿⣶⣦⣄⠀⠀⠀⠀⠈⠻⣿⡟⣿⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠻⣷⣄⠀⠀¯\_(ツ)_/¯⠀⠀⠀⠀⣀⠈⠙⠻⣿⣦⣄⠀⠀⠀⠀⠙⢿⡏⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣷⣄         ⢦⡀⠀⠀⠀⠀⠉⠒⢄⠀⠙⠻⣷⣄⠀⠀⠀⠈⢻⡆⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣦⣄⠀⠀⠘⡄⠀⠀⠀⠈⢦⠀⠀⠀⠀⠀⠀⠑⡄⣀⡴⠛⠉⠙⠒⣤⡼⠖⠛⠛⢷⣦⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⢀⣠⣶⣾⢻⣿⣽⣞⣯⣻⣿⢷⣄⣀⠙⢦⡀⠀⠀⠀⠳⣄⠀⠀⠀⠀⢠⡞⠉⠀⠀⣠⡶⠛⠁⠀⠀⠀⠀⠀⢹⡆\033[0m"
echo -e "\033[1;32m⠀⣾⣟⣳⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⢶⣽⡆⠀⠀⠀⠈⢷⠀⠀⢠⡏⠀⠀⠀⡸⠋ CELA ⢠⠄⣾⠀\033[0m"
echo -e "\033[1;32m⠀⠛⠛⢋⣠⡴⣿⣯⡿⠛⠉⢿⣬⣷⣍⠙⠛⠻⣦⡟⣼⠋     ⣞⣀⣠⣾⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⡴⠃⣰⡟⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠰⣿⣹⣿⠏⠁⠀⠀⠀⠀⢿⣯⣿⣇⣤⣄⠀⢰⡏     ⢸⠋⠉⠁⣿⠀ <(\"<)  ⣠⠞⠁⣠⡿⠁⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠈⠉⠀⠀⠀⠀⣶⠶⢦⣬⣭⣥⣿⣄⡙⠷⠟⠀⠀⠀ ⠀⣠⣿⠀⠀⠀⢻⣆⠀⠀⠀⠀⠀⣀⡴⠚⠁⠀⣴⡟⠁⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⢷⣒⠶⠤⣤⣄⡠⠁     ⣠⣾⡿⠋⠀⢀⣠⣄⣹⠷⠶⠶⠾⠉⣁⠃⠀⣠⣾⠋⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡟⠉⣛⣉⣁⣀⣤⣤⣤⣤⣤⣤⣤ⴰ⠛⠀⠀⠀⢸⣯⣩⣷⣿⣿⠆⣀⠔⠁⣀⣴⠟⠁⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⡴⠟⡻⠟⣉⣴⠞⢁⣠⡾⠟⠁⠀⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣸⡷⠼⠒⣩⣴⡿⠓⢡⡴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[0m"
echo -e "\033[1;32m⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣏⣀⣩⡶⠶⠛⠉⠘⠷⠶⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\033[0m"

echo -e "\033[0m" # Reset the text color



#PS3="Please choose an option (1-9):\033[0m "
# Define the PS3 prompt with green text
PS3="${BRIGHT_YELLOW}Please choose an option (1-9):${NC} "

echo -e "\033[1;32m"
    

    echo -e "\033[1;32m\033[4mPOSSIBLE FUNCTIONS\033[0m"
    echo -e "\033[1;32m"
    
   # switch the line if you want to enable downloads 
   # select SOURCE_JOB in "unpack-from-downloads" "unpack-from-supportlogs" "production-bundle" "get-application-detail" "enable-debug-loggers" "add-artifactory-system-properties" "redeploy-artifactory-server" "cot-saas-to-saas" "cot-saas-to-onprem"; do
    select SOURCE_JOB in "unpack-from-supportlogs" "production-bundle" "get-application-detail" "enable-debug-loggers" "get-artifactory-config" "redeploy-artifactory-server" "upgrade-artifactory-server" "add-artifactory-system-properties" "generate-bofa-token" "cot-saas-to-saas" "cot-saas-to-onprem"; do
    if [[ -n $SOURCE_JOB ]]; then
    SOURCE=$SOURCE_JOB
    echo
    echo -e " You chose ${SOURCE_JOB}"
    echo
    break
else
    echo "Invalid option $REPLY"
fi

    done
    if [ "$SOURCE" = "unpack-from-supportlogs" ]; then
        echo "\033[1;32mPlease enter case number\033[1;32m"
        read INPUTTED_CASE_NUMBER
    fi
    
    if [ "$SOURCE" = "production-bundle" ]; then
        echo "Choose a save path for the production bundle."
        echo -e "\033[1;32mEnter a case number (e.g., 123123) or a server name (e.g., hts1):\033[0m"
        read INPUTTED_CASE_NUMBER
    fi
    #if [ "$SOURCE" != "get-application-detail" ] && [ "$SOURCE" != "enable-debug-loggers" ] &&  [ "$SOURCE" != "add-artifactory-system-properties" ] &&  [ "$SOURCE" != "redeploy-artifactory-server" ] && [ "$SOURCE" != "cot-saas-to-saas" ]  && [ "$SOURCE" != "cot-saas-to-onprem" ]; then
    #   
    #    echo "\033[1;32mEnter case number or server name to determine where to save the file\033[1;32m"
    #    read INPUTTED_CASE_NUMBER
    #fi
fi

CASE_ID=$INPUTTED_CASE_NUMBER
DEST_DIR="$BASE_DEST_DIR/$CASE_ID"

if [ "$SOURCE" != "get-application-detail" ] && [ "$SOURCE" != "enable-debug-loggers" ] &&  [ "$SOURCE" != "add-artifactory-system-properties" ] &&  [ "$SOURCE" != "redeploy-artifactory-server" ] &&  [ "$SOURCE" != "upgrade-artifactory-server" ]  &&  [ "$SOURCE" != "generate-bofa-token" ] && [ "$SOURCE" != "cot-saas-to-saas" ]  && [ "$SOURCE" != "cot-saas-to-onprem" ] ; then
    mkdir -p "$DEST_DIR"
fi

if [ "$SOURCE" != "get-application-detail" ] && [ "$SOURCE" != "enable-debug-loggers" ] &&  [ "$SOURCE" != "add-artifactory-system-properties" ] &&  [ "$SOURCE" != "redeploy-artifactory-server" ] &&  [ "$SOURCE" != "upgrade-artifactory-server" ]  &&  [ "$SOURCE" != "generate-bofa-token" ] && [ "$SOURCE" != "cot-saas-to-saas" ] && [ "$SOURCE" != "cot-saas-to-onprem" ] && [ "$(ls -A "$DEST_DIR")" ]; then
    LATEST_BUNDLE=$(ls "$DEST_DIR" | grep 'support_bundle' | sort -n -r | head -n 1)

    if [ "$LATEST_BUNDLE" ]; then
        LATEST_NUMBER=$(echo "$LATEST_BUNDLE" | grep -o -E '[0-9]+')
        NEW_NUMBER=$((LATEST_NUMBER + 1))
    else
        NEW_NUMBER=1
    fi
else
    NEW_NUMBER=1
fi

if [[ "$SOURCE" = "download" || "$SOURCE" = "saas" || "$SOURCE" = "prod" ]]; then
   if [[ -z "$2" ]]; then
        echo "\033[1;31mError: A number is required for the 'download' 'saas' 'prod' command (e.g., sup saas 123123).\033[0m"
        exit 1
    fi
else
   if [[ -n "$2" ]]; then
        echo "\033[1;31mError: [$2] is not needed. Too many arguments for this command"
        exit 1
   fi
fi


# Check the source type and call appropriate functions
if [[ "$SOURCE" = "get-application-detail" || "$SOURCE" = "detail" ]]; then
     run_get_application_detail
elif [[ "$SOURCE" = "enable-debug-loggers" || "$SOURCE" = "logger" ]]; then
     enable_debug_loggers
elif [[ "$SOURCE" = "unpack-from-supportlogs" || "$SOURCE" = "saas" ]]; then
     download_from_saas
elif [[ "$SOURCE" = "update-artifactory-special-properties" || "$SOURCE" = "properties" ]]; then
     update_artifactory_special_properties
elif [[ "$SOURCE" = "redeploy-artifactory-server" || "$SOURCE" = "redeploy" ]]; then
     redeploy_artifactory_server
elif [[ "$SOURCE" = "production-bundle" || "$SOURCE" = "prod" ]]; then
     download_production_bundle
elif [[ "$SOURCE" = "add-artifactory-system-properties" || "$SOURCE" = "properties" ]]; then
     update_artifactory_special_properties 
elif [[ "$SOURCE" = "upgrade-artifactory-server" || "$SOURCE" = "upgrade" ]]; then
     upgrade_artifactory_server
elif [[ "$SOURCE" = "generate-bofa-token" || "$SOURCE" = "bofa" ]]; then
     generate_bofa_token
elif [[ "$SOURCE" = "cot-saas-to-saas" || "$SOURCE" = "cotsaas" ]]; then
     cot_saas_to_saas
elif [[ "$SOURCE" = "cot-saas-to-onprem" || "$SOURCE" = "cotonprem" ]]; then
     cot_saas_to_onprem
elif [[ "$SOURCE" = "get-artifactory-config" || "$SOURCE" = "getconfig" ]]; then
     get_artifactory_config_file 
elif [[ "$SOURCE" = "--config" ]]; then
     prompt_for_changes
elif [[ "$SOURCE" = "--config-show" ]]; then
     show_current_config
elif [[ "$SOURCE" = "unpack-from-downloads" || "$SOURCE" = "download" ]]; then
    # List the last 8 files in the Downloads folder
    echo
    echo "\033[4mHere are the last 8 files in your Downloads folder\033[0m"
    echo
    
    echo "\033[0;97m"
    ls -tr "$HOME/Downloads" | tail -n 8
    echo "\033[0m"
    # Ask the user for the file name they want to unzip
    echo "\033[1;32mPlease enter the name of the file you want to unzip from the Downloads folder:"
    read FILENAME

    echo

    if [ ! -f "$SOURCE_DIR/$FILENAME" ]; then
        echo "File $FILENAME not found in $SOURCE_DIR."
        exit 1
    fi

    echo "Starting local download"

    LATEST_BUNDLE=$(ls "$DEST_DIR" | grep 'support_bundle' | sort -n -r | head -n 1)

    if [ "$LATEST_BUNDLE" ]; then
        LATEST_NUMBER=$(echo "$LATEST_BUNDLE" | grep -o -E '[0-9]+')
        NEW_NUMBER=$((LATEST_NUMBER + 1))
    else
        NEW_NUMBER=1
    fi

    NEW_BUNDLE_FOLDER="support_bundle${NEW_NUMBER}"
    mkdir -p "$DEST_DIR/$NEW_BUNDLE_FOLDER"
    NEW_BUNDLE_DIR="$DEST_DIR/$NEW_BUNDLE_FOLDER" 
   
    mv "$SOURCE_DIR/$FILENAME" "$DEST_DIR/$NEW_BUNDLE_FOLDER"
    FILENAME="$DEST_DIR/$NEW_BUNDLE_FOLDER/$FILENAME"

    extract_file "$FILENAME"

    # Recursively process files in the bundle directory
    process_files_recursively "$NEW_BUNDLE_DIR"
fi


if [[ "$SOURCE" != "get-application-detail" && "$SOURCE" != "--config" && "$SOURCE" != "--help" && "$SOURCE" != "--config-show" && "$SOURCE" != "enable-debug-loggers" && "$SOURCE" != "logger" && "$SOURCE" != "detail" && "$SOURCE" != "saas" && "$SOURCE" != "download" && "$SOURCE" != "properties" && "$SOURCE" != "redeploy" && "$SOURCE" != "upgrade" && "$SOURCE" != "bofa" && "$SOURCE" != "cotsaas" && "$SOURCE" != "getconfig" ]]; then
echo -e "\033[1;32m"
        echo -e "\033[1;32m╔════════════════════════════════════════════╗\033[0m"
        echo -e "\033[1;32m║        Incorrect Function Selected         ║\033[0m"
        echo -e "\033[1;32m╚════════════════════════════════════════════╝\033[0m"
        echo -e  "\033[1;32m"
echo -e "\033[1;31mInvalid input. Please refer to the help command by running:\033[0m"
echo -e "\033[1;32msup --help\033[0m"

fi
#if [ "$SOURCE" != "get-application-detail" ] && [ "$SOURCE" != "--config" ] && [ "SOURCE" != "--config-show" ] && [ "$SOURCE" != "enable-debug-loggers" ]; then
#     echo -e "\033[1;32m"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⠤⠶⠦⣤⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⠛⠉⠀⣀⡀⠀⠀⠀⠳⣦⢤⠉⠓⠦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡞⠁⡀⢀⣿⣿⣿⣷⣶⣶⣦⣭⣿⣼⣦⡀⠀⠈⠳⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⣰⠋⣰⣻⡾⠟⠋⠉⠉⠁⠀⠀⠈⠉⠁⠉⠙⠙⠲⣦⣦⡙⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⣰⠿⠊⠋⠁⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠽⠦⣼⡆⠀⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⣠⢾⣅⠐⣻⡆⠀⢀⣤⣶⠟⢻⡏⢻⣿⣿⡟⣷⣶⣦⣭⣲⣶⣾⣦⠈⠻⣦⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⣠⠞⢱⣿⢻⣿⣿⣾⣿⣿⡟⠁⠀⠘⣇⠀⢻⣿⣿⠘⣏⢿⣿⣿⣷⣿⣾⣻⡗⠈⢷⡀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⡰⠃⣀⠈⠉⣴⣿⣿⣿⣿⠏⠀⠀⠀⠀⢹⡄⠀⠻⣿⡄⠘⣎⣿⣿⣿⣿⣷⡄⠀⠀⠀⢳⡀⠀⠀⠀⠀"
#        echo -e "⠀⢰⠃⡼⣿⣄⣾⢟⣿⣿⢿⡟⢀⣀⣄⣀⠀⠀⠁⠀⠀⠹⣷⠒⠒⠚⣿⡏⣿⣿⣿⣆⠀⠀⠀⢷⠀⠀⠀⠀"
#        echo -e "⠀⣿⢰⣧⣤⣽⣥⣿⣿⣿⢸⠇⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣀⣀⡀⠘⡇⣻⣿⣿⣭⣷⣀⣀⢸⡀⠀⠀⠀"
#        echo -e "⢀⣽⣸⡟⡻⣿⣿⣿⣻⣿⠇⠀⢠⡶⠖⢶⡆⠀⡆⠀⠀⠀⡿⠁⡈⣙⣠⢿⡝⣟⣻⢻⣼⡿⡌⢩⡇⠀⠀⠀"
#        echo -e "⠀⢻⡝⠁⣙⣿⣿⣹⢫⠼⣦⡀⠈⠀⠀⠀⠀⢼⡇⠀⠀⠀⠛⠒⠛⢋⣵⡏⢹⣹⣷⠿⣿⣧⡇⣾⠁⠀⠀⠀"
#        echo -e "⠀⠀⣧⠀⢻⣿⣿⡟⡏⠀⠈⡟⠓⠶⠦⣤⣄⣀⣉⣠⣤⡤⠶⠶⣟⠉⠀⠙⣤⡿⣿⣄⡼⣾⡼⠁⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠲⣽⡿⢷⢻⢦⣴⠃⠀⠀⠀⡿⠀⠀⠀⠈⡇⠀⠀⠀⢸⣤⠴⠚⢙⣷⢻⠟⣠⠞⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠙⠛⢘⡿⢦⡏⠙⠓⠢⢴⠧⠤⡤⠤⠤⣷⠒⠚⠛⠉⢧⡀⢀⣾⣏⣡⠞⠁⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠙⠺⣿⣦⡀⠀⢸⠀⠀⠀⠀⠀⢸⡄⠀⠀⢀⣸⣷⣿⣯⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠿⣗⣿⠷⠤⠤⠤⠤⣾⣷⣖⣺⣽⣻⣿⣿⣿⡛⠳⣦⣀⠀⠀⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⢹⠟⠉⠉⠻⣿⣿⣿⣿⣿⣿⣿⣍⠋⢹⣷⣄⠀⠀⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠋⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⡷⢾⣿⠈⠳⣄⠀⠀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣆⠙⢯⡀⠈⢧⡀⠀"
#        echo -e "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣞⠀⠀⠀⠀⣀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠙⣆⡀⢳⡄"
#        echo -e "\033[1;32m╔═════════════════════════════════════════════╗\033[0m"
#        echo -e "\033[1;32m║  Nice! The Support bundle is now unzipped.  ║\033[0m"
#        echo -e "\033[1;32m╚═════════════════════════════════════════════╝\033[0m"
#    echo
#    echo -e "\033[1;32mCOMPLETED PROCESSING ALL FILES INSIDE:                       \033[0m"
#    echo -e "\033[1;95m$DEST_DIR/$NEW_BUNDLE_FOLDER\033[0m"   
#fi
echo -e "\033[1;32m"


# Define text colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Define bold (bright) text colors
BOLD_BLACK='\033[1;30m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_MAGENTA='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Define bright (high-intensity) text colors
BRIGHT_BLACK='\033[0;90m'
BRIGHT_RED='\033[0;91m'
BRIGHT_GREEN='\033[0;92m'
BRIGHT_YELLOW='\033[0;93m'
BRIGHT_BLUE='\033[0;94m'
BRIGHT_MAGENTA='\033[0;95m'
BRIGHT_CYAN='\033[0;96m'
BRIGHT_WHITE='\033[0;97m'

# Define background colors
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# Define bright (high-intensity) background colors
BG_BRIGHT_BLACK='\033[0;100m'
BG_BRIGHT_RED='\033[0;101m'
BG_BRIGHT_GREEN='\033[0;102m'
BG_BRIGHT_YELLOW='\033[0;103m'
BG_BRIGHT_BLUE='\033[0;104m'
BG_BRIGHT_MAGENTA='\033[0;105m'
BG_BRIGHT_CYAN='\033[0;106m'
BG_BRIGHT_WHITE='\033[0;107m'

# Define text styles
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINED='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
HIDDEN='\033[8m'
STRIKETHROUGH='\033[9m'

# Reset color
NC='\033[0m' # No Color


