# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require 'json'
require_relative 'bout'
require_relative 'http'
require_relative 'search'

# Inbox.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class Netbout::Inbox
  def initialize(token)
    require_relative('http')
    @token = token
    @iri = Iri.new('https://netbout.com')
  end

  def identity
    JSON.parse(Netbout::Http.new(@iri.append('/self'), @token).get.response_body)['identity']
  end

  def search(query = '')
    Netbout::Search.new(@iri, @token, query)
  end

  def start(title)
    take(Integer(Netbout::Http.new(@iri.append('/start'), @token).post('title' => title).headers['X-Netbout-Bout'], 10))
  end

  def take(id)
    Netbout::Bout.new(
      @iri, @token,
      JSON.parse(Netbout::Http.new(@iri.append('/bout').append(id), @token).get.response_body)
    )
  end
end
