
# process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

request = require 'request'
crypto = require 'crypto'
qs = require 'querystring'

module.exports = class Bitfinex

	constructor: (key, secret) ->

		@url = "https://api.bitfinex.com"
		@key = key
		@secret = secret
		@nonce = 0

	_nonce: () ->

		nonce = Math.round((new Date()).getTime() / 1000)
		if @nonce is nonce
			return @nonce++
		else 
			@nonce = nonce
			return nonce

	make_request: (sub_path, type, params, cb) ->

		if !@key or !@secret
			cb(new Error("missing api key or secret"))

		path = '/v1/' + sub_path
		url = @url + path
		nonce = JSON.stringify(@_nonce())

		payload = 
			request: path
			nonce: nonce
			options: params


		payload = new Buffer(JSON.stringify(payload)).toString('base64')
		signature = crypto.createHmac("sha384", @secret).update(payload).digest('hex')

		headers = 
			'X-BFX-APIKEY': @key
			'X-BFX-PAYLOAD': payload
			'X-BFX-SIGNATURE': signature

		request({ url: url, method: type, headers: headers }, cb)                                   

	make_public_request: () ->

		

	wallet_balances: (cb) ->

		@make_request('balances', "POST", {}, cb)
