class QuasarHUD extends HUD;

var Texture2D CrosshairTexture;
var float CrosshairRelativeSize;
var float CrosshairU;
var float CrosshairV;
var float CrosshairUL;
var float CrosshairVL;
var Color CrosshairColor;

var vector AimLocation;
var vector AimDir;

function PreCalcValues()
{
	Super.PreCalcValues();
}

event PostRender()
{
	Super.PostRender();

	CalculateAimPos();
	
	RenderStats();
	
	RenderCrosshair(self);
	
	RenderHitInfo();

	if (QuasarPlayerController(PlayerOwner).PlayerDebug)
	{
		RenderPlayerLines();
	}
	
	RenderInventory();
	
	RenderQuickSlots();
	
	RenderOthers();
	
	RenderNotes();
}

function RenderNotes()
{
	local QuasarPawn Player;
	local QuasarMarker Marker;
	local vector Pos, HitLoc, HitNormal;
	local Actor TraceRes;
	
	Player = QuasarPawn(PlayerOwner.Pawn);
	
	foreach AllActors(class'QuasarMarker', Marker)
	{
		TraceRes = Trace(HitLoc, HitNormal, Marker.Location, Player.Location);
		
		PlayerOwner.ClientMessage(TraceRes);
		
		if (TraceRes.IsA('QuasarMarker'))
		{
			Pos = self.Canvas.Project(Marker.Location);
			
			self.Canvas.SetPos(Pos.X, Pos.Y);
			self.Canvas.DrawText(Marker.Message);
		}
		
		
		
		self.Draw3DLine(Player.Location, Marker.Location, self.Canvas.DrawColor);
	}
}

function RenderQuickSlots()
{
	local float BoxX, BoxY;
	
	BoxX = 200;
	BoxY = 80;
	
	self.Canvas.SetPos(((SizeX * 0.5f) - ((BoxX + 10) * 3)), SizeY - 10 - BoxY);
	self.Canvas.SetDrawColor(0, 0, 0, 60);
	self.Canvas.DrawRect(BoxX, BoxY);
	
	self.Canvas.SetPos(((SizeX * 0.5f) - ((BoxX + 10) * 2)), SizeY - 10 - BoxY);
	self.Canvas.SetDrawColor(0, 0, 0, 60);
	self.Canvas.DrawRect(BoxX, BoxY);	
	
	self.Canvas.SetPos((SizeX * 0.5f) - BoxX, SizeY - 10 - BoxY);
	self.Canvas.SetDrawColor(0, 0, 0, 60);
	self.Canvas.DrawRect(BoxX, BoxY);
}

function RenderOthers()
{
	local float XL, YL, LastY;
	
	self.Canvas.Font = class'Engine'.Static.GetSmallFont();
	self.Canvas.TextSize("BuildNo: "$QuasarGame(WorldInfo.Game).ConfigurationInfo.BuildNo, XL, YL);
	
	self.Canvas.SetDrawColor(255, 255, 255, 255);
	self.DrawShadowText("BuildNo: "$QuasarGame(WorldInfo.Game).ConfigurationInfo.BuildNo, self.SizeX - XL - 10, self.SizeY - YL - 10, self.Canvas.DrawColor);
	LastY = YL;
	
	self.Canvas.TextSize("BuildDate: "$class'Engine'.static.GetBuildDate(), XL, YL);
	self.DrawShadowText("BuildDate: "$class'Engine'.static.GetBuildDate(), self.SizeX - XL - 10, self.SizeY - YL - 10 - LastY, self.Canvas.DrawColor);
}

function RenderStats()
{
	local QuasarPawn Player;
	local float XL, YL, LastX;
	
	Player = QuasarPawn(PlayerOwner.Pawn);

	self.Canvas.SetPos(0, 0);
	self.Canvas.SetDrawColor(0, 0, 0, 60);
	self.Canvas.DrawRect(SizeX, 25);
	self.Canvas.SetDrawColor(255, 255, 255, 100);
	self.Canvas.Draw2DLine(0, 24, SizeX, 24, Canvas.DrawColor);
	
	self.Canvas.SetDrawColor(255, 255, 255, 255);
	self.DrawShadowText("Quasar", 5, 3, self.Canvas.DrawColor);
	
	self.Canvas.TextSize("Quasar", XL, YL);
	
	self.Canvas.SetDrawColor(255, 255, 0, 255);
	self.DrawShadowText("Q$"$Player.InventoryManager.Gold, XL + 15, 3, self.Canvas.DrawColor);
	
	LastX = XL + 15;
	
	self.Canvas.TextSize("Q$"$Player.InventoryManager.Gold, XL, YL);
	
	self.Canvas.SetDrawColor(255, 255, 255, 255);
	self.DrawShadowText("Inventory: "$Player.InventoryManager.Backpack.Length$"/"$Player.InventoryManager.Capacity$" Slots", LastX + XL + 15, 3, self.Canvas.DrawColor);
	
	LastX = XL + 15;
}

