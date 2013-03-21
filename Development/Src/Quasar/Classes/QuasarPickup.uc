class QuasarPickup extends KActorSpawnable
	ClassGroup(Quasar)
	placeable
	HideCategories(KActor, StayUprightSpring, Movement, Display, Attachment, Collision, Physics, Advanced, Debug, Object, Navigation, Mobile);
	
var (QuasarPickup) const int ItemID;
var (QuasarPickup) const string ItemName;
var (QuasarPickup) const float Range;
var (QuasarPickup) const bool Stack;

var (QuasarPickup) const ParticleSystem ParticleSystem;
var (QuasarPickup) const vector ParticleSystemOffset;

var ParticleSystemComponent ParticleSystemComponent;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (self.ParticleSystem != None)
	{
		if (self.ParticleSystemComponent == None)
		{
			self.ParticleSystemComponent = new () class'ParticleSystemComponent';
			
			if (self.ParticleSystemComponent != None)
			{
				self.ParticleSystemComponent.SetTemplate(self.ParticleSystem);
				
				self.ParticleSystemComponent.SetTranslation(self.ParticleSystemOffset);
				
				self.AttachComponent(self.ParticleSystemComponent);
			}
		}
		
		if (self.ParticleSystemComponent != None)
		{
			self.ParticleSystemComponent.ActivateSystem();
		}
	}
}

event PickedUp(QuasarPlayerController QPC)
{
	QPC.ClientMessage("Works...");
}

simulated event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
}

function DrawInfo(QuasarHUD HUD, QuasarPawn Player)
{
	local vector ItemScreenPos;
	local float Distance;
	
	ItemScreenPos = HUD.Canvas.Project(self.Location);
	
	ItemScreenPos.X -= 5;
	ItemScreenPos.Y -= 5;
	
	Distance = ((VSize(Player.Location - self.Location)) / 100);
	
	if (self.IsA('QuasarPickup'))
	{
		HUD.Canvas.Font = class'Engine'.Static.GetSmallFont();

		HUD.Canvas.SetDrawColor(0, 0, 0, 123);
		HUD.Canvas.SetPos(ItemScreenPos.X + 1, (ItemScreenPos.Y - 20) + 1);
		HUD.Canvas.DrawText(self.ItemName);
	
		HUD.Canvas.SetDrawColor(255, 255, 255, 255);
		HUD.Canvas.SetPos(ItemScreenPos.X, (ItemScreenPos.Y - 20));
		HUD.Canvas.DrawText(self.ItemName);

		HUD.Canvas.Font = class'Engine'.Static.GetTinyFont();
		
		if (self.IsInRange(Player))
		{
			HUD.Canvas.SetDrawColor(0, 255, 0, 180);
		}
		
		HUD.Canvas.SetDrawColor(0, 0, 0, 123);
		HUD.Canvas.SetPos(ItemScreenPos.X + 1, ItemScreenPos.Y + 1);
		HUD.Canvas.DrawText(Distance$"m");
	
		if (self.IsInRange(Player))
		{
			HUD.Canvas.SetDrawColor(0, 255, 0, 180);
		}
		else
		{
			HUD.Canvas.SetDrawColor(255, 0, 0, 180);
		}
		
		HUD.Canvas.SetPos(ItemScreenPos.X, ItemScreenPos.Y);
		HUD.Canvas.DrawText(Distance$"m");
	}
}

function bool IsInRange(Pawn Player)
{
	return ((VSize(Player.Location - self.Location) / 100.0f) < self.Range);
}
	
defaultproperties
{
	ItemID							= 0;
	ItemName						= "QuasarItem";
	
	Range							= 3.5f;
	
	Stack							= false;
	
	ParticleSystemOffset			= (X=0, Y=0, Z=0);
	
	bWakeOnLevelStart				= true;
	bCollideActors					= true;
}