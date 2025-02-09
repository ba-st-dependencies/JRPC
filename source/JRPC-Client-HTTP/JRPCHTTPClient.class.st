"
I am a client for JSON-RPC 2.0 over HTTP.

Internally, I use Zinc.
"
Class {
	#name : #JRPCHTTPClient,
	#superclass : #JRPCClient,
	#instVars : [
		'httpClient'
	],
	#category : #'JRPC-Client-HTTP'
}

{ #category : #'instance creation' }
JRPCHTTPClient class >> url: anObject [
	^ self new
		url: anObject;
		yourself
]

{ #category : #options }
JRPCHTTPClient >> ifFail: block [

	httpClient ifFail: block
]

{ #category : #initialization }
JRPCHTTPClient >> initialize [

	super initialize.
	httpClient := ZnClient new
		systemPolicy;
		http;
		yourself
]

{ #category : #'private - sending' }
JRPCHTTPClient >> sendRequest: aJRPCRequestObject [

	| result |

	result := httpClient
		          contents: ( self convertJRPCJsonableObjectToJSON: aJRPCRequestObject asJRPCJSON );
		          contentType: ZnMimeType applicationJson;
		          post.

	^ parser
		  parseSupposedJRPCMessageObjectFromString:
		  ( result ifNil: [ '' ] ifNotNil: [ :response | response contents ] )
		  forClient: true
]

{ #category : #accessing }
JRPCHTTPClient >> url: anObject [

	httpClient url: anObject asZnUrl
]
