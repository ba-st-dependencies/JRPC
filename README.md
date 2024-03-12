# JRPC

A fork of [JRPC](https://github.com/juliendelplanque/JRPC) to be used as a dependency in [ba-st](https://github.com/ba-st) for GS/64 & Pharo.

The `upstream` branch is supposed to track the changes in the `master` branch of [juliendelplanque/JRPC](https://github.com/juliendelplanque/JRPC)

The `release-candidate` is the branch where our changes land before releasing a version.

[![Unit Tests](https://github.com/ba-st-dependencies/JRPC/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/ba-st-dependencies/JRPC/actions/workflows/unit-tests.yml)
[![GS64 - Unit Tests](https://github.com/ba-st-dependencies/JRPC/actions/workflows/unit-tests-gs64.yml/badge.svg)](https://github.com/ba-st-dependencies/JRPC/actions/workflows/unit-tests-gs64.yml)
[![Coverage Status](https://codecov.io/github/ba-st-dependencies/JRPC/coverage.svg?branch=release-candidate)](https://codecov.io/gh/ba-st-dependencies/JRPC/branch/release-candidate)

[![Baseline Groups](https://github.com/ba-st-dependencies/JRPC/actions/workflows/loading-groups.yml/badge.svg)](https://github.com/ba-st-dependencies/JRPC/actions/workflows/loading-groups.yml)
[![GS64 Components](https://github.com/ba-st-dependencies/JRPC/actions/workflows/loading-gs64-components.yml/badge.svg)](https://github.com/ba-st-dependencies/JRPC/actions/workflows/loading-gs64-components.yml)


[![GitHub release](https://img.shields.io/github/release/ba-st-dependencies/Teapot.svg)](https://github.com/ba-st-dependencies/Teapot/releases/latest)
[![Pharo 9.0](https://img.shields.io/badge/Pharo-9.0-informational)](https://pharo.org)
[![Pharo 10](https://img.shields.io/badge/Pharo-10-informational)](https://pharo.org)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-informational)](https://pharo.org)

[![GS64 3.7.0](https://img.shields.io/badge/GS64-3.7.0-informational)](https://gemtalksystems.com/products/gs64/)

Yet another [JSON-RPC 2.0](https://www.jsonrpc.org/specification) implementation
for [Pharo Smalltalk](https://www.pharo.org)

- [Features](#features)
- [Installation](#installation)
- [Examples](#examples)
- [Comparison with other JSON RPC implementations](#jrpc-vs-others)
- [Contributing](#contributing)

## Features

- Client and Server support for JSON-RPC 2.0.
- Uses `STONJSON` to parse JSON internally.
- Transport agnostic (like JSON-RPC 2.0 spec claims).
- Can currently be used over
  - HTTP
  - TCP (only on Pharo)
- It is easy to add other transport layers.
- Additional `data` when an error occurred in the `error` object.

## Examples

Explore the [documentation](docs/Examples.md)

## Installation

To load the project in a Pharo image or declare it as a dependency of your project follow these [instructions](docs/Installation.md).

## Comparison with other JSON RPC implementations

| Property     | JRPC               | LtJsonRpc          | NeoJSONRPC         |
|--------------|--------------------|--------------------|--------------------|
| Server       | :white_check_mark: | :white_check_mark: | :x:                |
| Client       | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| JSON backend | STONJSON           | Json               | NeoJSON            |
| Tests        | :white_check_mark: | :x:                | :x:                |

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)
