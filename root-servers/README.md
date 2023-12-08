# Hetzner Root Servers
With this playbook we are going to install and configure the Hetzner Root Servers of the type EX-42-NVMe. These are going to be our worker nodes in the Kubernetes cluster.

This configuration is going to format one drive to the OS, and the other for Rook. This is done to make sure we have enough space for the Kubernetes cluster, and the Rook cluster. Alter the configuration if you want to use the drives differently.

## 🚀 Getting started

### Step 1: Rescue mode
The first step is to set the new machine in rescue mode. This is done by logging into the Hetzner Robot and selecting the server. Then go to the "Rescue" tab and select "Rescue system". Then you go to "Reset" and select "Hardware reset". This will reboot the server into rescue mode.

## Step 2: add to vSwitch
1. Log into the Hetzner Robot and select the server.
2. Go to the "Servers" page.
3. Click the "vSwitches" page
4. Select Your Switch.
5. Search for the new server in the "Add servers to vSwitch" section.
6. Click "Add server to vSwitch".

## Step 3: Update the configuration 
Make sure to update the `./host_vars` and `./inventory.yaml`. Make sure to change the filename in `./host_vars` to mach the name of the host in `./inventory.yaml`.

## Step 4: Install OS and configure
> This playbook is only going to run if the machine is set to rescue mode. This is to make sure we don't accidentally run it on a machine that is in production doing labour.

Run the following command:
`ansible-playbook -i inventory.yaml playbook.yaml --vault-password-file <master-key> --limit <server-name>`

> It's a good idea to do one server at the time just so you have a good overview and can catch potential issues easier. It's really important that everything goes as planned.

## Step 5: Validate the configuration
Log into the new server(s) that you added, and check out the following:

### Check the drives
Run: `lsblk -f`

Make sure one disk is formated for the OS, and the other is clean and not mounted.

## Troubbleshooting

### Networking issues:
- [Instructions for an error report with Hetzner network problems](https://docs.hetzner.com/robot/dedicated-server/troubleshooting/network-diagnosis-and-report-to-hetzner/)