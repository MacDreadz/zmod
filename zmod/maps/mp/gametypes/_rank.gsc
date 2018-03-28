/* No one likes egotistical faggots. This bitch has GPL. */
/* big thanks to chaz for the patch and his help.*/
/* Edited by [UD]Funky */

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_shop_menu;
#include maps\mp\gametypes\_SpawnPoints;







doFX()
{
  if(self.pers["team"] == "axis")
  {
    playFxOnTag( level.spawnGlow["enemy"], self, "pelvis" ); //red
  }
  if(self.pers["team"] == "allies")
  {
    playFxOnTag( level.spawnGlow["friendly"], self, "j_head" ); //green
  }
}

assistedKill(who)
{
  if (level.gameState != "playing" || who.team == self.team)
  return;
  earn = 0;
  if (self.team == "allies")
  earn = 25;
  else
  if (self.team == "axis")
  earn = 50;
  //self justScorePopup("Assist: +$" + earn);
  self justScorePopup("Assist: +$");
  self statCashAdd(earn);
}
killedPlayer(who, weap)
{
	if (self.team == who.team || level.gameState != "playing")
		return;
	if (self.team == who.team)
		return;
	//processChallengeKill(self, who, weap);
	if (self.isZombie != 0)
	{
		amount = 100 + (50 * self.combo);

		self statCashAdd(amount);
		self.combo++;
		if (self.combo > 1)
			self thread justScorePopup("Kill Combo! x" + self.combo + " +$" + amount);
		else
			self thread justScorePopup("Killed Human! +$" + amount);
		self notify("CASH");
	}
	else
	{
		who statCashAdd(50);
		who justScorePopup("Died! +$50");

		earn = 50;
		if (weap == "melee_mp")
		{
			earn *= 4;
			self thread justScorePopup("Melee Kill! +$" + earn);
		}
		else
			self thread justScorePopup("Killed Zombie! +$" + earn);
		self statCashAdd(earn);
	}
}



GetCursorPos()
{
  forward = self getTagOrigin("tag_eye");
  end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
  location = BulletTrace( forward, end, 0, self)[ "position" ];
  return location;
}

vector_scal(vec, scale)
{
  vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
  return vec;
}




destroyTrace()
{
  if (isDefined(level.bosspoint))
  {
    level.bosspoint destroy();
    level.bosspoint = undefined;
  }
}

buildWeaponName( baseName, attachment1, attachment2 )
{
  if( !isDefined( level.letterToNumber ) )
  {
    level.letterToNumber = makeLettersToNumbers();
  }
  if ( getDvarInt ( "scr_game_perks" ) == 0 )
  {
    attachment2 = "none";
    if ( baseName == "onemanarmy" )
    {
      return ( "beretta_mp" );
    }
  }
  weaponName = baseName;
  attachments = [];
  if ( attachment1 != "none" && attachment2 != "none" )
  {
    if ( level.letterToNumber[attachment1[0]] < level.letterToNumber[attachment2[0]] )
    {
      attachments[0] = attachment1;
      attachments[1] = attachment2;
    }
    else
    if ( level.letterToNumber[attachment1[0]] == level.letterToNumber[attachment2[0]] )
    {
      if ( level.letterToNumber[attachment1[1]] < level.letterToNumber[attachment2[1]] )
      {
        attachments[0] = attachment1;
        attachments[1] = attachment2;
      }
      else
      {
        attachments[0] = attachment2;
        attachments[1] = attachment1;
      }
    }
    else
    {
      attachments[0] = attachment2;
      attachments[1] = attachment1;
    }
  }
  else
  if ( attachment1 != "none" )
  {
    attachments[0] = attachment1;
  }
  else
  if ( attachment2 != "none" )
  {
    attachments[0] = attachment2;
  }
  foreach ( attachment in attachments )
  {
    weaponName += "_" + attachment;
  }
  return ( weaponName + "_mp" );
}

