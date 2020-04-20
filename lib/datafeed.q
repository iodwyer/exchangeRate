/
https://www.alphavantage.co/documentation
https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=USD&apikey=C60RIVKERB4TWM7C
\


if[not system "p";                         / if port is not set
  system "p 4999"                          / listen on port 5110
  ];


if[not "NO"~getenv`KX_SSL_VERIFY_SERVER;
	show"'KX_SSL_VERIFY_SERVER' variable not set.";
	show"Set using: 'export KX_SSL_VERIFY_SERVER=NO'";
	show"Exiting...";	
	exit 0
	];

h:hopen `::5000; // connect to RDB 

.er.lastData:();

publishData:{
	//show"Querying API";
	data:.Q.hg "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=USD&apikey=C60RIVKERB4TWM7C";
	if[data~.er.lastData;	// check if data is new  //TODO not working	
		.er.lastData:data;
		:show "No new data"
		
	];
	.er.lastData:data;   //FIX
	data:"S*S*FPSFF"$value flip value .j.k data;
	0N!string[.z.T]," Publishing new data";
	neg[h](`upd;`exchangeRate;data)
	};
.z.ts:publishData;

timer:1000*60%5;  //trigger .z.ts every 12 seconds
timer:60000;
system"t ",string timer;


/
https://www.alphavantage.co/query?
fn:"CURRENCY_EXCHANGE_RATE";
fc:"USD";
tc:"JPY";
ak:"C60RIVKERB4TWM7C";

"function=",fn,"&from_currency=",fc,"&to_currency=",tc,"&apikey=",ak
\

