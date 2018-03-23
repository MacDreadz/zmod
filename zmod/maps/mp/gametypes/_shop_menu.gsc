#include maps\mp\gametypes\_rank;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_zombie_items;
#include maps\mp\gametypes\_human_items;
/*
Initializes shop items:
name: reference to the item
every item has 7 variables: cost, page, pos, text1, text2, print_text, in_use
ZArray enables to find the name of a item directly by its page & pos in the shop; is used to print the menu
*/
initZShopItem(name, cost, page, pos, text1, text2){
	self.ZMenu[name]["cost"] = cost;
	self.ZMenu[name]["page"] = page;
	self.ZMenu[name]["pos"] = pos;
	self.ZMenu[name]["text1"] = text1 + cost;
	self.ZMenu[name]["text2"] = text2;
	self.ZMenu[name]["print_text"] = "text1";
	self.ZMenu[name]["in_use"] = 0;
	self.ZArray[page][pos] = name; //initializes ZArray
	//level.ZFuncArray[page][pos] = ::[[name]];
}

initHShopItem(name, cost, page, pos, text1, text2){
	self.HMenu[name]["cost"] = cost;
	self.HMenu[name]["page"] = page;
	self.HMenu[name]["pos"] = pos;
	self.HMenu[name]["text1"] = text1 + cost;
	self.HMenu[name]["text2"] = text2;
	self.HMenu[name]["print_text"] = "text1";
	self.HMenu[name]["in_use"] = 0;
	self.HArray[page][pos] = name; //initializes ZArray
	//level.ZFuncArray[page][pos] = ::name;
}

