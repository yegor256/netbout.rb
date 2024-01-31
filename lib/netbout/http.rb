# frozen_string_literal: true

#
# Copyright (c) 2024 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'iri'
require 'backtrace'
require 'typhoeus'
require_relative 'version'

# HTTP.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
module Netbout
  # Http page
  class Http
    # Connect timeout in seconds
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
          headers: headers.merge(
            'Content-Type': 'application/x-www-form-urlencoded'
          ),
          connecttimeout: CONNECT_TIMEOUT,
          timeout: CONNECT_TIMEOUT
        )
      )
    end

    private

    def checked(rsp)
      code = rsp.response_code.to_i
      raise "Invalid response #{code}: '#{rsp.headers['x-netbout-flash']}'" if code != 200 && code != 303 && code != 302
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
end