makeLettersToNumbers()
{
  array = [];
  array["a"] = 0;
  array["b"] = 1;
  array["c"] = 2;
  array["d"] = 3;
  array["e"] = 4;
  array["f"] = 5;
  array["g"] = 6;
  array["h"] = 7;
  array["i"] = 8;
  array["j"] = 9;
  array["k"] = 10;
  array["l"] = 11;
  array["m"] = 12;
  array["n"] = 13;
  array["o"] = 14;
  array["p"] = 15;
  array["q"] = 16;
  array["r"] = 17;
  array["s"] = 18;
  array["t"] = 19;
  array["u"] = 20;
  array["v"] = 21;
  array["w"] = 22;
  array["x"] = 23;
  array["y"] = 24;
  array["z"] = 25;
  return array;
}

isValidWeapon( refString )
{
  if ( !isDefined( level.weaponRefs ) )
  {
    level.weaponRefs = [];
    foreach ( weaponRef in level.weaponList )
    {
      level.weaponRefs[weaponRef] = true;
    }
  }
  if ( isDefined( level.weaponRefs[refString] ) )
  {
    return true;
  }
  assertMsg( "Replacing invalid weapon/attachment combo: " + refString );
  return false;
}



statCashAdd(amount)
{
  if (self.bounty + amount < 99999)
  self.bounty += amount;
  else
  self.bounty = 99999;
  self notify("CASH");
  self.cash maps\mp\gametypes\_zmod_hud::doTextPulse("cash");
}

statCashSub(amount)
{
  if (self.bounty - amount > 0)
  self.bounty -= amount;
  else
  self.bounty = 0;
  self notify("CASH");
  self.cash maps\mp\gametypes\_zmod_hud::doTextPulse("cash", 0.6);
}



statLivesInc(amount)
{
  if (self.lives < level.maxlives)
  self.lives++;
  self notify("LIVES");
  self.lifetext maps\mp\gametypes\_zmod_hud::doTextPulse("life");
}

statLivesDec(amount)
{
  if (self.lives > 0)
  self.lives--;
  self notify("LIVES");
  self.lifetext maps\mp\gametypes\_zmod_hud::doTextPulse("life", 0.6);
}

statMaxHealthAdd(amount)
{
  self.maxhealth += amount;
  self.health += amount;
  self notify("HEALTH");
  self.healthtext maps\mp\gametypes\_zmod_hud::doTextPulse("health");
}

doInit()
{
  level.gameState = "";
  level.ShowCreditShop = false;
  level weaponInit();
  level CreateServerHUD();
  level.infotext setText("^2Cycle Menu: ^3[{+actionslot 3}]^7/^3[{+actionslot 1}]");
  level thread OverRider();
  maps\mp\gametypes\_gamestate_logic::CleanupKillstreaks();
  level.mapwait = 0;

  level initializeItemFuncArray();
  level InitializeSpawnPoints();
  level thread maps\mp\gametypes\MapEdit::init();

  setDvar("g_gametype", "war");
  setDvar("ui_gametype", "war");
  setDvar("scr_war_scorelimit", 0);
  setDvar("scr_war_waverespawndelay", 0);
  setDvar("scr_war_playerrespawndelay", 0);
  wait 2;

  level thread maps\mp\gametypes\_gamestate_logic::doGameStarter();
}

