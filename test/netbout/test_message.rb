# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'json'
require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../../lib/netbout'

# Test of Message.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestMessage < Minitest::Test
  def test_attach_flag
    stub_request(:post, 'https://www.netbout.com/start').to_return(status: 302, headers: { 'X-Netbout-Bout' => '42' })
    stub_request(:get, 'https://www.netbout.com/bout/42').to_return(
      body: JSON.generate(id: 42),
      headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:post, 'https://www.netbout.com/b/42/post').to_return(
      status: 302, headers: { 'X-Netbout-Message' => '7' }
    )
    stub_request(:get, 'https://www.netbout.com/message/7').to_return(
      body: JSON.generate(id: 7, text: 'oops'),
      headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:post, 'https://www.netbout.com/m/7/attach').with(body: 'name=hey-you').to_return(
      status: 302,
      headers: { 'Location' => '/' }
    )
    stub_request(:get, 'https://www.netbout.com/m/7/detach?name=hey-you').to_return(
      status: 302,
      headers: { 'Location' => '/' }
    )
    stub_request(:get, 'https://www.netbout.com/flags/7').to_return(
      { body: JSON.generate([{ name: 'hey-you' }]), headers: { 'Content-Type' => 'application/json' } },
      { body: JSON.generate([]), headers: { 'Content-Type' => 'application/json' } }
    )
    msg = Netbout::Inbox.new('test').start('Hello, друг!').post('oops')
    tag = 'hey-you'
    msg.attach(tag)
    assert_equal(tag, msg.flags.first['name'])
    msg.detach(tag)
    assert_empty(msg.flags)
  end
end
