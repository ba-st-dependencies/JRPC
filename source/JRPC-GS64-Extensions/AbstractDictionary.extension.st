Extension { #name : #AbstractDictionary }

{ #category : #'*JRPC-GS64-Extensions' }
AbstractDictionary >> asJRPCJSON [

	^ (self associations collect: [ :assoc |
		   self assert: assoc key isString.
		   assoc key -> assoc value asJRPCJSON ]) asDictionary
]
