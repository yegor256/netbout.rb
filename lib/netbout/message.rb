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

# Message.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
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
