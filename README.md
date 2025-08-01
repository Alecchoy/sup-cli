Why This Tool?

This tool was designed to address a common challenge faced by support engineers: the manual, time-consuming process of managing support bundles, production bundles, debug loggers, and application details.
As support engineers, we often find ourselves spending 20-30 seconds opening each webpage, 30-40 seconds to get through okta, and the entire process of generating a production bundle or adding loggers can take up to 10 minutes just to start the job. Here's why:

 Generating a production bundle involves several steps:

Navigating to Jenkins, locating the technical server name on JPMS, triggering the Jenkins job,waiting for the console output, and finally heading over to support logs to download the file.

Even then, you might get logged out or have to reauthenticate, adding unnecessary delays.

Once you have the file, you need to unpack it manually.


Getting application details involves similar steps:

Going to JPMS for the technical server name, then heading back to Jenkins for the console output, and manually identifying the critical information.


Configuring debug loggers requires:

Referencing the internal wiki for the correct logback.xml configuration, selecting the necessary portions, and entering them manually into Jenkins, followed by specifying a time.

This tool automates and simplifies these tasks. You can quickly trigger a production bundle, process application details, and configure loggers—all in one place.

Prerequisites
Ensure you have the following:
1.A valid JFrog token for accessing support logs (https://supportlogs.jfrog.com). 

2.Jenkins credentials (username and API token) My username is ‘alecc’ based off the URL
3. Ensure your system has curl, unzip, tar, and jq installed.
4. A cases folder in your home directory for bundle management:

  mkdir ~/Users/alecc/cases
This folder is necessary for organizing and managing your support bundles.

Installation

Download the tool to your machine.

Place the tool in a directory included in your PATH, e.g., /usr/local/bin/, and rename it to sup:
sudo mv supportcli.sh /usr/local/bin/sup
sudo chmod +x /usr/local/bin/sup

Ensure you have created the cases folder in your home directory for bundle management:
mkdir ~/cases

Run the tool anywhere using the command sup followed by the necessary parameters.
Configuration
The first time you run the tool, you will need to set up the necessary parameters. You can also manually adjust these settings later by running:
sup --config
The configuration parameters include:


Downloads Folder (SOURCE_DIR): The directory where your downloaded files are stored (e.g., ~/Downloads).

Case Folder (BASE_DEST_DIR): Directory where case-related bundles will be saved (e.g., ~/cases).

JFrog Token (JFROG_TOKEN): Token for accessing the support logs.

Jenkins User (JENKINS_USER): Jenkins username.

Jenkins API Token (JENKINS_API_TOKEN): Jenkins API token.
You can view the current configuration at any time by running:
sup --config-show

Credential Storage
The credentials and configuration settings you input (such as the JFrog token and Jenkins credentials) are stored locally in a configuration file located at:
  ~/.supportMT/supportMT.conf
This file holds sensitive data like your JFrog token, Jenkins username, and Jenkins API token. The credentials are used by the tool to automatically access support logs, trigger Jenkins jobs, and manage bundles without requiring you to re-enter them each time.
To protect your credentials, ensure the file permissions for this configuration file are set properly:
  chmod 600 ~/.supportMT/supportMT.conf


Usage


Once configured, you can use the tool in two ways: via the interactive menu or by using short-form commands.

Interactive Menu (Easiest Method)
The easiest and quickest way to use the tool is through its interactive menu. To access the menu, simply run the tool without any parameters:
  sup
You'll be presented with the following menu options to choose from:

unpack-from-downloads: Unpack files locally or from the Downloads folder. ( Optional function )

unpack-from-supportlogs: Download and unpack bundles from the SaaS server.(multi-files)

production-bundle: Trigger and download a production bundle from Jenkins.

get-application-detail: Trigger a get-application-detail job from Jenkins.

enable-debug-loggers: Enable debug loggers for various services.

add-artifactory-system-properties: can view, add, delete system properties.

redeploy-artifactory-server: immediate restart or scheduled

cot-saas-to-saas: configure circle of trust between two Saas Servers

cot-saas-to-onprem: configurat circle of trust between cloud and on-prem servers.
This method is highly recommended for streamlining the process without needing to memorize commands.



Short-Form Commands
For those who prefer more direct control, the tool also supports short-form commands. These allow you to bypass the menu and trigger the necessary actions directly from the command line.
Please note: case number is only required for ‘download’, ‘saas’, and ‘prod’
Here’s the general format:
sup <command> <case-number>
Available commands:

download: Unpack files locally or from the Downloads folder. (requires case number)

saas: Triggers the saas-uploaded-bundle function. (requires case number)

prod: Triggers the production-bundle function. (requires case number)

detail: Triggers the get-application-detail function.

logger: Triggers the enable-debug-loggers function.

properties: Triggle add-artifactory-system-properties function

redeploy: triggers redeploy-artifactory-server function

cotsaas: trigger cot-saas-to-saas function

cotonprem: triggers cot-saas-to-onprem function

--help: shows quick tips and commands

--config: set up authentication between multiple sites

--config-show: show current configuration

Example:
  sup download 248842
  sup saas 248842
  sup prod 248842
  sup detail
  sup logger
  sup properties
  sup redeploy
  sup cotsaas
  sup cotonprem
  sup  --help
  sup  --config
  sup  --config-show
Bundle Organization and Management
To keep bundles organized, each case is saved under a dedicated subfolder inside your ~/cases directory. This helps ensure that each case's data, including downloaded and unpacked files, is easily accessible and neatly categorized.
When a new bundle is processed for a case, a new folder is created based on the case number and stored in:
  ~/cases/<case-number>/
Example folder structure after working on multiple cases:
  ~/cases/
  ├── 248842/
  │   ├── support_bundle1/
  │   │   ├── saas_option1/
  │   │   │       │
  │   │   │       └── file_from_option1.zip
  │   │   └── saas_option2/
  │   │           │
  │   │           └── file_from_option2.tar.gz
  │   └── support_bundle2/
  │
  └── 248843/
      └── support_bundle1/

Help
To get a quick refresher on how it works you  can run
sup --help