weaponInit()
{
  level.lmg = [];
  level.lmg[0] = "rpd";
  level.weapname["rpd"] = "RPD";
  level.lmg[1] = "sa80";
  level.weapname["sa80"] = "LSW";
  level.lmg[2] = "mg4";
  level.weapname["mg4"] = "MG4";
  level.lmg[3] = "m240";
  level.weapname["m240"] = "M240";
  level.lmg[4] = "aug";
  level.weapname["aug"] = "AUG";

  level.assault = [];
  level.assault[0] = "ak47";
  level.weapname["ak47"] = "AK-47";
  level.assault[1] = "m16";
  level.weapname["m16"] = "M16";
  level.assault[2] = "m4";
  level.weapname["m4"] = "M4";
  level.assault[3] = "fn2000";
  level.weapname["fn2000"] = "F2000";
  level.assault[4] = "masada";
  level.weapname["masada"] = "ACR";
  level.assault[5] = "famas";
  level.weapname["famas"] = "FAMAS";
  level.assault[6] = "fal";
  level.weapname["fal"] = "FAL";
  level.assault[7] = "scar";
  level.weapname["scar"] = "SCAR-H";
  level.assault[8] = "tavor";
  level.weapname["tavor"] = "TAR-21";

  level.sights = [];
  level.sights[0] = "reflex";
  level.sights[1] = "eotech";
  level.sights[2] = "acog";
  level.sights[3] = "";

  level.smg = [];
  level.smg[0] = "mp5k";
  level.weapname["mp5k"] = "MP5K";
  level.smg[1] = "uzi";
  level.weapname["uzi"] = "MINI-UZI";
  level.smg[2] = "p90";
  level.weapname["p90"] = "P90";
  level.smg[3] = "kriss";
  level.weapname["kriss"] = "VECTOR";
  level.smg[4] = "ump45";
  level.weapname["ump45"] = "UMP45";

  level.shot = [];
  level.shot[0] = "ranger";
  level.weapname["ranger"] = "RANGER";
  level.shot[1] = "model1887";
  level.weapname["model1887"] = "MODEL-1887";
  level.shot[2] = "striker";
  level.weapname["striker"] = "STRIKER";
  level.shot[3] = "aa12";
  level.weapname["aa12"] = "AA12";
  level.shot[4] = "m1014";
  level.weapname["m1014"] = "M1014";
  level.shot[5] = "spas12";
  level.weapname["spas12"] = "SPAS-12";

  level.machine = [];
  level.machine[0] = "pp2000";
  level.weapname["pp2000"] = "PP2000";
  level.machine[1] = "glock";
  level.weapname["glock"] = "G18";
  level.machine[2] = "beretta393";
  level.weapname["beretta393"] = "RAFFICA";

  level.hand = [];
  level.hand[0] = "beretta";
  level.hand[1] = "usp";
  level.hand[2] = "deserteagle";
  level.hand[3] = "coltanaconda";
  level.hand[4] = "glock";
  level.hand[5] = "beretta393";
  level.hand[6] = "pp2000";
  level.hand[7] = "tmp";



  level.rifle = [];
  level.rifle[0] = "wa2000";
  level.weapname["wa2000"] = "WA2000";
  level.rifle[1] = "barrett";
  level.weapname["barrett"] = "BARRETT .50CAL";
  level.rifle[2] = "cheytac";
  level.weapname["cheytac"] = "INTERVENTION";
  level.rifle[3] = "m21";
  level.weapname["m21"] = "M21 EBR";

  level.explosives = [];
  level.explosives[0] = "frag";
  level.weapname["frag"] = "FRAG";
  level.explosives[1] = "semtex";
  level.weapname["semtex"] = "SEMTEX";
  level.explosives[2] = "claymore";
  level.weapname["claymore"] = "CLAYMORE";
  level.explosives[3] = "c4";
  level.weapname["c4"] = "C4 CHARGE";

  level.weapname["riotshield"] = "Riotshield";

  level.weaponclasses = [];
  level.weaponclasses[0] = "weapon_lmg";
  level.weaponclasses[1] = "weapon_assault";
  level.weaponclasses[2] = "weapon_smg";
  level.weaponclasses[3] = "weapon_shotgun";
  level.weaponclasses[4] = "weapon_machine_pistol";
  level.weaponclasses[5] = "weapon_pistol";
  level.weaponclasses[6] = "weapon_sniper";
  level.weaponclasses[7] = "weapon_riot";
  level.weaponclasses[8] = "weapon_explosives";
}



OverRider()
{
  for(;;)
  {
    level notify("abort_forfeit");
    level.prematchPeriod = 0;

    if (level.enablekillcam)
    level.killcam = 1;
    else
    level.killcam = 0;
    level.killstreakRewards = 0;
    wait 1;
  }
}



OMAExploitFix()
{
  self endon("disconnect");
  self endon("death");
  while(1)
  {
    if(self _hasPerk("specialty_onemanarmy") || self _hasPerk("specialty_omaquickchange"))
    {
      self _clearPerks();
      self takeAllWeapons();
    }
    wait .5;
  }
}

