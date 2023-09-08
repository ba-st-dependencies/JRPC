Extension { #name : #Dictionary }

{ #category : #'*JRPC-Extensions' }
Dictionary >> asJRPCJSON [
	^ (self associations collect: [ :assoc |
		self assert: assoc key isString.
		assoc key -> assoc value asJRPCJSON ]) asDictionary
]
