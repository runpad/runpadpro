
function DoSheetClick(idx)
{
  external.setSheetActive(idx,true);
}

function GetSheetsCount()
{
  return external.getNumSheets;
}

function GetSheetName(idx)
{
  return external.getSheetName(idx);
}

function GetSheetBGPic(idx)
{
  return external.getSheetBGPic(idx);
}

function IsSheetActive(idx)
{
  return external.isSheetActive(idx);
}

function GetMachineDesc()
{
  return external.getMachineDesc;
}

function GetMachineLoc()
{
  return external.getMachineLoc;
}

function GetInfoText()
{
  return external.getInfoText;
}

function GetStatusString()
{
  return external.getStatusString;
}
