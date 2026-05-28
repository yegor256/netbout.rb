# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'backtrace'
require 'iri'
require 'typhoeus'
require_relative 'version'

# HTTP.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class Netbout::Http
  CONNECT_TIMEOUT = 0.8
  private_constant :CONNECT_TIMEOUT

  def initialize(iri, token)
    @iri = iri
    @token = token
  end

  def get
    checked(
      Typhoeus::Request.get(
        @iri.to_s,
        accept_encoding: 'gzip',
        headers: headers,
        connecttimeout: CONNECT_TIMEOUT,
        timeout: CONNECT_TIMEOUT
      )
    )
  end

  def post(hash)
    checked(
      Typhoeus::Request.post(
        @iri.to_s,
        accept_encoding: 'gzip',
        body: hash.map { |k, v| "#{k}=#{CGI.escape(v)}" }.join('&'),
        headers: headers.merge('Content-Type': 'application/x-www-form-urlencoded'),
        connecttimeout: CONNECT_TIMEOUT,
        timeout: CONNECT_TIMEOUT
      )
    )
  end

  private

  def checked(rsp)
    code = Integer(rsp.response_code)
    flash = rsp.headers['x-netbout-flash']
    raise(StandardError, "Invalid response #{code}: '#{flash}'") if code != 200 && code != 303 && code != 302
    rsp
  end

  def headers
    {
      Connection: 'close',
      'X-Netbout-Token': @token,
      'User-Agent': "Netbout.rb #{Netbout::VERSION}",
      'Accept-Encoding': 'gzip',
      'X-Netbout-Version': Netbout::VERSION
    }
  end
end
