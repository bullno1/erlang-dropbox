# Erlang Dropbox REST API

## Fetch dependencies

Project depends on [erlang-oauth](https://github.com/tim/erlang-oauth).

    $ rebar get-deps

## Compile

    $ rebar compile

## Quick start

    $ erl -pa ebin deps/*/ebin -s crypto -s inets -s ssl

### Authentication

    1> Key = "Your App key".
    2> Secret = "Your App secret".
    3> [{"oauth_token_secret", TokenSecret}, {"oauth_token", Token}] = dropbox:request_token(Key, Secret).

Redirect user to https://www.dropbox.com/1/oauth/authorize?oauth_token=Token

    4> [{"oauth_token_secret", TokenSecret2}, {"oauth_token", Token2}, {"uid", _Uid}] = dropbox:access_token(Key, Secret, Token, TokenSecret).

### Dropbox accounts

    5> dropbox:account_info(Key, Secret, Token2, TokenSecret2).

### Files and metadata

    6> dropbox:file_get(Key, Secret, Token2, TokenSecret2, "sandbox", Filename).
