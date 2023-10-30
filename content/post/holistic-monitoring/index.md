---
title: 'Holistic Monitoring'
subtitle: 'From metric to alert. Let’s examine scalable monitoring and alerting systems'
summary: 'In this blog post we are going to look at how you can improve the monitoring of your service by incorporating principles of resiliency engineering and defining customer centric SLOs'
authors:
- cedi
tags:
- monitoring
- resiliency engineering
- reliability
- talk
- slo
- alerting
categories:
- SRE
date: "2022-04-18T00:00:00Z"
lastmod: "2022-04-18T00:00:00Z"
featured: true
draft: true
merge_request: https://github.com/cedi/cedi.github.io/pull/13

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

# Set captions for image gallery.
gallery_item: []
---

## Introduction

Welcome back to my blog!

I hope you'll find this article helpful! If you do - please consider sharing it to your co-workers and friends! I think it is important that everyone working in IT knows at least a little bit about monitoring and alerting. From Developers to Operators, form Data Scientists to Program Managers.

## Why do we need to monitor our systems?

For everyone with a background in running production infrastructure, this should be a straight forward answer. For every developer who had to debug production issues, this seems to be pretty basic too.
And I would argue, even for program managers who aren't deeply technical this appears to be a basic question - they wanna know if something goes wrong and why, so they can make sure it never happens again

But is it really this simple?

I would like to introduce you to the "above-the-line/below-the-line" Framework[^1] as described in the [STELLA report][1].

[^1]: Woods DD. STELLA: Report from the SNAFUcatchers Workshop on Coping With Complexity. Columbus, OH: The Ohio State University, 2017.

It is impossible for me to do justice to the concept of the above-the-line/below-the-line framework in this brief paragraph. So please go over to the [SNAFUCatchers][1] website and read for yourself if you want to read it in more details

I'm building my argumentation of "why do we need to monitor our systems" on this framework.

### Monitoring and the above-the-line / below-the-line framework

When we speak about monitoring, monitoring is just another representation layer of our system.
If the monitoring system is carefully built it gives us real-time information about the current state of our system.

Alerting is just another, logical, extension to this. We alert when the system behaves differently compared to what our mental model anticipated the system to do.

## The confusing wold of Metrics, Timeseries, Monitors, SLIs, SLOs, and SLAs

You probably heard the terms "metric", "monitor", "service level indicator" (SLI), and "service level objective" (SLO) before.
But what do they actually mean?

### Metric

The first term you come across in all monitoring systems is going to be a metric.
The definition of a metric is rather simple:

> Monitoring metrics are collections of numeric data inputs organized in groups of consecutive, chronologically ordered lists
>
> -- <cite>Slawek Ligus. (2012). Effective Monitoring and Alerting. O’Reilly.</cite>

Rephrased a little: Metrics are the data points measured, grouped together in consecutively, chronological ordered lists.
Metrics are usually stored in time-series databases.

A collection of metrics are called a Timeseries.

### Timeseries

A Timeseries is a two-dimensional data representation, consisting of metrics as the y-axis and the exact point in time where the measurement was taken in the x-axis.

Any two timeseries always share a common axis - time.

This way you can plot to independent timeseries next to each other, allowing to view correlative relationships between metrics from many sources.

### Monitor

Monitors are the heart of almost all alerts.
A monitor is a condition attached to a timeseries. The monitor evaluates the metrics on a timeseries against a predefined threshold. 

When the monitor breaches the condition, the monitor will cause an alert to fire.

#### Alert

As mentioned above, an alert is the result of a monitor.
An alert must always include at least:

* The Metric
* The Threshold
* The Timeseries in which the threshold for the metric was breached

### Service Level Indicator

A Service Level Indicator (SLI) is a carefully defined quantitative measure of some aspect of the level of service that is provided. [^2]

[^2]: [Murphy, N. R., Beyer, B., Jones, C., & Petoff, J. (2016). Site Reliability Engineering. Van Duuren Media.][2]

An SLI is comparable to a Metric / Timeseries, but be measured as a percentage.
This percentage should be a representation of what a customer would be experiencing. The higher the percentage, the better.
100% would mean "everything works all the time" while 0% would mean "nothing works at all".

Common SLIs are

* Latency
* Availability
* Error rate

### Service Level Objective

Service Level Objectives (SLOs) are to SLIs what monitors are to metrics.
An SLO is a target range for SLIs.

The famous Site Reliability Engineering Book describes SLOs as `SLI <= target`, or `lower bound <= SLI <= upper bound`[^2].

### Service Level Agreements

Something I've noticed in the past is that Service Level Agreements (SLAs) are often confused with SLOs.
A SLA is a contract with a customer, while the SLO is a internal guarantee.

Account Managers and other representatives of a company often speak about "SLA breaches" when they mean "SLO breaches".

Someone once told me

> The distinction between a SLO and SLA breach is simple - If you breach your SLO it sucks and you have to apologize to your customer(s). If you breach your SLA you see your customer in court because they sue you to get their money back"
>
> -- Unknown, but wise, acquaintance

And I couldn't summarize it any better.

As an example I'll use the latency of an service:

The __SLI__ would be "Latency until image loaded"
The __SLO__ would be "90th percentile latency until image loaded must never be slower than 1s"
The __SLA__ would be "If the 90th percentile latency until image loaded is slower than 1s we have to pay $1000 for each minute we breached our commitment"

But there is one catch: You can have different levels of SLOs - internal SLOs and external SLOs. Internal SLOs are usually much stricter and guarantee a higher level of reliability than the externally published SLO which is used to write the SLA contract.

For example you could write an internal SLO (to which you hold yourself accountable for) "We guarantee 5x9s of reliability", while the externally published SLO (to which you will be held accountable for by customers) reads "We guarantee 4x9s of reliability".

## Writing service-centric vs. customer-centric SLOs