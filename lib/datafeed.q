/
1. KxS install + provide feedback to Sean: https://fdplc.sharepoint.com/:p:/r/sites/KxCustomerSuccess/_layouts/15/Doc.aspx?sourcedoc=%7B92C2E6D5-3BE5-4FC4-90DD-715FC59E08E4%7D&file=Kx%20for%20Sensors%20Training%202020%20-%20inprogress%20.pptx&action=edit&mobileredirect=true
2. Matthew's "Mass Data Ingestion": https://dubgitlab.firstderivatives.com/poc/poc-awiki/tree/bulkIngest-serviceClass/libraries/DataIngestion/MassIngestion

3. Analyst training: https://github.com/KxSystems/analyst-training
4. Unit testing (get package off cgervin)

5. Personal project: bitcoin/USD exchange rate + grafana dashboard 
https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=CNY&apikey=demo
https://github.com/AquaQAnalytics/grafana-kdb-datasource-ws
\

/
https://www.alphavantage.co/documentation
https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=USD&apikey=C60RIVKERB4TWM7C
\

//schema
//quotes:flip `last_refreshed`from_code`from_name`to_code`to_name`exchange_rate`time_zone`bid_price`ask_price!"PS*S*SSFF"$\:();

//data:.j.k raze read0 `:query.json;
//"S*S*FPSFF"$value flip value data

\p 4999 
\l schema.q

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

//m:`time_zone xcols `from_code`from_name`to_code`to_name`exchange_rate`last_refreshed`time_zone`bid_price`ask_price xcol value data;
//or
//.Q.id each `${ssr[3_x;"_";""]} each string cols value data; // potential no need


// {x$y}["S*S*FPSFF";value flip value data]
// "S*S*FPSFF"$value flip value data

.z.ts:publishData;

timer:1000*60%5;  //trigger .z.ts every 12 seconds
timer:60000;
system"t ",string timer;


/
generalHelper:{[tab;dict] ![tab;();0b;key[dict]!{(x$;y)}'[value dict;key dict]]};
{cols[x]!exec t from meta x}[quotes]

castTab:{[fromTab;toTab]}
   generalHelper[cols[fromTab] xcols toTab;{cols[x]!"*"^upper exec t from meta x}[toTab]]
   };

generalHelper[cols[`quotes] xcols m;{cols[x]!"*"^upper exec t from meta x}[`quotes]]

https://www.alphavantage.co/query?
fn:"CURRENCY_EXCHANGE_RATE";
fc:"USD";
tc:"JPY";
ak:"C60RIVKERB4TWM7C";

"function=",fn,"&from_currency=",fc,"&to_currency=",tc,"&apikey=",ak