/*
(re)sets the items and its variables
*/
initializeItemFuncArray(){
	level.ZFuncArray[10][3] = [];
	
	level.ZFuncArray[0][0]=::health;
	level.ZFuncArray[0][1]=::wallhack;
	level.ZFuncArray[0][2]=::throwingknife;
	
	level.ZFuncArray[1][0]=::coldblood;
	level.ZFuncArray[1][1]=::ninja;
	level.ZFuncArray[1][2]=::movespeed;
	
	level.ZFuncArray[2][0]= "";
	level.ZFuncArray[2][1]=::stinger;
	level.ZFuncArray[2][2]=::commando;
	
	level.ZFuncArray[3][0]=::blastshield;
	level.ZFuncArray[3][1]=::zriotshield;
	level.ZFuncArray[3][2]=::_suicide;
	
	
	
	level.HFuncArray[10][3] = [];
	
	level.HFuncArray[0][0]=::ammo;
	level.HFuncArray[0][1]=::extendedmags;
	level.HFuncArray[0][2]=::sight;
	
	level.HFuncArray[1][0]=::smg;
	level.HFuncArray[1][1]=::assault;
	level.HFuncArray[1][2]=::lmg;
	
	level.HFuncArray[2][0]=::pistol;
	level.HFuncArray[2][1]=::shotgun;
	level.HFuncArray[2][2]=::sniper;
	
	level.HFuncArray[3][0]=::hriotshield;
	level.HFuncArray[3][1]=::akimbo;
	level.HFuncArray[3][2]=::repair;
	
	level.HFuncArray[4][0]=::steadyaim;
	level.HFuncArray[4][1]=::sleightofhand;
	level.HFuncArray[4][2]=::rpg;
	
	level.HFuncArray[5][0]=::predator_missile;
	level.HFuncArray[5][1]=::harrier_airstrike;
	level.HFuncArray[5][2]=::helicopter_flares;
	
	level.HFuncArray[6][0]=::sentry;
	level.HFuncArray[6][1]=::helicopter_minigun;
	level.HFuncArray[6][2]=::ac130;
	
	level.HFuncArray[7][0]=::stealth_airstrike;
	level.HFuncArray[7][1]=::artillery;
	level.HFuncArray[7][2]=::nuke;
	
	level.HFuncArray[8][0]=::betterdevils;
	level.HFuncArray[8][1]=::grimreaper;
}
resetZMenu(){
	initZShopItem("health", 50, 0, 0, "Buy Health - ", "^1Max Health achieved");
	initZShopItem("wallhack", 200, 0, 1, "Buy Wallhack - ", "^1Wallhack activated");
	initZShopItem("throwingknife", 300, 0, 2, "Buy a Throwing Knife - ", "^1Throwing Knife equipped");
	
	initZShopItem("coldblood", 250, 1, 0, "Buy Coldblood - ", "^1Coldblood activated");
	initZShopItem("ninja", 100, 1, 1, "Buy Ninja - ", "^1Ninja activated");
	initZShopItem("movespeed", 50, 1, 2, "Buy Movespeed - ", "^1Max Movespeed achieved");
	
	initZShopItem("placeholder", 100, 2, 0, "Buy PLACEHOLDER - ", "^1PLACEHOLDER activated");
	initZShopItem("stinger", 150, 2, 1, "Buy Stinger - ", "^1Stinger equipped");
	initZShopItem("commando", 200, 2, 2, "Buy Commando - ", "^1Commando activated");
	
	initZShopItem("blastshield", 300, 3, 0, "Buy Blastshield - ", "^1Equip/Unequip Blastshield");
	initZShopItem("riotshield", 300, 3, 1, "Buy Riotshield - ", "^1 Riotshield equipped");
	initZShopItem("suicide", "", 3, 2, "Suicide", "");
}
resetHMenu(){
	initHShopItem("ammo", 100, 0, 0, "Buy Ammo - ", "^1current weapon ammo full");
	initHShopItem("extendedmags", 150, 0, 1, "Buy Extended Mags - ", "^1Extended Mags equipped");
	initHShopItem("sight", 50, 0, 2, "Unlock Sights - ", "Swap Sight");
	
	initHShopItem("smg", 150, 1, 0, "Exchange current weapon for SMG - ", "Swap SMG");
	initHShopItem("assault", 150, 1, 1, "Exchange current weapon for AR - ", "Swap AR");
	initHShopItem("lmg", 150, 1, 2, "Exchange current weapon for LMG - ", "Swap LMG");
	
	initHShopItem("pistol", 150, 2, 0, "Exchange current weapon for Pistol - ", "Swap Pistol");
	initHShopItem("shotgun", 150, 2, 1, "Exchange current weapon for Shotgun - ", "Swap Shotgun");
	initHShopItem("sniper", 150, 2, 2, "Exchange current weapon for Sniper - ", "Swap Sniper");
	
	initHShopItem("riotshield", 200, 3, 0, "Buy Riotshield - ", "^1Riotshield already equipped");
	initHShopItem("akimbo", 50, 3, 1, "Buy Akimbo - ", "^1Akimbo unavailable");
	initHShopItem("repair", 250, 3, 2, "Buy Repair Tool  - ", "^1Unavailable");
	
	initHShopItem("steadyaim", 100, 4, 0, "Buy Steady Aim - ", "^1Steady Aim equipped");	
	initHShopItem("sleightofhand", 150, 4, 1, "Buy Sleight of Hand - ", "^1Sleight of Hand equipped");
	initHShopItem("rpg", 50, 4, 2, "Buy RPG - ", "^1Unavailable");
	
	initHShopItem("predator_missile", 150, 5, 0, "Buy Predator - ", "");
	initHShopItem("harrier_airstrike", 450, 5, 1, "Buy Harrier - ", ""); //harrier
	initHShopItem("helicopter_flares", 500, 5, 2, "Buy Pavelow - ", ""); //pavelow
	
	initHShopItem("sentry", 450, 6, 0, "Buy Sentry - ", "");
	initHShopItem("helicopter_minigun", 800, 6, 1, "Buy Chopper - ", ""); //helicopter_minigun
	initHShopItem("ac130", 1000, 6, 2, "Buy AC-130 - ", "");
	
	initHShopItem("stealth_airstrike", 250, 7, 0, "Buy Stealth Bomber - ", ""); //stealthbomber
	initHShopItem("artillery", 400, 7, 1, "Buy Artillery Strike - ", "");
	initHShopItem("nuke", 3550, 7, 2, "Buy Nuke - ", "");
	
	initHShopItem("betterdevils", 500, 8, 0, "Buy Better Devils - ", "");
	initHShopItem("grimreaper", 500, 8, 1, "Buy Grimreaper - ", "");
	//initHShopItem("empty2", 100, 1, 1, "PLAcEHOLDER ", "^");
	
	
	//initHShopItem("empty3", 200, 2, 0, "PLACEHOLDER", "");
	
	//initHShopItem("empty0", 50, 2, 2, "Buy PLACEHOLDER - ", "");
	
	
	
	//initHShopItem("empty1", 200, 4, 0, "PLACEHOLDER", "");
	
	
	

	
	


	
	
	
	
	
	
	
	
}
/*
builds the array.
*/
initializeZMenu(){
	self.ZMenu[100][7] = [];
	self.ZArray[10][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	resetZMenu();
}
initializeHMenu(){
	self.HMenu[100][7] = [];
	self.HArray[10][3] = []; //stores name of shop item in regard to position; is used for printing the menu
	resetHMenu();
}
getZItemVal(item_name, var){
	return self.ZMenu[item_name][var];
}
setZItemVal(item_name, var, value){
	self.Zmenu[item_name][var] = value;
}
getHItemVal(item_name, var){
	return self.HMenu[item_name][var];
}
setHItemVal(item_name, var, value){
	self.Hmenu[item_name][var] = value;
}


giveZUpgrades(){ //gives the player the upgrades which he acquired through the shop + default perks (on respawn)
	self _clearPerks();
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_thermal");
	if(self getZItemVal("health", "in_use")>0){
		self.maxhealth = self.maxhp;
		self.health = self.maxhp;
		self notify("HEALTH");
	}
	if(self getZItemVal("movespeed", "in_use")>0){
		self.moveSpeedScaler = 1.0+self getZItemVal("movespeed", "in_use")*0.1;
		self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
	}else{
		self.moveSpeedScaler = 1;
		self maps\mp\gametypes\_weapons::updateMoveSpeedScale( "primary" );
	}
	if(self getZItemVal("coldblood", "in_use")>0){
		self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
		self maps\mp\perks\_perks::givePerk("specialty_spygame");
	}
	if(self getZItemVal("ninja", "in_use")>0){
		self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
		self maps\mp\perks\_perks::givePerk("specialty_quieter");
	}
	if(self getZItemVal("commando", "in_use")>0){
		self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
		self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	}
	
	if (self getZItemVal("blastshield", "in_use")==1)
	{
		self maps\mp\perks\_perks::givePerk("specialty_blastshield");
	}
	
	if(self getZItemVal("throwingknife", "in_use")>0)
	{
		self maps\mp\perks\_perks::givePerk( "throwingknife_mp" );
		self setWeaponAmmoClip("throwingknife_mp", 1);
		self thread monitorThrowingKnife();
	}
	
	switch(self getZItemVal("stinger", "in_use"))
	{
		case 1:
		self giveWeapon("stinger_mp", 0, false);
		self setWeaponAmmoClip("stinger_mp", 1);
		self setWeaponAmmoStock("stinger_mp", 0);
		self thread monitorZWeaponAmmo("stinger");
		break;
		case 2:
		self giveWeapon("stinger_mp", 0, false);
		self setWeaponAmmoClip("stinger_mp", 1);
		self setWeaponAmmoStock("stinger_mp", 1);
		self thread monitorZWeaponAmmo("stinger");
		break;
		default:
		break;
	}
	
	if(self getZItemVal("riotshield", "in_use")==1){
		self giveWeapon("riotshield_mp", 0, false);
	}
	
	if(self getZItemVal("wallhack", "in_use")==1){
		self ThermalVisionFOFOverlayOn();
	}
	
	self notify("MENUCHANGE_2");
}

doZombieShop()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self.buttonPressed[ "+smoke" ] == 1){ 													
		self.buttonPressed[ "+smoke" ] = 0;			
			self [[level.ZFuncArray[self.menu][0]]]();
		}
		if(self.buttonPressed[ "+actionslot 2" ] == 1){ 													
		self.buttonPressed[ "+actionslot 2" ] = 0;			
			self [[level.ZFuncArray[self.menu][1]]]();
		}
		if(self.buttonPressed[ "+actionslot 4" ] == 1){ 													
		self.buttonPressed[ "+actionslot 4" ] = 0;			
			self [[level.ZFuncArray[self.menu][2]]]();
		}
		
		wait 0.1;
	}
}

