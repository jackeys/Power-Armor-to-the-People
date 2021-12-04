{
  Power Armor Repair Requirements Patcher for Fallout 4
  by Skiesbleed
  
  This patcher is designed to go change the repair requirements to require perks depending on the type of power armor. It is designed for use when many power armor sets are installed to help differentiate them, and was made with the mod Power Armor to the People in mind.
  
  Requires: FO4Edit, MXPF
  Optional: Power Armor to the People and the many power armor sets it supports
  }

unit UserScript;
// Import MXPF functions
uses 'lib\mxpf';

function Initialize: Integer;
var
  i: integer;
  armorRating, newArmorRating: real;
  rec: IInterface;
begin
  // set MXPF options and initialize it
  DefaultOptionsMXPF;
  InitializeMXPF;
  
  // select/create a new patch file that will be identified by its author field
  PatchFileByName('PATTP Power Armor Repair Requirements.esp');
  SetExclusions(mxHardcodedDatFiles);
  LoadRecords('COBJ'); // loads all constructible object records
  
  // then copy records to the patch file
  CopyRecordsToPatch;
  
  // and set values on them
  for i := 0 to MaxPatchRecordIndex do begin
    rec := GetPatchRecord(i);
    AddMessage(Format('Looking at %s', [Name(rec)]));
  end;
  
  // call PrintMXPFReport for a report on successes and failures
  PrintMXPFReport;
  
  // always call FinalizeMXPF when done
  FinalizeMXPF;
end;

end.