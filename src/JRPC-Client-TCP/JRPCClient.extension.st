Extension { #name : #JRPCClient }

{ #category : #'*JRPC-Client-TCP' }
JRPCClient class >> tcp [
	^ JRPCTCPClient new
]

{ #category : #'*JRPC-Client-TCP' }
JRPCClient class >> tcpForAddress: aSocketAddress port: anInteger [
	^ JRPCTCPClient new
		address: aSocketAddress;
		port: anInteger;
		yourself
]
