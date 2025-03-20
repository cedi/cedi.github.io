+++
# Experience widget.
widget = "experience"  # See https://sourcethemes.com/academic/docs/page-builder/
headless = true  # This file represents a page section.
active = true  # Activate this widget? true/false
#weight = 40  # Order that this section will appear.
weight = 85

title = "Experience"
subtitle = "PREVIOUS ASSOCIATIONS THAT HELPED TO GATHER EXPERIENCE"

# Date format for experience
#   Refer to https://sourcethemes.com/academic/docs/customization/#date-format
date_format = "Jan 2006"

# Experiences.
#   Add/remove as many `[[experience]]` blocks below as you like.
#   Required fields are `title`, `company`, and `date_start`.
#   Leave `date_end` empty if it's your current employer.
#   Begin/end multi-line descriptions with 3 quotes `"""`.
[[experience]]
  title = "Technical Lead Site Reliability Engineer (L64) / Azure Platform SRE"
  company = "Microsoft"
  company_url = "https://microsoft.com"
  location = "Hamburg, Germany (Remote)"
  date_start = "2022-02-01"
  date_end = ""
  description = """
  Technical Lead in Azure’s Safe Change infrastructure SRE Team, responsible for chaos engineering, resiliency validation, and release infrastructure Harmonisation: Led the modernisation of Azure's release infrastructure, migrating 60+ repositories and 600+ pipelines, increasing deployment reliability and speed across multiple critical customer-facing services including, among others, Azure Cosmos DB, Log Analytics, Web Apps & Function Apps.

  * __Platform Engineering & DevOps Expertise:__ Developed platform tooling improvements to streamline engineering workflows and improve developer experience and led shift-left initiatives, integrating early validation mechanisms to catch issues earlier in the development lifecycle.
  * __Chaos Engineering & Resilience Validation:__ Designed and implemented Chaos Engineering experiments to validate system failure hypotheses covering 80% of high-impact critical customer scenarios and improve resilience strategies and built synthetic monitoring and business validation testing to proactively identify and mitigate reliability risks.
  * __Organised multiple internal learning sessions__, developing a 9-part self-guided onboarding tutorial as part of the SRE Academy, enabling new engineers to onboard 75% faster to the new release system.
  * __Leadership and Team Management:__ Technical lead & Scrum Master for my immediate team of 5 engineers, responsible for setting technical direction, mentoring, and defining strategies and goals for the team as well as the broader department, serving as the technical lead for a newly formed team within the Safe Change Infrastructure SRE organisation, and supporting to multiple program managers and teams from across three other SRE organisations in bootstrapping new SRE engagements.
  * __Cross-Org Collaboration and Stakeholder Engagement:__ Partnered with 10+ service teams across Azure to help them migrate to the new release system, contributing high-quality pull requests to their repositories as best-practice examples driving down change related outages by 20%.
  * __SRE Best Practices an Knowledge Sharing:__ Core Contributor & Committee Member for the Azure SRE Playbook, authoring a new SRE pattern with 3 sub-patterns and overseeing the review and integration of 3 additional major patterns.
  * __Technical Evangelism & Internal Training:__ Speaker at Azure SRE Tech Talks, delivering sessions on reliability, deployment strategies, and platform engineering.
  * __Maintained and expanded the Azure SRE Wiki__, working across all SRE organisations to standardise and document operational excellence.
  * __Recognition & Awards:__ Azure Reliability Quality Star – Leadership Excellence Award for sustained highquality contributions to Azure’s engineering culture and reliability improvements.
  """

