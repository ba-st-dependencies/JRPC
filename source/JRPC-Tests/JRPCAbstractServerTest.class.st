Class {
	#name : #JRPCAbstractServerTest,
	#superclass : #TestCase,
	#instVars : [
		'server'
	],
	#category : #'JRPC-Tests'
}

{ #category : #testing }
JRPCAbstractServerTest class >> isAbstract [
	^ self = JRPCAbstractServerTest
]

{ #category : #private }
JRPCAbstractServerTest >> checkPortAvailability [

	[ ( ZnNetworkingUtils serverSocketOn: self port ) close ]
		on: Error
		do: [ :error | self fail: ( 'Port <1p> is not available' expandMacrosWith: self port ) ]
]

{ #category : #'instance creation' }
JRPCAbstractServerTest >> newJRPCClient [
	^ self subclassResponsibility
]

{ #category : #private }
JRPCAbstractServerTest >> port [

	^ 7777
]

{ #category : #running }
JRPCAbstractServerTest >> tearDown [

	server ifNotNil: [ server stop ].
	server := nil.
	super tearDown
]

{ #category : #accessing }
JRPCAbstractServerTest >> testDefaultPort [

	self assert: server defaultPort equals: 4000
]

{ #category : #accessing }
JRPCAbstractServerTest >> testNotification [

	| notificationCount |

	notificationCount := 0.
	server addHandlerNamed: 'mail_sent' block: [ notificationCount := notificationCount + 1 ].

	self newJRPCClient notifyMethod: 'mail_sent'.

	self assert: notificationCount equals: 1
]

{ #category : #accessing }
JRPCAbstractServerTest >> testNotificationWithInvalidMethod [

	| notificationCount |

	notificationCount := 0.
	server addHandlerNamed: 'mail_sent' block: [ notificationCount := notificationCount + 1 ].

	self newJRPCClient notifyMethod: 'invalid'.

	self assert: notificationCount equals: 0
]

{ #category : #accessing }
JRPCAbstractServerTest >> testRequestWithoutParameters [

	server addHandlerNamed: 'zero' block: [ 0 ].

	self assert: ( self newJRPCClient callMethod: 'zero' withId: 3 ) result equals: 0
]

{ #category : #accessing }
JRPCAbstractServerTest >> testValidRequest [

	server addHandlerNamed: 'sum' block: [ :a :b | a + b ].

	self assert: ( self newJRPCClient callMethod: 'sum' arguments: #(1 3) withId: 1 ) result equals: 4
]
