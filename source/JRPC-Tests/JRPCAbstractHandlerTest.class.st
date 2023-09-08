"
A JRPCAbstractHandlerTest is a test class for testing the behavior of JRPCAbstractHandler
"
Class {
	#name : #JRPCAbstractHandlerTest,
	#superclass : #TestCase,
	#category : #'JRPC-Tests'
}

{ #category : #tests }
JRPCAbstractHandlerTest >> testEquality [

	| handler1 handler2 |
	handler1 := JRPCBlockHandler methodName: 'foo' block: [  ].
	handler2 := JRPCBlockHandler methodName: 'foo' block: [  ].

	self
		assert: handler1 equals: handler2;
		assert: handler1 hash equals: handler2 hash
]

{ #category : #tests }
JRPCAbstractHandlerTest >> testEquality2 [

	| handler1 handler2 |
	handler1 := JRPCBlockHandler methodName: 'foo' block: [  ].
	handler2 := JRPCBlockHandler methodName: 'bar' block: [  ].

	self deny: handler1 equals: handler2
]

{ #category : #tests }
JRPCAbstractHandlerTest >> testEquality3 [

	| handler1 handler2 |
	handler1 := (JRPCBlockHandler methodName: 'foo' block: [  ])
		            isForNotification: false;
		            yourself.
	handler2 := JRPCBlockHandler methodName: 'foo' block: [  ].

	self deny: handler1 equals: handler2
]

{ #category : #tests }
JRPCAbstractHandlerTest >> testEquality4 [

	| handler1 handler2 |
	handler1 := (JRPCBlockHandler methodName: 'foo' block: [  ])
		            isForNotification: false;
		            yourself.
	handler2 := (JRPCBlockHandler methodName: 'foo' block: [  ])
		            isForNotification: false;
		            yourself.

	self assert: handler1 equals: handler2
]

{ #category : #tests }
JRPCAbstractHandlerTest >> testEquality5 [

	| handler1 handler2 |
	handler1 := (JRPCBlockHandler methodName: 'foo' block: [  ])
		            isForRequest: false;
		            yourself.
	handler2 := JRPCBlockHandler methodName: 'foo' block: [  ].

	self deny: handler1 equals: handler2
]

{ #category : #tests }
JRPCAbstractHandlerTest >> testEquality6 [

	| handler1 handler2 |
	handler1 := (JRPCBlockHandler methodName: 'foo' block: [  ])
		            isForRequest: false;
		            yourself.
	handler2 := (JRPCBlockHandler methodName: 'foo' block: [  ])
		            isForRequest: false;
		            yourself.

	self assert: handler1 equals: handler2
]

{ #category : #tests }
JRPCAbstractHandlerTest >> testIsForRequestAndIsForNotificationSetters [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x | ].
	
	self assert: handler isForNotification.
	self assert: handler isForRequest.
	
	handler isForNotification: false.
	self deny: handler isForNotification.
	self assert: handler isForRequest.
	
	self should: [ handler isForRequest: false ] raise: Error.
	
	handler isForNotification: true.
	self assert: handler isForNotification.
	self assert: handler isForRequest.
	
	handler isForRequest: false.
	self assert: handler isForNotification.
	self deny: handler isForRequest.
	
	self should: [ handler isForNotification: false ] raise: Error.
]
