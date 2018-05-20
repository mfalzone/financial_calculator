# FINANCE
[![Build Status](https://travis-ci.org/mfalzone/financial_calculator.svg?branch=master)](https://travis-ci.org/mfalzone/financial_calculator)
[![Coverage Status](https://coveralls.io/repos/github/mfalzone/financial_calculator/badge.svg?branch=master)](https://coveralls.io/github/mfalzone/financial_calculator?branch=master)

A library for financial modelling in Ruby.

## INSTALL

    $ sudo gem install financial_calculator

## IMPORTANT CHANGES

This project started as a fork of the [finance](https://github.com/marksweston/finance) gem. The fork occured at version 2.0 of the finance library, and the first version of this gem is version 2.1. Version 2.1 is designed to be a drop in replacement for the finance gem, having only updated tests and documentation. However, starting with version 3.0, several significant changes have been made to the strucuture of the library as well as the underlying calculations.

Since there are many additional calculations that can be included in this gem, I am
working on developing a roadmap of which ones I will be adding and in what order. However,
I am always willing to accept well tested pull requests for new features.

## OVERVIEW

### GETTING STARTED

    >> require 'financial_calculator'

*Note:* The entire library is contained under the
FinancialCalculator namespace.  Existing code will not work unless you add:

    >> include FinancialCalculator

for all of the examples below, we'll assume that you have done this.

### AMORTIZATION

You are interested in borrowing $250,000 under a 30 year, fixed-rate
loan with a 4.25% APR.

    >> rate = Rate.new(0.0425, :apr, :duration => (30 * 12))
    >> amortization = Amortization.new(250000, rate)

Find the standard monthly payment:

    >> amortization.payment
    => DecNum('-1229.91')

Find the total cost of the loan:

    >> amortization.payments.sum
    => DecNum('-442766.55')

How much will you pay in interest?

    >> amortization.interest.sum
    => DecNum('192766.55')

How much interest in the first six months?

    >> amortization.interest[0,6].sum
    => DecNum('5294.62')

If your loan has an adjustable rate, no problem.  You can pass an
arbitrary number of rates, and they will be used in the amortization.
For example, we can look at an amortization of $250000, where the APR
starts at 4.25%, and increases by 1% every five years.

    >> values = %w{ 0.0425 0.0525 0.0625 0.0725 0.0825 0.0925 }
    >> rates = values.collect { |value| Rate.new( value, :apr, :duration => (5  * 12) }
    >> arm = Amortization.new(250000, *rates)

Since we are looking at an ARM, there is no longer a single "payment" value.

    >> arm.payment
    => nil

But we can look at the different payments over time.

    >> arm.payments.uniq
    => [DecNum('-1229.85'), DecNum('-1360.41'), DecNum('-1475.65'), DecNum('-1571.07'), ... snipped ... ]

The other methods previously discussed can be accessed in the same way:

    >> arm.interest.sum
    => DecNum('287515.45')
    >> arm.payments.sum
    => DecNum('-537515.45')

Last, but not least, you may pass a block when creating an Amortization
which returns a modified monthly payment.  For example, to increase your
payment by $150, do:

    >> rate = Rate.new(0.0425, :apr, :duration => (30 * 12))
    >> extra_payments = 250000.amortize(rate){ |period| period.payment - 150 }

Disregarding the block, we have used the same parameters as the first
example.  Notice the difference in the results:

    >> amortization.payments.sum
    => DecNum('-442745.98')
    >> extra_payments.payments.sum
    => DecNum('-400566.24')
    >> amortization.interest.sum
    => DecNum('192745.98')
    >> extra_payments.interest.sum
    => DecNum('150566.24')

You can also increase your payment to a specific amount:

    >> extra_payments_2 = 250000.amortize(rate){ -1500 }

## SUPPORTED STANDARD CALCUALTIONS
- IRR
- NPV
- PMT
- PV
- XIRR
- XNPV

## FEATURES

Currently implemented features include:

* Uses the [flt](http://flt.rubyforge.org/) library to ensure precision decimal arithmetic in all calculations.
* Fixed-rate mortgage amortization (30/360).
* Interest rates
* Various cash flow computations, such as NPV and IRR.
* Adjustable rate mortgage amortization.
* Payment modifications (i.e., how does paying an additional $75 per month affect the amortization?)

## RESOURCES

* [RubyGems Page](https://rubygems.org/gems/financial_calculator)
* [Source Code](http://github.com/mfalzone/financial_calculator)
* [Bug Tracker](https://github.com/mfalzone/financial_calculator/issues)

## COPYRIGHT

This library is released under the terms of the LGPL license.

Copyright (c) 2018, Mike Falzone.
Copyright (c) 2011, William Kranec.
All rights reserved.

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
