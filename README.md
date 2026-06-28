# Hub-and-Spoke Network — Portfolio Project

## Overview
A production-style hub-and-spoke network topology deployed on Azure using Terraform. 
The architecture centralises network security through Azure Firewall, with spoke VNets 
for isolated prod and dev environments. All inter-spoke traffic routes through the hub firewall.

## Architecture
(images/architecture-diagram.png)

## Architecture Decisions
**Why hub-and-spoke over a flat VNet?**
A flat VNet gives no traffic isolation between workloads. Hub-and-spoke lets you centralise 
security controls (firewall, DNS, monitoring) in the hub while keeping prod and dev environments 
isolated in separate spokes. This mirrors how enterprises like banks and insurers structure 
Azure at scale.

**Why Azure Firewall over NSGs alone?**
NSGs operate at Layer 4 (IP/port). Azure Firewall adds Layer 7 inspection, FQDN filtering, 
and centralised logging — you can allow `*.ubuntu.com` outbound without opening port 80 to 
the entire internet.


## Stack
- **Cloud:** Microsoft Azure
- **IaC:** Terraform (AzureRM provider v4.78.0)
- **Networking:** Azure VNet, VNet Peering, Azure Firewall, NSGs, Route Tables
- **Monitoring:** Azure Monitor, Log Analytics, KQL
- **CI/CD:** GitHub

## Project Structure
azure-project-1-hub-spoke-network/
README.md
images/
	- architecture-diagram.png
	- afw-hub-dev running.png
	- Hop IP matches FW private IP.png
	- nsg-deny-rule-priority-200.png
	- nsg-deny-rule-priority-4000.png
	- nsg-network-watcher-unreachable.png
	- Three VNets.png
	- Query 1 — All firewall logs in the last hour.png
	- Query 2 — Count of firewall actions by operation.png
	- Query 3- VM CPU metrics.png
terraform/
	- main.tf
	- variables.tf
	- outputs.tf
	- providers.tf
	- backend.tf
	- modules/
		- hub_vnet/
		- spoke_vnet/
		- peering/
		- nsg/
		- route_table/
		- firewall/
		- vm_test/
		- monitoring/

## How to Deploy
### Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Terraform >= 1.6.0
- Azure subscription with contributor access

### Bootstrap Terraform State Backend
```bash
az group create --name rg-tfstate --location "South Africa North"
az storage account create --name tfstatehubspoke001 --resource-group rg-tfstate --sku Standard_LRS
az storage container create --name tfstate --account-name tfstatehubspoke001
```

### Deploy Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Tear Down
```bash
terraform destroy
```

## Key Builds by Phase
| Phase | What I Built |
|-------|-------------|
| 1 | Hub VNet with firewall, gateway, and management subnets |
| 2 | Spoke VNets (prod/dev) with VNet peering to hub |
| 3 | NSGs with break-fix testing via Network Watcher |
| 4 | Azure Firewall with network and application rule collections |
| 5 | Log Analytics workspace, diagnostic settings, KQL queries |
| 6 | README, architecture diagram, portfolio polish |

## NSG Testing
Intentionally misconfigured the Deny-All-Inbound rule to override allow rules, 
confirmed blocked connectivity via Network Watcher, then restored correct rule priority.

## KQL Queries
Queries written against the Log Analytics workspace:

**All firewall logs in the last hour:**
```kql
AzureDiagnostics
| where TimeGenerated > ago(1h)
| where ResourceType == "AZUREFIREWALLS"
| project TimeGenerated, OperationName, msg_s
| order by TimeGenerated desc
```

**Firewall actions by operation type:**
```kql
AzureDiagnostics
| where ResourceType == "AZUREFIREWALLS"
| summarize Count = count() by OperationName
| order by Count desc