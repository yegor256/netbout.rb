# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'json'
require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../../lib/netbout'

# Test of Search.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestSearch < Minitest::Test
  def test_post_and_search
    stub_request(:get, %r{\Ahttps://www\.netbout\.com/search\?}).to_return(
      body: JSON.generate(Array.new(10) { |i| { id: i + 1 } }), headers: { 'Content-Type' => 'application/json' }
    )
    inbox = Netbout::Inbox.new('test')
    found = []
    inbox.search.each do |m|
      found << m
      break if found.size > 42
    end
    assert_operator(found.size, :>, 20)
  end
end
