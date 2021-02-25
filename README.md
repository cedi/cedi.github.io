[![CI](https://github.com/cedi/cedi.dev/actions/workflows/main.yml/badge.svg)](https://github.com/cedi/cedi.dev/actions/workflows/main.yml)

# cedi.dev

This repository contains the [hugo](gohugo.io) configuration to generate my personal website [cedi.dev](cedi.dev).
[cedric-kienzler.de](cedric-kienzler.de) redirects to here as well.

## Building

Checkout this repository and run `hugo server -t toha -w` for development

## CI/CD

This Repository is build via a [github action](.github/workflows/main.yml) that renders the HTML code and then commits this to [cedi/cedi.github.io](https://github.com/cedi/cedi.github.io)