CashFix()
{
  self endon("disconnect");
  while(1)
  {
    if(self.bounty < 0)
    {
      self.bounty = 0;
      self notify("CASH");
    }
    wait .5;
  }
}

iniButtons()
{
  self.buttonAction = [];
  self.buttonAction[0]="+actionslot 2";
  self.buttonAction[1]="+actionslot 1";
  self.buttonAction[2]="+actionslot 4";
  self.buttonAction[3]="+smoke";
  self.buttonAction[4]="+activate";
  self.buttonAction[5]="+frag";
  self.buttonAction[6]="+actionslot 3";
  self.buttonPressed = [];
  for(i=0;i<self.buttonAction.size;i++)
  {
    self.buttonPressed[self.buttonAction[i]] = 0;
    self thread monitorButtons( self.buttonAction[i] );
  }
}

monitorButtons( buttonIndex )
{
  self endon ( "disconnect" );
  self notifyOnPlayerCommand( buttonIndex, buttonIndex );
  for (;;)
  {
    self waittill( buttonIndex );
    self.buttonPressed[ buttonIndex ] = 1;
    wait .1;
    self.buttonPressed[ buttonIndex ] = 0;
  }
}
fadeOutMenu(dest)
{
  self.menutext fadeOverTime(0.3);
  self.menutext.alpha = 0.2;
  self.option1 fadeOverTime(0.3);
  self.option1.alpha = 0.2;
  self.option2 fadeOverTime(0.3);
  self.option2.alpha = 0.2;
  self.option3 fadeOverTime(0.3);
  self.option3.alpha = 0.2;
  self.option1 fadeOverTime(0.3);
  self.option1.alpha = 0.2;
  self.scrollleft fadeOverTime(0.3);
  self.scrollleft.alpha = 0.1;
  self.scrollright fadeOverTime(0.3);
  self.scrollright.alpha = 0.1;
}

fadeInMenu(dest)
{
  self.menutext fadeOverTime(0.3);
  self.menutext.alpha = 1;
  self.option1 fadeOverTime(0.3);
  self.option1.alpha = 1;
  self.option2 fadeOverTime(0.3);
  self.option2.alpha = 1;
  self.option3 fadeOverTime(0.3);
  self.option3.alpha = 1;
  self.option1 fadeOverTime(0.3);
  self.option1.alpha = 1;
  self.scrollleft fadeOverTime(0.3);
  self.scrollleft.alpha = 1;
  self.scrollright fadeOverTime(0.3);
  self.scrollright.alpha = 1;
}



CreateServerHUD()
{

  level.infotext = NewHudElem();
  level.infotext.alignX = "center";
  level.infotext.alignY = "bottom";
  level.infotext.horzAlign = "center";
  level.infotext.vertAlign = "bottom";
  level.infotext.y = 25;
  level.infotext.foreground = true;
  level.infotext.fontScale = 1;
  level.infotext.font = "objective";
  level.infotext.alpha = 1;
  level.infotext.glow = 0;
  level.infotext.glowColor = ( 0, 0, 0 );
  level.infotext.glowAlpha = 1;
  level.infotext.color = ( 1.0, 1.0, 1.0 );
}

