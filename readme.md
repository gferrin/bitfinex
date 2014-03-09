This is a node.js wrapper for the Bitfinex [API](https://bitfinex.com/pages/api).

### Install

`npm install bitfinex`

### coffee-script installation
`npm install -g coffee-script`

### Compile coffee-script
`coffee --compile bitfinex.coffee`

### Example

```js
var Bitfinex = require('bitfinex');

var bitfinex = new Bitfinex(your_key, your_secret);

bitfinex.new_order("btcusd", 42, 802.7, "all", "buy", "exchange limit", 
	function(err, res, order_id){
		console.log(order_id);
});
```