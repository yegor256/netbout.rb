# frozen_string_literal: true

#
# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative 'http'

# Tags.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
# License:: MIT
class Netbout::Tags
  def initialize(iri, token, id)
    @iri = iri
    @token = token
    @id = id
  end

  def to_a
    JSON.parse(Netbout::Http.new(@iri.append('/tags').append(@id), @token).get.response_body)
  end

  def put(key, value)
    Netbout::Http.new(@iri.append('/b').append(@id).append('/tag'), @token)
      .post('name' => key, 'value' => value)
  end
end
