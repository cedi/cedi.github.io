---
title: 'Breaking Clouds'
subtitle: 'When the virtual sky falls'
summary: 'Cloud infrastructure is a necessity in our modern digital world. However, understanding and preparing for failures in cloud infrastructure is critical for reliability of our services. Failures can be viewed as learning opportunities and to improve our system design. It can inform proactive problem-solving, fostering effective incident response, and guiding future design challenges. Chaos Engineering plays a vital role in testing for resilience of our system.'
authors:
- cedi
tags:
- resiliency
- reliability
- chaos
- failure
- incident-response
categories:
- SRE
date: "2023-08-01T00:00:00Z"
lastmod: "2022-08-01T00:00:00Z"
featured: true
draft: true
merge_request: https://github.com/cedi/cedi.github.io/pull/16

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal point options: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight
image:
  caption: 
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

Cloud infrastructure is a necessity in our modern digital world. However, understanding and preparing for failures in cloud infrastructure is critical for reliability of our services. Failures can be viewed as learning opportunities and to improve our system design. It can inform proactive problem-solving, fostering effective incident response, and guiding future design challenges. Chaos Engineering plays a vital role in testing for resilience of our system.

## The cloud as our new reality

Cloud Infrastructure has become an integral part of our modern digital landscape. It’s the foundation that supports a majority of the digital services used by millions of people every day. From social media platforms to online video conferencing enabling hybrid work. Even sectors like healthcare or education, cloud infrastructure plays a vital role these days.
Due to the cost-effectiveness and easy accessibility it has become easier and easier building more and more complex systems with ease and minimal knowledge required. Where once tens of infrastructure engineers maintained dozens of servers in a rack, nowadays any single developer can spin up vast infrastructure landscapes with intricate dependencies on public cloud-providers such as Azure or GCP. 

However this comes with the expectation of reliability and resilience. In this context, reliability means that cloud services should be available and function correctly when users need them. Resilience means that these services can quickly recover from any disruption or failure.
Given our modern reality, a significant part of our everyday lives is now “in the cloud”. We rely on it through our entire live.
From communication both private and professional, the digital workplace, as well as entertainment, and even  critical services such as healthcare set the expectations high when it comes to reliability and resilience. 

This is why understanding and preparing for potential failures in cloud infrastructure is so critical.

## Exploring failures

Failure modes, or commonly just called failures, describe the various ways in which a system, or service might fail. 
Failure modes are as diverse as the landscape of modern cloud infrastructure. They can range from Hardware to Software to Network and even Human Failure. 
I think Hardware, Software, and Network failures are quite self explanatory: These involve the failure of hardware, like servers, routers, or storage devices, or bugs and glitches in the software that cause system malfunctions. Network errors can be both: your Switch might break or a the implementation for the forwarding plane on your switch might glitch in certain conditions. But the effect is always the same: Users seeing errors, dropped connections, degraded system performance or intermittent problems of all sorts.
But what to me the most interesting group of failures is are failures involving the human factor. They are what happens when humans somewhere in the system make a mistake. Human factors are responsible for an entire new spectrum of failure modes. From unplugging the wrong cable in the data center to configuring something that does not work, or even executing the wrong command on the wrong machine accidentally deleting the entire production database (Looking at you [GitLab](TODO: Link to GitLab Outage)).

By considering how individual components might fail we can develop a better design that resilient to those failures.
We can use the [Above the line/Below the line framework](TODO) to better understand the relationship between what the system actually is and how we think of it. We can remember that incidents inform us how the system actually behaves and how our assumptions about it where wrong. And gauging this delta enables us to take proactive measures to prevent such failures in the future, or at least make them less likely. If you are a software developer, this is why you do Pull Request reviews and don’t just push your code directly to production. If you are a systems engineer working with configuration and are unfamiliar with pull request workflows: This is your sign to store your configuration in Git and leverage the advantages of pull request reviews.
Additionally when we have an understanding of how a system might fail, we can take better informed decisions and have streamlined incident response processes in place help speeding up recovery. It enables engineers to more quickly diagnose and address the root cause of an incident with less friction. 

## Failures as Learning Opportunities 

While system failure is often viewed as a negative, it’s time to challenge this perspective. Instead we should consider these disruptions as an opportunity to improve our own mental model about how the system works (see [Above the line/Below the line Framework](TODO: Link to above the line framework)) and inform our decisions going forward helping us to improve our infrastructure. Each failure, in it’s own unique way, can help us building a better version of our service. In the following section I want to present you with a few ways you can learn from failure.

### Unveil hidden weaknesses

As we have learned from the [Above the line/Below the line Framework](TODO: Link), failures are what happens when the system behaves differently than we think it will behave. So each incident gauges the delta of our understanding. When our mental model of the system behavior gets better, we can eventually find bugs or procedural and structural failures in our code. This allows us to make the improvements needed to arrive at a more resilient system.

### Put your resilience to the test

Each failure can be seen as an unscheduled drill for your system’s resilience mechanisms. Moments of crisis battle-test your redundancies, failover strategies, and even disaster recovery protocols. Chaos Experimentation is certainly the better approach to build confidence in your resilience mechanisms, but sometimes it takes a real incident to see how well every safeguard and every redundancy measure works hand-in-hand together with each other.

