class QuasarCamera extends Camera;

var const QuasarCameraProperties CameraProperties;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	self.DefaultFOV = CameraProperties.FOV;
}

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local Pawn Pawn;
	local Vector V, PotentialCameraLocation, HitLocation, HitNormal;
	local Actor HitActor;
	local CameraActor CameraActor;

	if (CameraProperties == None)
	{
		Super.UpdateViewTarget(OutVT, DeltaTime);
	}

	if (PendingViewTarget.Target != None && OutVT == ViewTarget && BlendParams.bLockOutgoing)
	{
		return;
	}

	// Viewing through a camera actor
	CameraActor = CameraActor(OutVT.Target);
	if (CameraActor != None)
	{
		CameraActor.GetCameraView(DeltaTime, OutVT.POV);

		// Grab aspect ratio from the CameraActor.
		bConstrainAspectRatio = bConstrainAspectRatio || CameraActor.bConstrainAspectRatio;
		OutVT.AspectRatio = CameraActor.AspectRatio;

		// See if the CameraActor wants to override the PostProcess settings used.
		CamOverridePostProcessAlpha = CameraActor.CamOverridePostProcessAlpha;
		CamPostProcessSettings = CameraActor.CamOverridePostProcess;
	}
	else
	{
		// Viewing through a pawn
		Pawn = Pawn(OutVT.Target);
		if (Pawn != None)
		{
			// If the camera properties have a valid pawn socket name, then start the camera location from there
			if (Pawn.Mesh != None && Pawn.Mesh.GetSocketByName(CameraProperties.PawnSocketName) != None)
			{
				Pawn.Mesh.GetSocketWorldLocationAndRotation(CameraProperties.PawnSocketName, OutVT.POV.Location, OutVT.POV.Rotation);
			}
			// Otherwise grab it from the target eye view point
			else
			{
				OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
			}

			// If the camera properties forces the camera to always use the target rotation, then extract it now
			if (CameraProperties.UseTargetRotation)
			{
				OutVT.Target.GetActorEyesViewPoint(V, OutVT.POV.Rotation);
			}

			// Add the camera offset
			OutVT.POV.Rotation += CameraProperties.CameraRotationOffset;
			// Calculate the potential camera location
			PotentialCameraLocation = OutVT.POV.Location + (CameraProperties.CameraOffset >> OutVT.POV.Rotation);		

			// Trace out to see if the potential camera location will be acceptable or not
			HitActor = Trace(HitLocation, HitNormal, PotentialCameraLocation, OutVT.POV.Location, true,,, TRACEFLAG_BULLET);
			// Check if the trace hit world geometry, if so then use the hit location offseted by the hit normal
			if (HitActor != None && HitActor.bWorldGeometry)
			{
				OutVT.POV.Location = HitLocation + HitNormal * 16.f;
			}
			else
			{
				OutVT.POV.Location = PotentialCameraLocation;
			}
		}
	}

	// Apply camera modifiers such as camera anims
	ApplyCameraModifiers(DeltaTime, OutVT.POV);
}

defaultproperties
{
	CameraProperties			= QuasarCameraProperties'QuasarProperties.Camera.Default'
}