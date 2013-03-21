class QuasarGame extends GameInfo;

var QuasarPawn DefaultPawnArchetype;

var QuasarConfigurationInfo ConfigurationInfo;

event PreBeginPlay()
{
	Super.PreBeginPlay();
	
	self.ConfigurationInfo = new () class'Quasar.QuasarConfigurationInfo';
	
	if (self.ConfigurationInfo != None)
	{
		self.ConfigurationInfo.IncrementBuildNo();
	}
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
	local Rotator StartRotation;

	// Don't allow pawn to be spawned with any pitch or roll
	StartRotation.Yaw = StartSpot.Rotation.Yaw;

	// Check incoming variables
	if (NewPlayer != None)
	{
		if (DefaultPawnArchetype != None)
		{
			// Spawn and return the pawn
			return Spawn(DefaultPawnArchetype.Class,,, StartSpot.Location, StartRotation, DefaultPawnArchetype);
		}
	}

	// Abort if the default pawn archetype is none
	if (DefaultPawnArchetype == None)
	{
		return None;
	}

	// Spawn and return the pawn
	return Spawn(DefaultPawnClass,,, StartSpot.Location, StartRotation );
}

defaultproperties
{
	DefaultPawnArchetype		= QuasarPawn'QuasarProperties.Pawns.Default'
	DefaultPawnClass			= class'Quasar.QuasarPawn'
	PlayerControllerClass		= class'Quasar.QuasarPlayerController'
	
	HUDType						= class'Quasar.QuasarHUD'
	
	bDelayedStart				= false;
}