init()
{
  level.scoreInfo = [];
  level.xpScale = getDvarInt( "scr_xpscale" );
  level.rankTable = [];
  precacheShader("white");
  precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
  precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
  precacheString( &"RANK_PROMOTED" );
  precacheString( &"MP_PLUS" );
  precacheString( &"RANK_ROMANI" );
  precacheString( &"RANK_ROMANII" );
  precacheString( &"RANK_ROMANIII" );
  registerScoreInfo("zmod_credits", 0);
  if ( level.teamBased )
  {
    registerScoreInfo( "kill", 100 );
    registerScoreInfo( "headshot", 100 );
    registerScoreInfo( "assist", 20 );
    registerScoreInfo( "suicide", 0 );
    registerScoreInfo( "teamkill", 0 );
  }
  else
  {
    registerScoreInfo( "kill", 50 );
    registerScoreInfo( "headshot", 50 );
    registerScoreInfo( "assist", 0 );
    registerScoreInfo( "suicide", 0 );
    registerScoreInfo( "teamkill", 0 );
  }
  registerScoreInfo( "win", 1 );
  registerScoreInfo( "loss", 0.5 );
  registerScoreInfo( "tie", 0.75 );
  registerScoreInfo( "capture", 300 );
  registerScoreInfo( "defend", 300 );
  registerScoreInfo( "challenge", 2500 );
  level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
  level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));
  pId = 0;
  rId = 0;
  for ( pId = 0; pId <= level.maxPrestige; pId++ )
  {
    for ( rId = 0;rId <= level.maxRank;rId++ )
    {
      precacheShader( tableLookup( "mp/rankIconTable.csv", 0, rId, pId+1 ) );
    }
  }
  rankId = 0;
  rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
  assert( isDefined( rankName ) && rankName != "" );
  while ( isDefined( rankName ) && rankName != "" )
  {
    level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
    level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
    level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
    level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );
    precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );
    rankId++;
    rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
  }
  maps\mp\gametypes\_missions::buildChallegeInfo();

  setDvar("scr_zmod_intermission_time", "10");
  setDvar("scr_zmod_starting_time", "10");
  setDvar("scr_zmod_alpha_time", "10");
  setDvar("scr_zmod_sentry_timeout", "200");
  level thread onPlayerConnect();
  level thread doInit();


}

isRegisteredEvent( type )
{
  if ( isDefined( level.scoreInfo[type] ) )
  {
    return true;
  }
  else
  {
    return false;
  }
}

registerScoreInfo( type, value )
{
  level.scoreInfo[type]["value"] = value;
}

getScoreInfoValue( type )
{
  overrideDvar = "scr_" + level.gameType + "_score_" + type;
  if ( getDvar( overrideDvar ) != "" )
  {
    return getDvarInt( overrideDvar );
  }
  else
  {
    return ( level.scoreInfo[type]["value"] );
  }
}

getScoreInfoLabel( type )
{
  return ( level.scoreInfo[type]["label"] );
}

getRankInfoMinXP( rankId )
{
  return int(level.rankTable[rankId][2]);
}

getRankInfoXPAmt( rankId )
{
  return int(level.rankTable[rankId][3]);
}

getRankInfoMaxXp( rankId )
{
  return int(level.rankTable[rankId][7]);
}

getRankInfoFull( rankId )
{
  return tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 );
}

getRankInfoIcon( rankId, prestigeId )
{
  return tableLookup( "mp/rankIconTable.csv", 0, rankId, prestigeId+1 );
}

getRankInfoLevel( rankId )
{
  return int( tableLookup( "mp/ranktable.csv", 0, rankId, 13 ) );
}


