# Changelog
All notable changes to this project will be documented in this file

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2018-05-12
### Added
- New class for Present Value calculation (FinancialCalculator::PV)

### Removed
- Monkey patched cashflow methods on Array

### Changed
- Calculations for IRR
- IRR, XIRR, NPV, and XNPV now belong to their own classes

## [2.1.0]
### Added
- Code coverage and build status badges to README

### Removed

### Changed
- Gem name from finance to financial_calculator
- Replaced minitest with rspec