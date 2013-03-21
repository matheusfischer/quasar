class QuasarPawn extends Pawn
	ClassGroup(Quasar);

var(Pawn) const LightEnvironmentComponent LightEnvironment;

var class<QuasarInventoryManager> QuasarInventoryManagerClass;

var QuasarInventoryManager InventoryManager;

var Actor CrosshairTrace;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (self.InventoryManager == None && self.QuasarInventoryManagerClass != None)
	{
		self.InventoryManager = Spawn(self.QuasarInventoryManagerClass, self);
	}
}

event Bump (Actor Other, PrimitiveComponent OtherComp, Object.Vector HitNormal)
{
	if (Other.IsA('KActor'))
	{
		KActor(Other).ApplyImpulse( self.Velocity * 20.0f, 20.0f, self.Location );
	}
}

defaultproperties
{
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bSynthesizeSHLight=true
		bIsCharacterLightEnvironment=true
		bUseBooleanEnvironmentShadowing=false
		InvisibleUpdateTime=1.f
		MinTimeBetweenFullUpdates=0.2f
	End Object

	Begin Object Class=SkeletalMeshComponent Name=MySkeletalMeshComponent
		bCacheAnimSequenceNodes=false
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		CastShadow=true
		BlockRigidBody=true
		bUpdateSkelWhenNotRendered=true
		bIgnoreControllersWhenNotRendered=false
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=false
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2f
		bChartDistanceFactor=true
		RBDominanceGroup=20
		bUseOnePassLightingOnTranslucency=true
		bPerBoneMotionBlur=true
	End Object
	
	Components.Add(MyLightEnvironment);
	Components.Add(MySkeletalMeshComponent);
	Components.Remove(Sprite);

	QuasarInventoryManagerClass		= class'Quasar.QuasarInventoryManager';
	
	Mesh							= MySkeletalMeshComponent;
	LightEnvironment				= MyLightEnvironment;
	
	GroundSpeed						= 220.0f;
	
	bCollideActors					= true;
	bBlockActors					= true;
}