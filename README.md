<img src="/logo.svg" width="64px" height="64px"/>

[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/netbout)](http://www.rultor.com/p/yegor256/netbout)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/netbout/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/netbout/actions/workflows/rake.yml)
[![PDD status](http://www.0pdd.com/svg?name=yegor256/netbout)](http://www.0pdd.com/p?name=yegor256/netbout)
[![Gem Version](https://badge.fury.io/rb/netbout.svg)](http://badge.fury.io/rb/netbout)
[![Maintainability](https://api.codeclimate.com/v1/badges/155f86b639d155259219/maintainability)](https://codeclimate.com/github/yegor256/netbout/maintainability)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/netbout.svg)](https://codecov.io/github/yegor256/netbout?branch=master)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/yegor256/netbout/master/frames)
![Lines of code](https://img.shields.io/tokei/lines/github/yegor256/netbout)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/netbout)](https://hitsofcode.com/view/github/yegor256/netbout)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/netbout/blob/master/LICENSE.txt)

This simple gem will help you enable login/logout through
[GitHub OAuth](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/)
for your web application. This is how it works with
[Sinatra](http://www.sinatrarb.com/),
but you can do something similar in any framework.

Read this blog post to get the idea:
[_Simplified GitHub Login for a Ruby Web App_](https://www.yegor256.com/2018/06/19/netbout.html)

First, somewhere in the global space, before the app starts:

```ruby
require 'netbout'
configure do
  set :netbout, Netbout::Auth.new(
    # Make sure their values are coming from a secure
    # place and are not visible in the source code:
    client_id, client_secret,
    # This is what you will register in GitHub as an
    # authorization callback URL:
    'http://www.example.com/github-callback'
  )
end
```

Next, for all web pages we need to parse a cookie, if it exists,
and convert it into a user:

```ruby
require 'sinatra/cookies'
before '/*' do
  if cookies[:netbout]
    begin
      @user = Netbout::Cookie::Closed.new(
        cookies[:netbout],
        # This must be some long text to be used to
        # encrypt the value in the cookie.
        secret
      ).to_user
    rescue Netbout::Codec::DecodingError => _
      # Nothing happens here, the user is not logged in.
      cookies.delete(:netbout)
    end
  end
end
```

If the `netbout` cookie is coming in and contains a valid data,
a local variable `@user` will be set to something like this:

```ruby
{ login: 'yegor256', avatar: 'http://...' }
```

If the `secret` is an empty string, the encryption will be disabled.

Next, we need a URL for GitHub OAuth callback:

```ruby
get '/github-callback' do
  cookies[:netbout] = Netbout::Cookie::Open.new(
    settings.netbout.user(params[:code]),
    # The same encryption secret that we were using above:
    secret
  ).to_s
  redirect to('/')
end
```

Finally, we need a logout URL:

```ruby
get '/logout' do
  cookies.delete(:netbout)
  redirect to('/')
end
```

It is recommended to provide the third "context" parameter to
`Netbout::Cookie::Closed` and `Netbout::Cookie::Open` constructors, in order
to enforce stronger security. The context may include the `User-Agent`
HTTP header of the user, their IP address, and so on. When anything
changes on the user side, they will be forced to re-login.

One more thing is the login URL you will need for your front page. Here
it is:

```ruby
settings.netbout.login_uri
```

For unit testing you can just provide an empty string as a `secret` for
`Netbout::Cookie::Open` and `Netbout::Cookie::Closed` and the encryption will be disabled:
whatever will be coming from the cookie will be trusted. For testing
it will be convenient to provide a user name in a query string, like:

```
http://localhost:9292/?netbout=tester
```

To enable that, it's recommended to add this line (see how
it works in [zold-io/wts.zold.io](https://github.com/zold-io/wts.zold.io)):

```ruby
require 'sinatra/cookies'
before '/*' do
  cookies[:netbout] = params[:netbout] if params[:netbout]
  if cookies[:netbout]
    # same as above
  end
end
```

I use this gem in [sixnines](https://github.com/yegor256/sixnines)
and [0pdd](https://github.com/yegor256/0pdd) web apps (both open source),
on top of Sinatra.

Also, you can use `Netbout::Codec` just to encrypt/decrypt a piece of text:

```ruby
require 'netbout/codec'
codec = Netbout:Codec.new('the secret')
encrypted = codec.encrypt('Hello, world!')
decrypted = codec.decrypt(encrypted)
```

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure you build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
