real   THRESHOLD = 18.0;

string TEMP_DP = "BidCos-RF.JEQ0058916:1.TEMPERATURE";
string VENT_DP = "BidCos-RF.SEQ3057205:1.STATE";

string SV_DAY   = "SV_LueftungBoostDatum";   ! STRING: "YYYY-MM-DD"
string SV_UNTIL = "SV_LueftungBoostBis";     ! INTEGER: epoch seconds, 0 = inactive

integer BOOST_SECONDS = 7200;

real t = dom.GetObject(TEMP_DP).Value();

string  today    = system.Date("%Y-%m-%d");
integer nowEpoch = system.Date("%s").ToInteger();

object svDay   = dom.GetObject(SV_DAY);
object svUntil = dom.GetObject(SV_UNTIL);

string lastDay = "";
if (svDay) {
  lastDay = svDay.Value().ToString();
}

integer untilEpoch = 0;
if (svUntil) {
  untilEpoch = svUntil.Value().ToInteger();
}

boolean boostActive = (untilEpoch > 0) && (nowEpoch < untilEpoch);

! Wenn Temperatur >= Schwellwert: Lüftung an, Boost-Timer zurücksetzen
if (t >= THRESHOLD) {
  dom.GetObject(VENT_DP).State(true);
  if (svUntil) { svUntil.Value(0); }
  return;
}

! Wenn Boost noch aktiv: nichts tun
if (boostActive) { return; }

! Pro Kalendertag genau einmal Boost starten
if (lastDay != today) {
  dom.GetObject(VENT_DP).State(true);

  integer endEpoch = nowEpoch + BOOST_SECONDS;

  if (svUntil) { svUntil.Value(endEpoch); }
  if (svDay)   { svDay.Value(today); }
} else {
  dom.GetObject(VENT_DP).State(false);
}