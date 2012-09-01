-module(dropbox).
-export([
	get_authorization_url/2,
	request_token/2,
	access_token/4, 
	account_info/4,
	file_get/6,
	metadata/6,
	copy_ref/6,
	copy_from_ref/7
]).

-spec(request_token(string(), string()) -> [{string(), string()}]).
request_token(Key, Secret) -> 
	{ok, RequestToken} = oauth:post("https://api.dropbox.com/1/oauth/request_token", [], {Key, Secret, hmac_sha1}),
	oauth:params_decode(RequestToken).

get_authorization_url(Token, Callback) ->
	format(
		"https://www.dropbox.com/1/oauth/authorize?oauth_token=~s&oauth_callback=~s",
		[Token, Callback]
	).

access_token(Key, Secret, Token, TokenSecret) ->
	{ok, AccessToken} = oauth:post("https://api.dropbox.com/1/oauth/access_token", [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
	oauth:params_decode(AccessToken).

account_info(Key, Secret, Token, TokenSecret) ->
	{ok, {_, _, AccountInfo}} = oauth:get("https://api.dropbox.com/1/account/info", [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
	AccountInfo.

%%
%% Files and metadata
%%

file_get(Key, Secret, Token, TokenSecret, Root, Path) ->
	{ok, {_, _, File}} = oauth:get("https://api-content.dropbox.com/1/files/" ++ Root ++ "/" ++ Path, [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
	File.

metadata(Key, Secret, Token, TokenSecret, Root, Path) ->
	{ok, {_, _, Metadata}} = oauth:get("https://api.dropbox.com/1/metadata/" ++ Root ++ "/" ++ Path, [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
	Metadata.

copy_ref(Key, Secret, Token, TokenSecret, Root, Path) ->
	Url = format(
		"https://api.dropbox.com/1/copy_ref/~s/~s",
		[Root, Path]
	),
	{ok, {_, _, Ref}} = oauth:get(Url, [], {Key, Secret, hmac_sha1}, Token, TokenSecret),
	Ref.

copy_from_ref(Key, Secret, Token, TokenSecret, Root, Ref, Target) ->
	{ok, {_, _, Result}} = oauth:get(
		"https://api.dropbox.com/1/fileops/copy",
		[
			{"root", Root},
			{"from_copy_ref", Ref},
			{"to_path", Target}
		],
		{Key, Secret, hmac_sha1},
		Token,
		TokenSecret
	),
	Result.

format(Pattern, Params) ->
	lists:flatten(io_lib:format(Pattern, Params)).
