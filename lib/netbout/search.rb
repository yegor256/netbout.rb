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

require_relative 'http'
require_relative 'message'

# Search.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Yegor Bugayenko
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
