"
I'm a test for JSON RPC over HTTP transport
"
Class {
	#name : #JRPCHttpServerTest,
	#superclass : #JRPCAbstractServerTest,
	#category : #'JRPC-HTTP-Tests'
}

{ #category : #'instance creation' }
JRPCHttpServerTest >> newJRPCClient [

	^ ( JRPCClient http: ( 'http://localhost' asUrl port: self port ) )
		ifFail: [ self fail ];
		yourself
]

{ #category : #running }
JRPCHttpServerTest >> setUp [

	super setUp.
	self checkPortAvailability.
	server := JRPCServer http.
	server
		port: self port;
		debugMode: true.
	self
		assert: server port equals: self port;
		assert: server debugMode.
	server start
]

{ #category : #tests }
JRPCHttpServerTest >> testRequestOnInvalidEndpoint [

	| httpClient failed |

	server addHandlerNamed: 'sum' block: [ :a :b | a + b ].
	failed := false.

	httpClient := JRPCClient http: ( 'http://localhost' asUrl port: self port ) / 'bad'.
	httpClient
		ifFail: [ :error | 
			failed := true.
			'{}'
			].
	self
		should: [ httpClient callMethod: 'sum' arguments: #(1 3) withId: 1 ] raise: JRPCIncorrectJSON;
		assert: failed
]
