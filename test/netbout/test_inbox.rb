# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'json'
require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../../lib/netbout'

# Test of Inbox.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestInbox < Minitest::Test
  def test_self_identity
    stub_request(:get, 'https://www.netbout.com/self').to_return(
      body: JSON.generate(identity: '?test'),
      headers: { 'Content-Type' => 'application/json' }
    )
    assert_equal('?test', Netbout::Inbox.new('test').identity)
  end
end
