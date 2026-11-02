# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'json'
require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../../lib/netbout'

# Test of Bout.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class TestBout < Minitest::Test
  def test_start_and_post
    stub_request(:post, 'https://www.netbout.com/start').to_return(status: 302, headers: { 'X-Netbout-Bout' => '42' })
    stub_request(:get, 'https://www.netbout.com/bout/42').to_return(
      body: JSON.generate(
        id: 42, title: 'Hello, друг!',
        owner: '?test'
      ), headers: { 'Content-Type' => 'application/json' }
    )
    stub_request(:post, 'https://www.netbout.com/b/42/post').to_return(
      status: 302, headers: { 'X-Netbout-Message' => '7' }
    )
    stub_request(:get, 'https://www.netbout.com/message/7').to_return(
      body: JSON.generate(
        id: 7, text: 'How are you, друг?',
        author: '?test'
      ), headers: { 'Content-Type' => 'application/json' }
    )
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
