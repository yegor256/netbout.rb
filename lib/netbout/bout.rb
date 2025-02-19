# frozen_string_literal: true

#
# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative 'message'
require_relative 'http'
require_relative 'tags'

# Bout.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class Netbout::Bout
  def initialize(iri, token, json)
    @iri = iri
    @token = token
    @json = json
  end

  def id
    @json['id']
  end

  def title
    @json['title']
  end

  def owner
    @json['owner']
  end

  def post(text)
    rsp = Netbout::Http.new(@iri.append('/b').append(id).append('/post'), @token).post('text' => text)
    id = rsp.headers['X-Netbout-Message'].to_i
    take(id)
  end

  def take(id)
    rsp = Netbout::Http.new(@iri.append('/message').append(id), @token).get
    Netbout::Message.new(@iri, @token, JSON.parse(rsp.response_body))
  end

  def tags
    Netbout::Tags.new(@iri, @token, id)
  end
end