[[experience]]
  title = "Tech Lead & Manager - SRE, Managed Kubernetes"
  company = "German Edge Cloud"
  company_url = "https://gec.io"
  location = "Hamburg, Germany (Remote)"
  date_start = "2020-07-15"
  date_end = "2022-01-31"
  description = """
  Built and led the Kubernetes SRE Team: Established and scaled a remote team from two to 6 highly skilled SREs, taking full ownership of the company’s Managed Kubernetes Platform, spread across 3 availability zones and hosting 50+ customer clusters. Ensured only high-quality changes made it into production by reviewing code, design documents, and architecture changes daily, implementing state of the art GitOps tooling and observability, resulting in a 75% reduction in change related outages over 12 months.

  * __Incident & Change Management:__ Developed and implemented new incident, change, and problem management processes, improving reliability and operational efficiency, enabling an average 10 minute time-to-engage and reducing time-to-mitigation by several hours on average through more streamlined and efficient incident management processes and standard operating procedures.
  * __Cross-Functional Collaboration:__ Worked closely with the Service Management team to improve incident response, change reviews, and operational excellence as well as the Infrastructure, OpenStack, and CEPH Storage teams, ensuring seamless integration and optimised performance across compute, storage, and networking layers resulting in 10% increased storage throughput and decrease in etcd commit latencies driving customer satisfaction.
  * __Platform & Product Leadership:__ Took on the Product and Platform Owner role, shielding the team from unnecessary business complexity while aligning priorities with company strategy and CTO directives.
  * __Financial Oversight & Cost Optimisation:__ Managed the budget for the Managed Kubernetes Service, including forecasting infrastructure costs and collaborating with accounting on financial planning.
  * __Sales & Pricing Strategy:__ Worked with Sales and Finance leadership to define a competitive pricing structure for the Kubernetes offering.
  * __Cloud-Native & Open Source Advocacy:__ Fostered a culture of open-source collaboration, contributing improvements back to the cloud-native community and positioning the company’s offerings within CNCF certification programs.
  """

[[experience]]
  title = "Site Reliability Engineer 2 (L61), SharePoint Online"
  company = "Microsoft"
  company_url = "https://microsoft.com"
  location = "Dublin, Ireland"
  date_start = "2019-01-01"
  date_end = "2020-03-31"
  description = """
  Running Live-Site operations for one of the largest M365 services with over 200 million monthly active users and over 1 exabyte of data, including incident response and management, rapidly diagnosing and resolving critical issues to maintain SharePoint Online’s 99,99% SLA.

  * __Disaster Recovery & Infrastructure Modernisation:__ Led an initiative to improve disaster recovery playbooks using a more resilient storage solution, ensuring recovery procedures remained accessible even during blackout scenarios.
  * __Onboarding & Global Expansion:__ Played a key role in onboarding and training a new SRE team in China, enabling 24/7 follow-the-sun operations.
  * __Community & Knowledge Sharing:__ Organised meet-ups for Microsoft Ireland’s Open Source Club
  """

[[experience]]
  title = "Software Engineer, Network Security (VPN & Authentication)"
  company = "Sophos"
  company_url = "https://sophos.com"
  location = "Karlsruhe, Germany"
  date_start = "2017-01-01"
  date_end = "2018-12-31"
  description = """
  * __Network Security & Threat Detection:__ Worked on the Synchronised Security Engine, significantly
improving network threat detection rates compared to competing vendors.
  * __IPSec & Network Protocol Implementation:__ Worked on the implementation of IPsec IKEv2 in the Linux
Kernel for the Firewall Appliance
  * __Scalability & Load Testing:__ Implemented extensive firewall load testing using the Ixia BreakingPoint
platform, ensuring performance under high traffic loads. Developed custom load-testing frameworks with
Python Mininet SDN, simulating concurrent user traffic.
  * __Testing & Release Acceleration:__ Expanded the integration test suite for firewall products, leading to faster
and more reliable release cycles.
  """
  
[[experience]]
  title = "Software Engineer"
  company = "MARKANT Handels- und Service GmbH"
  company_url = "https://markant.de"
  location = "Offenburg, Germany"
  date_start = "2015-08-01"
  date_end = "2016-12-31"
  description = """
  * __Infrastructure Modernisation:__ Led a department-wide initiative migrating from CVS to Git, upgrading IDE versions, and implementing a CI/CD pipeline for improved development workflows, increasing deployment velocity from once a week to multiple times a day.
  * __Operational Support Tooling:__ Built custom tools to assist operations teams, enhancing incident response times in highly time-sensitive trading systems.
  * __Mentorship & Training:__ Trained apprentices and junior engineers in software architecture, clean code principles, and design patterns.
  """

[[experience]]
  title = "Junior Software Engineer - Apprenticeship"
  company = "Streit Datentechnik"
  company_url = "https://streit-datec.de"
  location = "Hasslach im Kinzigtal, Germany"
  date_start = "2012-08-01"
  date_end = "2015-07-31"
  description = """
  * __Software Development:__ Learned MS Visual C++, C# .NET, MS T-SQL, MFC, and the Win32 API, broadening problem-solving capabilities across multiple technologies.
  * __Reverse Engineering & Analysis:__ Developed a disassembler to read dependencies from Windows-PE and C# executables for debugging and system analysis.
  """

+++
