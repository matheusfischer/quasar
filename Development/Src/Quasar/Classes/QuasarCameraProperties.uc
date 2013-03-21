class QuasarCameraProperties extends Object
	HideCategories(Object);
	
var(Camera) const Vector CameraOffset;
var(Camera) const Rotator CameraRotationOffset;
var(Camera) const Name PawnSocketName;
var(Camera) const bool UseTargetRotation;
var(Camera) const float FOV;

defaultproperties
{
	FOV					= 90.0f
}