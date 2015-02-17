class helperlibrary expands actor;


// some common helper functions;
var() string CryptKey;
var() int CryptSeed;

function string getplayername( playerpawn p)
{

 local PlayerReplicationInfo PRI;
 PRI=p.PlayerReplicationInfo;
 return pri.Playername;

}


function int getplayeridfromp( playerpawn p)
{

 local PlayerReplicationInfo PRI;
 PRI=p.PlayerReplicationInfo;
 return pri.Playerid;

}


function playerpawn checkisplayername( string searchfor)
{

 local PlayerReplicationInfo PRI;
 local bool l;
   local PlayerPawn q;
    foreach AllActors(class'PlayerPawn',q)
    {
       PRI=q.PlayerReplicationInfo;

      if (caps(pri.Playername) ==  caps(searchfor))
      {
      return q;
      l = true;
      }
    }

 if (!l)
 {
  return none;
 }

}


function playerpawn returnpfromid(int i)
{ // return a playerpawn via id.
   local PlayerReplicationInfo PRI;
   local bool l;
   local PlayerPawn q;
    foreach AllActors(class'PlayerPawn',q)
    {
       PRI=q.PlayerReplicationInfo;
       if (PRI.PlayerID==i)
       {
       l = true;
       return q;


       }
    }
 if (!l)
 {
  return none;
 }

}



function bool IsNumeric(string str)
{
  switch(str)
   {
 case("0"):return true;break;
 case("1"):return true;break;
 case("2"):return true;break;
 case("3"):return true;break;
 case("4"):return true;break;
 case("5"):return true;break;
 case("6"):return true;break;
 case("7"):return true;break;
 case("8"):return true;break;
 case("9"):return true;break;
 case("10"):return true;break;
 case("11"):return true;break;
 case("12"):return true;break;
 case("13"):return true;break;
 case("14"):return true;break;
 case("15"):return true;break;
 case("16"):return true;break;

  default:
  return false;
  break;
   };

}


function int String2IntSingle(String s)
{
 switch(s)
 {
 case("9"):return(9);break;
 case("8"):return(8);break;
 case("7"):return(7);break;
 case("6"):return(6);break;
 case("5"):return(5);break;
 case("4"):return(4);break;
 case("3"):return(3);break;
 case("2"):return(2);break;
 case("1"):return(1);break;
 case("0"):case(" "):case(""):return(0);break;
 };
}


function int exp_s(int base, int h)
{
 local int i, result;
 if (h==0) return(1);
 if (h==1) return(base);
 if (h<0) return (-1); // illegal!!!
 result=1;
 for(i=0;i<h;i++) result*=base;
 return(result);
}


function int String2Int(String pff)
{
 local String digits[24];
 local int i, counter, result;
i=0;
while ((len(pff)) > 0)  // while there is stuff to munch on
{
digits[i]=right(pff,1);
pff=left(pff,len(pff)-1);
i++;}
counter=i;
result=0;

 for(i=0; i<counter; i++)
    result+=String2IntSingle(digits[i])*(exp_s(10,i));
 return(result);
}


function string Crypt (string In, optional out string incsalt)
{
	local int jdx,lgt,KeyPos,keylgt,cc,kk,salt;
	local string Code,Key;

	lgt=Len(In);
	keylgt=Len(CryptKey);
	salt=SumUp(CryptKey) + CryptSeed;
	While( True )
	{
		cc=cc ^ Asc(Mid(CryptKey,KeyPos,1));
		if (  ++KeyPos >= keylgt )
			KeyPos=0;
		kk=Asc(Mid(CryptKey,KeyPos,1)) + salt & 255 ^ Asc(Mid(Key,jdx,1));
		if ( cc != kk )
			cc=cc ^ kk;
		Key=Left(Key,jdx) $ Chr(cc) $ Mid(Key,jdx + 1);
		if ( KeyPos == 0 )
			Break;
		if (  ++jdx >= lgt )
			jdx=0;
	}
	keylgt=Len(Key);
	Code="";
	jdx=0;
	While( jdx < lgt )
	{
		cc=Asc(Mid(In,jdx,1));
		kk=Asc(Mid(Key,KeyPos,1)) + CryptSeed & 255;
		if (  ++KeyPos >= keylgt )
			KeyPos=0;
		if ( cc != kk )
			cc=cc ^ kk;
		Code=Code $ Chr(cc);
		jdx++;
	}
	incsalt=incsalt $ Code;
	return Code;
}
simulated function int SumUp (string In)
{
	local int jdx,lgt,sum;

	lgt=Len(In);
	jdx=0;
	While( jdx < lgt )
	{
		sum += Asc(Mid(In,jdx,1));
		jdx++;
	}
	return sum;
}
simulated function int SumInit ()
{
	return SumUp(CryptKey);
}