doHumanShop()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		if(self.buttonPressed[ "+smoke" ] == 1){ 													
		self.buttonPressed[ "+smoke" ] = 0;			
			self [[level.HFuncArray[self.menu][0]]]();
		}
		if(self.buttonPressed[ "+actionslot 2" ] == 1){ 													
		self.buttonPressed[ "+actionslot 2" ] = 0;			
			self [[level.HFuncArray[self.menu][1]]]();
		}
		if(self.buttonPressed[ "+actionslot 4" ] == 1){ 													
		self.buttonPressed[ "+actionslot 4" ] = 0;			
			self [[level.HFuncArray[self.menu][2]]]();
		}
		
		wait 0.1;
	}
}

monitorWeapons(){	
	self endon("disconnect");
	self endon("death");
	while(1){
		
		//self iprintlnbold(self getCurrentWeapon());
		wait 0.5;
		//self iPrintlnBold(self isOnGround());
		/*
		Updates text to print for when akimbo is available/unavailable
		*/
		if(self.attach["akimbo"] != 1) self setHItemVal("akimbo", "print_text", "text2");
		else self setHItemVal("akimbo", "print_text", "text1");
		
		if(self getHItemVal("sight", "in_use")==1) self setHItemVal("sight", "print_text", "text2");
		else self setHItemVal("sight", "print_text", "text1");
		
		if(!(self getCurrentWeapon()=="none")){ //makes sure to not change anything if current weapon is "none" (for example while climbing), so just keeps state from before player started climbing
			foreach(weaponclass in level.weaponclasses){
			basename = strtok(weaponclass, "_");
			modweaponclass = getWeaponClass(self getCurrentWeapon());
			if(modweaponclass=="weapon_machine_pistol") modweaponclass="weapon_pistol";
				if(modweaponclass==weaponclass) self setHItemVal(basename[1], "print_text", "text2");
				else  self setHItemVal(basename[1], "print_text", "text1");
					self notify("MENUCHANGE_2");
			}
		}
	}
}


monitorZWeaponAmmo(weapon)
{
	self endon("disconnect");
	self endon("death");
	prevWeapon = self getCurrentWeapon();
	while(self getZItemVal(weapon, "in_use")>0)
	{
		self setZItemVal(weapon, "in_use", self getWeaponAmmoClip(weapon+"_mp") + self getWeaponAmmoStock(weapon+"_mp"));
		self waittill ("weapon_fired");
		wait 0.1;
		self notify("MENUCHANGE_2");
	}
	self setZItemVal(weapon, "in_use", 0);
	self takeWeapon(weapon+"_mp");
	self switchToWeapon(prevWeapon);
	self setZItemVal(weapon, "print_text", "text1");
}
