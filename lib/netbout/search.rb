# frozen_string_literal: true

#
# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative 'http'
require_relative 'message'

# Search.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class Netbout::Search
  def initialize(iri, token, query)
    @iri = iri
    @token = token
    @query = query
  end

  def to_a
    array = []
    each do |m|
      array << m
    end
    array
  end

  def each
    entry = @iri.append('/search').add(q: @query).add(limit: '10')
    offset = 0
    loop do
      rsp = Netbout::Http.new(entry.over(offset: offset), @token).get
      json = JSON.parse(rsp.response_body)
      seen = 0
      json.each do |h|
        yield Netbout::Message.new(@iri, @token, h['id'])
        seen += 1
      end
      offset += seen
      break if seen.zero?
    end
  end
end