onPlayerConnect()
{

  for(;;)
  {
    level waittill( "connected", player );
    player.isZombie=0;
    player initializeZMenu();
    player initializeHMenu();
    player initializeCMenu();
    player.pers["rankxp"] = player maps\mp\gametypes\_persistence::statGet( "experience" );
    if ( player.pers["rankxp"] < 0 )
    {
      player.pers["rankxp"] = 0;
    }
    rankId = player getRankForXp( player getRankXP() );
    player.pers[ "rank" ] = rankId;
    player.pers[ "participation" ] = 0;
    player.xpUpdateTotal = 0;
    player.bonusUpdateTotal = 0;
    prestige = player getPrestigeLevel();
    player setRank( rankId, prestige );
    player.pers["prestige"] = prestige;
    player.postGamePromotion = false;
    if ( !isDefined( player.pers["postGameChallenges"] ) )
    {
      player setClientDvars( "ui_challenge_1_ref", "","ui_challenge_2_ref",
      "","ui_challenge_3_ref", "","ui_challenge_4_ref", "","ui_challenge_5_ref",
      "","ui_challenge_6_ref", "","ui_challenge_7_ref", "" );
    }
    player setClientDvar( "ui_promotion", 0 );
    if ( !isDefined( player.pers["summary"] ) )
    {
      player.pers["summary"] = [];
      player.pers["summary"]["xp"] = 0;
      player.pers["summary"]["score"] = 0;
      player.pers["summary"]["challenge"] = 0;
      player.pers["summary"]["match"] = 0;
      player.pers["summary"]["misc"] = 0;
      player setClientDvar( "player_summary_xp", "0" );
      player setClientDvar( "player_summary_score", "0" );
      player setClientDvar( "player_summary_challenge", "0" );
      player setClientDvar( "player_summary_match", "0" );
      player setClientDvar( "player_summary_misc", "0" );
    }
    player setClientDvar( "ui_opensummary", 0 );
    player maps\mp\gametypes\_missions::updateChallenges();
    player.explosiveKills[0] = 0;
    player.xpGains = [];
    player.hud_scorePopup = newClientHudElem( player );
    player.hud_scorePopup.horzAlign = "center";
    player.hud_scorePopup.vertAlign = "middle";
    player.hud_scorePopup.alignX = "center";
    player.hud_scorePopup.alignY = "middle";
    player.hud_scorePopup.x = 0;
    if ( level.splitScreen )
    {
      player.hud_scorePopup.y = -40;
    }
    else
    {
      player.hud_scorePopup.y = -60;
    }
    player.hud_scorePopup.font = "hudbig";
    player.hud_scorePopup.fontscale = 0.75;
    player.hud_scorePopup.archived = false;
    player.hud_scorePopup.color = (0.5,0.5,0.5);
    player.hud_scorePopup.sort = 10000;
    player.hud_scorePopup maps\mp\gametypes\_hud::fontPulseInit( 3.0 );
    if (level.gameState == "playing" || level.gameState == "ending")
    {
      player.newcomer = 1;
    }
    else
    {
      player.newcomer = 0;
    }

    isd = false;

    player.doorInRange = 0;
    player.wasAlpha = 0;
    player.wasSurvivor = 0;
    //player.credits = player getCreditsPersistent();
    player.credits = 50000;
    player iniButtons();
    player thread maps\mp\gametypes\_shop_menu::destroyOnDeath();
    player thread maps\mp\gametypes\_spawn::onPlayerSpawned();
    player thread CashFix();
    player thread onDisconnect();
    player allowSpectateTeam( "allies", true );
    player allowSpectateTeam( "axis", true );
    player allowSpectateTeam( "freelook", true );
    player allowSpectateTeam( "none", true );

    player.CONNECT = 1;

    //player thread TestSpawnpoints();
	  //player thread CollectSpawnCords();
  }

}


debugtext(){
  while(1){
    self iPrintlnBold(self.team+" "+self.isZombie+" "+game["menu_team"]);
    wait .5;
  }
}










onDisconnect()
{
  self waittill("disconnect");
}

