This is a node.js wrapper for the Bitfinex [API](https://bitfinex.com/pages/api).

### Install

`npm install bitfinex`

### Example

```js
var Bitfinex = require('bitfinex');

var bitfinex = new Bitfinex(your_key, your_secret);

bitfinex.new_order("btcusd", 42, 802.7, "all", "buy", "limit", false, 
	function(err, order_id){
		console.log(order_id);
});
```