/
https://www.alphavantage.co/documentation
https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=USD&apikey=C60RIVKERB4TWM7C
\

.u.h:0Ni; / tickerplant handle
.u.tp:5010;

if[not system "p";                         / if port is not set
  system "p 4999"                          / listen on port 5110
  ];


if[not "NO"~getenv`KX_SSL_VERIFY_SERVER;
	show"'KX_SSL_VERIFY_SERVER' variable not set.";
	show"Set using: 'export KX_SSL_VERIFY_SERVER=NO'";
	show"Exiting...";	
	exit 0
	];

.er.lastData:();

publishData:{
	//show"Querying API";
	data:.Q.hg "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=USD&apikey=C60RIVKERB4TWM7C";
	if[data~.er.lastData;	// check if data is new  //TODO not working	
		:show "No new data"
	 ];
	.er.lastData:data;
	data:value flip value .j.k data;
	data:@[data;0;:;enlist "/" sv first each data[0 2]];
	data:"SP**F*FF"$data 0 5 1 3 4 6 7 8;
	0N!string[.z.T]," Publishing new data";
	neg[.u.h](`.u.upd;`exchangeRate;data)
	};

.z.ts:{[]
  if[null .u.h;
    .u.h:@[hopen;.u.tp;0Ni]
  ];
  if[not null .u.h;
    publishData[]
   ];
  };

//timer:1000*60%5;  //trigger .z.ts every 12 seconds
timer:60000;  // once per minute 
system"t ",string timer;


/
https://www.alphavantage.co/query?
fn:"CURRENCY_EXCHANGE_RATE";
fc:"USD";
tc:"JPY";
ak:"C60RIVKERB4TWM7C";

"function=",fn,"&from_currency=",fc,"&to_currency=",tc,"&apikey=",ak
\

