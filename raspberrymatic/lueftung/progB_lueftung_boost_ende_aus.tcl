string VENT_DP  = "BidCos-RF.SEQ3057205:1.STATE";
string SV_UNTIL = "SV_LueftungBoostBis";

string nowS = system.Date("%Y-%m-%d %H:%M:%S");

object svUntil = dom.GetObject(SV_UNTIL);
if (!svUntil) { return; }

string untilS = svUntil.Value().ToString();
if (untilS == "") { return; }

if (nowS >= untilS) {
  dom.GetObject(VENT_DP).State(false);
  svUntil.Value("");
}