function RenderInventory()
{
	local QuasarPawn Player;
	local QuasarPickup CurrentItem;
	local int i;
	local float BoxH;

	Player = QuasarPawn(PlayerOwner.Pawn);
	
	if (Player.InventoryManager.Backpack.Length > 0)
	{
		BoxH = (Player.InventoryManager.Backpack.Length * 20 + 5);
		
		self.Canvas.Font = class'Engine'.Static.GetSmallFont();
		
		self.Canvas.SetPos(10, 35);
		self.Canvas.SetDrawColor(0, 0, 0, 60);
		self.Canvas.DrawRect(150, BoxH);
		self.Canvas.SetDrawColor(255, 255, 255, 100);
		self.Canvas.Draw2DLine(12, 36, 159, 36, self.Canvas.DrawColor);
		self.Canvas.Draw2DLine(12, BoxH + 34, 159, BoxH + 34, self.Canvas.DrawColor);
		self.Canvas.Draw2DLine(12, 36, 11, BoxH + 34, self.Canvas.DrawColor);
		self.Canvas.Draw2DLine(159, 36, 159, BoxH + 33, self.Canvas.DrawColor);
		
		self.Canvas.SetDrawColor(255, 255, 255, 255);
		
		
		for(i = 0; i < Player.InventoryManager.Backpack.Length; i++)
		{
			CurrentItem = Player.InventoryManager.Backpack[i].Item;
			
			self.Canvas.SetPos(15, 25 * (i + 1));
			
			if (!CurrentItem.Stack)
			{
				self.DrawShadowText("Slot "$(i+1)$": "$CurrentItem.ItemName$"", 18, (20 * (i + 1)) + 20, self.Canvas.DrawColor);
			}
			else
			{
				self.DrawShadowText("Slot "$(i+1)$": "$CurrentItem.ItemName$" ("$Player.InventoryManager.Backpack[i].Quantity$")", 18, (20 * (i + 1)) + 20, self.Canvas.DrawColor);
			}
		}
	}
}

function DrawShadowText(string Text, float X, float Y, Color C)
{
	self.Canvas.SetPos(X+1, Y+1);
	self.Canvas.SetDrawColor(0, 0, 0, 255);
	self.Canvas.DrawText(Text);
	self.Canvas.DrawColor = C;
	self.Canvas.SetPos(X, Y);
	self.Canvas.DrawText(Text);
}

function CalculateAimPos()
{
	local vector2d Center;

	Center.X = self.SizeX * 0.5f;
	Center.Y = self.SizeY * 0.5f;
	
	self.Canvas.DeProject(Center, AimLocation, AimDir);
}

function RenderPlayerLines()
{
	local QuasarPawn Player;
	local vector PlayerBaseLocation;
	local Rotator PlayerRotation, LeftRotation, RightRotation;
	local float Length;
	
	Length = 16384.0f;
	
	Player = QuasarPawn(PlayerOwner.Pawn);
	PlayerBaseLocation = Player.Location + QuasarCamera(PlayerOwner.PlayerCamera).CameraProperties.CameraOffset;
	PlayerRotation = Player.Rotation;
	PlayerRotation.Roll = 0;
	PlayerRotation.Pitch = 0;
	
	LeftRotation = PlayerRotation;
	LeftRotation.Yaw -= 8192;
	
	RightRotation = PlayerRotation;
	RightRotation.Yaw += 8192;
	
	self.Canvas.SetDrawColor(255, 0, 0, 123);
	
	self.Draw3DLine(PlayerBaseLocation + normal(vector(PlayerRotation)) * Length, PlayerBaseLocation, self.Canvas.DrawColor);
	self.Draw3DLine(PlayerBaseLocation + normal(vector(LeftRotation)) * Length, PlayerBaseLocation, self.Canvas.DrawColor);
	self.Draw3DLine(PlayerBaseLocation + normal(vector(RightRotation)) * Length, PlayerBaseLocation, self.Canvas.DrawColor);
}

function RenderCrosshair(HUD HUD)
{
	local float CrosshairSize;
	local Vector HitLocation, HitNormal;
	local Rotator ViewRotation;
	local Actor HitActor;

	CrosshairSize = CrosshairRelativeSize * self.SizeX;
	ViewRotation = PlayerOwner.Pawn.GetViewRotation();
	
	HitActor = Trace(HitLocation, HitNormal, self.AimLocation + Vector(ViewRotation) * 16384.f, self.AimLocation, true,,,);
	
	QuasarPawn(PlayerOwner.Pawn).CrosshairTrace = HitActor;

	
	self.Canvas.SetPos((CenterX - (CrosshairSize * 0.5f)) + 1 , (CenterY - (CrosshairSize * 0.5f)) + 1);
	self.Canvas.SetDrawColor(0, 0, 0, 123);
	self.Canvas.DrawTile(CrosshairTexture, CrosshairSize, CrosshairSize, CrosshairU, CrosshairV, CrosshairUL, CrosshairVL);
	self.Canvas.SetPos(CenterX - (CrosshairSize * 0.5f), CenterY - (CrosshairSize * 0.5f));
	
	if (HitActor.IsA('QuasarPickup'))
	{
		if (QuasarPickup(HitActor).IsInRange(self.PlayerOwner.Pawn))
		{
			self.Canvas.SetDrawColor(0, 255, 0, 255);
		}
		else
		{
			self.Canvas.SetDrawColor(255, 0, 0, 255);
		}
	}
	else
	{
		self.Canvas.SetDrawColor(255, 255, 255, 255);
	}
	
	self.Canvas.DrawTile(CrosshairTexture, CrosshairSize, CrosshairSize, CrosshairU, CrosshairV, CrosshairUL, CrosshairVL);
}

function RenderHitInfo()
{
	local Actor Hit;
	
	Hit = QuasarPawn(PlayerOwner.Pawn).CrosshairTrace;

	if (Hit.IsA('QuasarPickup'))
	{
		(QuasarPickup(Hit)).DrawInfo(self, QuasarPawn(PlayerOwner.Pawn));
	}
}

defaultproperties
{
	CrosshairTexture			= Texture2D'UI_HUD.HUD.UTCrossHairs'
	CrosshairRelativeSize		= 0.0078125
	
	CrosshairU					= 380.000000
	CrosshairV					= 320.0
	
	CrosshairUL					= 27.000000
	CrosshairVL					= 27.000000
	
	CrosshairColor				= (R=255,G=255,B=255,A=255)
}