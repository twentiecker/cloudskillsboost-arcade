ZONE="$(gcloud compute instances list --project=$DEVSHELL_PROJECT_ID --format='value(ZONE)' | head -n 1)"

INSTANCE_ID=$(gcloud compute instances describe apache-vm --zone=$ZONE --format='value(id)')

# Task 1. Install the Cloud Logging and Monitoring agents
# So for this task, you need to install the Cloud Logging and Cloud Monitoring agents.
# 1. Connect to the VM instance apache-vm provisioned for you via SSH and install the Cloud Logging and Cloud Monitoring agents.
# 2. Enable the Apache Web Server monitoring plugin using the following commands:

# Run the Monitoring agent install script command in the SSH terminal of your VM instance to install the Cloud Monitoring agent:
# curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh

# sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# If asked if you want to continue, press Y.

# Run the Logging agent install script command in the SSH terminal of your VM instance to install the Cloud Logging agent:

# sudo systemctl status google-cloud-ops-agent"*"

# Press q to exit the status.

# sudo apt-get update

cat > prepare_disk.sh <<'EOF_END'
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh --also-install

curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh --also-install

# (cd /etc/stackdriver/collectd.d/ && sudo curl -O https://raw.githubusercontent.com/Stackdriver/stackdriver-agent-service-configs/master/etc/collectd.d/apache.conf)

sudo service stackdriver-agent restart
EOF_END

gcloud compute scp prepare_disk.sh apache-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh apache-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"


# Task 2. Add an uptime check for Apache Web Server on the VM
# For this task, you need to verify that your VM is up and running. To do this, create an uptime check with the resource type set to instance.
# Uptime checks verify that a resource is always accessible. For practice, create an uptime check to verify your VM is up.

# In the Cloud Console, in the left menu, click Uptime checks, and then click Create Uptime Check.

# For Protocol, select HTTP.

# For Resource Type, select Instance.

# For Instance, select lamp-1-vm.

# For Check Frequency, select 1 minute.

# Click Continue.

# In Response Validation, accept the defaults and then click Continue.

# In Alert & Notification, accept the defaults, and then click Continue.

# For Title, type Lamp Uptime Check.

# Click Test to verify that your uptime check can connect to the resource.

# When you see a green check mark everything can connect.

# Click Create.

# The uptime check you configured takes a while for it to become active. Continue with the lab, you'll check for results later. While you wait, create an alerting policy for a different resource.

gcloud monitoring uptime create quicklab \
  --resource-type="gce-instance" \
  --resource-labels=project_id=$DEVSHELL_PROJECT_ID,instance_id=$INSTANCE_ID,zone=$ZONE


# Task 3. Add an alert policy for Apache Web Server
# 1. Create an alert policy for Apache Web Server traffic that notifies you on your personal email account when the traffic rate exceeds 3 KiB/s.
# 2. Connect to the instance via SSH and run the following command to generate the traffic:

#### Use Cloud Monitoring to create alerting policies.

> **Step 1**. In the left menu, click **Alerting**, and then click **+Create Policy**.

> **Step 2**. Click on **Select a metric** dropdown. Uncheck the **Active**.

> **Step 3**. For the metric, be sure to select **Cloud Function > Function > Active Instances** and click **Apply**. Leave all other fields at the default value.

> **Step 4**. Click **Next**.

> **Step 5**. Set the **Threshold position** to `Above threshold`, **Threshold value** to `1` (number of active Cloud Run Function instances is greater than zero). Click **Next**.

> **Step 6**. Click on the drop down arrow next to **Notification Channels**, then click on **Manage Notification Channels**.

#### A Notification channels page will open in a new tab.

> **Step 7**. Scroll down the page and click on **ADD NEW** for **Email**.

> **Step 8**. In the **Create Email Channel** dialog box, enter your personal email address in the **Email Address** field and a **Display name**.

> **Step 9**. Click on **Save**.

> **Step 10**. Go back to the previous **Create alerting policy** tab.

> **Step 11**. Click on **Notification Channels** again, then click on the **Refresh icon** to get the display name you mentioned in the previous step.

> **Step 12**. Click on **Notification Channels** again if necessary, select your **Display name** and click **OK**.

> **Step 13**. Mention the **Alert name** as **Active Cloud Run Function Instances**.

> **Step 14**. Click **Next**.

> **Step 15**. Review the alert and click **Create Policy**.

cat > email-channel.json <<EOF_END
{
  "type": "email",
  "displayName": "quicklab",
  "description": "Subscribe to quicklab",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_END


gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"


# Run the gcloud command and store the output in a variable
channel_info=$(gcloud beta monitoring channels list)

# Extract the channel ID using grep and awk
channel_id=$(echo "$channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)


cat > app-engine-error-percent-policy.json <<EOF_END

{
  "displayName": "alert",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - Traffic",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/apache/traffic\"",
        "aggregations": [
          {
            "alignmentPeriod": "60s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 3072
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "1800s"
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$channel_id"
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}

EOF_END


gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"




# Task 4. Create a dashboard and charts for Apache Web Server on the VM
# For this task, you need to create a dashboard that's configured with charts.
# In the left menu select Dashboards, and then +Create Custom Dashboard.
# Name the dashboard Cloud Monitoring LAMP Qwik Start Dashboard.

# 1. Add the first line chart that has a Resource metric filter, CPU load (1m), for the VM.
# Click on + ADD WIDGET
# Select the Line option under Visualization in the Add widget.
# Name the Widget title.
# Click on Select a metric dropdown. Uncheck the Active.
# Type CPU load (1m) in filter by resource and metric name and click on VM instance > Cpu. Select CPU load (1m) and click Apply. Leave all other fields at the default value. Refresh the tab to view the graph.

# 2. Add a second line chart that has a Resource metric filter, Requests, for Apache Web Server.
# Click + Add WIDGET and select Line option under Visualization in the Add widget.
# Name the Widget title.
# Click on Select a metric dropdown. Uncheck the Active.
# Type Requests in filter by resource and metric name and click on VM Instance > apache. Select Requests and click Apply. Leave all other fields at the default value. Refresh the tab to view the graph.




# Task 5. Create a log-based metric
# 1. Next, create a log based metric that filters for the following values:

# my version
# Cloud Monitoring and Cloud Logging are closely integrated. Check out the logs for your lab.
# Now you'll create a Distribution type logs based metric to extract the value of textPayload from the log entries textPayload.
# Select Navigation menu > Logging > Logs Explorer.
# Select the logs you want to see, in this case, you select the logs for the following values:
## Resource type: VM
# Click on All Resource.
# Select VM Instance in the Resource drop-down menu.
# Click Apply.
## Logname: apache-access
# Click on Log Names.
# Select apache-access in the Log Names drop-down menu.
# Click Apply.
## Text Payload: textPayload:"200" (add this to to the query)
# In Actions dropdown click Create metric.
# In the Create log-based metric form:
# Change the Metric Type to Distribution.
# In Log-based metric name enter the name what you want.
# Enter textPayload for Field name.
# Click Create metric.


# qwiklab versions
# copy the the querry
resource.type="gce_instance"
logName="projects/YOUR_PROJECT_ID/logs/apache-access"
textPayload:"200"

# Enter the following in the Regular Expression field:
execution took (\d+)