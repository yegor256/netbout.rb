# frozen_string_literal: true

#
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
    inbox = Netbout::Inbox.new('test')
    bout = inbox.start('Hello, друг!')
    assert(bout.id.positive?)
    assert(bout.title.include?('друг'))
    assert_equal('?test', bout.owner)
    msg = bout.post('How are you, друг?')
    assert(msg.id.positive?)
    assert(msg.text.include?('друг'))
    assert_equal('?test', msg.author)
  end
end
