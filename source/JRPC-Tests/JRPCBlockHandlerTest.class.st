"
A JRPCBlockHandlerTest is a test class for testing the behavior of JRPCBlockHandler
"
Class {
	#name : #JRPCBlockHandlerTest,
	#superclass : #TestCase,
	#category : #'JRPC-Tests'
}

{ #category : #tests }
JRPCBlockHandlerTest >> testCheckParametersForRequest [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x | ].
	self should: [ 
		handler checkParametersForRequest: JRPCRequestObject new
	] raise: JRPCInvalidParameters.
	
	self should: [ 
		handler checkParametersForRequest: (JRPCRequestObject new params: #(1 2); yourself)
	] raise: JRPCInvalidParameters.

	self should: [ 
		handler checkParametersForRequest: (JRPCRequestObject new params: { 'x' -> 1 . 'y' -> 2 } asDictionary; yourself)
	] raise: JRPCInvalidParameters.
	
	self should: [ 
		handler checkParametersForRequest: (JRPCRequestObject new params: { 'y' -> 1 } asDictionary; yourself)
	] raise: JRPCInvalidParameters.
	
	"The two next will not raise error."
	handler checkParametersForRequest: (JRPCRequestObject new params: #(1); yourself).
		
	handler checkParametersForRequest: (JRPCRequestObject new params: { 'x' -> 1 } asDictionary; yourself)
]

{ #category : #tests }
JRPCBlockHandlerTest >> testExecuteWithArgumentsBeingArray [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y | x + y ].
	
	self assertCollection: (handler executeWithArguments: #(1 2)) equals: 3
]

{ #category : #tests }
JRPCBlockHandlerTest >> testExecuteWithArgumentsDictionary [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y | x + y ].
	
	self assertCollection: (handler executeWithArguments: { 'x' -> 1. 'y' -> 2 } asDictionary) equals: 3
]

{ #category : #tests }
JRPCBlockHandlerTest >> testParametersCount [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y | x + y ].
	
	self assert: handler parametersCount equals: 2
]

{ #category : #tests }
JRPCBlockHandlerTest >> testParametersNames [
	| handler |
	handler := JRPCBlockHandler methodName: 'test' block: [ :x :y | x + y ].
	
	self assertCollection: handler parametersNames equals: #('x' 'y')
]

{ #category : #tests }
JRPCBlockHandlerTest >> testUnnamedBlockHandlerRaiseErrorWhenMethodNameIsAsked [
	| handler |
	handler := JRPCBlockHandler new
					receiver: [ :x :y | x + y ];
					yourself.
					
	self should: [ handler methodName ] raise: Error withExceptionDo: [ :error |
		error description = 'It is mandatory to specify the #methodName of a block handler via #methodName: method on instance side.' ]
]
