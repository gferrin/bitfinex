# https://bitfinex.com/pages/api

process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"

request = require 'request'
crypto = require 'crypto'
qs = require 'querystring'

module.exports = class Bitfinex

	constructor: (key, secret) ->

		@url = "https://api.bitfinex.com"
		@key = key
		@secret = secret
		@nonce = Math.ceil((new Date()).getTime() / 1000)

	_nonce: () ->

		return ++@nonce

	make_request: (sub_path, params, cb) ->

		if !@key or !@secret
			return cb(new Error("missing api key or secret"))

		path = '/v1/' + sub_path
		url = @url + path
		nonce = JSON.stringify(@_nonce())

		payload = 
			request: path
			nonce: nonce

		for key, value of params
			payload[key] = value

		payload = new Buffer(JSON.stringify(payload)).toString('base64')
		signature = crypto.createHmac("sha384", @secret).update(payload).digest('hex')

		headers = 
			'X-BFX-APIKEY': @key
			'X-BFX-PAYLOAD': payload
			'X-BFX-SIGNATURE': signature

		request { url: url, method: "POST", headers: headers, timeout: 15000 }, (err,response,body)->
		    
            if err || (response.statusCode != 200 && response.statusCode != 400)
                return cb new Error(err ? response.statusCode)
                
            try
                result = JSON.parse(body)
            catch error
                return cb(null, { messsage : body.toString() } )
            
            if result.message?
                return cb new Error(result.message)

            cb null, result
    
	make_public_request: (path, cb) ->

		url = @url + '/v1/' + path	

		request { url: url, method: "GET", timeout: 15000}, (err,response,body)->
		    
		    if err || (response.statusCode != 200 && response.statusCode != 400)
                return cb new Error(err ? response.statusCode)
            
            try
                result = JSON.parse(body)
            catch error
                return cb(null, { messsage : body.toString() } )

            if result.message?
                return cb new Error(result.message)
            
            cb null, result
    
	#####################################
	########## PUBLIC REQUESTS ##########
	#####################################                            

	ticker: (symbol, cb) ->

		@make_public_request('ticker/' + symbol, cb)

	today: (symbol, cb) ->

		@make_public_request('today/' + symbol, cb)		

	candles: (symbol, cb) ->

		@make_public_request('candles/' + symbol, cb)	

	lendbook: (currency, cb) ->

		@make_public_request('lendbook/' + currency, cb)	

	orderbook: (symbol, cb) ->

        maxOrders = 50
        uri = 'book/' + symbol + '/?limit_bids=' + maxOrders + '&limit_asks=' + maxOrders
        @make_public_request(uri, cb)
    
	trades: (symbol, cb) ->

		@make_public_request('trades/' + symbol, cb)

	lends: (currency, cb) ->

		@make_public_request('lends/' + currency, cb)		

	get_symbols: (cb) ->

		@make_public_request('symbols/', cb)

	# #####################################
	# ###### AUTHENTICATED REQUESTS #######
	# #####################################   

	new_order: (symbol, amount, price, exchange, side, type, is_hidden, cb) ->

		if typeof is_hidden is 'function'
			cb = is_hidden
			is_hidden = false

		params = 
			symbol: symbol
			amount: amount
			price: price
			exchange: exchange
			side: side
			type: type
			is_hidden: is_hidden 

		@make_request('order/new', params, cb)  

	multiple_new_orders: (symbol, amount, price, exchange, side, type, cb) ->

		params = 
			symbol: symbol
			amount: amount
			price: price
			exchange: exchange
			side: side
			type: type

		@make_request('order/new/multi', params, cb)  

	cancel_order: (order_id, cb) ->

		params = 
			order_id: parseInt(order_id)

		@make_request('order/cancel', params, cb)

	cancel_all_orders: (cb) ->

		@make_request('order/cancel/all', {}, cb)

	cancel_multiple_orders: (order_ids, cb) ->

		params = 
			order_ids: order_ids.map( (id) ->
			    return parseInt(id) )

		@make_request('order/cancel/multi', params, cb)

	replace_order: (order_id, symbol, amount, price, exchange, side, type, cb) ->

		params = 
			order_id: parseInt(order_id)
			symbol: symbol
			amount: amount
			price: price
			exchange: exchange
			side: side
			type: type

		@make_request('order/cancel/replace', params, cb)  

	order_status: (order_id, cb) ->

		params = 
			order_id: order_id

		@make_request('order/status', params, cb)  

	active_orders: (cb) ->

		@make_request('orders', {}, cb)  

	active_positions: (cb) ->

		@make_request('positions', {}, cb)  

	past_trades: (symbol, timestamp, limit_trades, cb) ->

		params = 
			symbol: symbol
			timestamp: timestamp
			limit_trades: limit_trades

		@make_request('mytrades', params, cb)  

	new_deposit: (currency, method, wallet_name, cb) ->

		params = 
			currency: currency
			method: method
			wallet_name: wallet_name

		@make_request('deposit/new', params, cb)  

	new_offer: (currency, amount, rate, period, direction, insurance_option, cb) ->

		params = 
			currency: currency
			amount: amount
			rate: rate
			period: period
			direction: direction
			insurance_option: insurance_option

		@make_request('offer/new', params, cb)  

	cancel_offer: (offer_id, cb) ->

		params = 
			order_id: offer_id

		@make_request('offer/cancel', params, cb) 

	offer_status: (order_id, cb) ->

		params = 
			order_id: order_id

		@make_request('offer/status', params, cb) 

	active_offers: (cb) ->

		@make_request('offers', {}, cb) 

	active_credits: (cb) ->

	 	@make_request('credits', {}, cb) 

	wallet_balances: (cb) ->

		@make_request('balances', {}, cb)
