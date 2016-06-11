#!/bin/sh

grep spec_helper_without_rails -Rl spec/* | xargs rspec