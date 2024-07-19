Class {
	#name : #BaselineOfJRPC,
	#superclass : #BaselineOf,
	#category : #BaselineOfJRPC
}

{ #category : #baselines }
BaselineOfJRPC >> baseline: spec [

	<baseline>
	spec for: #pharo do: [
		self
			setUpDependencies: spec;
			setUpPackages: spec.
		spec
			group: 'CI' with: 'Tests';
			group: 'Development' with: 'Tests'
		]
]

{ #category : #accessing }
BaselineOfJRPC >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfJRPC >> setUpClientDeploymentPackages: spec [

	spec
		package: 'JRPC-Client-Core' with: [ spec requires: #('JRPC-Extensions' 'JRPC-STON-Extensions') ];
		group: 'Client-Deployment' with: 'JRPC-Client-Core';
		package: 'JRPC-Client-HTTP' with: [ spec requires: 'JRPC-Client-Core' ];
		group: 'Client-HTTP-Transport' with: 'JRPC-Client-HTTP';
		package: 'JRPC-Client-TCP' with: [ spec requires: 'JRPC-Client-Core' ];
		group: 'Client-TCP-Transport' with: 'JRPC-Client-TCP'
]

{ #category : #baselines }
BaselineOfJRPC >> setUpDependencies: spec [

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v8' ];
		project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ]
]

{ #category : #baselines }
BaselineOfJRPC >> setUpPackages: spec [

	spec package: 'JRPC-Common'.
	spec
		package: 'JRPC-Extensions'
		with: [ spec requires: 'JRPC-Common' ];
		package: 'JRPC-STON-Extensions'
		with: [ spec requires: 'JRPC-Common' ].
	self
		setUpServerDeploymentPackages: spec;
		setUpClientDeploymentPackages: spec.

	spec
		group: 'HTTP-Transport' with: 'Server-HTTP-Transport';
		group: 'HTTP-Transport' with: 'Client-HTTP-Transport';
		group: 'TCP-Transport' with: 'Server-TCP-Transport';
		group: 'TCP-Transport' with: 'Client-TCP-Transport';
		group: 'Deployment'
		with: #( 'Server-Deployment' 'HTTP-Transport' 'TCP-Transport'
			   'Client-Deployment' ).

	self setUpTestPackages: spec
]

{ #category : #baselines }
BaselineOfJRPC >> setUpServerDeploymentPackages: spec [

	spec
		package: 'JRPC-Server-Core'
		with: [ spec requires: #( 'JRPC-Extensions' 'JRPC-STON-Extensions' 'Buoy-Deployment' ) ];
		group: 'Server-Deployment' with: 'JRPC-Server-Core'.

	spec
		package: 'JRPC-Server-HTTP' with: [ spec requires: 'JRPC-Server-Core' ];
		group: 'Server-HTTP-Transport' with: 'JRPC-Server-HTTP'.

	spec
		package: 'JRPC-Server-TCP' with: [ spec requires: 'JRPC-Server-Core' ];
		group: 'Server-TCP-Transport' with: 'JRPC-Server-TCP'.

	spec
		package: 'JRPC-Server-Logging' with: [ spec requires: 'JRPC-Server-Core' ];
		group: 'Server-Logging' with: 'JRPC-Server-Logging'
]

{ #category : #baselines }
BaselineOfJRPC >> setUpTestPackages: spec [

	spec
		package: 'JRPC-Tests' with: [ spec requires: 'Deployment' ];
		group: 'Tests' with: 'JRPC-Tests';
		package: 'JRPC-HTTP-Tests' with: [ spec requires: 'HTTP-Transport' ];
		group: 'Tests' with: 'JRPC-HTTP-Tests';
		package: 'JRPC-TCP-Tests' with: [ spec requires: 'TCP-Transport' ];
		group: 'Tests' with: 'JRPC-TCP-Tests';
		package: 'JRPC-Server-Logging-Tests' with: [ spec requires: #( 'Deployment' 'Server-Logging' ) ];
		group: 'Tests' with: 'JRPC-Server-Logging-Tests'
]