roundUp( floatVal )
{
  if ( int( floatVal ) != floatVal )
  {
    return int( floatVal+1 );
  }
  else
  {
    return int( floatVal );
  }
}
giveRankXP( type, value )
{
  self endon("disconnect");
  lootType = "none";
  if ( !self rankingEnabled() )
  {
    return;
  }
  if ( level.teamBased && (!level.teamCount["allies"] || !level.teamCount["axis"]) )
  {
    return;
  }
  else
  if( !level.teamBased && (level.teamCount["allies"] + level.teamCount["axis"] < 2) )
  {
    return;
  }
  if ( !isDefined( value ) )
  {
    value = getScoreInfoValue( type );
  }
  if ( !isDefined( self.xpGains[type] ) )
  {
    self.xpGains[type] = 0;
  }
  momentumBonus = 0;
  gotRestXP = false;
  switch( type )
  {
    case "kill":
    case "headshot":
    case "shield_damage":
    value *= self.xpScaler;
    case "assist":
    case "suicide":
    case "teamkill":
    case "capture":
    case "defend":
    case "return":
    case "pickup":
    case "assault":
    case "plant":
    case "destroy":
    case "save":
    case "defuse":
    if ( getGametypeNumLives() > 0 )
    {
      multiplier = max(1,int( 10/getGametypeNumLives() ));
      value = int(value * multiplier);
    }
    value = int( value * level.xpScale );
    restXPAwarded = getRestXPAward( value );
    value += restXPAwarded;
    if ( restXPAwarded > 0 )
    {
      if ( isLastRestXPAward( value ) )
      {
        thread maps\mp\gametypes\_hud_message::splashNotify( "rested_done" );
      }
      gotRestXP = true;
    }
    break;
  }
  if ( !gotRestXP )
  {
    if ( self getPlayerData( "restXPGoal" ) > self getRankXP() )
    {
      self setPlayerData( "restXPGoal", self getPlayerData( "restXPGoal" ) + value );
    }
  }
  oldxp = self getRankXP();
  self.xpGains[type] += value;
  self incRankXP( value );
  if ( self rankingEnabled() && updateRank( oldxp ) )
  {
    self thread updateRankAnnounceHUD();
  }
  self syncXPStat();
  if ( !level.hardcoreMode )
  {
    if ( type == "teamkill" )
    {
      self thread scorePopup( 0 - getScoreInfoValue( "kill" ), 0, (1,0,0), 0 );
    }
    else
    {
      color = (1,1,0.5);
      if ( gotRestXP )
      {
        color = (1,.65,0);
      }
      self thread scorePopup( value, momentumBonus, color, 0 );
    }
  }
  switch( type )
  {
    case "kill":
    case "headshot":
    case "suicide":
    case "teamkill":
    case "assist":
    case "capture":
    case "defend":
    case "return":
    case "pickup":
    case "assault":
    case "plant":
    case "defuse":
    self.pers["summary"]["score"] += value;
    self.pers["summary"]["xp"] += value;
    break;
    case "win":
    case "loss":
    case "tie":
    self.pers["summary"]["match"] += value;
    self.pers["summary"]["xp"] += value;
    break;
    case "challenge":
    self.pers["summary"]["challenge"] += value;
    self.pers["summary"]["xp"] += value;
    break;
    default:
    self.pers["summary"]["misc"] += value;
    self.pers["summary"]["match"] += value;
    self.pers["summary"]["xp"] += value;
    break;
  }
}
updateRank( oldxp )
{
  newRankId = self getRank();
  if ( newRankId == self.pers["rank"] )
  {
    return false;
  }
  oldRank = self.pers["rank"];
  rankId = self.pers["rank"];
  self.pers["rank"] = newRankId;
  println( "promoted " + self.name + " from rank " + oldRank + " to " + newRankId + ". Experience went from " + oldxp + " to " + self getRankXP() + "." );
  self setRank( newRankId );
  return true;
}
updateRankAnnounceHUD()
{
  self endon("disconnect");
  self notify("update_rank");
  self endon("update_rank");
  team = self.pers["team"];
  if ( !isdefined( team ) )
  {
    return;
  }
  if ( !levelFlag( "game_over" ) )
  {
    level waittill_notify_or_timeout( "game_over", 0.25 );
  }
  newRankName = self getRankInfoFull( self.pers["rank"] );
  rank_char = level.rankTable[self.pers["rank"]][1];
  subRank = int(rank_char[rank_char.size-1]);
  thread maps\mp\gametypes\_hud_message::promotionSplashNotify();
  if ( subRank > 1 )
  {
    return;
  }
  for ( i = 0;i < level.players.size;i++ )
  {
    player = level.players[i];
    playerteam = player.pers["team"];
    if ( isdefined( playerteam ) && player != self )
    {
      if ( playerteam == team )
      {
        player iPrintLn( &"RANK_PLAYER_WAS_PROMOTED", self, newRankName );
      }
    }
  }
}
endGameUpdate()
{
  player = self;
}

fontPulseNew(player)
{
  self notify ( "fontPulse" );
  self endon ( "fontPulse" );
  self endon( "death" );

  player endon("disconnect");
  player endon("joined_team");
  player endon("joined_spectators");

  self ChangeFontScaleOverTime( self.inFrames * 0.05 );
  self.fontScale = self.maxFontScale;
  wait (self.inFrames * 0.05);

  self ChangeFontScaleOverTime( self.outFrames * 0.05 );
  self.fontScale = self.baseFontScale;
  wait 0.3;

  self fadeOverTime( 0.75 );
  self.alpha = 0;
}


