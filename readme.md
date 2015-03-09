This is a node.js wrapper for the Bitfinex [API](https://bitfinex.com/pages/api).

### Install

`npm install bitfinex`

### Example

```js
var Bitfinex = require('bitfinex');

var bitfinex = new Bitfinex(your_key, your_secret);

bitfinex.new_order("btcusd", 42, 802.7, "all", "buy", "exchange limit", 
	function(err, res, order_id){
		console.log(order_id);
});
```

### Error

If your getting the error `[Error: Nonce is too small.]` then your most likely
running the same process twice using the same API keys.

## Functions

`ticker(symbol, cb)`

`today(symbol, cb)`		

`candles(symbol, cb)`

`lendbook(currency, cb)`	

`orderbook(symbol, options, cb) `

`trades(symbol, cb)`

`lends(currency, cb)`	

`get_symbols(cb)`

`symbols_details(cb)`

##### AUTHENTICATED REQUESTS 

`new_deposit(currency, method, wallet_name, cb)`

`new_order(symbol, amount, price, exchange, side, type, cb)`

`multiple_new_orders(symbol, amount, price, exchange, side, type, cb)`

`cancel_order(order_id, cb)`

`cancel_all_orders(cb)`

`cancel_multiple_orders(order_ids, cb)`

`replace_order(order_id, symbol, amount, price, exchange, side, type, cb)`

`order_status(order_id, cb)`

`active_orders(cb)`

`active_positions(cb)`

`movements(currency, [options,] cb)`

`past_trades(symbol, [options,] cb)`

`new_offer(currency, amount, rate, period, direction, insurance_option, cb)`

`cancel_offer(offer_id, cb)`

`offer_status(order_id, cb)`

`active_offers(cb)`

`active_credits(cb)`

`wallet_balances(cb)`

`taken_swaps(cb)`

`close_swap(cb)`

`account_infos(cb)`

`margin_infos(cb)`


