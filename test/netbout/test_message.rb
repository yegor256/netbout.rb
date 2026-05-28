# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../../lib/netbout'

# Test of Message.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestMessage < Minitest::Test
  def test_attach_flag
    msg = Netbout::Inbox.new('test').start('Hello, друг!').post('oops')
    tag = 'hey-you'
    msg.attach(tag)
    assert_equal(tag, msg.flags.first['name'])
    msg.detach(tag)
    assert_empty(msg.flags)
  end
end
