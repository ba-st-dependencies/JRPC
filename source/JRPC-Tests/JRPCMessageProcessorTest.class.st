"
A JRPCMessageProcessorTest is a test class for testing the behavior of JRPCMessageProcessor
"
Class {
	#name : #JRPCMessageProcessorTest,
	#superclass : #TestCase,
	#category : #'JRPC-Tests'
}

{ #category : #private }
JRPCMessageProcessorTest >> powerOf2Handler [

	^ JRPCBlockHandler methodName: 'powerOf2' block: [ :x | x raisedTo: 2 ]
]

{ #category : #tests }
JRPCMessageProcessorTest >> testAddHandler [

	| messageProcessor handler |
	messageProcessor := JRPCMessageProcessor new.

	self assert: messageProcessor handlers isEmpty.

	handler := self powerOf2Handler.
	messageProcessor addHandler: handler.

	self assert: messageProcessor handlers size equals: 1.
	self assert: messageProcessor handlers first identicalTo: handler
]

{ #category : #tests }
JRPCMessageProcessorTest >> testAddHandler2 [

	| messageProcessor handler |
	messageProcessor := JRPCMessageProcessor new.

	self assert: messageProcessor handlers isEmpty.

	handler := self powerOf2Handler.
	messageProcessor addHandler: handler.

	self
		should: [ messageProcessor addHandler: handler ]
		raise: JRPCDuplicatedHandlerError
]

{ #category : #tests }
JRPCMessageProcessorTest >> testAddHandler3 [

	| messageProcessor handler handler2 |
	messageProcessor := JRPCMessageProcessor new.

	self assert: messageProcessor handlers isEmpty.

	handler := self powerOf2Handler.
	messageProcessor addHandler: handler.

	"Different handler with same name"
	handler2 := self powerOf2Handler.

	self
		should: [ messageProcessor addHandler: handler2 ]
		raise: JRPCDuplicatedHandlerError
]

{ #category : #tests }
JRPCMessageProcessorTest >> testAddHandler4 [

	| messageProcessor handler handler2 |
	messageProcessor := JRPCMessageProcessor new.

	self assert: messageProcessor handlers isEmpty.

	handler := self powerOf2Handler
		           isForRequest: false;
		           yourself.
	messageProcessor addHandler: handler.

	"Different handler with same name"
	handler2 := self powerOf2Handler
		            isForNotification: false;
		            yourself.

	self
		shouldnt: [ messageProcessor addHandler: handler2 ]
		raise: JRPCDuplicatedHandlerError
]

{ #category : #tests }
JRPCMessageProcessorTest >> testDebugMode [
	| messageProcessor |
	messageProcessor := JRPCMessageProcessor new.
	
	self deny: messageProcessor debugMode.
	
	messageProcessor debugMode: true.
	
	self assert: messageProcessor debugMode.
]

{ #category : #tests }
JRPCMessageProcessorTest >> testDebugModeDoNotCatchError [
	| messageProcessor |
	messageProcessor := JRPCMessageProcessor new.
	messageProcessor debugMode: true.
	
	messageProcessor addHandlerNamed: 'error' block: [ Error signal ].
	
	self should: [ (JRPCRequestObject id: 1 method: 'error') beHandledBy: messageProcessor ]
		raise: Error.
		
	messageProcessor debugMode: false.
	
	self shouldnt: [ (JRPCRequestObject id: 1 method: 'error') beHandledBy: messageProcessor ]
		raise: Error.
]

{ #category : #'tests - error handlers' }
JRPCMessageProcessorTest >> testErrorHandlersAreNotEvaluatedOnSuccess [

	| messageProcessor response |
	messageProcessor := JRPCMessageProcessor new.
	messageProcessor
		addHandlerNamed: 'success' block: [ 'Sucess!' ];
		addErrorHandler: [ :error | self fail ].

	response := messageProcessor handleJRPCRequestObject:
		            (JRPCRequestObject new
			             id: 1;
			             method: 'success';
			             yourself).

	self deny: response isError
]

{ #category : #'tests - error handlers' }
JRPCMessageProcessorTest >> testErrorHandlersAreNotEvaluatedWhenDebugModeIsEnabled [

	| messageProcessor |
	messageProcessor := JRPCMessageProcessor new.
	messageProcessor
		debugMode: true;
		addHandlerNamed: 'error' block: [ 1 / 0 ];
		addErrorHandler: [ :error | self fail ].

	self
		should: [ 
			messageProcessor handleJRPCRequestObject: (JRPCRequestObject new
					 id: 1;
					 method: 'error';
					 yourself) ]
		raise: ZeroDivide
]

{ #category : #'tests - error handlers' }
JRPCMessageProcessorTest >> testErrorHandling [

	| messageProcessor errorWasRaised response |
	errorWasRaised := false.

	messageProcessor := JRPCMessageProcessor new.
	messageProcessor
		addHandlerNamed: 'error' block: [ Error signal ];
		addErrorHandler: [ :error | errorWasRaised := true ].

	response := messageProcessor handleJRPCRequestObject:
		            (JRPCRequestObject new
			             id: 1;
			             method: 'error';
			             yourself).

	self
		assert: response isError;
		assert: errorWasRaised
]

{ #category : #tests }
JRPCMessageProcessorTest >> testHandlerFor [
	| messageProcessor block handler |

	messageProcessor := JRPCMessageProcessor new.

	self should: [ messageProcessor handlerFor: (JRPCRequestObject id: 1 method: 'powerOf2') ] raise: JRPCNonExistentHandler.

	block := [ :anInteger | anInteger raisedTo: 2 ].

	messageProcessor addHandlerNamed: 'powerOf2' block: block.
	handler := messageProcessor handlerFor: (JRPCRequestObject id: 1 method: 'powerOf2').

	self
		assert: handler methodName equals: 'powerOf2';
		assert: handler receiver equals: block
]

{ #category : #tests }
JRPCMessageProcessorTest >> testHandlerForHandlerThatDealWithNotificationOnly [

	| messageProcessor handler |
	messageProcessor := JRPCMessageProcessor new.

	messageProcessor addHandler: (self powerOf2Handler
			 isForRequest: false;
			 yourself).

	handler := messageProcessor handlerFor:
		           (JRPCNotificationObject method: 'powerOf2').

	self
		assert: handler methodName equals: 'powerOf2';
		assert: (handler receiver value: 3) equals: 9.

	self
		should: [
			messageProcessor handlerFor:
				(JRPCRequestObject id: 1 method: 'powerOf2') ]
		raise: JRPCNonExistentHandler
]

{ #category : #tests }
JRPCMessageProcessorTest >> testHandlerForHandlerThatDealWithRequestOnly [

	| messageProcessor handler |
	messageProcessor := JRPCMessageProcessor new.

	messageProcessor addHandler: (self powerOf2Handler
			 isForNotification: false;
			 yourself).

	handler := messageProcessor handlerFor:
		           (JRPCRequestObject id: 1 method: 'powerOf2').

	self
		assert: handler methodName equals: 'powerOf2';
		assert: (handler receiver value: 3) equals: 9.

	self
		should: [
			messageProcessor handlerFor:
				(JRPCNotificationObject method: 'powerOf2') ]
		raise: JRPCNonExistentHandler
]

{ #category : #tests }
JRPCMessageProcessorTest >> testRemoveHandler [

	| messageProcessor handler |
	messageProcessor := JRPCMessageProcessor new.
	handler := self powerOf2Handler.
	messageProcessor addHandler: handler.

	self assert: messageProcessor handlers size equals: 1.

	messageProcessor removeHandler: handler.

	self assert: messageProcessor handlers isEmpty
]

{ #category : #'tests - error handlers' }
JRPCMessageProcessorTest >> testSeveralErrorHandlers [

	| messageProcessor response errorCount |
	errorCount := 0.

	messageProcessor := JRPCMessageProcessor new.
	messageProcessor
		addHandlerNamed: 'error' block: [ Error signal ];
		addErrorHandler: [ :error | errorCount := errorCount + 1 ];
		addErrorHandler: [ :error | errorCount := errorCount + 1 ].

	response := messageProcessor handleJRPCRequestObject:
		            (JRPCRequestObject new
			             id: 1;
			             method: 'error';
			             yourself).

	self
		assert: response isError;
		assert: errorCount equals: 2
]
