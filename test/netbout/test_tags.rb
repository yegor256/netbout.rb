# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'json'
require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../../lib/netbout'

# Test of Tags.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestTags < Minitest::Test
  def test_put_and_list
    stub_request(:post, 'https://www.netbout.com/start').to_return(status: 302, headers: { 'X-Netbout-Bout' => '42' })
    stub_request(:get, 'https://www.netbout.com/bout/42').to_return(
      body: JSON.generate(id: 42),
      headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:post, 'https://www.netbout.com/b/42/tag').to_return(status: 302, headers: { 'Location' => '/' })
    stub_request(:get, 'https://www.netbout.com/tags/42').to_return(
      body: JSON.generate([{ name: 'tag1', value: 'привет!' }]), headers: { 'Content-Type' => 'application/json' }
    )
    inbox = Netbout::Inbox.new('test')
    bout = inbox.start('Hello, друг!')
    assert_predicate(bout.id, :positive?)
    key = 'tag1'
    value = 'привет!'
    bout.tags.put(key, value)
    t = inbox.take(bout.id).tags.to_a.first
    assert_equal(key, t['name'])
    assert_equal(value, t['value'])
  end
end
