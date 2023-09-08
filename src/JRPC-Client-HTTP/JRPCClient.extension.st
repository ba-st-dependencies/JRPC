Extension { #name : #JRPCClient }

{ #category : #'*JRPC-Client-HTTP' }
JRPCClient class >> http: aString [
	^ JRPCHTTPClient url: aString
]
