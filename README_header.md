# CloudScaleAnalytics v2 - Data Management Zone

This project revisits the Cloud Scale Analytics data platform reference architecture for Microsoft Azure. While the core principles of the architecture design have not changed, the next generation of the design will and enhance and introduce many new capabilities that will simplify the overall management, onboarding and significantly reduce the time to market.

Over the last couple of years, numerous data platforms have been built on the basis of Cloud Scale Analytics which resulted in a ton of learnings and insights. In addition to that, new services and features have been introduced, reached a GA status and common requirements have drifted. All these data points have been used to build this next iteration of the reference architecture for scalable data platforms on Azure.

The Cloud Scale Analytics reference architecture consists of the following core building blocks:

1. The *Data Management Zone* is the core data governance entity of on organization. In this Azure subscription, an organization places all data management solution including their data catalog, the data lineage solution, the master data management tool and other data governance capabilities. Placing these tools inside a single subscription ensures a resusable data management framework that can be applied to all *Data Landing Zones* and other data sources across an organization.

2. The *Data Landing Zone* is used for data retention and processing. A *Data Landing Zone* maps to a single Azure Subscription, but organizations are encouraged to have multiple of these for scaling purposes. Within a *Data Landing Zone* an orgnaization may implement one or multiple data applications.

3. A *Data Application* environment is a bounded context within a *Data Landing Zone*. A *Data Application* is concerned with consuming, processing and producing data as an output. These outputs should no longer be treated as byproducts but rather be managed as a full product that has a defined service-level-agreement.

![Cloud-scale Analytics v2](https://raw.githubusercontent.com/PerfectThymeTech/terraform-azurerm-data-management-zone/main/docs/media/CloudScaleAnalyticsv2.gif)

## Architecture

The following architecture will be deployed by this module, whereby the module expects that the Vnet, Route Table and NSG already exists within the Azure Landing Zone:

![Data Management Zone Architecture](https://raw.githubusercontent.com/PerfectThymeTech/terraform-azurerm-data-management-zone/main/docs/media/DataManagementZoneArchitecture.png)

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create your Azure free account today](https://azure.microsoft.com/free/).
- (1) [Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor) and [User Access Administrator](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) or (2) [Owner](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#owner) access to the subscription to be able to create resources and role assignments.
- A [GitHub self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners) or an [Azure DevOps self-hosted agent](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops) to be able to access the data-plane of services.
