# frozen_string_literal: true

#
# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'iri'
require 'json'
require_relative 'http'
require_relative 'bout'
require_relative 'search'

# Inbox.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class Netbout::Inbox
  def initialize(token)
    require_relative 'http'
    @token = token
    @iri = Iri.new('https://netbout.com')
  end

  def identity
    rsp = Netbout::Http.new(@iri.append('/self'), @token).get
    json = JSON.parse(rsp.response_body)
    json['identity']
  end

  def search(query = '')
    Netbout::Search.new(@iri, @token, query)
  end

  def start(title)
    rsp = Netbout::Http.new(@iri.append('/start'), @token).post('title' => title)
    id = rsp.headers['X-Netbout-Bout'].to_i
    take(id)
  end

  def take(id)
    rsp = Netbout::Http.new(@iri.append('/bout').append(id), @token).get
    Netbout::Bout.new(@iri, @token, JSON.parse(rsp.response_body))
  end
end