### Sharpen your Incident Response

Failures are the real-world stage on which your carefully crafted play of incident response procedures are executed. You can reason about incident response processes as much as you want but there is nothing that tests the effectiveness of communication protocols and channels as well as the teams collaboration and agility in identifying mitigating and the root-cause than a real incident when real money and real customer demand is on the line. Tabletop exercises of incident drills are a good way to validate some of you processes, but the critically and fire during a real production outage is the ultimate test. Each stumble and misstep during the incident response procedure is a chance to fine-tune your approach, ultimately minimizing the fallout and TTM metric (explanation of TTM, or at least a link to an explanation) of future incidents.

### Guiding future design

The wisdom derived from actual failures not only bolsters existing systems but also informs the design of future systems. Understanding the triggers of past failures equips engineers to preemptively design systems that sidesteps these pitfalls, inherently making them more robust and reliable.

## Strategies and techniques for dealing with failures

As mentioned many times throughout this article, incidents, while they are undesirable, are an integral part of our cloud infrastructure. They test our resilience to failure, challenge our readiness to respond, and drive us towards an ever-evolving state of improvement.
I wanna dive into a couple of topics showcasing how we can effectively respond to, recover from, and learn from incidents.

### Incident Response processes

Once our infrastructure begins to fail it calls for an swift and structured response.
Effective incident response requires three major pillars:

1. Fast Detection
2. Rapid Mitigation
3. Clear lines of communication

To allow for a fast detection we require solid monitoring of our infrastructure and proper instrumentation of our application. 
Once we discovered that something went wrong we have to focus on mitigating the issue. Clear lines of communication tremendously help in coordinating remediation measures across teams and dependent services.

Incident Management is a highly complex topic in it’s own and deserves it’s own blog-post in the future. Stay tuned.

### Effective Recovery

Recovering effectively again is a delicate topic and requires in-depth knowledge about the type of service and the specific infrastructure. There is no “one-size-fits-all” solution to improve recovery time (often referred to “TTM” or “Time to mitigate).
However, one key concept that we can talk about here is “graceful degradation”. When designing complex distributed systems, we can design our system in a way, that even in the event of a failure of one sub-component or micro-serve, the system maintains functionality with reduced capacity or functionality and prevent a total system collapse. Designing a complex system for graceful degradation can significantly limit the blast-radius of an incident.
However, you might have guessed it already: graceful degradation is a complex process in it’s own and there are entire book written about designing distributed systems and handling failures.

### Post-Incident Analysis

Once the issue is under control and the incident is mitigated, we can get the post-incident analysis process started.
The post-mortem process is where we can take time to reflect and learn from the failure and implement measures to prevent similar failures in the future.

During the post-mortem analysis we try to understand the exact cause and progression of the incident. However we should refrain from finding a scapegoat. Post-mortem processes must be blameless to be effective.
Every aspect of an incident, from it’s start to finish must be evaluated in great detail. This through examination provides insights into our system, the exact failure mode that occurred, it can give us some insights into how this failure mode can be prevented in the future and last but not least it highlights opportunities for improving the incident management process.

#### The power of blameless postmortem culture

A blameless postmortem, as the term suggests, is one where to focus is not on pointing fingers who did something wrong but to identify the conditions that led to the incident. In such an environment, team members feel free to provide honest insights without the fear of retribution. It is important that the human error is not the root-cause of a failure, but the result of systemic deficiencies.

While the concept of blameless postmortem culture is gaining industry-wide recognition, another vital element of a healthy postmortem process is sanctionlessness. Sanctionless postmortems not only refrains from attributing blame but also from negative repercussions for those involved in the incident. It acknowledges that while humans make errors, these errors are merely symptoms of a systemic weakness.

To explain this, let’s consider an incident caused by a junior engineer wo deployed faulty code. In a blameless postmortem we would focus on understanding how the code made it through the review and was not caught in our QA processes and was allowed to progress through our release gates. Rather than blaming the junior engineer for pushing bad code we recognize the gaps in the code review process and the need for better testing procedures.
However, let’s assume following this postmortem management enforces new checklists demanding more rigorous testing protocols and stricter gating of releases. Everyone wanting to deploy must comply with this vast list of action items ensuring the release is acceptable.
In this case, despite the postmortem being blameless, it wasn’t sanction-less. The negative consequences are now having to comply with overly long and dreadful checklists fostering a fear-driven culture, inhibiting honest communication since no-one wants to follow even tighter protocols.
Conversely, a truly sanction-less postmortem would dig deeper in why the already existing QA processes did not detect the issue earlier and would have allowed to gate this release. Maybe we would have found out that deadlines were too tight and engineers overworked and could not spend enough time on quality assurance. We could have identified that promises were made towards customers in regards to the availability of the feature creating the time-pressure. This finding would allow us to re-think the communication strategy for new features to customers or the way we prioritize our feature backlog.

## Conclusion

Building a resilient service involves accepting and navigating through the unpredictability of cloud infrastructure, recognizing failures as stepping stones to improve and even to utilize approaches such as chaos engineering to build confidence in your resiliency.
As we continue to operate our service, each failure should be viewed as an opportunity for learning and enhancing our systems. Thus, ensuring the resilience of our digital reality is not merely about combating unpredictability, but harnessing it to create stronger and more reliable services.