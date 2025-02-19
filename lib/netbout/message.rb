# frozen_string_literal: true

#
# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Message.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class Netbout::Message
  def initialize(iri, token, json)
    @iri = iri
    @token = token
    @json = json
  end

  def id
    @json['id'].to_i
  end

  def author
    @json['author']
  end

  def text
    @json['text']
  end

  def flags
    JSON.parse(Netbout::Http.new(@iri.append('/flags').append(id), @token).get.response_body)
  end

  def attach(flag)
    Netbout::Http.new(@iri.append('/m').append(id).append('/attach'), @token)
      .post('name' => flag)
  end

  def detach(flag)
    Netbout::Http.new(@iri.append('/m').append(id).append('/detach').add(name: flag), @token).get
  end
end
