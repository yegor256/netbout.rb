# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../../lib/netbout'

# Test of Bout.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestBout < Minitest::Test
  def test_start_and_post
    bout = Netbout::Inbox.new('test').start('Hello, друг!')
    assert_predicate(bout.id, :positive?)
    assert_includes(bout.title, 'друг')
    assert_equal('?test', bout.owner)
    msg = bout.post('How are you, друг?')
    assert_predicate(msg.id, :positive?)
    assert_includes(msg.text, 'друг')
    assert_equal('?test', msg.author)
  end
end
