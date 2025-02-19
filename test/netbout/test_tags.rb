# frozen_string_literal: true

#
# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../../lib/netbout'

# Test of Tags.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class TestTags < Minitest::Test
  def test_put_and_list
    inbox = Netbout::Inbox.new('test')
    bout = inbox.start('Hello, друг!')
    assert(bout.id.positive?)
    key = 'tag1'
    value = 'привет!'
    bout.tags.put(key, value)
    t = inbox.take(bout.id).tags.to_a.first
    assert_equal(key, t['name'])
    assert_equal(value, t['value'])
  end
end
