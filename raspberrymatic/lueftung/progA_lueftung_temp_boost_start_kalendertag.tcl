real   THRESHOLD = 18.0;

string TEMP_DP = "BidCos-RF.JEQ0058916:1.TEMPERATURE";
string VENT_DP = "BidCos-RF.SEQ3057205:1.STATE";

string SV_DAY   = "SV_LueftungBoostDatum";
string SV_UNTIL = "SV_LueftungBoostBis";

integer BOOST_SECONDS = 7200;

real t = dom.GetObject(TEMP_DP).Value();

string today = system.Date("%Y-%m-%d");
string nowS  = system.Date("%Y-%m-%d %H:%M:%S");

object svDay   = dom.GetObject(SV_DAY);
object svUntil = dom.GetObject(SV_UNTIL);

string lastDay = (svDay) ? svDay.Value().ToString() : "";
string untilS  = (svUntil) ? svUntil.Value().ToString() : "";

boolean boostActive = (untilS != "") && (nowS < untilS);

if (t >= THRESHOLD) {
  dom.GetObject(VENT_DP).State(true);
  if (svUntil) { svUntil.Value(""); }
  return;
}

if (boostActive) { return; }

if (lastDay != today) {
  dom.GetObject(VENT_DP).State(true);

  integer nowEpoch = system.Date("%s").ToInteger();
  integer endEpoch = nowEpoch + BOOST_SECONDS;
  string endS = system.Date("%Y-%m-%d %H:%M:%S", endEpoch);

  svUntil.Value(endS);
  svDay.Value(today);
} else {
  dom.GetObject(VENT_DP).State(false);
}