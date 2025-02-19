# frozen_string_literal: true

#
# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../../lib/netbout'

# Test of Search.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class TestSearch < Minitest::Test
  def test_post_and_search
    inbox = Netbout::Inbox.new('test')
    found = []
    inbox.search.each do |m|
      found << m
      break if found.size > 42
    end
    assert(found.size > 20)
  end
end