justScorePopup( text )
{
  glowAlpha = (1, 1, 1);
  hudColor = (1,1,0.5);
  self endon( "disconnect" );
  self endon( "joined_team" );
  self endon( "joined_spectators" );
  self notify( "scorePopup" );
  self.hud_scorePopup.color = hudColor;
  self.hud_scorePopup.glowColor = hudColor;
  self.hud_scorePopup.glowAlpha = glowAlpha;
  self.hud_scorePopup setText(text);
  self.hud_scorePopup.alpha = 0.85;
  self.hud_scorePopup thread fontPulseNew( self );
}

scorePopup( amount, bonus, hudColor, glowAlpha )
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	if ( amount == 0 )
	{
		return;
	}
	self notify( "scorePopup" );
	self endon( "scorePopup" );
	self.xpUpdateTotal += amount;
	self.bonusUpdateTotal += bonus;
	wait ( 0.05 );
	increment = max( int( self.bonusUpdateTotal / 20 ), 1 );
	if ( self.bonusUpdateTotal )
	{
		while ( self.bonusUpdateTotal > 0 )
		{
			self.xpUpdateTotal += min( self.bonusUpdateTotal, increment );
			self.bonusUpdateTotal -= min( self.bonusUpdateTotal, increment );
			//self.hud_scorePopup setValue( self.xpUpdateTotal );
			wait ( 0.05 );
		}
	}
	else
		{
			wait ( 1.0 );
		}
	self.xpUpdateTotal = 0;
}
removeRankHUD()
{
  self.hud_scorePopup.alpha = 0;
}
getRank()
{
  rankXp = self.pers["rankxp"];
  rankId = self.pers["rank"];
  if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
  {
    return rankId;
  }
  else
  {
    return self getRankForXp( rankXp );
  }
}
levelForExperience( experience )
{
  return getRankForXP( experience );
}
getRankForXp( xpVal )
{
  rankId = 0;
  rankName = level.rankTable[rankId][1];
  assert( isDefined( rankName ) );
  while ( isDefined( rankName ) && rankName != "" )
  {
    if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
    {
      return rankId;
    }
    rankId++;
    if ( isDefined( level.rankTable[rankId] ) )
    {
      rankName = level.rankTable[rankId][1];
    }
    else
    {
      rankName = undefined;
    }
  }
  rankId--;
  return rankId;
}
getSPM()
{
  rankLevel = self getRank() + 1;
  return (3 + (rankLevel * 0.5))*10;
}
getPrestigeLevel()
{
  return self maps\mp\gametypes\_persistence::statGet( "prestige" );
}

getRankXP()
{
  return self.pers["rankxp"];
}

incRankXP( amount )
{
  if ( !self rankingEnabled() )
  {
    return;
  }
  if ( isDefined( self.isCheater ) )
  {
    return;
  }
  xp = self getRankXP();
  newXp = (xp + amount);
  if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
  {
    newXp = getRankInfoMaxXP( level.maxRank );
  }
  self.pers["rankxp"] = newXp;
}

getRestXPAward( baseXP )
{
  if ( !getdvarint( "scr_restxp_enable" ) )
  {
    return 0;
  }
  restXPAwardRate = getDvarFloat( "scr_restxp_restedAwardScale" );
  wantGiveRestXP = int(baseXP * restXPAwardRate);
  mayGiveRestXP = self getPlayerData( "restXPGoal" ) - self getRankXP();
  if ( mayGiveRestXP <= 0 )
  {
    return 0;
  }
  return wantGiveRestXP;
}

isLastRestXPAward( baseXP )
{
  if ( !getdvarint( "scr_restxp_enable" ) )
  {
    return false;
  }
  restXPAwardRate = getDvarFloat( "scr_restxp_restedAwardScale" );
  wantGiveRestXP = int(baseXP * restXPAwardRate);
  mayGiveRestXP = self getPlayerData( "restXPGoal" ) - self getRankXP();
  if ( mayGiveRestXP <= 0 )
  {
    return false;
  }
  if ( wantGiveRestXP >= mayGiveRestXP )
  {
    return true;
  }
  return false;
}

syncXPStat()
{
  xp = self getRankXP();
  self maps\mp\gametypes\_persistence::statSet( "experience", xp );
}
