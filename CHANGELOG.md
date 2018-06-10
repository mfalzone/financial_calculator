# Changelog
All notable changes to this project will be documented in this file

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.2.0] - 2018-06-09
### Added
- New class for FV, IPMT and PPMT calculations

### Removed

### Changed

## [3.1.0] - 2018-05-20
### Added
- New class for PMT calculation (FinancialCalculator::Pmt)

### Removed

### Changed

## [3.0.0] - 2018-05-12
### Added
- New class for Present Value calculation (FinancialCalculator::Pv)

### Removed
- Monkey patched cashflow methods on Array
- Fork relationship with Ruby [finance](https://github.com/marksweston/finance) gem

### Changed
- Calculations for IRR
- IRR, XIRR, NPV, and XNPV now belong to their own classes
- Method for calculating IRR. The finance gem used Newton's method, this gem now uses the Secant method.
- Significant changes now captured in README.md instead of HISTORY

## [2.1.0]
### Added
- Code coverage and build status badges to README

### Removed

### Changed
- Gem name from finance to financial_calculator
- Replaced minitest with rspec