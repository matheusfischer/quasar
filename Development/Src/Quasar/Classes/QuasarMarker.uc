class QuasarMarker extends Actor
	HideCategories(Movement, Display, Attachment, Physics, Advanced, Debug, Object, Mobile)
	ClassGroup(Quasar)
	placeable;
	
var(Marker) SpriteComponent Sprite;
var(Marker) string Message;

var(MarkerCollision) CylinderComponent CylinderComponent;
	
defaultproperties
{
	Message				= "Simple Marker."
	
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Note'
		HiddenGame=false
		HiddenEditor=false
		SpriteCategoryName="Marker"
	End Object
	Components.Add(Sprite)
	Sprite=Sprite
	
	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=+0034.000000
		CollisionHeight=+0078.000000
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}