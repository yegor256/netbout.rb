# frozen_string_literal: true

#
# Copyright (c) 2024-2025 Yegor Bugayenko
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
require 'json'
require_relative 'http'
require_relative 'bout'
require_relative 'search'

# Inbox.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
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
